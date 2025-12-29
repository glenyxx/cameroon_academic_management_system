import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';

class StudyMaterialsScreen extends StatefulWidget {
  const StudyMaterialsScreen({super.key});

  @override
  State<StudyMaterialsScreen> createState() => _StudyMaterialsScreenState();
}

class _StudyMaterialsScreenState extends State<StudyMaterialsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _materials = [
    {
      'title': 'Chapter 5: Photosynthesis Notes',
      'description': 'A detailed summary of core concepts.',
      'subject': 'Biology',
      'level': 'Form 3',
      'type': 'Notes',
      'isOffline': true,
      'size': '2.5 MB',
      'updated': '2 days ago',
    },
    {
      'title': 'The Laws of Motion',
      'description': 'Video explanation of Newton\'s Laws.',
      'subject': 'Physics',
      'level': 'Form 4',
      'type': 'Video',
      'isOffline': true,
      'duration': '12:34',
      'views': '1.2k',
      'rating': 4.8,
    },
    {
      'title': 'Algebra I Quiz',
      'description': 'Test your knowledge of basic algebra.',
      'subject': 'Math',
      'level': 'Form 1',
      'type': 'Quiz',
      'isOffline': false,
      'questions': '20 questions',
    },
    {
      'title': '2021 History GCE Paper',
      'description': 'Official exam paper with marking guide.',
      'subject': 'History',
      'level': 'Form 5',
      'type': 'Past Paper',
      'isOffline': true,
      'size': '3.8 MB',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
                    _buildSearchAndFilter(),
                    _buildTabs(),
                    Expanded(child: _buildMaterialsList()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Download/Upload action
        },
        backgroundColor: AppColors.secondary,
        child: const Icon(Icons.download, color: Colors.white),
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
              'Study Materials',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.language, color: Colors.white),
            onPressed: () {
              // TODO: Change language
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Expanded(
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
                  hintText: 'Search notes, videos...',
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
          ),
          const SizedBox(width: 12),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: IconButton(
              icon: const Icon(Icons.tune, color: Colors.white),
              onPressed: () {
                // TODO: Show filter bottom sheet
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.primary,
        indicatorWeight: 3,
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        tabs: const [
          Tab(text: 'All'),
          Tab(text: 'Notes'),
          Tab(text: 'Videos'),
          Tab(text: 'Quizzes'),
        ],
      ),
    );
  }

  Widget _buildMaterialsList() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildAllMaterials(),
        _buildFilteredMaterials('Notes'),
        _buildFilteredMaterials('Video'),
        _buildFilteredMaterials('Quiz'),
      ],
    );
  }

  Widget _buildAllMaterials() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _materials.length,
      itemBuilder: (context, index) {
        return _buildMaterialCard(_materials[index]);
      },
    );
  }

  Widget _buildFilteredMaterials(String type) {
    final filtered = _materials.where((m) => m['type'] == type).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open, size: 64, color: AppColors.textSecondary.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(
              'No $type found',
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        return _buildMaterialCard(filtered[index]);
      },
    );
  }

  Widget _buildMaterialCard(Map<String, dynamic> material) {
    final iconData = _getIconForType(material['type']);
    final color = _getColorForSubject(material['subject']);

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
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(iconData, color: color, size: 28),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  material['title'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  material['description'],
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildInfoChip(material['subject'], color),
                    const SizedBox(width: 8),
                    _buildInfoChip(material['level'], AppColors.textSecondary),
                    const Spacer(),
                    if (material['isOffline'])
                      Icon(Icons.download_done, color: AppColors.success, size: 16),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.bookmark_border),
                color: AppColors.textSecondary,
                onPressed: () {},
              ),
              if (material['type'] == 'Video' && material['rating'] != null)
                Row(
                  children: [
                    Icon(Icons.star, color: AppColors.secondary, size: 14),
                    const SizedBox(width: 2),
                    Text(
                      material['rating'].toString(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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

  IconData _getIconForType(String type) {
    switch (type) {
      case 'Notes':
        return Icons.description;
      case 'Video':
        return Icons.play_circle_outline;
      case 'Quiz':
        return Icons.quiz_outlined;
      case 'Past Paper':
        return Icons.assignment;
      default:
        return Icons.folder;
    }
  }

  Color _getColorForSubject(String subject) {
    switch (subject.toLowerCase()) {
      case 'biology':
        return AppColors.success;
      case 'physics':
        return AppColors.info;
      case 'math':
      case 'mathematics':
        return AppColors.primary;
      case 'history':
        return AppColors.warning;
      default:
        return AppColors.textSecondary;
    }
  }
}