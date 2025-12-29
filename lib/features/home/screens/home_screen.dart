import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/app_router.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../widgets/greeting_header.dart';
import '../widgets/exam_countdown_card.dart';
import '../widgets/study_goals_card.dart';
import '../widgets/ai_assistant_card.dart';
import '../widgets/study_streak_card.dart';
import '../widgets/quick_access_grid.dart';
import '../widgets/recent_activity_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _buildBody(),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return _buildCoursesTab();
      case 2:
        return _buildForumTab();
      case 3:
        return _buildProfileTab();
      default:
        return _buildHomeTab();
    }
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting Header
          const GreetingHeader(),

          const SizedBox(height: 16),

          // Exam Countdown Card
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: ExamCountdownCard(
              examType: 'GCE O-Level',
              daysLeft: 42,
              examDate: 'June 2025',
            ),
          ),

          const SizedBox(height: 20),

          // Study Goals
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: StudyGoalsCard(),
          ),

          const SizedBox(height: 20),

          // AI Assistant
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: AIAssistantCard(),
          ),

          const SizedBox(height: 20),

          // Study Streak
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: StudyStreakCard(currentStreak: 12),
          ),

          const SizedBox(height: 24),

          // Quick Access
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: QuickAccessGrid(),
          ),

          const SizedBox(height: 24),

          // Recent Activity
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: RecentActivityList(),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildCoursesTab() {
    return Center(
      child: Text(
        'Courses',
        style: TextStyle(fontSize: 24, color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildForumTab() {
    return Center(
      child: Text(
        'Forum',
        style: TextStyle(fontSize: 24, color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildProfileTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Profile',
            style: TextStyle(fontSize: 24, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final authProvider = context.read<AuthProvider>();
              await authProvider.signOut();
              if (mounted) {
                Navigator.pushReplacementNamed(context, AppRouter.login);
              }
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            activeIcon: Icon(Icons.menu_book),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum_outlined),
            activeIcon: Icon(Icons.forum),
            label: 'Forum',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}