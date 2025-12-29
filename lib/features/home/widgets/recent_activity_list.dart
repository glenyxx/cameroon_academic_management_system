import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';

class RecentActivityList extends StatelessWidget {
  const RecentActivityList({super.key});

  @override
  Widget build(BuildContext context) {
    final activities = [
      {
        'icon': Icons.check_circle,
        'color': AppColors.success,
        'title': "You completed 'Algebra II' quiz",
        'time': '1 hour ago',
      },
      {
        'icon': Icons.calendar_today,
        'color': AppColors.info,
        'title': 'Physics Study Group Meeting',
        'time': 'Today at 4:00 PM',
      },
      {
        'icon': Icons.forum,
        'color': AppColors.primary,
        'title': "New post in 'GCE Discussion'",
        'time': 'Yesterday',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),

        const SizedBox(height: 16),

        Container(
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
            children: activities.map((activity) {
              final isLast = activity == activities.last;
              return _ActivityItem(
                icon: activity['icon'] as IconData,
                color: activity['color'] as Color,
                title: activity['title'] as String,
                time: activity['time'] as String,
                isLast: isLast,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String time;
  final bool isLast;

  const _ActivityItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.time,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: !isLast
            ? Border(
          bottom: BorderSide(
            color: AppColors.inputBorder.withOpacity(0.3),
            width: 1,
          ),
        )
            : null,
      ),
      child: Row(
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
                const SizedBox(height: 4),
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

          Icon(
            Icons.chevron_right,
            color: AppColors.textSecondary,
            size: 20,
          ),
        ],
      ),
    );
  }
}