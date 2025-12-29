import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';
import '../models/exam_model.dart';
import '../models/resource_model.dart';

class HiveSetup {
  // Box names
  static const String userBox = 'user_box';
  static const String examBox = 'exam_box';
  static const String questionBox = 'question_box';
  static const String resourceBox = 'resource_box';
  static const String progressBox = 'progress_box';
  static const String tutorBox = 'tutor_box';
  static const String scholarshipBox = 'scholarship_box';
  static const String settingsBox = 'settings_box';
  static const String cacheBox = 'cache_box';
  static const String downloadBox = 'download_box';

  static Future<void> initialize() async {
    // Initialize Hive
    await Hive.initFlutter();

    // Register Type Adapters
    // Note: If using @HiveType annotations, run: flutter packages pub run build_runner build
    // For now, we'll use JSON serialization (Map<String, dynamic>)

    // Open all boxes
    await Future.wait([
      Hive.openBox(userBox),
      Hive.openBox(examBox),
      Hive.openBox(questionBox),
      Hive.openBox(resourceBox),
      Hive.openBox(progressBox),
      Hive.openBox(tutorBox),
      Hive.openBox(scholarshipBox),
      Hive.openBox(settingsBox),
      Hive.openBox(cacheBox),
      Hive.openBox(downloadBox),
    ]);
  }

  // Get box methods
  static Box getUserBox() => Hive.box(userBox);
  static Box getExamBox() => Hive.box(examBox);
  static Box getQuestionBox() => Hive.box(questionBox);
  static Box getResourceBox() => Hive.box(resourceBox);
  static Box getProgressBox() => Hive.box(progressBox);
  static Box getTutorBox() => Hive.box(tutorBox);
  static Box getScholarshipBox() => Hive.box(scholarshipBox);
  static Box getSettingsBox() => Hive.box(settingsBox);
  static Box getCacheBox() => Hive.box(cacheBox);
  static Box getDownloadBox() => Hive.box(downloadBox);

  // Helper methods for common operations

  // Save current user
  static Future<void> saveCurrentUser(UserModel user) async {
    final box = getUserBox();
    await box.put('current_user', user.toJson());
  }

  // Get current user
  static UserModel? getCurrentUser() {
    final box = getUserBox();
    final userData = box.get('current_user');
    if (userData != null) {
      return UserModel.fromJson(Map<String, dynamic>.from(userData));
    }
    return null;
  }

  // Cache data with expiry
  static Future<void> cacheData(String key, dynamic data, {Duration? expiry}) async {
    final box = getCacheBox();
    final cacheEntry = {
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'expiry': expiry?.inMilliseconds,
    };
    await box.put(key, cacheEntry);
  }

  // Get cached data
  static dynamic getCachedData(String key) {
    final box = getCacheBox();
    final cacheEntry = box.get(key);

    if (cacheEntry == null) return null;

    final entry = Map<String, dynamic>.from(cacheEntry);
    final timestamp = entry['timestamp'] as int;
    final expiry = entry['expiry'] as int?;

    // Check if expired
    if (expiry != null) {
      final age = DateTime.now().millisecondsSinceEpoch - timestamp;
      if (age > expiry) {
        box.delete(key);
        return null;
      }
    }

    return entry['data'];
  }

  // Save exam with offline support
  static Future<void> saveExam(ExamModel exam) async {
    final box = getExamBox();
    await box.put(exam.id, exam.toJson());
  }

  // Get all exams
  static List<ExamModel> getAllExams() {
    final box = getExamBox();
    return box.values
        .map((e) => ExamModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  // Save resource
  static Future<void> saveResource(ResourceModel resource) async {
    final box = getResourceBox();
    await box.put(resource.id, resource.toJson());
  }

  // Get all resources
  static List<ResourceModel> getAllResources() {
    final box = getResourceBox();
    return box.values
        .map((e) => ResourceModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  // Save user progress
  static Future<void> saveProgress(String subjectId, Map<String, dynamic> progress) async {
    final box = getProgressBox();
    await box.put(subjectId, progress);
  }

  // Get user progress
  static Map<String, dynamic>? getProgress(String subjectId) {
    final box = getProgressBox();
    final progress = box.get(subjectId);
    return progress != null ? Map<String, dynamic>.from(progress) : null;
  }

  // Track downloaded resources
  static Future<void> markAsDownloaded(String resourceId, String localPath) async {
    final box = getDownloadBox();
    await box.put(resourceId, {
      'localPath': localPath,
      'downloadedAt': DateTime.now().toIso8601String(),
    });
  }

  // Check if resource is downloaded
  static bool isDownloaded(String resourceId) {
    final box = getDownloadBox();
    return box.containsKey(resourceId);
  }

  // Get local path of downloaded resource
  static String? getLocalPath(String resourceId) {
    final box = getDownloadBox();
    final data = box.get(resourceId);
    if (data != null) {
      return (data as Map)['localPath'] as String?;
    }
    return null;
  }

  // Clear cache
  static Future<void> clearCache() async {
    await getCacheBox().clear();
  }

  // Clear all downloaded files
  static Future<void> clearDownloads() async {
    await getDownloadBox().clear();
  }

  // Clear all data (for logout)
  static Future<void> clearAllData() async {
    await Future.wait([
      getUserBox().clear(),
      getExamBox().clear(),
      getQuestionBox().clear(),
      getResourceBox().clear(),
      getProgressBox().clear(),
      getTutorBox().clear(),
      getScholarshipBox().clear(),
      getCacheBox().clear(),
      getDownloadBox().clear(),
      // Keep settings box for app preferences
    ]);
  }

  // Get storage usage in bytes
  static int getStorageUsage() {
    int total = 0;

    // Calculate size of each box
    for (var box in [
      getExamBox(),
      getQuestionBox(),
      getResourceBox(),
      getProgressBox(),
      getTutorBox(),
      getScholarshipBox(),
      getCacheBox(),
      getDownloadBox(),
    ]) {
      total += box.length;
    }

    return total;
  }

  // Compact all boxes (free up space)
  static Future<void> compactAll() async {
    await Future.wait([
      getUserBox().compact(),
      getExamBox().compact(),
      getQuestionBox().compact(),
      getResourceBox().compact(),
      getProgressBox().compact(),
      getTutorBox().compact(),
      getScholarshipBox().compact(),
      getSettingsBox().compact(),
      getCacheBox().compact(),
      getDownloadBox().compact(),
    ]);
  }
}