import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';

class ScholarshipDetailScreen extends StatefulWidget {
  final Map<String, dynamic>? scholarship;

  const ScholarshipDetailScreen({
    super.key,
    this.scholarship,
  });

  @override
  State<ScholarshipDetailScreen> createState() => _ScholarshipDetailScreenState();
}

class _ScholarshipDetailScreenState extends State<ScholarshipDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isBookmarked = false;

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
    final scholarship = widget.scholarship ?? _getDemoScholarship();
    final matchPercentage = scholarship['match'] as int? ?? 85;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(scholarship),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderCard(scholarship, matchPercentage),
                _buildInfoGrid(scholarship),
                _buildTabs(),
                _buildTabContent(scholarship),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildSliverAppBar(Map<String, dynamic> scholarship) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: AppColors.primary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: Icon(
            _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              _isBookmarked = !_isBookmarked;
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.share, color: Colors.white),
          onPressed: () {},
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Scholarship Details',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(Icons.card_giftcard, size: 40, color: AppColors.secondary),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(Map<String, dynamic> scholarship, int matchPercentage) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Match Badge
          if (matchPercentage >= 80)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.verified, size: 16, color: AppColors.secondary),
                  const SizedBox(width: 6),
                  Text(
                    '$matchPercentage% Match - Highly Recommended!',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),

          // Title
          Text(
            scholarship['title'] ?? 'Cameroon Leadership Scholarship',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 1.3,
            ),
          ),

          const SizedBox(height: 12),

          // Amount
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.success, AppColors.success.withOpacity(0.8)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              scholarship['amount'] ?? '500,000 CFA Award',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoGrid(Map<String, dynamic> scholarship) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
        children: [
          _buildInfoCard(Icons.calendar_today, 'Deadline', scholarship['deadline'] ?? '15 Dec 2024'),
          _buildInfoCard(Icons.location_on, 'Location', scholarship['location'] ?? 'Cameroon'),
          _buildInfoCard(Icons.school, 'Level', scholarship['level'] ?? 'Undergraduate'),
          _buildInfoCard(Icons.science, 'Field', scholarship['field'] ?? 'STEM'),
          _buildInfoCard(Icons.people, 'Spots', scholarship['spots'] ?? '10'),
          _buildInfoCard(Icons.accessibility_new, 'Eligibility', scholarship['eligibility'] ?? 'Female'),
        ],
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inputBorder.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: AppColors.primary),
          const SizedBox(height: 8),
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
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.primary,
        indicatorWeight: 3,
        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Requirements'),
          Tab(text: 'Apply'),
          Tab(text: 'Winners'),
        ],
      ),
    );
  }

  Widget _buildTabContent(Map<String, dynamic> scholarship) {
    return SizedBox(
      height: 500,
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildRequirementsTab(),
          _buildApplyTab(),
          _buildWinnersTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('About the Scholarship'),
          const SizedBox(height: 12),
          Text(
            'This scholarship aims to empower the next generation of female leaders in Cameroon by providing financial support for postgraduate studies in STEM fields. We believe in fostering innovation and leadership that will drive national development.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('What it Covers'),
          const SizedBox(height: 12),
          _buildBulletPoint('Full tuition fees for the duration of the course.'),
          _buildBulletPoint('Monthly stipend for living expenses.'),
          _buildBulletPoint('Round-trip airfare for international students.'),
          _buildBulletPoint('Mentorship from industry leaders.'),
          const SizedBox(height: 24),
          _buildSectionTitle('Duration'),
          const SizedBox(height: 12),
          Text(
            '4 Years (Full-time Undergraduate Program)',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          _buildWhyYouMatch(),
        ],
      ),
    );
  }

  Widget _buildWhyYouMatch() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.info.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, color: AppColors.info, size: 20),
              const SizedBox(width: 8),
              Text(
                'Why You Match',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Your profile shows a strong alignment based on your academic background in Science, your specified interest in Masters programs, and your residency in Cameroon. This makes you a prime candidate for this opportunity.',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Eligibility Criteria'),
          const SizedBox(height: 12),
          _buildRequirementItem(Icons.check_circle, 'Female applicants only', true),
          _buildRequirementItem(Icons.check_circle, 'Cameroonian citizen or resident', true),
          _buildRequirementItem(Icons.check_circle, 'GCE O/L and A/L certificates in science field', true),
          _buildRequirementItem(Icons.cancel, 'Minimum GPA of 3.5/4.0', false),
          _buildRequirementItem(Icons.check_circle, 'Age between 16-22 years', true),
        ],
      ),
    );
  }

  Widget _buildRequirementItem(IconData icon, String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isMet ? AppColors.success : AppColors.textSecondary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplyTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.success),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Application Tracker',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Text(
                  'Not Started',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: 0.0,
            backgroundColor: AppColors.inputFill,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.success),
          ),
        ],
      ),
    );
  }

  Widget _buildWinnersTab() {
    return Center(
      child: Text(
        'Previous winners information',
        style: TextStyle(color: AppColors.textSecondary),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
                height: 1.5,
              ),
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
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Add to List'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(color: AppColors.primary, width: 2),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.file_download_outlined, color: Colors.white),
              label: const Text('Start Application'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getDemoScholarship() {
    return {
      'title': 'Cameroon Leadership Scholarship',
      'amount': '500,000 CFA Award',
      'deadline': '15 Dec 2024',
      'location': 'Cameroon',
      'level': 'Undergraduate',
      'field': 'STEM',
      'spots': '10',
      'eligibility': 'Female',
      'match': 85,
    };
  }
}