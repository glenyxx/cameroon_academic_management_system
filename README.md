# Name: NGONG GLENYS FULAI
# Matricule: ICTU20233806
# Course: Introduction to Mobile Application Development
# Cameroon Academic Management System - README

## 📱 Bilingual Offline-First Mobile Learning Ecosystem for Cameroonian Secondary School Students

CAMS is a comprehensive educational platform designed specifically for Cameroonian students preparing for GCE O/A-Level, BEPC, Probatoire, and Baccalauréat examinations. The app features an exam bank, study resources, tutor marketplace, scholarship portal, and parent dashboard with full offline functionality.

---

##  Key Features

- Exam Bank: 500+ past questions with marking schemes
- Study Resources: Video lessons, PDFs, quizzes, and notes
- Tutor Marketplace: Find and book qualified tutors
- Scholarship Portal: AI-powered scholarship matching
- Parent Dashboard: Real-time student progress monitoring
- Offline-First: Full functionality without internet
- Bilingual Support: English & French interface
- Multi-Role: Student, Teacher, Tutor, and Parent accounts

---

## ️ Technology Stack

- Framework: Flutter 3.0+
- Language: Dart
- State Management: Provider
- Local Database: Hive
- Backend: Firebase (Firestore, Auth , Analytics)
- Cloud Storage: Cloudinary
- Payment: MTN Mobile Money, Orange Money (placeholder)
- Charts: fl_chart
- PDF Viewer: flutter_pdfview

---

## Prerequisites

Before you begin, ensure you have the following installed:

### Required Software

1. Flutter SDK (3.0.0 or higher)
    - Download from: https://docs.flutter.dev/get-started/install
    - Verify installation: `flutter --version`

2. Dart SDK (comes with Flutter)
    - Verify: `dart --version`

3. Android Studio (for Android development)
    - Download from: https://developer.android.com/studio
    - Install Flutter and Dart plugins

4. Git
    - Download from: https://git-scm.com/downloads
    - Verify: `git --version`

### Optional Tools

- **VS Code** with Flutter extension (alternative to Android Studio)
- **Firebase CLI**: `npm install -g firebase-tools`

---

## 🚀 Installation & Setup

### Step 1: Clone the Repository

```bash
# Clone the repository
git clone https://github.com/glenyxx/cameroon_academic_management_system.git

# Navigate to project directory
cd cameroon_academic_management_system
```

### Step 2: Install Dependencies

```bash
# Get all Flutter packages
flutter pub get
```

### Step 3: Configure Firebase

#### 3.1 Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add Project"
3. Name it "CAMS" 
4. Enable Google Analytics 
5. Create project

#### 3.2 Add Android App

1. In Firebase Console, click "Add App" → Android (🤖)
2. **Android package name**: `com.glenys.cameroon_academic_management_system`
3. Download `google-services.json`
4. Place it in: `android/app/google-services.json`

#### 3.4 Enable Firebase Services

In Firebase Console, enable:

- **Authentication** → Sign-in method → Email/Password (Enable)
- **Firestore Database** → Create database → Start in **test mode**
- **Analytics** 

**⚠️ IMPORTANT**: Update Firestore security rules before production:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Everyone can read exams and resources (read-only public content)
    match /exams/{examId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    match /resources/{resourceId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    // Only authenticated users can read/write other collections
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### Step 4: Configure Cloudinary (For Image/File Uploads)

1. Create account at [Cloudinary](https://cloudinary.com/)
2. Get your credentials from Dashboard
3. Update `lib/core/constants/app_constants.dart`:

```dart
// REPLACE THESE WITH YOUR ACTUAL CREDENTIALS
static const String cloudinaryCloudName = 'dlehlwowc';
static const String cloudinaryUploadPreset = 'cams_upload';
```

**To create upload preset:**
- Go to Settings → Upload → Upload presets
- Click "Add upload preset"
- Set Signing Mode to "Unsigned"
- Save preset name

### Step 5: Configure Gemini AI (Optional for AI Features)

1. Get API key from [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Update `lib/core/constants/app_constants.dart`:

```dart
static const String geminiApiKey = 'AIzaSyDCf7gocerq-VpZgGU6CQ3RXdSYo428Hnk';
```

### Step 6: Verify Setup

```bash
# Check for any issues
flutter doctor

# Should show all checkmarks ✓
# Fix any issues shown with red X
```

---

## ▶️ Running the App

### Run on Android Emulator

```bash
# List available emulators
flutter emulators

# Launch emulator
flutter emulators --launch <emulator_id>

# Run app
flutter run
```

### Run on Android Physical Device

1. Enable **Developer Options** on your Android device:
    - Go to Settings → About Phone
    - Tap "Build Number" 7 times

2. Enable **USB Debugging**:
    - Settings → Developer Options → USB Debugging (ON)

3. Connect device via USB

```bash
# Check if device is connected
flutter devices

# Run app
flutter run
```

### Run Specific Configuration

```bash
# Run in debug mode (default)
flutter run

# Run in profile mode (performance testing)
flutter run --profile

# Run in release mode (optimized)
flutter run --release

# Run on specific device
flutter run -d <device_id>

# Run with verbose logging
flutter run -v
```

---

## 🏗️ Building the App

### Build Android APK

```bash
# Build debug APK
flutter build apk --debug

# Build release APK (for distribution)
flutter build apk --release

# Build split APKs by ABI (smaller file size)
flutter build apk --split-per-abi

# Output location: build/app/outputs/flutter-apk/app-release.apk
```

### Build Android App Bundle (for Google Play)

```bash
# Build release bundle
flutter build appbundle --release

# Output location: build/app/outputs/bundle/release/app-release.aab
```


---

## 🗂️ Project Structure

```
lib/
├── main.dart                 # App entry point
├── app.dart                  # Main app widget
│
├── core/                     # Core utilities
│   ├── constants/            # App constants, API keys
│   ├── theme/                # Colors, text styles
│   ├── routes/               # Navigation routing
│   ├── services/             # Backend services (AI, sync, notifications)
│   └── utils/                # Helper functions
│
├── data/                     # Data layer
│   ├── models/               # Data models (User, Exam, Resource)
│   ├── repositories/         # Data access logic
│   └── local/                # Hive database setup
│
├── features/                 # Feature modules
│   ├── auth/                 # Authentication screens
│   ├── home/                 # Home dashboard
│   ├── exam_bank/            # Past questions
│   ├── study_resources/      # Learning materials
│   ├── tutor_marketplace/    # Find tutors
│   ├── scholarships/         # Scholarship portal
│   ├── parent_dashboard/     # Parent monitoring
│   └── profile/              # User profile, settings
│
├── shared/                   # Shared components
│   ├── widgets/              # Reusable UI widgets
│   └── providers/            # Global state providers
│
└── l10n/                     # Localization files (future)
```

---

## 🧪 Testing

### Run Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/widget_test.dart
```

### Manual Testing Checklist

- [ ] Authentication (Sign up, Login, Logout)
- [ ] Offline mode (Airplane mode test)
- [ ] Data synchronization (Online → Offline → Online)
- [ ] Exam download and offline viewing
- [ ] Study resource playback
- [ ] Tutor search and booking
- [ ] Scholarship filtering
- [ ] Parent dashboard analytics
- [ ] Language switching
- [ ] Profile updates

---

## 🐛 Troubleshooting

### Common Issues

#### 1. `google-services.json` not found

Error: `File google-services.json is missing`

Solution:
```bash
# Ensure file is in correct location
ls android/app/google-services.json

# If missing, download from Firebase Console
```

#### 3. Gradle Build Failed (Android)

Error: `Gradle build failed`

Solution:
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

#### 4. Hive Database Error

Error: `HiveError: Box has already been closed`

Solution: Delete app data and reinstall
```bash
flutter clean
flutter pub get
flutter run
```

#### 5. Firebase Authentication Error

Error: `PERMISSION_DENIED` or `User not found`

Solution: Check Firebase Console → Authentication → Sign-in method → Email/Password is enabled

#### 6. Cloudinary Upload Fails

Error: `Failed to upload`

Solution:
- Verify credentials in `app_constants.dart`
- Check upload preset is "unsigned"
- Ensure file size is under limit (5MB for images, 50MB for docs)

### Clear All Data & Rebuild

```bash
# Nuclear option - start fresh
flutter clean
cd ios && pod deintegrate && pod install && cd ..
rm -rf build/
flutter pub get
flutter run
```

---

## 📱 Device Requirements

### Android
- **Minimum**: Android 6.0 (API 23)
- **Recommended**: Android 8.0+ (API 26+)
- **Storage**: 100MB+ free space
- **RAM**: 2GB minimum, 4GB recommended

---

## 🔑 Environment Variables (Optional)

For sensitive data, use environment variables:

1. Create `.env` file in project root (don't commit to Git):

```env
FIREBASE_API_KEY='AIzaSyDHGvSnw1oBsUMtKYe5i5kKL_a5l8suYXQ'
CLOUDINARY_CLOUD_NAME='dlehlwowc'
GEMINI_API_KEY='AIzaSyDCf7gocerq-VpZgGU6CQ3RXdSYo428Hnk'
```

2. Add to `.gitignore`:

```
.env
```

3. Use `flutter_dotenv` package to load variables

---

## 📦 Dependencies

### Production Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  provider: ^6.1.1
  
  # Local Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
  # Backend
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.3
  cloud_firestore: ^4.13.6
  firebase_storage: ^11.5.6
  
  # Cloud Storage
  cloudinary_public: ^0.21.0
  
  # UI Components
  google_fonts: ^6.1.0
  fl_chart: ^0.65.0
  shimmer: ^3.0.0
  
  # PDF Viewer
  flutter_pdfview: ^1.3.2
  
  # Networking
  http: ^1.1.2
  connectivity_plus: ^5.0.2
  
  # Notifications
  flutter_local_notifications: ^16.3.0
  
  # File Handling
  file_picker: ^6.1.1
  image_picker: ^1.0.5
  
  # Utils
  intl: ^0.18.1
  uuid: ^4.2.2
```

### Dev Dependencies

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  build_runner: ^2.4.7
  hive_generator: ^2.0.1
```

To install/update dependencies:
```bash
flutter pub get
flutter pub upgrade
```

---

## 🚢 Deployment

### Android - Google Play Store

1. **Generate Signing Key**:
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. **Create** `android/key.properties`:
```properties
storePassword=<password>
keyPassword=<password>
keyAlias=upload
storeFile=/Users/<username>/upload-keystore.jks
```

3. **Build Release**:
```bash
flutter build appbundle --release
```

4. Upload `app-release.aab` to Google Play Console


---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👥 Developer

- **[Ngong Glenys Fulai]** - *Ngong Glenys Fulai* - [GitHub Profile](https://github.com/glenyxx)

---

## 🙏 Acknowledgments

- Cameroon Ministry of Education for curriculum guidelines
- GCE Board and BEPC examination bodies
- Firebase, Cloudinary and Flutter communities
- Anthropic's Claude for development assistance
- The ICT University for project support

---

## 📞 Support & Contact

- **Email**: glenysngong.ngf@gmail.cm
- **GitHub Issues**: [Report bugs here](https://github.com/glenyxx/cameroon_academic_management_system.git/issues)
- **Documentation**: [Wiki](https://github.com/glenyxx/cameroon_academic_management_system.git/wiki)

---

## 🗺️ Roadmap

### Phase 1 (Completed) ✅
- [x] User authentication
- [x] Exam bank with offline support
- [x] Study resources library
- [x] Tutor marketplace
- [x] Scholarship portal
- [x] Parent dashboard

### Phase 2 (In Progress) 🚧
- [ ] Complete language localization
- [ ] Payment integration (MTN/Orange Money)
- [ ] Push notifications
- [ ] Video player enhancements

### Phase 3 (Planned) 📅
- [ ] AI-powered study recommendations
- [ ] Live classes with video conferencing
- [ ] Gamification (leaderboards, achievements)
- [ ] Community forums
- [ ] Web platform

---

## 💡 Tips for Development

1. **Hot Reload**: Press `r` in terminal while app is running to hot reload changes
2. **Hot Restart**: Press `R` for full app restart
3. **Debug Paint**: Use Flutter DevTools to inspect UI layout
4. **Performance**: Run in profile mode (`--profile`) to test performance
5. **Logs**: Use `print()` or `debugPrint()` for debugging, check with `flutter logs`

---

**Last Updated**: 3rd January 2026  
**Flutter Version**: 3.0+  
**Minimum Dart SDK**: 2.19.0

---

**Built with love for Cameroonian Secondary School Students**