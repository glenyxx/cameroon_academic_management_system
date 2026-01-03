import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../../../data/models/exam_model.dart';

class PastQuestionsScreen extends StatefulWidget {
  const PastQuestionsScreen({super.key});

  @override
  State<PastQuestionsScreen> createState() => _PastQuestionsScreenState();
}

class _PastQuestionsScreenState extends State<PastQuestionsScreen> {
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _mockExams = [
    {
      'title': 'GCE Advanced Level Mathematics Paper 2',
      'subtitle': 'Includes Marking Guide',
      'subject': 'Mathematics',
      'year': '2022',
      'examType': 'GCE Board',
      'type': ExamType.gceALevel,
      'isDownloaded': true,
    },
    {
      'title': 'BEPC Physics',
      'subtitle': 'Question Paper Only',
      'subject': 'Physics',
      'year': '2021',
      'examType': 'BEPC',
      'type': ExamType.bepc,
      'isDownloaded': false,
    },
    {
      'title': 'GCE Ordinary Level Biology Paper 1',
      'subtitle': 'Includes Marking Guide',
      'subject': 'Biology',
      'year': '2022',
      'examType': 'GCE Board',
      'type': ExamType.gceOLevel,
      'isDownloaded': true,
    },
    {
      'title': 'GCE Advanced Level Chemistry Paper 3',
      'subtitle': 'Question Paper Only',
      'subject': 'Chemistry',
      'year': '2020',
      'examType': 'GCE Board',
      'type': ExamType.gceALevel,
      'isDownloaded': false,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    _buildSearchBar(),
                    _buildFilterChips(),
                    Expanded(child: _buildExamList()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Past Questions',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.white),
            onPressed: () {
              // TODO: Show filter options
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
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
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search by keyword, topic...',
            hintStyle: TextStyle(
              color: AppColors.textSecondary.withOpacity(0.6),
            ),
            prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'GCE', 'BEPC', 'By Subject'];

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              backgroundColor: Colors.white,
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? AppColors.primary : AppColors.inputBorder,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildExamList() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Showing ${_mockExams.length} results',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        ..._mockExams.map((exam) => _buildExamCard(exam)),
      ],
    );
  }

  Widget _buildExamCard(Map<String, dynamic> exam) {
    final color = _getExamTypeColor(exam['type']);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.description,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exam['title'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      exam['subtitle'],
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (exam['isDownloaded'])
                Icon(Icons.download_done, color: AppColors.success, size: 20)
              else
                Icon(Icons.download_outlined, color: AppColors.textSecondary, size: 20),
            ],
          ),

          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            children: [
              _buildTag(exam['subject'], AppColors.primary),
              _buildTag(exam['year'], AppColors.secondary),
              _buildTag(exam['examType'], color),
              if (exam['isDownloaded'])
                _buildTag('Offline', AppColors.success),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Color _getExamTypeColor(ExamType type) {
    switch (type) {
      case ExamType.gceOLevel:
        return AppColors.gceOLevel;
      case ExamType.gceALevel:
        return AppColors.gceALevel;
      case ExamType.bepc:
        return AppColors.bepc;
      case ExamType.probatoire:
        return AppColors.probatoire;
      case ExamType.bac:
        return AppColors.bac;
    }
  }
}