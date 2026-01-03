import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/theme/colors.dart';
import '../../../shared/providers/connectivity_provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _notifications = [
    {
      'type': 'urgent',
      'icon': Icons.campaign,
      'color': AppColors.error,
      'title': 'Important: School Closure Announcement',
      'message': 'Please note that the school will be closed on Friday, 24th May, due to unforeseen maintenance. All classes will resume on Monday.',
      'time': 'Today',
      'isRead': false,
      'eventId': 'SCHOOL_CLOSURE_001',
      'eventDate': 'May 24, 2024',
      'eventLocation': 'All Campuses',
    },
    {
      'type': 'event',
      'icon': Icons.calendar_today,
      'color': AppColors.info,
      'title': 'Parent-Teacher Meeting Schedule',
      'message': 'The schedule for the upcoming parent-teacher meetings has been released. Please review and book your slot.',
      'time': '2 hours ago',
      'isRead': false,
      'eventId': 'PTM_2024_001',
      'eventDate': 'June 1-5, 2024',
      'eventLocation': 'School Conference Hall',
    },
    {
      'type': 'academic',
      'icon': Icons.assignment,
      'color': AppColors.primary,
      'title': 'New Mathematics Assignment',
      'message': 'A new assignment for Chapter 5: Algebra has been posted. The due date is next Monday.',
      'time': 'Yesterday',
      'isRead': true,
    },
    {
      'type': 'event',
      'icon': Icons.science,
      'color': AppColors.warning,
      'title': 'Science Fair Registration Open',
      'message': 'Registration for the annual science fair is now open to all students. Submit your project ideas by June 1st.',
      'time': '3 days ago',
      'isRead': true,
      'eventId': 'SCIENCE_FAIR_2024',
      'eventDate': 'June 15-17, 2024',
      'eventLocation': 'Science Building',
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isOffline = !context.watch<ConnectivityProvider>().isOnline;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            if (isOffline) _buildOfflineBanner(),
            _buildTabs(),
            Expanded(child: _buildNotificationsList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.menu, color: AppColors.textPrimary),
            onPressed: () {
              // Optional: Add drawer navigation
            },
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Notifications & News',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.search, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildOfflineBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppColors.warning.withOpacity(0.1),
      child: Row(
        children: [
          Icon(Icons.cloud_off, color: AppColors.warning, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'You are currently offline. Showing saved content.',
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

  Widget _buildTabs() {
    return Container(
      color: Colors.white,
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
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('All'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.warning, size: 16),
                SizedBox(width: 4),
                Text('Urgent'),
              ],
            ),
          ),
          Tab(text: 'Events'),
          Tab(text: 'Academics'),
        ],
      ),
    );
  }

  Widget _buildNotificationsList() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildAllTab(),
        _buildFilteredTab('urgent'),
        _buildFilteredTab('event'),
        _buildFilteredTab('academic'),
      ],
    );
  }

  Widget _buildAllTab() {
    if (_notifications.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _notifications.length + 1,
      itemBuilder: (context, index) {
        if (index == _notifications.length) {
          return _buildAllCaughtUp();
        }
        return _buildNotificationCard(_notifications[index]);
      },
    );
  }

  Widget _buildFilteredTab(String type) {
    final filtered = _notifications.where((n) => n['type'] == type).toList();

    if (filtered.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        return _buildNotificationCard(filtered[index]);
      },
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final isUrgent = notification['type'] == 'urgent';
    final isEvent = notification['type'] == 'event';
    final hasEventDetails = notification.containsKey('eventId');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: notification['isRead'] ? Colors.white : AppColors.primary.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUrgent
              ? AppColors.error.withOpacity(0.3)
              : notification['isRead']
              ? Colors.transparent
              : AppColors.primary.withOpacity(0.1),
          width: isUrgent ? 2 : 1,
        ),
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
          onTap: () {
            _handleNotificationTap(notification);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: notification['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    notification['icon'],
                    color: notification['color'],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isUrgent)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: AppColors.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'URGENT ANNOUNCEMENT',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.error,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      Text(
                        notification['title'],
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notification['message'],
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        notification['time'],
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      // Show event details if available
                      if (hasEventDetails)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today, size: 12, color: AppColors.textSecondary),
                              const SizedBox(width: 4),
                              Text(
                                notification['eventDate'],
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(Icons.location_on, size: 12, color: AppColors.textSecondary),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  notification['eventLocation'],
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  children: [
                    if (!notification['isRead'])
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    const SizedBox(height: 8),
                    PopupMenuButton(
                      icon: Icon(Icons.more_vert, size: 20, color: AppColors.textSecondary),
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'read',
                          child: Text('Mark as read'),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'read') {
                          _markAsRead(notification);
                        } else if (value == 'delete') {
                          _deleteNotification(notification);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleNotificationTap(Map<String, dynamic> notification) {
    // Mark as read
    _markAsRead(notification);

    // Check if it's an urgent notification or has event details
    if (notification['type'] == 'urgent' ||
        notification['type'] == 'event' && notification.containsKey('eventId')) {
      // Navigate to EventDetailScreen
      Navigator.pushNamed(
        context,
        AppRouter.eventDetail,
        arguments: {
          'id': notification['eventId'] ?? 'EVENT_${notification['title'].hashCode}',
          'title': notification['title'],
          'description': notification['message'],
          'date': notification['eventDate'] ?? notification['time'],
          'location': notification['eventLocation'] ?? 'Not specified',
          'type': notification['type'],
          'isUrgent': notification['type'] == 'urgent',
          'icon': notification['icon'].toString(),
          'color': notification['color'].value,
        },
      );
    } else {
      // For non-event notifications, show the detail bottom sheet
      _showNotificationDetail(notification);
    }
  }

  void _markAsRead(Map<String, dynamic> notification) {
    setState(() {
      final index = _notifications.indexWhere((n) => n['title'] == notification['title']);
      if (index != -1) {
        _notifications[index]['isRead'] = true;
      }
    });
  }

  void _deleteNotification(Map<String, dynamic> notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Notification'),
        content: const Text('Are you sure you want to delete this notification?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _notifications.removeWhere((n) => n['title'] == notification['title']);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notification deleted')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 64,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllCaughtUp() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle,
              size: 48,
              color: AppColors.success,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'You\'re all caught up!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'New notifications will appear here.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _showNotificationDetail(Map<String, dynamic> notification) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.inputBorder,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: notification['color'].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          notification['icon'],
                          color: notification['color'],
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notification['title'],
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              notification['time'],
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
                  const SizedBox(height: 24),
                  Text(
                    notification['message'],
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.textPrimary,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Show event details if available
                  if (notification.containsKey('eventId'))
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(),
                        const SizedBox(height: 16),
                        Text(
                          'Event Details',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.calendar_today, size: 20, color: AppColors.textSecondary),
                            const SizedBox(width: 12),
                            Text(
                              'Date: ${notification['eventDate']}',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 20, color: AppColors.textSecondary),
                            const SizedBox(width: 12),
                            Text(
                              'Location: ${notification['eventLocation']}',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context); // Close bottom sheet
                              // Navigate to full event details
                              Navigator.pushNamed(
                                context,
                                AppRouter.eventDetail,
                                arguments: {
                                  'id': notification['eventId'],
                                  'title': notification['title'],
                                  'description': notification['message'],
                                  'date': notification['eventDate'],
                                  'location': notification['eventLocation'],
                                  'type': notification['type'],
                                  'isUrgent': notification['type'] == 'urgent',
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text('View Full Event Details'),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}