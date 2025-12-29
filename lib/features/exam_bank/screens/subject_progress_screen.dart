import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';

class SubjectProgressScreen extends StatefulWidget {
  final String subject;

  const SubjectProgressScreen({
    super.key,
    this.subject = 'Mathematics',
  });

  @override
  State<SubjectProgressScreen> createState() => _SubjectProgressScreenState();
}

class _SubjectProgressScreenState extends State<SubjectProgressScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
        title: Text(
          widget.subject,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _buildStatsCard(),
          _buildTabs(),
          Expanded(child: _buildTabContent()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.auto_awesome, color: Colors.white),
        label: const Text(
          'Start Smart Practice',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          // Progress Circle
          SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    value: 0.68,
                    strokeWidth: 8,
                    backgroundColor: AppColors.inputFill,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
                Center(
                  child: Text(
                    '68%',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 24),

          // Stats Grid
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    _buildStatItem('Total Questions', '1,250'),
                    const SizedBox(width: 16),
                    _buildStatItem('Completed', '850'),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildStatItem('Avg Score', '78%', color: AppColors.success),
                    const SizedBox(width: 16),
                    _buildStatItem('Time Spent', '42h 30m'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, {Color? color}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
          Tab(text: 'By Year'),
          Tab(text: 'By Topic'),
          Tab(text: 'Mock Exams'),
          Tab(text: 'Saved'),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildByYearTab(),
        _buildByTopicTab(),
        _buildMockExamsTab(),
        _buildSavedTab(),
      ],
    );
  }

  Widget _buildByYearTab() {
    final years = [
      {'year': '2023', 'papers': 2, 'progress': 1.0},
      {'year': '2022', 'papers': 2, 'progress': 0.5},
      {'year': '2021', 'papers': 2, 'progress': 0.0},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: years.length,
      itemBuilder: (context, index) {
        final year = years[index];
        return _buildYearCard(year);
      },
    );
  }

  Widget _buildYearCard(Map<String, dynamic> year) {
    final progress = year['progress'] as double;
    final isComplete = progress == 1.0;
    final isInProgress = progress > 0 && progress < 1.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.all(16),
          childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isComplete
                  ? AppColors.success.withOpacity(0.1)
                  : isInProgress
                  ? AppColors.warning.withOpacity(0.1)
                  : AppColors.inputFill,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                year['year'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isComplete
                      ? AppColors.success
                      : isInProgress
                      ? AppColors.warning
                      : AppColors.textSecondary,
                ),
              ),
            ),
          ),
          title: Text(
            '${year['year']} GCE O-Level',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          trailing: isComplete
              ? Icon(Icons.check_circle, color: AppColors.success)
              : Icon(Icons.chevron_right, color: AppColors.textSecondary),
          children: [
            _buildPaperItem('Paper 1: Multiple Choice', isComplete, progress >= 1.0),
            const SizedBox(height: 8),
            _buildPaperItem('Paper 2: Structured Questions', isInProgress, progress >= 0.5),
          ],
        ),
      ),
    );
  }

  Widget _buildPaperItem(String title, bool isComplete, bool hasProgress) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
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
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: hasProgress ? 0.75 : 0.0,
                  backgroundColor: AppColors.inputFill,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isComplete ? AppColors.success : AppColors.warning,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          if (isComplete)
            TextButton(
              onPressed: () {},
              child: const Text('View Results'),
            )
          else if (hasProgress)
            TextButton(
              onPressed: () {},
              child: const Text('Resume'),
            )
          else
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                elevation: 0,
              ),
              child: const Text('Download Paper'),
            ),
        ],
      ),
    );
  }

  Widget _buildByTopicTab() {
    return Center(
      child: Text('Topics View', style: TextStyle(color: AppColors.textSecondary)),
    );
  }

  Widget _buildMockExamsTab() {
    return Center(
      child: Text('Mock Exams', style: TextStyle(color: AppColors.textSecondary)),
    );
  }

  Widget _buildSavedTab() {
    return Center(
      child: Text('Saved Items', style: TextStyle(color: AppColors.textSecondary)),
    );
  }
}