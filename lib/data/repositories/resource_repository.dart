import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/resource_model.dart';
import '../local/hive_setup.dart';
import 'package:cameroon_academic_management_system/core/services/sync_services.dart';

class ResourceRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SyncService _syncService = SyncService();

  // GET ALL RESOURCES (OFFLINE-FIRST)
  Future<List<ResourceModel>> getAllResources() async {
    try {
      final localResources = HiveSetup.getAllResources();

      final online = await _syncService.isOnline();
      if (online) {
        await _syncService.syncResources();
        return HiveSetup.getAllResources();
      }

      return localResources;
    } catch (e) {
      return HiveSetup.getAllResources();
    }
  }

  // GET RESOURCES BY TYPE
  Future<List<ResourceModel>> getResourcesByType(ResourceType type) async {
    final all = await getAllResources();
    return all.where((r) => r.type == type).toList();
  }

  // GET RESOURCES BY SUBJECT
  Future<List<ResourceModel>> getResourcesBySubject(String subject) async {
    final all = await getAllResources();
    return all.where((r) => r.subject == subject).toList();
  }

  // SEARCH RESOURCES
  Future<List<ResourceModel>> searchResources({
    String? query,
    String? subject,
    ResourceType? type,
    String? language,
  }) async {
    var resources = await getAllResources();

    if (query != null && query.isNotEmpty) {
      final lowerQuery = query.toLowerCase();
      resources = resources.where((r) =>
      r.title.toLowerCase().contains(lowerQuery) ||
          r.description.toLowerCase().contains(lowerQuery) ||
          r.tags.any((tag) => tag.toLowerCase().contains(lowerQuery))
      ).toList();
    }

    if (subject != null) {
      resources = resources.where((r) => r.subject == subject).toList();
    }

    if (type != null) {
      resources = resources.where((r) => r.type == type).toList();
    }

    if (language != null) {
      resources = resources.where((r) => r.language == language).toList();
    }

    return resources;
  }

  // GET RESOURCE BY ID
  Future<ResourceModel?> getResourceById(String id) async {
    try {
      final box = HiveSetup.getResourceBox();
      final data = box.get(id);

      if (data != null) {
        return ResourceModel.fromJson(Map<String, dynamic>.from(data));
      }

      final online = await _syncService.isOnline();
      if (online) {
        final doc = await _firestore.collection('resources').doc(id).get();
        if (doc.exists) {
          final resource = ResourceModel.fromJson(doc.data()!);
          await HiveSetup.saveResource(resource);
          return resource;
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // CREATE RESOURCE
  Future<ResourceModel?> createResource(ResourceModel resource) async {
    try {
      await HiveSetup.saveResource(resource);

      final online = await _syncService.isOnline();
      if (online) {
        await _firestore
            .collection('resources')
            .doc(resource.id)
            .set(resource.toJson());
      }

      return resource;
    } catch (e) {
      return null;
    }
  }

  // UPDATE RESOURCE
  Future<bool> updateResource(ResourceModel resource) async {
    try {
      await HiveSetup.saveResource(resource);

      final online = await _syncService.isOnline();
      if (online) {
        await _firestore
            .collection('resources')
            .doc(resource.id)
            .update(resource.toJson());
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  // DELETE RESOURCE
  Future<bool> deleteResource(String id) async {
    try {
      final box = HiveSetup.getResourceBox();
      await box.delete(id);

      final online = await _syncService.isOnline();
      if (online) {
        await _firestore.collection('resources').doc(id).delete();
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  // INCREMENT VIEW COUNT
  Future<void> incrementViewCount(String id) async {
    try {
      final resource = await getResourceById(id);
      if (resource != null) {
        final updated = resource.copyWith(
          viewCount: resource.viewCount + 1,
        );
        await updateResource(updated);
      }

      final online = await _syncService.isOnline();
      if (online) {
        await _firestore
            .collection('resources')
            .doc(id)
            .update({'viewCount': FieldValue.increment(1)});
      }
    } catch (e) {
      print('Error incrementing view count: $e');
    }
  }

  // INCREMENT DOWNLOAD COUNT
  Future<void> incrementDownloadCount(String id, String localPath) async {
    try {
      await HiveSetup.markAsDownloaded(id, localPath);

      final resource = await getResourceById(id);
      if (resource != null) {
        final updated = resource.copyWith(
          downloadCount: resource.downloadCount + 1,
          isOfflineAvailable: true,
          localPath: localPath,
        );
        await updateResource(updated);
      }

      final online = await _syncService.isOnline();
      if (online) {
        await _firestore
            .collection('resources')
            .doc(id)
            .update({'downloadCount': FieldValue.increment(1)});
      }
    } catch (e) {
      print('Error incrementing download count: $e');
    }
  }

  // GET POPULAR RESOURCES
  Future<List<ResourceModel>> getPopularResources({int limit = 10}) async {
    try {
      final online = await _syncService.isOnline();
      if (!online) {
        final all = await getAllResources();
        all.sort((a, b) => b.viewCount.compareTo(a.viewCount));
        return all.take(limit).toList();
      }

      final snapshot = await _firestore
          .collection('resources')
          .orderBy('viewCount', descending: true)
          .limit(limit)
          .get();

      final resources = snapshot.docs
          .map((doc) => ResourceModel.fromJson(doc.data()))
          .toList();

      for (var resource in resources) {
        await HiveSetup.saveResource(resource);
      }

      return resources;
    } catch (e) {
      final all = await getAllResources();
      all.sort((a, b) => b.viewCount.compareTo(a.viewCount));
      return all.take(limit).toList();
    }
  }

  // GET RECENT RESOURCES
  Future<List<ResourceModel>> getRecentResources({int limit = 10}) async {
    try {
      final online = await _syncService.isOnline();
      if (!online) {
        final all = await getAllResources();
        all.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return all.take(limit).toList();
      }

      final snapshot = await _firestore
          .collection('resources')
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      final resources = snapshot.docs
          .map((doc) => ResourceModel.fromJson(doc.data()))
          .toList();

      for (var resource in resources) {
        await HiveSetup.saveResource(resource);
      }

      return resources;
    } catch (e) {
      final all = await getAllResources();
      all.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return all.take(limit).toList();
    }
  }

  // GET OFFLINE RESOURCES
  Future<List<ResourceModel>> getOfflineResources() async {
    final all = await getAllResources();
    return all.where((r) => r.isOfflineAvailable).toList();
  }

  // GET RESOURCES BY UPLOADER
  Future<List<ResourceModel>> getResourcesByUploader(String uploaderId) async {
    final all = await getAllResources();
    return all.where((r) => r.uploadedBy == uploaderId).toList();
  }
}