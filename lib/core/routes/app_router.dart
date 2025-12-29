import 'package:flutter/material.dart';
import '../../features/onboarding/screens/splash_screen.dart';
import '../../features/onboarding/screens/language_selection_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/role_selection_screen.dart';
import '../../features/auth/screens/signup_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/home/screens/notifications_screen.dart';
import '../../features/home/screens/messages_screen.dart';
import '../../features/home/screens/school_calendar_screen.dart';
import '../../features/exam_bank/screens/past_questions_screen.dart';
import '../../features/exam_bank/screens/subject_progress_screen.dart';
import '../../features/study_resources/screens/study_materials_screen.dart';
import '../../features/study_resources/screens/video_player_screen.dart';
import '../../features/scholarships/screens/scholarships_screen.dart';
import '../../features/scholarships/screens/scholarship_detail_screen.dart';
import '../../features/tutor_marketplace/screens/find_tutor_screen.dart';
import '../../features/tutor_marketplace/screens/tutor_profile_screen.dart';
import '../../features/tutor_marketplace/screens/book_session_screen.dart';
import '../../features/tutor_marketplace/screens/payment_method_screen.dart';
import '../../features/parent_dashboard/screens/parent_dashboard_screen.dart';
import '../../features/profile/screens/settings_screen.dart';
import '../../features/profile/screens/student_report_screen.dart';
import '../../features/home/screens/event_detail_screen.dart';
import '../../features/tutor_marketplace/screens/my_students_screen.dart';
import '../../features/teacher_dashboard/screens/teaching_jobs_screen.dart';
import '../../features/teacher_dashboard/screens/teacher_dashboard_screen.dart';
import '../../features/profile/screens/edit_profile_screen.dart';
import '../../features/tutor_marketplace/screens/tutor_message_screen.dart';

class AppRouter {
  // Route names
  static const String splash = '/';
  static const String languageSelection = '/language-selection';
  static const String roleSelection = '/role-selection';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String examBank = '/exam-bank';
  static const String subjectProgress = '/subject-progress';
  static const String studyResources = '/study-resources';
  static const String videoPlayer = '/video-player';
  static const String tutorMarketplace = '/tutor-marketplace';
  static const String tutorProfile = '/tutor-profile';
  static const String bookSession = '/book-session';
  static const String paymentMethod = '/payment-method';
  static const String scholarships = '/scholarships';
  static const String scholarshipDetail = '/scholarship-detail';
  static const String parentDashboard = '/parent-dashboard';
  static const String notifications = '/notifications';
  static const String messages = '/messages';
  static const String schoolCalendar = '/school-calendar';
  static const String settings = '/settings';
  static const String studentReport = '/student-report';
  static const String eventDetail = '/event-detail';
  static const String myStudents = '/my-students';
  static const String teachingJobs = '/teaching-jobs';
  static const String teacherDashboard = '/teacher-dashboard';
  static const String editProfile = '/edit-profile';
  static const String tutorMessages = '/tutor-messages';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );

      case languageSelection:
        return MaterialPageRoute(
          builder: (_) => const LanguageSelectionScreen(),
        );

      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );

      case roleSelection:
        return MaterialPageRoute(
          builder: (_) => const RoleSelectionScreen(),
        );

      case register:
        return MaterialPageRoute(
          builder: (_) => const SignUpScreen(),
        );

      case home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );

      case examBank:
        return MaterialPageRoute(
          builder: (_) => const PastQuestionsScreen(),
        );

      case subjectProgress:
        return MaterialPageRoute(
          builder: (_) => SubjectProgressScreen(
            subject: settings.arguments as String? ?? 'Mathematics',
          ),
        );

      case studyResources:
        return MaterialPageRoute(
          builder: (_) => const StudyMaterialsScreen(),
        );

      case videoPlayer:
        return MaterialPageRoute(
          builder: (_) => const VideoPlayerScreen(),
        );

      case tutorMarketplace:
        return MaterialPageRoute(
          builder: (_) => const FindTutorScreen(),
        );

      case tutorProfile:
        return MaterialPageRoute(
          builder: (_) => TutorProfileScreen(
            tutor: settings.arguments as Map<String, dynamic>?,
          ),
        );

      case bookSession:
        return MaterialPageRoute(
          builder: (_) => BookSessionScreen(
            tutor: settings.arguments as Map<String, dynamic>?,
          ),
        );

      case paymentMethod:
        return MaterialPageRoute(
          builder: (_) => PaymentMethodScreen(
            amount: (settings.arguments as double?) ?? 1500,
          ),
        );

      case scholarships:
        return MaterialPageRoute(
          builder: (_) => const ScholarshipsScreen(),
        );

      case scholarshipDetail:
        return MaterialPageRoute(
          builder: (_) => ScholarshipDetailScreen(
            scholarship: settings.arguments as Map<String, dynamic>?,
          ),
        );

      case parentDashboard:
        return MaterialPageRoute(
          builder: (_) => const ParentDashboardScreen(),
        );

      case notifications:
        return MaterialPageRoute(
          builder: (_) => const NotificationsScreen(),
        );

      case messages:
        return MaterialPageRoute(
          builder: (_) => const MessagesScreen(),
        );

      case schoolCalendar:
        return MaterialPageRoute(
          builder: (_) => const SchoolCalendarScreen(),
        );

      case AppRouter.settings:
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
        );

      case studentReport:
        return MaterialPageRoute(
          builder: (_) => const StudentReportScreen(),
        );

      case eventDetail:
        return MaterialPageRoute(
          builder: (_) => EventDetailScreen(
            event: settings.arguments as Map<String, dynamic>?,
          ),
        );

      case myStudents:
        return MaterialPageRoute(
          builder: (_) => const MyStudentsScreen(),
        );

      case teachingJobs:
        return MaterialPageRoute(
          builder: (_) => const TeachingJobsScreen(),
        );

      case teacherDashboard:
        return MaterialPageRoute(
          builder: (_) => const TeacherDashboardScreen(),
        );

      case editProfile:
        return MaterialPageRoute(
          builder: (_) => const EditProfileScreen(),
        );

      case tutorMessages:
        return MaterialPageRoute(
          builder: (_) => const TutorMessagesScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}