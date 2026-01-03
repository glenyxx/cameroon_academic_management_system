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
    // Navigate to Study Resources Screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_currentIndex == 1) {
        Navigator.pushNamed(context, AppRouter.studyResources);
        // Reset to home tab after navigation
        setState(() {
          _currentIndex = 0;
        });
      }
    });

    return Container();
  }

  Widget _buildForumTab() {
    // Navigate to Messages Screen (since Forum/Messages are similar)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_currentIndex == 2) {
        Navigator.pushNamed(context, AppRouter.messages);
        // Reset to home tab after navigation
        setState(() {
          _currentIndex = 0;
        });
      }
    });

    return Container();
  }

  Widget _buildProfileTab() {
    // Build actual profile screen with options
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),

          // Profile Header
          CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: Text(
              user?.name?.substring(0, 1).toUpperCase() ?? 'U',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),

          const SizedBox(height: 16),

          Text(
            user?.name ?? 'User',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            user?.email ?? 'user@example.com',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified, size: 14, color: AppColors.info),
                const SizedBox(width: 4),
                Text(
                  'Verified Student',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.info,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Profile Options
          _buildProfileOption(
            icon: Icons.person_outline,
            title: 'Edit Profile',
            subtitle: 'Update your personal information',
            onTap: () {
              Navigator.pushNamed(context, AppRouter.editProfile);
            },
          ),

          _buildProfileOption(
            icon: Icons.assessment_outlined,
            title: 'My Progress',
            subtitle: 'View your academic progress',
            onTap: () {
              Navigator.pushNamed(context, AppRouter.studentReport);
            },
          ),

          _buildProfileOption(
            icon: Icons.calendar_today_outlined,
            title: 'School Calendar',
            subtitle: 'View upcoming events and exams',
            onTap: () {
              Navigator.pushNamed(context, AppRouter.schoolCalendar);
            },
          ),

          _buildProfileOption(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Manage your notifications',
            onTap: () {
              Navigator.pushNamed(context, AppRouter.notifications);
            },
          ),

          _buildProfileOption(
            icon: Icons.settings_outlined,
            title: 'Settings',
            subtitle: 'App preferences and account',
            onTap: () {
              Navigator.pushNamed(context, AppRouter.settings);
            },
          ),

          const SizedBox(height: 16),

          // Logout Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final shouldLogout = await _showLogoutDialog(context);
                  if (shouldLogout == true && mounted) {
                    final authProvider = context.read<AuthProvider>();
                    await authProvider.signOut();
                    Navigator.pushReplacementNamed(context, AppRouter.login);
                  }
                },
                icon: const Icon(Icons.logout),
                label: const Text('Sign Out'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> _showLogoutDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
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

  void _handleNavigation(int index) {
    switch (index) {
      case 0: // Home
        Navigator.pushReplacementNamed(context, AppRouter.home);
        break;
      case 1: // Courses
        Navigator.pushNamed(context, AppRouter.studyResources);
        break;
      case 3: // Forum
        Navigator.pushNamed(context, AppRouter.messages);
        break;
      case 4: // Profile
        Navigator.pushNamed(context, AppRouter.settings);
        break;
    }
  }
}