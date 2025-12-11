import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/app_router.dart';
import '../../../data/models/user_model.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  UserRole? _selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                'EN/FR',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.school,
                  size: 32,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 24),

              // Title
              Text(
                'Welcome! Who are you?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 40),

              // Role Cards Grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                  children: [
                    _RoleCard(
                      icon: Icons.school_outlined,
                      title: 'Student',
                      description: 'Access lessons, quizzes, and track your progress.',
                      role: UserRole.student,
                      isSelected: _selectedRole == UserRole.student,
                      onTap: () {
                        setState(() {
                          _selectedRole = UserRole.student;
                        });
                      },
                    ),
                    _RoleCard(
                      icon: Icons.menu_book_outlined,
                      title: 'Teacher',
                      description: 'Manage classes, create assignments, and monitor students.',
                      role: UserRole.teacher,
                      isSelected: _selectedRole == UserRole.teacher,
                      onTap: () {
                        setState(() {
                          _selectedRole = UserRole.teacher;
                        });
                      },
                    ),
                    _RoleCard(
                      icon: Icons.people_outline,
                      title: 'Parent',
                      description: 'Follow your child\'s performance and communicate with teachers.',
                      role: UserRole.parent,
                      isSelected: _selectedRole == UserRole.parent,
                      onTap: () {
                        setState(() {
                          _selectedRole = UserRole.parent;
                        });
                      },
                    ),
                    _RoleCard(
                      icon: Icons.workspace_premium_outlined,
                      title: 'Tutor',
                      description: 'Connect with students and provide personalized support.',
                      role: UserRole.tutor,
                      isSelected: _selectedRole == UserRole.tutor,
                      onTap: () {
                        setState(() {
                          _selectedRole = UserRole.tutor;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Help Link
              Center(
                child: TextButton(
                  onPressed: () {
                    // TODO: Show help dialog
                  },
                  child: Text(
                    'Help',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final UserRole role;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.role,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.secondary : Colors.transparent,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32,
                color: AppColors.secondary,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}