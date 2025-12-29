import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/app_router.dart';
import '../../../shared/providers/connectivity_provider.dart';

class ScholarshipsScreen extends StatefulWidget {
  const ScholarshipsScreen({super.key});

  @override
  State<ScholarshipsScreen> createState() => _ScholarshipsScreenState();
}

class _ScholarshipsScreenState extends State<ScholarshipsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFieldFilter = '';
  String _selectedEligibilityFilter = '';
  String _selectedDeadlineFilter = '';

  final List<Map<String, dynamic>> _scholarships = [
    {
      'id': '1',
      'organization': 'Cameroon Scholars Foundation',
      'title': 'Future Leaders STEM Scholarship',
      'amount': 'Up to 500,000 XAF',
      'deadline': '31 Dec 2024',
      'location': 'Cameroon',
      'level': 'Undergraduate',
      'field': 'STEM',
      'spots': '10',
      'eligibility': 'Female',
      'match': 85,
    },
    {
      'id': '2',
      'organization': 'National Arts Council',
      'title': 'Creative Arts Grant for Students',
      'amount': '250,000 XAF',
      'deadline': '15 Nov 2024',
      'location': 'Cameroon',
      'level': 'Undergraduate',
      'field': 'Arts',
      'spots': '20',
      'eligibility': 'All',
      'match': 72,
    },
    {
      'id': '3',
      'organization': 'AgriTech Innovators Fund',
      'title': 'Scholarship for Agricultural Innovation',
      'amount': '750,000 XAF',
      'deadline': '28 Feb 2025',
      'location': 'Cameroon',
      'level': 'Undergraduate',
      'field': 'Agriculture',
      'spots': '5',
      'eligibility': 'All',
      'match': 68,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isOffline = !context.watch<ConnectivityProvider>().isOnline;

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
                    if (isOffline) _buildOfflineBanner(),
                    _buildSearchBar(),
                    _buildFilterChips(),
                    Expanded(child: _buildScholarshipsList()),
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
              'Scholarships',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border, color: Colors.white),
            onPressed: () {
              // TODO: Show saved scholarships
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOfflineBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warning.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.cloud_off, color: AppColors.warning, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'You are offline. Showing saved data.',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
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
            hintText: 'Search by name, field...',
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
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _buildFilterChip('Field of Study', Icons.science_outlined, _selectedFieldFilter != ''),
          const SizedBox(width: 8),
          _buildFilterChip('Eligibility', Icons.person_outline, _selectedEligibilityFilter != ''),
          const SizedBox(width: 8),
          _buildFilterChip('Deadline', Icons.calendar_today_outlined, _selectedDeadlineFilter != ''),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon, bool isActive) {
    return GestureDetector(
      onTap: () {
        // TODO: Show filter bottom sheet
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.inputBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive ? Colors.white : AppColors.textPrimary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : AppColors.textPrimary,
              ),
            ),
            if (isActive) ...[
              const SizedBox(width: 4),
              Icon(Icons.close, size: 16, color: Colors.white),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildScholarshipsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _scholarships.length,
      itemBuilder: (context, index) {
        return _buildScholarshipCard(_scholarships[index]);
      },
    );
  }

  Widget _buildScholarshipCard(Map<String, dynamic> scholarship) {
    final matchPercentage = scholarship['match'] as int;
    final isHighMatch = matchPercentage >= 80;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRouter.scholarshipDetail,
          arguments: scholarship,
        );
      },
      child: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with match badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          scholarship['organization'],
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (isHighMatch)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.verified, size: 14, color: AppColors.secondary),
                              const SizedBox(width: 4),
                              Text(
                                '$matchPercentage% Match - Highly Recommended!',
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

                  const SizedBox(height: 8),

                  // Title
                  Text(
                    scholarship['title'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Amount Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.paid, size: 16, color: AppColors.success),
                        const SizedBox(width: 6),
                        Text(
                          scholarship['amount'],
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Info Grid
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoItem(Icons.calendar_today, 'Deadline', scholarship['deadline']),
                      ),
                      Expanded(
                        child: _buildInfoItem(Icons.location_on, 'Location', scholarship['location']),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoItem(Icons.school, 'Level', scholarship['level']),
                      ),
                      Expanded(
                        child: _buildInfoItem(Icons.science, 'Field', scholarship['field']),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoItem(Icons.people, 'Spots', scholarship['spots']),
                      ),
                      Expanded(
                        child: _buildInfoItem(Icons.accessibility_new, 'Eligibility', scholarship['eligibility']),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.bookmark_border, size: 18, color: AppColors.primary),
                    label: Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRouter.scholarshipDetail,
                        arguments: scholarship,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Text(
                          'View Details',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_forward, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}