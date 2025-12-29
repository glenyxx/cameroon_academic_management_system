import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';

class TutorMessagesScreen extends StatefulWidget {
  const TutorMessagesScreen({super.key});

  @override
  State<TutorMessagesScreen> createState() => _TutorMessagesScreenState();
}

class _TutorMessagesScreenState extends State<TutorMessagesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _messages = [
    {
      'name': 'Femi Adebayo',
      'avatar': 'FA',
      'message': 'Wants to book a session for tomorrow at 3 PM.',
      'time': '9:15 AM',
      'type': 'booking',
      'bookingType': 'New Booking Request',
      'unread': 0,
      'isOnline': true,
    },
    {
      'name': 'Aisha Bello',
      'avatar': 'AB',
      'message': "Okay, that makes sense. I'll review the materials.",
      'time': '10:42 AM',
      'type': 'message',
      'unread': 2,
      'isOnline': true,
    },
    {
      'name': 'BrightPath Support',
      'avatar': 'BP',
      'message': 'Your weekly summary is now available.',
      'time': 'Yesterday',
      'type': 'support',
      'unread': 0,
      'isOnline': false,
    },
    {
      'name': 'Emeka Okafor',
      'avatar': 'EO',
      'message': 'Thank you for the help with the last assignment!',
      'time': 'Mon',
      'type': 'message',
      'unread': 0,
      'isOnline': false,
    },
    {
      'name': 'Chidinma Nwosu',
      'avatar': 'CN',
      'message': "I've sent the payment, please confirm.",
      'time': 'Apr 12',
      'type': 'message',
      'unread': 0,
      'isOnline': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
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
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Messages',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTabs(),
          Expanded(child: _buildMessagesList()),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
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
          Tab(text: 'Unread'),
          Tab(text: 'Booking Requests'),
          Tab(text: 'Students'),
          Tab(text: 'Support'),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildAllMessagesTab(),
        _buildFilteredTab('unread'),
        _buildFilteredTab('booking'),
        _buildFilteredTab('students'),
        _buildFilteredTab('support'),
      ],
    );
  }

  Widget _buildAllMessagesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        return _buildMessageCard(_messages[index]);
      },
    );
  }

  Widget _buildFilteredTab(String filter) {
    List<Map<String, dynamic>> filtered = [];

    switch (filter) {
      case 'unread':
        filtered = _messages.where((m) => (m['unread'] as int) > 0).toList();
        break;
      case 'booking':
        filtered = _messages.where((m) => m['type'] == 'booking').toList();
        break;
      case 'students':
        filtered = _messages.where((m) => m['type'] == 'message').toList();
        break;
      case 'support':
        filtered = _messages.where((m) => m['type'] == 'support').toList();
        break;
    }

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No messages',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        return _buildMessageCard(filtered[index]);
      },
    );
  }

  Widget _buildMessageCard(Map<String, dynamic> message) {
    final isBookingRequest = message['type'] == 'booking';
    final hasUnread = (message['unread'] as int) > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: hasUnread ? AppColors.primary.withOpacity(0.03) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isBookingRequest
            ? Border.all(color: AppColors.secondary.withOpacity(0.3), width: 2)
            : null,
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
            child: Column(
              children: [
                Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: _getAvatarColor(message['avatar']),
                          child: Text(
                            message['avatar'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        if (message['isOnline'])
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 14,
                              height: 14,
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  message['name'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              Text(
                                message['time'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          if (isBookingRequest)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              margin: const EdgeInsets.only(bottom: 4),
                              decoration: BoxDecoration(
                                color: AppColors.secondary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                message['bookingType'],
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.secondary,
                                ),
                              ),
                            ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  message['message'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: hasUnread
                                        ? AppColors.textPrimary
                                        : AppColors.textSecondary,
                                    fontWeight: hasUnread ? FontWeight.w600 : FontWeight.normal,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (hasUnread)
                                Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    message['unread'].toString(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (isBookingRequest) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textSecondary,
                            side: BorderSide(color: AppColors.inputBorder),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Decline'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Accept'),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getAvatarColor(String initials) {
    final colors = [
      AppColors.primary,
      AppColors.success,
      AppColors.warning,
      AppColors.info,
      AppColors.secondary,
    ];
    final index = initials.codeUnitAt(0) % colors.length;
    return colors[index];
  }
}