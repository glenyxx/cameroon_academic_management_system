import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';

class SchoolCalendarScreen extends StatefulWidget {
  const SchoolCalendarScreen({super.key});

  @override
  State<SchoolCalendarScreen> createState() => _SchoolCalendarScreenState();
}

class _SchoolCalendarScreenState extends State<SchoolCalendarScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDate = DateTime.now();
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  final List<Map<String, dynamic>> _events = [
    {
      'date': 5,
      'title': 'Mathematics Assignment Due',
      'description': 'Submit Chapter 5 exercises online.',
      'type': 'assignment',
      'time': 'All Day',
    },
    {
      'date': 5,
      'title': 'Parent-Teacher Meeting',
      'description': 'For all Form 3 students.',
      'type': 'meeting',
      'time': '1:00 PM - 3:00 PM',
    },
    {
      'date': 5,
      'title': 'National Day',
      'description': 'School closed for public holiday.',
      'type': 'holiday',
      'time': 'All Day',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
                    _buildViewToggle(),
                    Expanded(child: _buildContent()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'School Calendar',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _selectedDate = DateTime.now();
                _selectedMonth = DateTime.now().month;
                _selectedYear = DateTime.now().year;
              });
            },
            child: const Text(
              'Today',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewToggle() {
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
          Tab(text: 'Monthly'),
          Tab(text: 'Weekly'),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildMonthlyView(),
        _buildWeeklyView(),
      ],
    );
  }

  Widget _buildMonthlyView() {
    return Column(
      children: [
        _buildMonthSelector(),
        _buildCalendarGrid(),
        _buildEventFilters(),
        Expanded(child: _buildEventsList()),
      ],
    );
  }

  Widget _buildMonthSelector() {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left, color: AppColors.textPrimary),
            onPressed: () {
              setState(() {
                if (_selectedMonth == 1) {
                  _selectedMonth = 12;
                  _selectedYear--;
                } else {
                  _selectedMonth--;
                }
              });
            },
          ),
          Text(
            '${months[_selectedMonth - 1]} $_selectedYear',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          IconButton(
            icon: Icon(Icons.chevron_right, color: AppColors.textPrimary),
            onPressed: () {
              setState(() {
                if (_selectedMonth == 12) {
                  _selectedMonth = 1;
                  _selectedYear++;
                } else {
                  _selectedMonth++;
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final daysInWeek = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
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
          // Days of week header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: daysInWeek.map((day) => SizedBox(
              width: 36,
              child: Center(
                child: Text(
                  day,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            )).toList(),
          ),
          const SizedBox(height: 16),
          // Calendar days
          ..._buildCalendarWeeks(),
        ],
      ),
    );
  }

  List<Widget> _buildCalendarWeeks() {
    final weeks = <Widget>[];
    final daysInMonth = DateTime(_selectedYear, _selectedMonth + 1, 0).day;
    final firstDayOfMonth = DateTime(_selectedYear, _selectedMonth, 1).weekday;

    int dayCounter = 1;

    // Build weeks
    for (int week = 0; week < 6; week++) {
      final weekDays = <Widget>[];

      for (int day = 0; day < 7; day++) {
        if ((week == 0 && day < firstDayOfMonth % 7) || dayCounter > daysInMonth) {
          weekDays.add(const SizedBox(width: 36, height: 36));
        } else {
          final isSelected = dayCounter == _selectedDate.day &&
              _selectedMonth == _selectedDate.month &&
              _selectedYear == _selectedDate.year;
          final hasEvent = [3, 5, 8, 12, 15, 20].contains(dayCounter);

          weekDays.add(_buildCalendarDay(dayCounter, isSelected, hasEvent));
          dayCounter++;
        }
      }

      weeks.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: weekDays,
          ),
        ),
      );

      if (dayCounter > daysInMonth) break;
    }

    return weeks;
  }

  Widget _buildCalendarDay(int day, bool isSelected, bool hasEvent) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDate = DateTime(_selectedYear, _selectedMonth, day);
        });
      },
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                day.toString(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ),
            if (hasEvent && !isSelected)
              Positioned(
                bottom: 4,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventFilters() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildFilterChip('All', true),
          _buildFilterChip('Exams', false, color: AppColors.error),
          _buildFilterChip('Holidays', false, color: AppColors.success),
          _buildFilterChip('Assignments', false, color: AppColors.warning),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isActive, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? (color ?? AppColors.primary) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? (color ?? AppColors.primary) : AppColors.inputBorder,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isActive && color != null)
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(right: 6),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsList() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        Text(
          'Upcoming Events: Sat, Oct ${_selectedDate.day}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        ..._events.map((event) => _buildEventCard(event)),
      ],
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    final color = _getEventColor(event['type']);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 60,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event['title'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        event['description'],
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            event['time'],
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getEventColor(String type) {
    switch (type) {
      case 'assignment':
        return AppColors.warning;
      case 'meeting':
        return AppColors.info;
      case 'holiday':
        return AppColors.success;
      case 'exam':
        return AppColors.error;
      default:
        return AppColors.primary;
    }
  }

  Widget _buildWeeklyView() {
    return Center(
      child: Text(
        'Weekly View',
        style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
      ),
    );
  }
}