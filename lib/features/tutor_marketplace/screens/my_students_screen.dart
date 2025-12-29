import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';

class MyStudentsScreen extends StatefulWidget {
  const MyStudentsScreen({super.key});

  @override
  State<MyStudentsScreen> createState() => _MyStudentsScreenState();
}

class _MyStudentsScreenState extends State<MyStudentsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedTab = 'All';
  String _sortBy = 'Recent Sessions';

  final List<Map<String, dynamic>> _students = [
    {
      'name': 'Danielle Johnson',
      'avatar': 'assets/images/student1.jpg',
      'class': 'Class 10',
      'subjects': 'Mathematics, Physics',
      'totalSessions': 24,
      'avgScore': 88,
      'lastSession': 'Oct 28, 2023',
      'payment': 'Paid',
      'status': 'Improving',
      'trend': 'up',
    },
    {
      'name': 'Michael Chen',
      'avatar': 'assets/images/student2.jpg',
      'class': 'Class 12',
      'subjects': 'Chemistry',
      'totalSessions': 15,
      'avgScore': 62,
      'lastSession': 'Oct 25, 2023',
      'payment': 'Due',
      'status': 'Needs Attention',
      'trend': 'down',
    },
    {
      'name': 'Fatima Diallo',
      'avatar': 'assets/images/student3.jpg',
      'class': 'Class 9',
      'subjects': 'English, History',
      'totalSessions': 32,
      'avgScore': 95,
      'lastSession': 'Oct 29, 2023',
      'payment': 'Paid',
      'status': 'High Performer',
      'trend': 'star',
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
        title: Text(
          'My Students',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person_add_outlined, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildSortSection(),
          _buildFilterTabs(),
          Expanded(child: _buildStudentsList()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
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
          hintText: 'Search by name...',
          hintStyle: TextStyle(
            color: AppColors.textSecondary.withOpacity(0.6),
          ),
          prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildSortSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Sort by:',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          PopupMenuButton<String>(
            initialValue: _sortBy,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text(
                    _sortBy,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_drop_down, color: AppColors.primary),
                ],
              ),
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'Recent Sessions', child: Text('Recent Sessions')),
              const PopupMenuItem(value: 'Name A-Z', child: Text('Name A-Z')),
              const PopupMenuItem(value: 'Performance', child: Text('Performance')),
              const PopupMenuItem(value: 'Payment Due', child: Text('Payment Due')),
            ],
            onSelected: (value) {
              setState(() {
                _sortBy = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    final tabs = ['All', 'Active', 'Inactive', 'High-Performers'];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final tab = tabs[index];
          final isSelected = _selectedTab == tab;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(tab),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedTab = tab;
                });
              },
              backgroundColor: Colors.white,
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
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

  Widget _buildStudentsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _students.length,
      itemBuilder: (context, index) {
        return _buildStudentCard(_students[index]);
      },
    );
  }

  Widget _buildStudentCard(Map<String, dynamic> student) {
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
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text(
                  student['name'].toString().substring(0, 1),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          student['name'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildStatusBadge(student['status'], student['trend']),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${student['class']} -',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      student['subjects'],
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Sessions',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${student['totalSessions']}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Avg. Score',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${student['avgScore']}%',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Last Session',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      student['lastSession'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      student['payment'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: student['payment'] == 'Paid'
                            ? AppColors.success
                            : AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.visibility, size: 16),
                  label: const Text('Progress'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(color: AppColors.inputBorder),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.message, size: 16),
                  label: const Text('Message'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(color: AppColors.inputBorder),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.calendar_today, size: 16),
                  label: const Text('Schedule'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(color: AppColors.inputBorder),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status, String trend) {
    Color color;
    IconData? icon;

    if (trend == 'star') {
      color = AppColors.secondary;
      icon = Icons.star;
    } else if (trend == 'up') {
      color = AppColors.success;
      icon = Icons.trending_up;
    } else {
      color = AppColors.warning;
      icon = Icons.warning;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) Icon(icon, size: 12, color: color),
          if (icon != null) const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}