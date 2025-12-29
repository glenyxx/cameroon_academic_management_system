import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';

class StudyStreakCard extends StatelessWidget {
  final int currentStreak;

  const StudyStreakCard({
    super.key,
    required this.currentStreak,
  });

  @override
  Widget build(BuildContext context) {
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
              const Text('🔥', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Text(
                '$currentStreak Day Study Streak!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Calendar Grid
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDayLabel('Mon'),
              _buildDayLabel('Tue'),
              _buildDayLabel('Wed'),
              _buildDayLabel('Thu'),
              _buildDayLabel('Fri'),
              _buildDayLabel('Sat'),
              _buildDayLabel('Sun'),
            ],
          ),

          const SizedBox(height: 8),

          // Week 1
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStreakDay(false),
              _buildStreakDay(false),
              _buildStreakDay(true),
              _buildStreakDay(true),
              _buildStreakDay(true),
              _buildStreakDay(true),
              _buildStreakDay(true),
            ],
          ),

          const SizedBox(height: 8),

          // Week 2
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStreakDay(true),
              _buildStreakDay(true),
              _buildStreakDay(true),
              _buildStreakDay(true),
              _buildStreakDay(true),
              _buildStreakDay(true),
              _buildStreakDay(false, isToday: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDayLabel(String day) {
    return SizedBox(
      width: 36,
      child: Text(
        day,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildStreakDay(bool completed, {bool isToday = false}) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: completed
            ? AppColors.success
            : isToday
            ? AppColors.success.withOpacity(0.3)
            : AppColors.inputFill,
        borderRadius: BorderRadius.circular(8),
        border: isToday
            ? Border.all(color: AppColors.success, width: 2)
            : null,
      ),
      child: completed
          ? const Icon(Icons.check, color: Colors.white, size: 20)
          : null,
    );
  }
}