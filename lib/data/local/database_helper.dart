import 'package:hive_flutter/hive_flutter.dart';

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

  static Future<void> initialize() async {
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
    ]);
  }
}