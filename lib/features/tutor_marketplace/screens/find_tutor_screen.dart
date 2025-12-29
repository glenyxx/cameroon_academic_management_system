import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/app_router.dart';

class FindTutorScreen extends StatefulWidget {
  const FindTutorScreen({super.key});

  @override
  State<FindTutorScreen> createState() => _FindTutorScreenState();
}

class _FindTutorScreenState extends State<FindTutorScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _selectedSubjects = [];
  final List<String> _selectedAvailability = [];
  String _selectedPriceRange = '';

  final List<Map<String, dynamic>> _tutors = [
    {
      'id': '1',
      'name': 'Dr. Amina Diallo',
      'subjects': ['Mathematics', 'Physics'],
      'rating': 4.9,
      'reviews': 156,
      'rate': '5000 XAF/hour',
      'language': 'EN/FR',
      'isVerified': true,
      'isAvailable': true,
      'profileImage': '',
      'experience': '8 years',
      'students': '250+',
      'matchScore': 85,
    },
    {
      'id': '2',
      'name': 'Jean-Pierre Talla',
      'subjects': ['History', 'Geography'],
      'rating': 4.8,
      'reviews': 89,
      'rate': '4500 XAF/hour',
      'language': 'FR',
      'isVerified': true,
      'isAvailable': true,
      'profileImage': '',
      'experience': '5 years',
      'students': '180+',
      'matchScore': 78,
    },
    {
      'id': '3',
      'name': 'Fatima Ekwensi',
      'subjects': ['Chemistry', 'Biology'],
      'rating': 4.7,
      'reviews': 124,
      'rate': '4800 XAF/hour',
      'language': 'EN',
      'isVerified': false,
      'isAvailable': false,
      'profileImage': '',
      'experience': '6 years',
      'students': '200+',
      'matchScore': 65,
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Find a Tutor',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterChips(),
          Expanded(child: _buildTutorsList()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
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
          hintText: 'Search by name, subject...',
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
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildFilterChip(
            'Subject',
            Icons.subject,
            _selectedSubjects.isNotEmpty,
            _selectedSubjects.isNotEmpty ? _selectedSubjects.first : null,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            'Availability',
            Icons.access_time,
            _selectedAvailability.isNotEmpty,
            null,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            'Price Range',
            Icons.payments_outlined,
            _selectedPriceRange.isNotEmpty,
            _selectedPriceRange,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon, bool isActive, String? activeLabel) {
    return GestureDetector(
      onTap: () {
        _showFilterBottomSheet(label);
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
              activeLabel ?? label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : AppColors.textPrimary,
              ),
            ),
            if (isActive) ...[
              const SizedBox(width: 4),
              Icon(Icons.close, size: 16, color: Colors.white),
            ] else ...[
              const SizedBox(width: 4),
              Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.textPrimary),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTutorsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _tutors.length,
      itemBuilder: (context, index) {
        return _buildTutorCard(_tutors[index]);
      },
    );
  }

  Widget _buildTutorCard(Map<String, dynamic> tutor) {
    final matchScore = tutor['matchScore'] as int;
    final isHighMatch = matchScore >= 80;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRouter.tutorProfile,
          arguments: tutor,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Profile Image
              Stack(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Text(
                      tutor['name'].toString().substring(0, 1),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  if (tutor['isAvailable'])
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(width: 16),

              // Tutor Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            tutor['name'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (tutor['isVerified'])
                          Icon(
                            Icons.verified,
                            size: 20,
                            color: AppColors.info,
                          ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    Text(
                      (tutor['subjects'] as List).join(', '),
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Icon(Icons.star, size: 16, color: AppColors.secondary),
                        const SizedBox(width: 4),
                        Text(
                          '${tutor['rating']}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          ' (${tutor['reviews']} reviews)',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '|',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          tutor['language'],
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          tutor['rate'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        if (isHighMatch)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.thumb_up, size: 12, color: AppColors.secondary),
                                const SizedBox(width: 4),
                                Text(
                                  '$matchScore% Match',
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

                    const SizedBox(height: 12),

                    SizedBox(
                      height: 38,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRouter.tutorProfile,
                            arguments: tutor,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Book Session',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterBottomSheet(String filterType) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter by $filterType',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Filter options will be implemented here',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Apply Filters'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}