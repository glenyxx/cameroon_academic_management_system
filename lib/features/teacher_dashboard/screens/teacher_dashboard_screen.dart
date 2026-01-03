import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/colors.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../core/routes/app_router.dart';

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  int _currentIndex = 0;
  String _selectedLanguage = 'EN';

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
    if (_currentIndex == 0) {
      return _buildDashboardTab();
    } else {
      return Center(
        child: ElevatedButton(
          onPressed: () {
            _navigateToTabScreen(_currentIndex);
          },
          child: Text('Go to ${_getTabName(_currentIndex)}'),
        ),
      );
    }
  }

  String _getTabName(int index) {
    switch (index) {
      case 1: return 'Classes';
      case 2: return 'Jobs';
      case 3: return 'Resources';
      case 4: return 'Profile';
      default: return 'Dashboard';
    }
  }

  void _navigateToTabScreen(int index) {
    switch (index) {
      case 0:
      // Already on dashboard
        break;
      case 1:
      // Navigate to video player screen for classes
        Navigator.pushNamed(context, AppRouter.videoPlayer);
        break;
      case 2:
      // Navigate to teaching jobs screen
        Navigator.pushNamed(context, AppRouter.teachingJobs);
        break;
      case 3:
      // Navigate to study resources screen
        Navigator.pushNamed(context, AppRouter.studyResources);
        break;
      case 4:
      // Navigate to edit profile screen
        Navigator.pushNamed(context, AppRouter.tutorProfile);
        break;
    }
  }

  Widget _buildDashboardTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildStatsGrid(),
          _buildQuickActions(),
          _buildLessonManagement(),
          _buildTodaysSchedule(),
          _buildRecentMessages(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final authProvider = context.watch<AuthProvider>();
    final userName = authProvider.currentUser?.name ?? 'Prof. Alima';

    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.secondary.withOpacity(0.2),
            child: Text(
              userName.substring(0, 1),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Welcome, $userName',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.inputFill,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                _buildLanguageButton('EN'),
                _buildLanguageButton('FR'),
              ],
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: AppColors.textPrimary),
            onPressed: () {
              // Navigate to notifications screen
              Navigator.pushNamed(context, AppRouter.notifications);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageButton(String lang) {
    final isSelected = _selectedLanguage == lang;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLanguage = lang;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          lang,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard('Active Students', '124', Icons.people),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard('Classes', '5', Icons.class_),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return GestureDetector(
      onTap: () {
        if (label == 'Active Students') {
          // Navigate to My Students screen
          Navigator.pushNamed(context, AppRouter.myStudents);
        } else if (label == 'Classes') {
          // Navigate to Video Player screen (classes)
          Navigator.pushNamed(context, AppRouter.videoPlayer);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildClassAnalyticsCard(),
        ],
      ),
    );
  }

  Widget _buildClassAnalyticsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Class Analytics',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'View student progress and average grades.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Updated 2h ago',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigate to My Students screen (tutor view)
                  Navigator.pushNamed(context, AppRouter.myStudents);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: const Text('View Analytics'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Simple chart placeholder
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(
                Icons.show_chart,
                size: 48,
                color: AppColors.primary.withOpacity(0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonManagement() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Lesson Management',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  // Navigate to Study Resources screen for uploading
                  Navigator.pushNamed(context, AppRouter.studyResources);
                },
                icon: Icon(Icons.upload_file, size: 16, color: AppColors.primary),
                label: Text(
                  'Upload New',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildLessonItem(
            'Algebra_Chapter_4.pdf',
            'Uploaded yesterday',
            Icons.picture_as_pdf,
            AppColors.error,
          ),
          const SizedBox(height: 12),
          _buildLessonItem(
            'Photosynthesis_Intro.ppt',
            'Uploaded 3 days ago',
            Icons.slideshow,
            AppColors.info,
          ),
        ],
      ),
    );
  }

  Widget _buildLessonItem(String title, String time, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.more_vert, color: AppColors.textSecondary),
          onPressed: () {
            _showLessonOptions(context, title);
          },
        ),
      ],
    );
  }

  Widget _buildTodaysSchedule() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Today's Schedule",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              IconButton(
                icon: Icon(Icons.add_circle_outline, color: AppColors.primary),
                onPressed: () {
                  // Navigate to School Calendar screen
                  Navigator.pushNamed(context, AppRouter.schoolCalendar);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              // Navigate to School Calendar screen
              Navigator.pushNamed(context, AppRouter.schoolCalendar);
            },
            child: _buildScheduleItem(
              '10:00 AM',
              'Grade 10 - Physics Class',
              'Topic: Newtonian Mechanics',
              AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              // Navigate to School Calendar screen
              Navigator.pushNamed(context, AppRouter.schoolCalendar);
            },
            child: _buildScheduleItem(
              '2:00 PM',
              'Staff Meeting',
              'Location: Conference Room',
              AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(String time, String title, String subtitle, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 4,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                time,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
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
      ],
    );
  }

  Widget _buildRecentMessages() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Messages',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to Messages screen
                  Navigator.pushNamed(context, AppRouter.tutorMessages);
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              // Navigate to Tutor Messages screen
              Navigator.pushNamed(context, AppRouter.tutorMessages);
            },
            child: _buildMessageItem('Fongang Gilles', 'Hello Professor, I have a question about the...'),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              // Navigate to Tutor Messages screen
              Navigator.pushNamed(context, AppRouter.tutorMessages);
            },
            child: _buildMessageItem('Amina Doumbia', 'Thank you for the feedback on my essay!'),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(String name, String message) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Text(
            name.substring(0, 1),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                message,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Remove these since we're navigating to actual screens
  // Widget _buildClassesTab() { ... }
  // Widget _buildMessagesTab() { ... }
  // Widget _buildResourcesTab() { ... }
  // Widget _buildProfileTab() { ... }

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
          if (index == 0) {
            // If clicking on dashboard, stay on dashboard (current screen)
            setState(() {
              _currentIndex = index;
            });
          } else {
            // For other tabs, navigate to the corresponding screen
            _navigateToTabScreen(index);
            // Keep the dashboard tab selected visually
            setState(() {
              _currentIndex = 0; // Reset to dashboard
            });
          }
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
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            activeIcon: Icon(Icons.school),
            label: 'Classes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            activeIcon: Icon(Icons.work),
            label: 'Jobs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_outlined),
            activeIcon: Icon(Icons.folder),
            label: 'Resources',
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

  void _showLessonOptions(BuildContext context, String lessonTitle) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.remove_red_eye, color: AppColors.primary),
                title: Text('Preview'),
                onTap: () {
                  Navigator.pop(context);
                  // Could navigate to a PDF viewer or video player
                  Navigator.pushNamed(context, AppRouter.videoPlayer);
                },
              ),
              ListTile(
                leading: Icon(Icons.edit, color: AppColors.warning),
                title: Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to edit screen (could be study resources)
                  Navigator.pushNamed(context, AppRouter.studyResources);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: AppColors.error),
                title: Text('Delete'),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDeleteLesson(context, lessonTitle);
                },
              ),
              ListTile(
                leading: Icon(Icons.share, color: AppColors.info),
                title: Text('Share'),
                onTap: () {
                  Navigator.pop(context);
                  // Share functionality
                  // You might want to add a share package
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDeleteLesson(BuildContext context, String lessonTitle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Lesson'),
        content: Text('Are you sure you want to delete "$lessonTitle"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Call API to delete lesson
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Lesson deleted'))
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}