import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cameroon_academic_management_system/data/local/hive_setup.dart';
import '/data/models/user_model.dart';
import '/data/models/exam_model.dart';
import '/data/models/resource_model.dart';

class SyncService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Connectivity _connectivity = Connectivity();

  bool _isSyncing = false;
  DateTime? _lastSyncTime;

  // CHECK IF ONLINE
  Future<bool> isOnline() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  // FULL SYNC (CALLED ON APP START OR WHEN CONNECTION RESTORED)
  Future<void> performFullSync() async {
    if (_isSyncing) return;

    final online = await isOnline();
    if (!online) return;

    _isSyncing = true;

    try {
      // Sync in order of priority
      await syncUserData();
      await syncExams();
      await syncResources();
      await syncProgress();
      await syncTutors();
      await syncScholarships();

      _lastSyncTime = DateTime.now();
      await _saveLastSyncTime();

      print('✅ Full sync completed successfully');
    } catch (e) {
      print('❌ Sync failed: $e');
    } finally {
      _isSyncing = false;
    }
  }

  // SYNC USER DATA
  Future<void> syncUserData() async {
    try {
      final localUser = HiveSetup.getCurrentUser();
      if (localUser == null) return;

      // Push local changes to Firestore
      await _firestore
          .collection('users')
          .doc(localUser.id)
          .set(localUser.toJson(), SetOptions(merge: true));

      // Pull latest from Firestore
      final doc = await _firestore.collection('users').doc(localUser.id).get();
      if (doc.exists) {
        final updatedUser = UserModel.fromJson(doc.data()!);
        await HiveSetup.saveCurrentUser(updatedUser);
      }

      print('✅ User data synced');
    } catch (e) {
      print('❌ User sync failed: $e');
    }
  }

  // SYNC EXAMS (DOWNLOAD NEW, UPLOAD LOCAL)
  Future<void> syncExams() async {
    try {
      final localExams = HiveSetup.getAllExams();

      // Push unsynced local exams to Firestore
      for (var exam in localExams) {
        if (!exam.isSynced) {
          await _firestore
              .collection('exams')
              .doc(exam.id)
              .set(exam.copyWith(isSynced: true).toJson());

          // Update local copy
          await HiveSetup.saveExam(exam.copyWith(isSynced: true));
        }
      }

      // Pull new exams from Firestore
      final snapshot = await _firestore
          .collection('exams')
          .where('createdAt', isGreaterThan: _getLastSyncTimestamp())
          .get();

      for (var doc in snapshot.docs) {
        final exam = ExamModel.fromJson(doc.data());
        await HiveSetup.saveExam(exam);
      }

      print('✅ ${snapshot.docs.length} exams synced');
    } catch (e) {
      print('❌ Exam sync failed: $e');
    }
  }

  // SYNC RESOURCES
  Future<void> syncResources() async {
    try {
      final localResources = HiveSetup.getAllResources();

      // Push new resources
      for (var resource in localResources) {
        final doc = await _firestore
            .collection('resources')
            .doc(resource.id)
            .get();

        if (!doc.exists) {
          await _firestore
              .collection('resources')
              .doc(resource.id)
              .set(resource.toJson());
        }
      }

      // Pull new resources
      final snapshot = await _firestore
          .collection('resources')
          .where('createdAt', isGreaterThan: _getLastSyncTimestamp())
          .limit(50) // Limit to avoid overload
          .get();

      for (var doc in snapshot.docs) {
        final resource = ResourceModel.fromJson(doc.data());
        await HiveSetup.saveResource(resource);
      }

      print('✅ ${snapshot.docs.length} resources synced');
    } catch (e) {
      print('❌ Resource sync failed: $e');
    }
  }

  // SYNC USER PROGRESS
  Future<void> syncProgress() async {
    try {
      final localUser = HiveSetup.getCurrentUser();
      if (localUser == null) return;

      // Push all progress to Firestore
      final progressBox = HiveSetup.getProgressBox();
      for (var key in progressBox.keys) {
        final progress = progressBox.get(key);
        await _firestore
            .collection('users')
            .doc(localUser.id)
            .collection('progress')
            .doc(key)
            .set(Map<String, dynamic>.from(progress), SetOptions(merge: true));
      }

      // Pull latest progress
      final snapshot = await _firestore
          .collection('users')
          .doc(localUser.id)
          .collection('progress')
          .get();

      for (var doc in snapshot.docs) {
        await HiveSetup.saveProgress(doc.id, doc.data());
      }

      print('✅ Progress synced');
    } catch (e) {
      print('❌ Progress sync failed: $e');
    }
  }

  // SYNC TUTORS
  Future<void> syncTutors() async {
    try {
      final snapshot = await _firestore
          .collection('tutors')
          .where('isVerified', isEqualTo: true)
          .limit(50)
          .get();

      final tutorBox = HiveSetup.getTutorBox();
      for (var doc in snapshot.docs) {
        await tutorBox.put(doc.id, doc.data());
      }

      print('✅ ${snapshot.docs.length} tutors synced');
    } catch (e) {
      print('❌ Tutor sync failed: $e');
    }
  }

  // SYNC SCHOLARSHIPS
  Future<void> syncScholarships() async {
    try {
      final now = DateTime.now();
      final snapshot = await _firestore
          .collection('scholarships')
          .where('deadline', isGreaterThan: now)
          .orderBy('deadline')
          .limit(50)
          .get();

      final scholarshipBox = HiveSetup.getScholarshipBox();
      for (var doc in snapshot.docs) {
        await scholarshipBox.put(doc.id, doc.data());
      }

      print('✅ ${snapshot.docs.length} scholarships synced');
    } catch (e) {
      print('❌ Scholarship sync failed: $e');
    }
  }

  // SYNC SPECIFIC COLLECTION (GENERIC)
  Future<void> syncCollection(
      String collectionName,
      String boxName,
      ) async {
    try {
      final snapshot = await _firestore
          .collection(collectionName)
          .where('updatedAt', isGreaterThan: _getLastSyncTimestamp())
          .get();

      final box = HiveSetup.getCacheBox();
      for (var doc in snapshot.docs) {
        await box.put('${collectionName}_${doc.id}', doc.data());
      }

      print('✅ $collectionName synced: ${snapshot.docs.length} items');
    } catch (e) {
      print('❌ $collectionName sync failed: $e');
    }
  }

  // BACKGROUND SYNC (PERIODIC)
  Future<void> backgroundSync() async {
    final online = await isOnline();
    if (!online) return;

    // Only sync if last sync was more than 15 minutes ago
    if (_lastSyncTime != null) {
      final diff = DateTime.now().difference(_lastSyncTime!);
      if (diff.inMinutes < 15) return;
    }

    await performFullSync();
  }

  // PUSH SINGLE ITEM TO FIRESTORE
  Future<void> pushToFirestore(
      String collection,
      String docId,
      Map<String, dynamic> data,
      ) async {
    try {
      final online = await isOnline();
      if (!online) {
        // Queue for later sync
        await _queueForSync(collection, docId, data);
        return;
      }

      await _firestore
          .collection(collection)
          .doc(docId)
          .set(data, SetOptions(merge: true));

      print('✅ Pushed to Firestore: $collection/$docId');
    } catch (e) {
      await _queueForSync(collection, docId, data);
      print('❌ Push failed, queued: $e');
    }
  }

  // PULL SINGLE ITEM FROM FIRESTORE
  Future<Map<String, dynamic>?> pullFromFirestore(
      String collection,
      String docId,
      ) async {
    try {
      final online = await isOnline();
      if (!online) return null;

      final doc = await _firestore.collection(collection).doc(docId).get();
      return doc.data();
    } catch (e) {
      print('❌ Pull failed: $e');
      return null;
    }
  }

  // QUEUE OPERATIONS FOR LATER SYNC
  Future<void> _queueForSync(
      String collection,
      String docId,
      Map<String, dynamic> data,
      ) async {
    final cacheBox = HiveSetup.getCacheBox();
    final queue = cacheBox.get('sync_queue', defaultValue: <Map>[]) as List;

    queue.add({
      'collection': collection,
      'docId': docId,
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });

    await cacheBox.put('sync_queue', queue);
  }

  // PROCESS SYNC QUEUE
  Future<void> processSyncQueue() async {
    final online = await isOnline();
    if (!online) return;

    final cacheBox = HiveSetup.getCacheBox();
    final queue = cacheBox.get('sync_queue', defaultValue: <Map>[]) as List;

    if (queue.isEmpty) return;

    for (var item in List.from(queue)) {
      try {
        await _firestore
            .collection(item['collection'])
            .doc(item['docId'])
            .set(Map<String, dynamic>.from(item['data']), SetOptions(merge: true));

        queue.remove(item);
      } catch (e) {
        print('❌ Queue item failed: $e');
      }
    }

    await cacheBox.put('sync_queue', queue);
    print('✅ Sync queue processed: ${queue.length} items remaining');
  }

  // HELPER: GET LAST SYNC TIMESTAMP
  Timestamp _getLastSyncTimestamp() {
    if (_lastSyncTime == null) {
      // Default to 30 days ago
      return Timestamp.fromDate(
        DateTime.now().subtract(const Duration(days: 30)),
      );
    }
    return Timestamp.fromDate(_lastSyncTime!);
  }

  // HELPER: SAVE LAST SYNC TIME
  Future<void> _saveLastSyncTime() async {
    final settingsBox = HiveSetup.getSettingsBox();
    await settingsBox.put(
      'last_sync_time',
      _lastSyncTime?.millisecondsSinceEpoch,
    );
  }

  // HELPER: LOAD LAST SYNC TIME
  Future<void> loadLastSyncTime() async {
    final settingsBox = HiveSetup.getSettingsBox();
    final timestamp = settingsBox.get('last_sync_time');
    if (timestamp != null) {
      _lastSyncTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
  }

  // GET SYNC STATUS
  Map<String, dynamic> getSyncStatus() {
    return {
      'isSyncing': _isSyncing,
      'lastSyncTime': _lastSyncTime?.toIso8601String(),
      'timeSinceLastSync': _lastSyncTime != null
          ? DateTime.now().difference(_lastSyncTime!).inMinutes
          : null,
    };
  }
}