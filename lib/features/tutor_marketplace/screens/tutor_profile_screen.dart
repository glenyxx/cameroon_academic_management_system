import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/app_router.dart';

class TutorProfileScreen extends StatefulWidget {
  final Map<String, dynamic>? tutor;

  const TutorProfileScreen({
    super.key,
    this.tutor,
  });

  @override
  State<TutorProfileScreen> createState() => _TutorProfileScreenState();
}

class _TutorProfileScreenState extends State<TutorProfileScreen> with SingleTickerProviderStateMixin {
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
    final tutor = widget.tutor ?? _getDemoTutor();

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(tutor),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(tutor),
                _buildQuickStats(tutor),
                _buildActionButtons(tutor),
                _buildTabs(),
                _buildTabContent(tutor),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(tutor),
    );
  }

  Widget _buildSliverAppBar(Map<String, dynamic> tutor) {
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
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onPressed: () {},
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.success, AppColors.success.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(Map<String, dynamic> tutor) {
    return Transform.translate(
      offset: const Offset(0, -50),
      child: Column(
        children: [
          // Profile Image
          Stack(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 58,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    tutor['name'].toString().substring(0, 1),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              if (tutor['isAvailable'])
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Text(
                      'Available Now',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Name & Verification
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                tutor['name'],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              if (tutor['isVerified']) ...[
                const SizedBox(width: 8),
                Icon(Icons.verified, color: AppColors.info, size: 24),
              ],
            ],
          ),

          const SizedBox(height: 4),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, color: AppColors.secondary, size: 20),
              const SizedBox(width: 4),
              Text(
                '${tutor['rating']} (${tutor['reviews']} reviews)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            '${tutor['rate']}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),

          if (tutor['matchScore'] != null && tutor['matchScore'] >= 80) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_awesome, color: AppColors.secondary, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    'First session discount!',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickStats(Map<String, dynamic> tutor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem('1200+', 'Total Sessions'),
          Container(width: 1, height: 40, color: AppColors.inputBorder),
          _buildStatItem('250+', 'Students Taught'),
          Container(width: 1, height: 40, color: AppColors.inputBorder),
          _buildStatItem('92%', 'Pass Rate'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(Map<String, dynamic> tutor) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.message_outlined),
              label: const Text('Message'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(color: AppColors.primary, width: 2),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.phone_outlined),
              label: const Text('Call'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(color: AppColors.primary, width: 2),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.bookmark_border, color: Colors.white),
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
          Tab(text: 'About'),
          Tab(text: 'Availability'),
          Tab(text: 'Reviews'),
          Tab(text: 'Media'),
        ],
      ),
    );
  }

  Widget _buildTabContent(Map<String, dynamic> tutor) {
    return SizedBox(
      height: 400,
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildAboutTab(tutor),
          _buildAvailabilityTab(),
          _buildReviewsTab(),
          _buildMediaTab(),
        ],
      ),
    );
  }

  Widget _buildAboutTab(Map<String, dynamic> tutor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('About Me'),
          const SizedBox(height: 12),
          Text(
            'Dedicated and passionate Physics and Mathematics educator with over 8 years of experience helping students excel in their GCE examinations. My goal is to make complex concepts simple and engaging.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 24),

          _buildSectionTitle('Credentials'),
          const SizedBox(height: 12),
          _buildCredentialItem(
            Icons.school,
            'M.Sc. in Physics, University of Yaoundé I',
            '2012 - 2014',
          ),
          const SizedBox(height: 8),
          _buildCredentialItem(
            Icons.work,
            'Senior Tutor, ABC Tutors Douala',
            '2015 - Present',
          ),
          const SizedBox(height: 8),
          _buildCredentialItem(
            Icons.verified_user,
            'Background Check & ID Verified',
            'Completed on Jan 2024',
          ),

          const SizedBox(height: 24),

          _buildSectionTitle('Subjects & Levels'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildSubjectChip('Physics (GCE)'),
              _buildSubjectChip('Mathematics (GCE)'),
              _buildSubjectChip('Additional Maths'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCredentialItem(IconData icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
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
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectChip(String subject) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.info.withOpacity(0.3)),
      ),
      child: Text(
        subject,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.info,
        ),
      ),
    );
  }

  Widget _buildAvailabilityTab() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Next available'),
          const SizedBox(height: 12),
          Text(
            'Today, 4:00 PM',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.success,
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Schedule'),
          const SizedBox(height: 12),
          Text(
            'Time slots coming soon...',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    return Center(
      child: Text('Reviews', style: TextStyle(color: AppColors.textSecondary)),
    );
  }

  Widget _buildMediaTab() {
    return Center(
      child: Text('Media', style: TextStyle(color: AppColors.textSecondary)),
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

  Widget _buildBottomBar(Map<String, dynamic> tutor) {
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
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Price',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '4,500 CFA',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRouter.tutorProfile);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Book This Tutor',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getDemoTutor() {
    return {
      'name': 'Mr. Ndongo Emmanuel',
      'rating': 4.9,
      'reviews': 156,
      'rate': '4,500 CFA/hour',
      'isVerified': true,
      'isAvailable': true,
      'matchScore': 85,
    };
  }
}