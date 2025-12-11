import 'package:flutter/material.dart';
import '../features/onboarding/screens/splash_screen.dart';
import '../features/onboarding/screens/language_selection_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/role_selection_screen.dart';
import '../features/auth/screens/signup_screen.dart';

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
  static const String examDetail = '/exam-detail';
  static const String quiz = '/quiz';
  static const String quizResult = '/quiz-result';
  static const String studyResources = '/study-resources';
  static const String resourceDetail = '/resource-detail';
  static const String tutorMarketplace = '/tutor-marketplace';
  static const String tutorProfile = '/tutor-profile';
  static const String scholarships = '/scholarships';
  static const String scholarshipDetail = '/scholarship-detail';
  static const String profile = '/profile';
  static const String parentDashboard = '/parent-dashboard';
  static const String settings = '/settings';

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
          builder: (_) => const Scaffold(
            body: Center(child: Text('Home Screen')),
          ),
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