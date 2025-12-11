import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';

class StudyGoalsCard extends StatefulWidget {
  const StudyGoalsCard({super.key});

  @override
  State<StudyGoalsCard> createState() => _StudyGoalsCardState();
}

class _StudyGoalsCardState extends State<StudyGoalsCard> {
  final List<Map<String, dynamic>> _goals = [
    {'title': 'Complete Algebra Chapter 5', 'completed': true},
    {'title': 'Review Physics Optics notes', 'completed': true},
    {'title': 'Take Literature practice quiz', 'completed': true},
    {'title': 'Watch video on French grammar', 'completed': false},
  ];

  @override
  Widget build(BuildContext context) {
    final completedCount = _goals.where((g) => g['completed']).length;
    final totalCount = _goals.length;

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "Today's Study Goals",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('✨', style: TextStyle(fontSize: 16)),
                ],
              ),
              Text(
                '$completedCount/$totalCount Done',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.success,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          ...(_goals.map((goal) => _buildGoalItem(goal))),
        ],
      ),
    );
  }

  Widget _buildGoalItem(Map<String, dynamic> goal) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                goal['completed'] = !goal['completed'];
              });
            },
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: goal['completed'] ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: goal['completed'] ? AppColors.primary : AppColors.inputBorder,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: goal['completed']
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              goal['title'],
              style: TextStyle(
                fontSize: 14,
                color: goal['completed']
                    ? AppColors.textSecondary
                    : AppColors.textPrimary,
                decoration: goal['completed']
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}