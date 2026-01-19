import 'package:flutter/material.dart';
import 'teacher_app_drawer.dart';

class TeacherNotification {
  final String id;
  final String title;
  final String message;
  final String description;
  final DateTime timestamp;
  bool isRead;
  final String category;

  TeacherNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.description,
    required this.timestamp,
    this.isRead = false,
    required this.category,
  });
}

class TeacherNotificationScreen extends StatefulWidget {
  const TeacherNotificationScreen({super.key});

  @override
  State<TeacherNotificationScreen> createState() =>
      _TeacherNotificationScreenState();
}

class _TeacherNotificationScreenState extends State<TeacherNotificationScreen> {
  final List<TeacherNotification> notifications = [
    TeacherNotification(
      id: '1',
      title: 'New Assignment Submission',
      message: 'Aarav Sharma submitted Math assignment',
      description:
          'Student Aarav Sharma has successfully submitted the Math assignment on Algebra. Please review and provide feedback.',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      category: 'Academic',
    ),
    TeacherNotification(
      id: '2',
      title: 'Parent-Teacher Meeting Request',
      message: 'Parent requested meeting for Vikas',
      description:
          'A parent has requested a meeting to discuss Vikas\'s progress. Please schedule a meeting at your earliest convenience.',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      category: 'Meeting',
    ),
    TeacherNotification(
      id: '3',
      title: 'Attendance Reminder',
      message: 'Please mark attendance for today',
      description:
          'Reminder to mark attendance for all classes today. Please complete attendance marking by end of day.',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: true,
      category: 'Attendance',
    ),
    TeacherNotification(
      id: '4',
      title: 'Syllabus Completion Update',
      message: 'Physics syllabus 75% completed',
      description:
          'You have completed 75% of the Physics syllabus for Class 12. Great progress! Keep it up.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      category: 'Syllabus',
    ),
    TeacherNotification(
      id: '5',
      title: 'New Doubt Posted',
      message: 'Student posted a doubt in Maths',
      description:
          'A student has posted a new doubt regarding Quadratic Equations. Please respond to help the student.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      category: 'Doubt',
    ),
    TeacherNotification(
      id: '6',
      title: 'Leave Application Approved',
      message: 'Your leave request has been approved',
      description:
          'Your leave application for sick leave on 10th Jan has been approved by the admin.',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
      category: 'Leave',
    ),
    TeacherNotification(
      id: '7',
      title: 'Staff Meeting Scheduled',
      message: 'Department meeting on Friday',
      description:
          'A department meeting has been scheduled for this Friday at 4:00 PM in the conference room. Attendance is mandatory.',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      category: 'Meeting',
    ),
  ];

  String selectedFilter = 'All';
  String? expandedNotificationId;

  List<TeacherNotification> get filteredNotifications {
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
      case 'Syllabus':
        return Colors.green;
      case 'Doubt':
        return Colors.red;
      case 'Leave':
        return Colors.teal;
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
      case 'Syllabus':
        return Icons.book_outlined;
      case 'Doubt':
        return Icons.help_outline;
      case 'Leave':
        return Icons.event_busy_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const TeacherAppDrawer(),
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [const Color(0xFF8B5CF6), const Color(0xFF7C3AED)],
            ),
          ),
        ),
        actions: [
          if (unreadCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$unreadCount New',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
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
                _buildFilterChip(
                    'Unread', notifications.where((n) => !n.isRead).length),
                const SizedBox(width: 8),
                _buildFilterChip('Academic',
                    notifications.where((n) => n.category == 'Academic').length),
                const SizedBox(width: 8),
                _buildFilterChip('Meeting',
                    notifications.where((n) => n.category == 'Meeting').length),
                const SizedBox(width: 8),
                _buildFilterChip('Attendance',
                    notifications.where((n) => n.category == 'Attendance').length),
                const SizedBox(width: 8),
                _buildFilterChip('Doubt',
                    notifications.where((n) => n.category == 'Doubt').length),
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
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
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
                      final isExpanded =
                          expandedNotificationId == notification.id;

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
                                        color: _getCategoryColor(
                                                notification.category)
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        _getCategoryIcon(notification.category),
                                        color: _getCategoryColor(
                                            notification.category),
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 12),

                                    // Title and Message
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  notification.title,
                                                  style: const TextStyle(
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              padding:
                                                  const EdgeInsets.symmetric(
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
