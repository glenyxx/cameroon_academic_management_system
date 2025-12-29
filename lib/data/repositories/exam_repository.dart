import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/exam_model.dart';
import '../local/hive_setup.dart';
import 'package:cameroon_academic_management_system/core/services/sync_services.dart';

class ExamRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SyncService _syncService = SyncService();

  // GET ALL EXAMS (OFFLINE-FIRST)
  Future<List<ExamModel>> getAllExams() async {
    try {
      // Try local first
      final localExams = HiveSetup.getAllExams();

      // If online, sync and get latest
      final online = await _syncService.isOnline();
      if (online) {
        await _syncService.syncExams();
        return HiveSetup.getAllExams();
      }

      return localExams;
    } catch (e) {
      print('Error getting exams: $e');
      return HiveSetup.getAllExams(); // Fallback to local
    }
  }

  // GET EXAMS BY TYPE
  Future<List<ExamModel>> getExamsByType(ExamType type) async {
    final allExams = await getAllExams();
    return allExams.where((exam) => exam.type == type).toList();
  }

  // GET EXAMS BY SUBJECT
  Future<List<ExamModel>> getExamsBySubject(String subject) async {
    final allExams = await getAllExams();
    return allExams.where((exam) => exam.subject == subject).toList();
  }

  // GET EXAMS BY YEAR
  Future<List<ExamModel>> getExamsByYear(int year) async {
    final allExams = await getAllExams();
    return allExams.where((exam) => exam.year == year).toList();
  }

  // SEARCH EXAMS
  Future<List<ExamModel>> searchExams({
    String? subject,
    ExamType? type,
    int? year,
    String? language,
  }) async {
    var exams = await getAllExams();

    if (subject != null) {
      exams = exams.where((e) => e.subject == subject).toList();
    }
    if (type != null) {
      exams = exams.where((e) => e.type == type).toList();
    }
    if (year != null) {
      exams = exams.where((e) => e.year == year).toList();
    }
    if (language != null) {
      exams = exams.where((e) => e.language == language).toList();
    }

    return exams;
  }

  // GET EXAM BY ID
  Future<ExamModel?> getExamById(String examId) async {
    try {
      // Try local first
      final examBox = HiveSetup.getExamBox();
      final localData = examBox.get(examId);

      if (localData != null) {
        return ExamModel.fromJson(Map<String, dynamic>.from(localData));
      }

      // If not found locally and online, fetch from Firestore
      final online = await _syncService.isOnline();
      if (online) {
        final doc = await _firestore.collection('exams').doc(examId).get();
        if (doc.exists) {
          final exam = ExamModel.fromJson(doc.data()!);
          await HiveSetup.saveExam(exam);
          return exam;
        }
      }

      return null;
    } catch (e) {
      print('Error getting exam by ID: $e');
      return null;
    }
  }

  // CREATE EXAM (FOR TEACHERS)
  Future<ExamModel?> createExam(ExamModel exam) async {
    try {
      // Save locally first
      await HiveSetup.saveExam(exam);

      // Try to push to Firestore
      final online = await _syncService.isOnline();
      if (online) {
        await _firestore
            .collection('exams')
            .doc(exam.id)
            .set(exam.toJson());
      }

      return exam;
    } catch (e) {
      print('Error creating exam: $e');
      return null;
    }
  }

  // UPDATE EXAM
  Future<bool> updateExam(ExamModel exam) async {
    try {
      // Update locally
      await HiveSetup.saveExam(exam);

      // Try to push to Firestore
      final online = await _syncService.isOnline();
      if (online) {
        await _firestore
            .collection('exams')
            .doc(exam.id)
            .update(exam.toJson());
      }

      return true;
    } catch (e) {
      print('Error updating exam: $e');
      return false;
    }
  }

  // DELETE EXAM
  Future<bool> deleteExam(String examId) async {
    try {
      // Delete locally
      final examBox = HiveSetup.getExamBox();
      await examBox.delete(examId);

      // Try to delete from Firestore
      final online = await _syncService.isOnline();
      if (online) {
        await _firestore.collection('exams').doc(examId).delete();
      }

      return true;
    } catch (e) {
      print('Error deleting exam: $e');
      return false;
    }
  }

  // GET AVAILABLE YEARS FOR A SUBJECT
  Future<List<int>> getAvailableYears(String subject) async {
    final exams = await getExamsBySubject(subject);
    final years = exams.map((e) => e.year).toSet().toList();
    years.sort((a, b) => b.compareTo(a)); // Newest first
    return years;
  }

  // GET POPULAR EXAMS (MOST DOWNLOADED)
  Future<List<ExamModel>> getPopularExams({int limit = 10}) async {
    try {
      final online = await _syncService.isOnline();
      if (!online) {
        final allExams = await getAllExams();
        return allExams.take(limit).toList();
      }

      final snapshot = await _firestore
          .collection('exams')
          .orderBy('downloadCount', descending: true)
          .limit(limit)
          .get();

      final exams = snapshot.docs
          .map((doc) => ExamModel.fromJson(doc.data()))
          .toList();

      // Cache locally
      for (var exam in exams) {
        await HiveSetup.saveExam(exam);
      }

      return exams;
    } catch (e) {
      print('Error getting popular exams: $e');
      final allExams = await getAllExams();
      return allExams.take(limit).toList();
    }
  }

  // GET RECENT EXAMS
  Future<List<ExamModel>> getRecentExams({int limit = 10}) async {
    try {
      final online = await _syncService.isOnline();
      if (!online) {
        final allExams = await getAllExams();
        allExams.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return allExams.take(limit).toList();
      }

      final snapshot = await _firestore
          .collection('exams')
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      final exams = snapshot.docs
          .map((doc) => ExamModel.fromJson(doc.data()))
          .toList();

      // Cache locally
      for (var exam in exams) {
        await HiveSetup.saveExam(exam);
      }

      return exams;
    } catch (e) {
      print('Error getting recent exams: $e');
      final allExams = await getAllExams();
      allExams.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return allExams.take(limit).toList();
    }
  }

  // DOWNLOAD EXAM (MARK AS DOWNLOADED)
  Future<bool> downloadExam(String examId, String localPath) async {
    try {
      // Mark as downloaded locally
      await HiveSetup.markAsDownloaded(examId, localPath);

      // Update exam record
      final exam = await getExamById(examId);
      if (exam != null) {
        final updatedExam = exam.copyWith(pdfLocalPath: localPath);
        await updateExam(updatedExam);
      }

      // Increment download count in Firestore
      final online = await _syncService.isOnline();
      if (online) {
        await _firestore
            .collection('exams')
            .doc(examId)
            .update({'downloadCount': FieldValue.increment(1)});
      }

      return true;
    } catch (e) {
      print('Error marking exam as downloaded: $e');
      return false;
    }
  }

  // CHECK IF EXAM IS DOWNLOADED
  bool isExamDownloaded(String examId) {
    return HiveSetup.isDownloaded(examId);
  }

  // GET DOWNLOADED EXAMS
  Future<List<ExamModel>> getDownloadedExams() async {
    final allExams = await getAllExams();
    return allExams.where((exam) => exam.pdfLocalPath != null).toList();
  }

  // FILTER BY MULTIPLE CRITERIA
  Future<List<ExamModel>> filterExams({
    List<String>? subjects,
    List<ExamType>? types,
    List<int>? years,
    String? language,
    bool? isDownloaded,
  }) async {
    var exams = await getAllExams();

    if (subjects != null && subjects.isNotEmpty) {
      exams = exams.where((e) => subjects.contains(e.subject)).toList();
    }

    if (types != null && types.isNotEmpty) {
      exams = exams.where((e) => types.contains(e.type)).toList();
    }

    if (years != null && years.isNotEmpty) {
      exams = exams.where((e) => years.contains(e.year)).toList();
    }

    if (language != null) {
      exams = exams.where((e) => e.language == language).toList();
    }

    if (isDownloaded != null) {
      if (isDownloaded) {
        exams = exams.where((e) => e.pdfLocalPath != null).toList();
      } else {
        exams = exams.where((e) => e.pdfLocalPath == null).toList();
      }
    }

    return exams;
  }

  // GET EXAM STATISTICS
  Future<Map<String, dynamic>> getExamStatistics() async {
    final allExams = await getAllExams();

    final stats = <String, dynamic>{};
    stats['totalExams'] = allExams.length;
    stats['downloadedExams'] = allExams.where((e) => e.pdfLocalPath != null).length;

    // Count by type
    final typeCount = <String, int>{};
    for (var type in ExamType.values) {
      typeCount[type.toString().split('.').last] =
          allExams.where((e) => e.type == type).length;
    }
    stats['byType'] = typeCount;

    // Count by subject
    final subjectCount = <String, int>{};
    for (var exam in allExams) {
      subjectCount[exam.subject] = (subjectCount[exam.subject] ?? 0) + 1;
    }
    stats['bySubject'] = subjectCount;

    return stats;
  }
}