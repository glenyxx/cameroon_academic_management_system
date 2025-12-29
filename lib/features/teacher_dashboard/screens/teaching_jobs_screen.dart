import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';

class TeachingJobsScreen extends StatefulWidget {
  const TeachingJobsScreen({super.key});

  @override
  State<TeachingJobsScreen> createState() => _TeachingJobsScreenState();
}

class _TeachingJobsScreenState extends State<TeachingJobsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _jobs = [
    {
      'title': 'Substitute Teacher Quick Board',
      'school': 'Lycée Bilingue de Yaoundé',
      'location': 'Yaoundé, CM',
      'type': 'Substitute',
      'duration': '3 days',
      'subject': 'Physics',
      'salary': null,
      'urgent': true,
      'match': 0,
      'postedTime': 'Immediate need',
      'available': true,
    },
    {
      'title': 'Mathematics Teacher',
      'school': 'Lycée Bilingue de Yaoundé',
      'location': 'Yaoundé, CM',
      'type': 'Permanent',
      'duration': 'Full-Time',
      'subject': 'Mathematics',
      'salary': '150K - 200K CFA/month',
      'urgent': false,
      'match': 85,
      'postedTime': 'Posted 2 days ago',
      'available': false,
    },
    {
      'title': 'Chemistry Teacher',
      'school': 'English High School, Douala',
      'location': 'Douala, CM',
      'type': 'Contract',
      'duration': 'Urgent',
      'subject': 'Chemistry',
      'salary': '120K - 180K CFA/month',
      'urgent': true,
      'match': 78,
      'postedTime': 'Posted 5 hours ago',
      'available': false,
    },
    {
      'title': 'History Teacher (Part-Time)',
      'school': 'Amity International College',
      'location': 'Yaoundé, CM',
      'type': 'Part-Time',
      'duration': null,
      'subject': 'History',
      'salary': '80K - 110K CFA/month',
      'urgent': false,
      'match': 65,
      'postedTime': 'Posted 1 week ago',
      'available': false,
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: AppColors.textPrimary),
          onPressed: () {},
        ),
        title: Text(
          'Teaching Jobs',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildSearchBar(),
          _buildTabs(),
          _buildFilterChips(),
          Expanded(child: _buildJobsList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Icon(Icons.school, color: AppColors.secondary, size: 28),
          const SizedBox(width: 12),
          Text(
            '47 Open Positions',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
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
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search jobs by school, location',
                  hintStyle: TextStyle(
                    color: AppColors.textSecondary.withOpacity(0.6),
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.tune, color: Colors.white),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: const EdgeInsets.all(20),
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
          Tab(text: 'Permanent'),
          Tab(text: 'Contract'),
          Tab(text: 'Substitute'),
          Tab(text: 'Part-Time'),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip('Recommended', Icons.stars, true),
          const SizedBox(width: 8),
          _buildFilterChip('Hiring Urgently', Icons.local_fire_department, false, isRed: true),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon, bool isActive, {bool isRed = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isRed ? AppColors.error : (isActive ? AppColors.primary : AppColors.inputBorder),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isActive ? Colors.white : (isRed ? AppColors.error : AppColors.textPrimary),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.white : (isRed ? AppColors.error : AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _jobs.length,
      itemBuilder: (context, index) {
        return _buildJobCard(_jobs[index]);
      },
    );
  }

  Widget _buildJobCard(Map<String, dynamic> job) {
    final isQuickBoard = job['available'] == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isQuickBoard ? AppColors.warning.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: job['urgent']
              ? AppColors.error.withOpacity(0.3)
              : (isQuickBoard ? AppColors.warning.withOpacity(0.3) : Colors.transparent),
          width: isQuickBoard || job['urgent'] ? 2 : 0,
        ),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            job['title'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (job['urgent'])
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.error,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'URGENT',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      job['school'],
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (job['match'] > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.lightbulb, size: 12, color: AppColors.secondary),
                      const SizedBox(width: 4),
                      Text(
                        '${job['match']}% Match',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          if (isQuickBoard) ...[
            const SizedBox(height: 12),
            Text(
              'Immediate need for a ${job['subject']} substitute at ${job['school']} for ${job['duration']}.',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.calendar_today, size: 16),
                label: const Text("I'm Available"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.warning,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ] else ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildInfoChip(job['location'], Icons.location_on),
                _buildInfoChip(job['type'], Icons.work_outline),
                if (job['duration'] != null)
                  _buildInfoChip(job['duration'], Icons.access_time),
              ],
            ),
            if (job['salary'] != null) ...[
              const SizedBox(height: 12),
              Text(
                'Salary: ${job['salary']}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  job['postedTime'],
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.bookmark_border, size: 20, color: AppColors.textSecondary),
                      onPressed: () {},
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      child: const Text('Apply Now'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}