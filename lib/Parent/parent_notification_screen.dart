import 'package:flutter/material.dart';
import 'parent_app_drawer.dart';

class Notification {
  final String id;
  final String title;
  final String message;
  final String description;
  final DateTime timestamp;
  bool isRead;
  final String category;

  Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.description,
    required this.timestamp,
    this.isRead = false,
    required this.category,
  });
}

class ParentNotificationScreen extends StatefulWidget {
  const ParentNotificationScreen({super.key});

  @override
  State<ParentNotificationScreen> createState() =>
      _ParentNotificationScreenState();
}

class _ParentNotificationScreenState extends State<ParentNotificationScreen> {
  final List<Notification> notifications = [
    Notification(
      id: '1',
      title: 'Assignment Submitted',
      message: 'Aarav submitted Math assignment',
      description:
          'Aarav has successfully submitted his Math assignment on Algebra. The submission was completed on time.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      category: 'Academic',
    ),
    Notification(
      id: '2',
      title: 'Parent-Teacher Meeting Scheduled',
      message: 'PTM scheduled for next Friday',
      description:
          'A parent-teacher meeting has been scheduled for next Friday at 3:00 PM. Please meet with the class teacher to discuss Vikas\'s progress.',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      category: 'Meeting',
    ),
    Notification(
      id: '3',
      title: 'Attendance Alert',
      message: 'Low attendance for Aarav',
      description:
          'Aarav\'s attendance has dropped below 80%. Please ensure regular attendance to avoid any issues.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      category: 'Attendance',
    ),
    Notification(
      id: '4',
      title: 'Test Results Available',
      message: 'Physics test results for Vikas',
      description:
          'Physics test results have been published. Vikas scored 85/100 in the test.',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
      category: 'Result',
    ),
    Notification(
      id: '5',
      title: 'Fee Reminder',
      message: 'Monthly fee due',
      description:
          'The monthly fee for both children is due this month. Please complete the payment by the end of this week.',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
      category: 'Payment',
    ),
  ];

  String selectedFilter = 'All';
  String? expandedNotificationId;

  List<Notification> get filteredNotifications {
    if (selectedFilter == 'Unread') {
      return notifications.where((n) => !n.isRead).toList();
    } else if (selectedFilter == 'All') {
      return notifications;
    } else {
      return notifications.where((n) => n.category == selectedFilter).toList();
    }
  }

  void _markAsRead(String id) {
    setState(() {
      final notification = notifications.firstWhere((n) => n.id == id);
      notification.isRead = true;
    });
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Academic':
        return const Color(0xFF7C3AED);
      case 'Meeting':
        return const Color(0xFF7C3AED);
      case 'Attendance':
        return Colors.orange;
      case 'Result':
        return Colors.green;
      case 'Payment':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Academic':
        return Icons.school_outlined;
      case 'Meeting':
        return Icons.people_outline;
      case 'Attendance':
        return Icons.calendar_today_outlined;
      case 'Result':
        return Icons.emoji_events_outlined;
      case 'Payment':
        return Icons.account_balance_wallet;
      default:
        return Icons.notifications_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const ParentAppDrawer(),
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF7C3AED),
                Color(0xFF8B5CF6),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildFilterChip('All', notifications.length),
                const SizedBox(width: 8),
                _buildFilterChip('Unread', notifications.where((n) => !n.isRead).length),
                const SizedBox(width: 8),
                _buildFilterChip('Academic', notifications.where((n) => n.category == 'Academic').length),
                const SizedBox(width: 8),
                _buildFilterChip('Meeting', notifications.where((n) => n.category == 'Meeting').length),
                const SizedBox(width: 8),
                _buildFilterChip('Attendance', notifications.where((n) => n.category == 'Attendance').length),
              ],
            ),
          ),

          // Notifications List
          Expanded(
            child: filteredNotifications.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_none,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No notifications',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredNotifications.length,
                    itemBuilder: (context, index) {
                      final notification = filteredNotifications[index];
                      final isExpanded = expandedNotificationId == notification.id;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isExpanded) {
                              expandedNotificationId = null;
                            } else {
                              expandedNotificationId = notification.id;
                              _markAsRead(notification.id);
                            }
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: notification.isRead
                                  ? Colors.grey[300]!
                                  : _getCategoryColor(notification.category),
                              width: notification.isRead ? 1 : 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(
                                  notification.isRead ? 0.05 : 0.1,
                                ),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    // Category Icon
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: _getCategoryColor(notification.category)
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        _getCategoryIcon(notification.category),
                                        color: _getCategoryColor(notification.category),
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 12),

                                    // Title and Message
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  notification.title,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ),
                                              if (!notification.isRead)
                                                Container(
                                                  width: 8,
                                                  height: 8,
                                                  decoration: BoxDecoration(
                                                    color: _getCategoryColor(
                                                        notification.category),
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            notification.message,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),

                                    // Time
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          _formatTime(notification.timestamp),
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Icon(
                                          isExpanded
                                              ? Icons.keyboard_arrow_up
                                              : Icons.keyboard_arrow_down,
                                          color: Colors.grey[500],
                                          size: 18,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Expanded Details
                              if (isExpanded) ...[
                                Container(
                                  height: 1,
                                  color: Colors.grey[200],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Details',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        notification.description,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[700],
                                          height: 1.5,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Category: ${notification.category}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: _getCategoryColor(
                                                  notification.category),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          if (!notification.isRead)
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 6,
                                              ),
                                              decoration: BoxDecoration(
                                                color: _getCategoryColor(
                                                        notification.category)
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                'New',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: _getCategoryColor(
                                                      notification.category),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, int count) {
    final isSelected = selectedFilter == label;
    return FilterChip(
      label: Text('$label ($count)'),
      selected: isSelected,
      onSelected: (value) {
        setState(() {
          selectedFilter = label;
        });
      },
      backgroundColor: Colors.white,
      selectedColor: const Color(0xFF7C3AED),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontWeight: FontWeight.w500,
      ),
      side: BorderSide(
        color: isSelected ? const Color(0xFF7C3AED) : Colors.grey[300]!,
      ),
    );
  }
}
