import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';

class StudentReportScreen extends StatefulWidget {
  const StudentReportScreen({super.key});

  @override
  State<StudentReportScreen> createState() => _StudentReportScreenState();
}

class _StudentReportScreenState extends State<StudentReportScreen> {
  String _selectedTerm = 'First Term';
  String _selectedSubjects = 'All Subjects';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last updated: 2 mins ago',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStudentHeader(),
            _buildFilters(),
            _buildOverallPerformance(),
            _buildPerformanceTrend(),
            _buildSubjectGrades(),
            _buildTeacherRemarks(),
            _buildParentRemarks(),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildStudentHeader() {
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
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: Text(
              'KM',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kouamé, Marie-Claire',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Form 5 Science',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildFilterDropdown(
              value: _selectedTerm,
              items: ['First Term', 'Second Term', 'Third Term'],
              icon: Icons.calendar_today,
              onChanged: (value) {
                setState(() => _selectedTerm = value!);
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildFilterDropdown(
              value: _selectedSubjects,
              items: ['All Subjects', 'Science', 'Arts'],
              icon: Icons.book,
              onChanged: (value) {
                setState(() => _selectedSubjects = value!);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String value,
    required List<String> items,
    required IconData icon,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
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
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              underline: const SizedBox(),
              items: items.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item, style: const TextStyle(fontSize: 13)),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallPerformance() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Overall Average',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '85.6%',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 80,
            color: Colors.white24,
            margin: const EdgeInsets.symmetric(horizontal: 20),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Rank in Class',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '3rd',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(Widget child) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
      child: child,
    );
  }

  Widget _buildTotalScore() {
    return _buildCard(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Score',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '856/1000',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceTrend() {
    return _buildCard(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Trend',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Across all subjects this term',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          // Placeholder for chart
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSubjectTrend('Math', 'MATH'),
              _buildSubjectTrend('CHEM', 'CHEM'),
              _buildSubjectTrend('ENG', 'ENG'),
              _buildSubjectTrend('PHY', 'PHY'),
              _buildSubjectTrend('BIO', 'BIO'),
              _buildSubjectTrend('FR', 'FR'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectTrend(String label, String shortName) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectGrades() {
    final subjects = [
      {'name': 'Mathematics', 'teacher': 'Mr. Talla', 'score': 92},
      {'name': 'Biology', 'teacher': 'Mrs. Ngassa', 'score': 90},
      {'name': 'French', 'teacher': 'M. Dubois', 'score': 85},
    ];

    return _buildCard(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...subjects.map((subject) => _buildSubjectRow(
            subject['name'] as String,
            subject['teacher'] as String,
            subject['score'] as int,
          )),
        ],
      ),
    );
  }

  Widget _buildSubjectRow(String name, String teacher, int score) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getScoreColor(score).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(
                Icons.subject,
                color: _getScoreColor(score),
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  teacher,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$score%',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _getScoreColor(score),
            ),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 90) return AppColors.success;
    if (score >= 75) return AppColors.primary;
    if (score >= 60) return AppColors.warning;
    return AppColors.error;
  }

  Widget _buildTeacherRemarks() {
    return _buildCard(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Teacher Remarks',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Marie-Claire has shown exceptional improvement this term, especially in Biology. She is a diligent student but needs to participate more actively in class discussions. Keep up the great work!',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParentRemarks() {
    return _buildCard(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Parent Remarks',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'No remarks added yet.',
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.download),
        label: const Text('Download Full Report'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}