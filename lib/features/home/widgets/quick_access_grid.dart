import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/app_router.dart';

class QuickAccessGrid extends StatelessWidget {
  const QuickAccessGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Access',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),

        const SizedBox(height: 16),

        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _QuickAccessItem(
              icon: Icons.description_outlined,
              label: 'Past Qs',
              color: AppColors.gceOLevel,
              onTap: () {
                Navigator.pushNamed(context, AppRouter.examBank);
              },
            ),
            _QuickAccessItem(
              icon: Icons.school_outlined,
              label: 'Resources',
              color: AppColors.bepc,
              onTap: () {
                Navigator.pushNamed(context, AppRouter.studyResources);
              },
            ),
            _QuickAccessItem(
              icon: Icons.card_giftcard_outlined,
              label: 'Scholarships',
              color: AppColors.probatoire,
              onTap: () {
                Navigator.pushNamed(context, AppRouter.scholarships);
              },
            ),
            _QuickAccessItem(
              icon: Icons.person_search_outlined,
              label: 'Find Tutor',
              color: AppColors.secondary,
              onTap: () {
                Navigator.pushNamed(context, AppRouter.tutorMarketplace);
              },
            ),
            _QuickAccessItem(
              icon: Icons.trending_up_outlined,
              label: 'Progress',
              color: AppColors.success,
              onTap: () {},
            ),
            _QuickAccessItem(
              icon: Icons.forum_outlined,
              label: 'Forum',
              color: AppColors.info,
              onTap: () {},
            ),
            _QuickAccessItem(
              icon: Icons.calendar_today_outlined,
              label: 'Timetable',
              color: AppColors.warning,
              onTap: () {},
            ),
            _QuickAccessItem(
              icon: Icons.settings_outlined,
              label: 'Settings',
              color: AppColors.textSecondary,
              onTap: () {
                Navigator.pushNamed(context, AppRouter.settings);
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickAccessItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAccessItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
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
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}