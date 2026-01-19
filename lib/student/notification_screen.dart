import 'package:flutter/material.dart';
import 'app_drawer.dart';

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

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<Notification> notifications = [
    Notification(
      id: '1',
      title: 'Physics Class Scheduled',
      message: 'Your Physics class with Mr. Sharma',
      description:
          'Your Physics class with Mr. Sharma is scheduled for tomorrow at 10:00 AM. Please be on time and bring your textbook.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      category: 'Class',
    ),
    Notification(
      id: '2',
      title: 'Mathematics Exam Alert',
      message: 'Unit Test scheduled on 30th December',
      description:
          'Unit Test for Mathematics is scheduled on 30th December 2025 at 9:00 AM. Topics covered: Algebra, Trigonometry, and Calculus.',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      category: 'Exam',
    ),
    Notification(
      id: '3',
      title: 'Chemistry Lab Session',
      message: 'Practical session rescheduled',
      description:
          'Practical session for Chemistry has been rescheduled to 3:00 PM today. Please bring your lab manual and safety equipment.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      category: 'Class',
    ),
    Notification(
      id: '4',
      title: 'JEE Mock Test Results',
      message: 'Mock Test 5 results available',
      description:
          'Your JEE Mock Test 5 results are now available. You scored 245/300. Check detailed analysis in the Result section.',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
      category: 'Result',
    ),
    Notification(
      id: '5',
      title: 'Biology Class Cancelled',
      message: 'Tomorrow\'s class cancelled',
      description:
          'Tomorrow\'s Biology class has been cancelled due to unavoidable circumstances. Make-up class will be scheduled next week.',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
      category: 'Class',
    ),
    Notification(
      id: '6',
      title: 'Assignment Deadline',
      message: 'Chemistry assignment due tomorrow',
      description:
          'Chemistry assignment submission deadline is tomorrow. Please submit before 5:00 PM through the portal.',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
      category: 'Assignment',
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
      case 'Class':
        return const Color(0xFF7C3AED);
      case 'Exam':
        return Colors.red;
      case 'Result':
        return Colors.green;
      case 'Assignment':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Class':
        return Icons.class_outlined;
      case 'Exam':
        return Icons.assignment_outlined;
      case 'Result':
        return Icons.emoji_events_outlined;
      case 'Assignment':
        return Icons.assignment_turned_in_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
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
                _buildFilterChip('Class', notifications.where((n) => n.category == 'Class').length),
                const SizedBox(width: 8),
                _buildFilterChip('Exam', notifications.where((n) => n.category == 'Exam').length),
                const SizedBox(width: 8),
                _buildFilterChip('Assignment', notifications.where((n) => n.category == 'Assignment').length),
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
