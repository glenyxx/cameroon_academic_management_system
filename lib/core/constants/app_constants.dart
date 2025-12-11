class AppConstants {
  // App Info
  static const String appName = 'EduConnect Cameroon';
  static const String appVersion = '1.0.0';

  // API & Storage
  static const String cloudinaryCloudName = 'YOUR_CLOUD_NAME';
  static const String cloudinaryUploadPreset = 'YOUR_UPLOAD_PRESET';

  // Pagination
  static const int itemsPerPage = 20;

  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration cacheValidDuration = Duration(hours: 24);

  // Subjects (Cameroon Curriculum)
  static const List<String> subjects = [
    'Mathematics',
    'Physics',
    'Chemistry',
    'Biology',
    'English',
    'French',
    'History',
    'Geography',
    'Literature',
    'Economics',
    'Computer Science',
  ];

  // Class Levels
  static const List<String> classLevels = [
    'Form 1',
    'Form 2',
    'Form 3',
    'Form 4',
    'Form 5',
    'Lower Sixth',
    'Upper Sixth',
  ];

  // Languages
  static const List<Map<String, String>> languages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'fr', 'name': 'Français'},
  ];

  // Exam Types
  static const List<String> examTypes = [
    'GCE O-Level',
    'GCE A-Level',
    'BEPC',
    'Probatoire',
    'Baccalauréat',
  ];

  // Payment Methods
  static const List<String> paymentMethods = [
    'MTN Mobile Money',
    'Orange Money',
    'Credit/Debit Card',
  ];

  // File Size Limits (in MB)
  static const int maxImageSize = 5;
  static const int maxDocumentSize = 50;

  // Cloudinary Folders
  static const String profileImagesFolder = 'profile_images';
  static const String resourcesFolder = 'study_resources';
}