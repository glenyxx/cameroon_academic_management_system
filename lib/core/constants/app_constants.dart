class AppConstants {
  // App Info
  static const String appName = 'Cameroon Academic Management System-CAMS';
  static const String appVersion = '1.0.0';
  static const String appPackageName = 'com.glenys.cameroon_academic_management_system';

  static const String cloudinaryApiKey = '889939332928937';
  static const String cloudinaryApiSecret = 'swvAtSL85_RfXNypgg6ZzAC0B5w';
  static const String cloudinaryCloudName = 'dlehlwowc';
  static const String cloudinaryUploadPreset = 'cams_upload';

  static const String geminiApiKey = 'AIzaSyDCf7gocerq-VpZgGU6CQ3RXdSYo428Hnk';

  // API Endpoints
  static const String baseUrl = 'https://api.educonnect.cm'; // Your backend URL
  static const String geminiApiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';

  // Pagination
  static const int itemsPerPage = 20;
  static const int maxSearchResults = 50;

  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration cacheValidDuration = Duration(hours: 24);
  static const Duration shortCacheDuration = Duration(minutes: 15);

  // File Size Limits (in MB)
  static const int maxImageSize = 5;
  static const int maxDocumentSize = 50;
  static const int maxVideoSize = 100;

  // Storage Limits
  static const int maxOfflineStorage = 5 * 1024 * 1024 * 1024; // 5GB
  static const int warningStorageThreshold = 4 * 1024 * 1024 * 1024; // 4GB

  // Subjects (Cameroon Curriculum)
  static const List<String> anglophoneSubjects = [
    'Mathematics',
    'Physics',
    'Chemistry',
    'Biology',
    'English Language',
    'Literature in English',
    'History',
    'Geography',
    'Economics',
    'Computer Science',
    'Further Mathematics',
    'Additional Mathematics',
    'French',
    'Religious Studies',
  ];

  static const List<String> francophoneSubjects = [
    'Mathématiques',
    'Physique',
    'Chimie',
    'Biologie',
    'Français',
    'Anglais',
    'Histoire',
    'Géographie',
    'Sciences Économiques',
    'Informatique',
    'Philosophie',
    'Sciences de la Vie et de la Terre',
  ];

  // Class Levels - Anglophone System
  static const List<String> anglophoneClasses = [
    'Form 1',
    'Form 2',
    'Form 3',
    'Form 4',
    'Form 5',
    'Lower Sixth',
    'Upper Sixth',
  ];

  // Class Levels - Francophone System
  static const List<String> francophoneClasses = [
    'Sixième (6e)',
    'Cinquième (5e)',
    'Quatrième (4e)',
    'Troisième (3e)',
    'Seconde (2nde)',
    'Première (1ère)',
    'Terminale',
  ];

  // Languages
  static const List<Map<String, String>> languages = [
    {'code': 'en', 'name': 'English', 'native': 'English'},
    {'code': 'fr', 'name': 'French', 'native': 'Français'},
  ];

  // Exam Types
  static const List<String> examTypes = [
    'GCE O-Level',
    'GCE A-Level',
    'BEPC',
    'Probatoire',
    'Baccalauréat',
  ];

  // Study Duration Presets (in minutes)
  static const List<int> studyDurations = [15, 30, 45, 60, 90, 120];

  // Payment Methods
  static const List<Map<String, String>> paymentMethods = [
    {'name': 'MTN Mobile Money', 'code': 'mtn', 'prefix': '*126#'},
    {'name': 'Orange Money', 'code': 'orange', 'prefix': '#150#'},
    {'name': 'Credit/Debit Card', 'code': 'card', 'prefix': ''},
    {'name': 'Wallet Balance', 'code': 'wallet', 'prefix': ''},
  ];

  // Tutor Rates (CFA per hour)
  static const Map<String, int> tutorRateRanges = {
    'minimum': 2000,
    'average': 5000,
    'premium': 10000,
    'maximum': 20000,
  };

  // Notification Types
  static const String notifTypeStudyReminder = 'study_reminder';
  static const String notifTypeExamCountdown = 'exam_countdown';
  static const String notifTypeScholarship = 'scholarship_alert';
  static const String notifTypeSessionBooking = 'session_booking';
  static const String notifTypePayment = 'payment_due';
  static const String notifTypeAchievement = 'achievement_unlock';
  static const String notifTypeMessage = 'new_message';
  static const String notifTypeAnnouncement = 'announcement';

  // Cloudinary Folders
  static const String profileImagesFolder = 'profile_images';
  static const String resourcesFolder = 'study_resources';
  static const String examPapersFolder = 'exam_papers';
  static const String certificatesFolder = 'certificates';
  static const String portfolioFolder = 'portfolio';

  // AI Prompts
  static const String aiSystemPrompt = '''
You are an AI educational assistant for Cameroonian students. 
You help with GCE, BEPC, Probatoire, and Baccalauréat exams.
Provide clear, accurate, and encouraging responses in both English and French.
Focus on understanding concepts, not just memorization.
Be culturally aware and reference the Cameroonian education system.
''';

  // Study Streak Badges
  static const Map<int, String> streakBadges = {
    7: '7-Day Scholar 🔥',
    14: '2-Week Warrior 💪',
    30: 'Monthly Master 🌟',
    60: '2-Month Champion 🏆',
    90: 'Quarter King/Queen 👑',
    180: 'Half-Year Hero 🦸',
    365: 'Year Legend 🎯',
  };

  // Score Thresholds
  static const int passScore = 50;
  static const int goodScore = 70;
  static const int excellentScore = 85;
  static const int perfectScore = 100;

  // Session Durations (in minutes)
  static const List<int> sessionDurations = [30, 45, 60, 90, 120];

  // Scholarship Eligibility
  static const List<String> scholarshipFields = [
    'STEM',
    'Arts',
    'Business',
    'Agriculture',
    'Medicine',
    'Engineering',
    'Law',
    'Education',
    'Any Field',
  ];

  static const List<String> scholarshipLevels = [
    'Secondary School',
    'Undergraduate',
    'Masters',
    'PhD',
    'Professional',
  ];

  // Contact & Support
  static const String supportEmail = 'support@CAMS.cm';
  static const String supportPhone = '+237 6XX XXX XXX';
  static const String websiteUrl = 'https://CAMS.cm';
  static const String privacyPolicyUrl = 'https://CAMS.cm/privacy';
  static const String termsOfServiceUrl = 'https://CAMS.cm/terms';

  // Social Media
  static const String facebookUrl = 'https://facebook.com/cams.cm';
  static const String twitterUrl = 'https://twitter.com/cams_cm';
  static const String instagramUrl = 'https://instagram.com/cams.cm';
  static const String youtubeUrl = 'https://youtube.com/@cams';

  // Feature Flags
  static const bool enableAIAssistant = true;
  static const bool enableVideoLessons = true;
  static const bool enableLiveClasses = false; // Coming soon
  static const bool enablePeerToPeer = false; // Coming soon
  static const bool enableGameification = true;

  // Cache Keys
  static const String cacheKeyExams = 'cached_exams';
  static const String cacheKeyResources = 'cached_resources';
  static const String cacheKeyTutors = 'cached_tutors';
  static const String cacheKeyScholarships = 'cached_scholarships';
  static const String cacheKeyUserProfile = 'cached_user_profile';

  // Error Messages
  static const String errorNetworkUnavailable = 'No internet connection. Using offline data.';
  static const String errorServerError = 'Server error. Please try again later.';
  static const String errorInvalidCredentials = 'Invalid email or password.';
  static const String errorSessionExpired = 'Your session has expired. Please login again.';
  static const String errorPaymentFailed = 'Payment failed. Please try again.';

  // Success Messages
  static const String successLogin = 'Welcome back!';
  static const String successSignup = 'Account created successfully!';
  static const String successPayment = 'Payment successful!';
  static const String successBooking = 'Session booked successfully!';
  static const String successDownload = 'Downloaded successfully!';

  // RegEx Patterns
  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
  );
  static final RegExp phoneRegex = RegExp(
    r'^(\+237)?[6][0-9]{8}$',
  );
  static final RegExp passwordRegex = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$',
  );

  // Shared Preferences Keys (in addition to storage_keys.dart)
  static const String keyFirstLaunch = 'is_first_launch';
  static const String keyOnboardingComplete = 'onboarding_complete';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguageCode = 'language_code';
  static const String keyUserId = 'user_id';
  static const String keyUserRole = 'user_role';
}