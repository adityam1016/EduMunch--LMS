import 'package:flutter/material.dart';
import 'app_drawer.dart';
import '../services/notification_service.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_widgets.dart';

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
  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final live = await NotificationService.getNotifications(role: 'student');
    if (live.isNotEmpty && mounted) {
      setState(() {
        notifications.clear();
        notifications.addAll(live.map((n) => Notification(
              id: n.id,
              title: n.title,
              message: n.message,
              description: n.description,
              timestamp: n.createdAt,
              category: n.category,
              isRead: n.isRead,
            )));
      });
    }
  }

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
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
      category: 'Class',
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
        return const Color(0xFFEF4444);
      case 'Result':
        return const Color(0xFF10B981);
      case 'Assignment':
        return const Color(0xFFD97706);
      default:
        return NMTheme.textSecondary;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Class':
        return Icons.class_rounded;
      case 'Exam':
        return Icons.quiz_rounded;
      case 'Result':
        return Icons.emoji_events_rounded;
      case 'Assignment':
        return Icons.assignment_turned_in_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NMTheme.bg,
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            NMAppBar(
              title: 'Notifications',
              isRoot: false,
            ),
            const SizedBox(height: 10),

            // Filter Chips in Neumorphic Horizontal Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildFilterTab('All', notifications.length),
                  const SizedBox(width: 8),
                  _buildFilterTab('Unread', notifications.where((n) => !n.isRead).length),
                  const SizedBox(width: 8),
                  _buildFilterTab('Class', notifications.where((n) => n.category == 'Class').length),
                  const SizedBox(width: 8),
                  _buildFilterTab('Exam', notifications.where((n) => n.category == 'Exam').length),
                  const SizedBox(width: 8),
                  _buildFilterTab('Assignment', notifications.where((n) => n.category == 'Assignment').length),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Notifications List
            Expanded(
              child: filteredNotifications.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.notifications_none_rounded, size: 64, color: NMTheme.textMuted),
                          SizedBox(height: 14),
                          Text(
                            'No notifications in this category',
                            style: TextStyle(
                              fontSize: 15,
                              color: NMTheme.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: filteredNotifications.length,
                      itemBuilder: (context, index) {
                        final notification = filteredNotifications[index];
                        final isExpanded = expandedNotificationId == notification.id;
                        final color = _getCategoryColor(notification.category);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: NMCard(
                            radius: 20,
                            padding: const EdgeInsets.all(16),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: color.withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        _getCategoryIcon(notification.category),
                                        color: color,
                                        size: 22,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
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
                                                    fontSize: 15,
                                                    fontWeight: !notification.isRead ? FontWeight.w800 : FontWeight.w600,
                                                    color: NMTheme.textPrimary,
                                                  ),
                                                ),
                                              ),
                                              if (!notification.isRead)
                                                Container(
                                                  width: 8,
                                                  height: 8,
                                                  margin: const EdgeInsets.only(left: 6),
                                                  decoration: const BoxDecoration(
                                                    color: Color(0xFFEF4444),
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                            ],
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            notification.message,
                                            maxLines: isExpanded ? null : 1,
                                            overflow: isExpanded ? null : TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 12.5,
                                              color: NMTheme.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _formatTime(notification.timestamp),
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: NMTheme.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                                if (isExpanded) ...[
                                  const SizedBox(height: 12),
                                  Container(
                                    height: 1,
                                    color: NMTheme.shadowDark.withOpacity(0.3),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    notification.description,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: NMTheme.textSecondary,
                                      height: 1.45,
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
      ),
    );
  }

  Widget _buildFilterTab(String label, int count) {
    final isSelected = selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? NMTheme.surface : NMTheme.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF7C3AED) : Colors.white.withOpacity(0.8),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? NMTheme.raisedShadow(offset: 2, blur: 4)
              : NMTheme.raisedShadow(offset: 3, blur: 6),
        ),
        child: Text(
          '$label ($count)',
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected ? const Color(0xFF7C3AED) : NMTheme.textSecondary,
          ),
        ),
      ),
    );
  }
}
