import 'package:flutter/material.dart';
import 'teacher_app_drawer.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_widgets.dart';

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
          'Student Aarav Sharma has successfully submitted the Math assignment on Quadratic Equations. Please review and provide feedback.',
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
          'A student has posted a new doubt regarding Quadratic Equations discriminant. Please respond.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      category: 'Doubt',
    ),
    TeacherNotification(
      id: '6',
      title: 'Leave Application Approved',
      message: 'Your leave request has been approved',
      description:
          'Your leave application for sick leave on 10th Jan has been approved by the department head.',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
      category: 'Leave',
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

  void _markAllAsRead() {
    setState(() {
      for (var n in notifications) {
        n.isRead = true;
      }
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

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Academic':
        return Icons.school_outlined;
      case 'Meeting':
        return Icons.people_outline_rounded;
      case 'Attendance':
        return Icons.fact_check_outlined;
      case 'Syllabus':
        return Icons.menu_book_rounded;
      case 'Doubt':
        return Icons.help_outline_rounded;
      case 'Leave':
        return Icons.time_to_leave_outlined;
      default:
        return Icons.notifications_none_rounded;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Academic':
        return NMTheme.primaryPurple;
      case 'Meeting':
        return NMTheme.accentTeal;
      case 'Attendance':
        return NMTheme.accentOcean;
      case 'Syllabus':
        return const Color(0xFFFB8C00);
      case 'Doubt':
        return const Color(0xFFE53935);
      case 'Leave':
        return const Color(0xFF8E24AA);
      default:
        return NMTheme.primaryPurple;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NMTheme.bg,
      drawer: const TeacherAppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            NMAppBar(
              title: 'Notifications',
              isRoot: true,
              onSearchTap: () {},
              onNotificationTap: () {},
            ),
            _buildFilterTabs(),
            Expanded(
              child: filteredNotifications.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: filteredNotifications.length,
                      itemBuilder: (context, index) {
                        return _buildNotificationCard(filteredNotifications[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTabs() {
    final filters = ['All', 'Unread', 'Academic', 'Doubt', 'Meeting', 'Attendance'];

    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter;

          return GestureDetector(
            onTap: () => setState(() => selectedFilter = filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8, top: 4, bottom: 4),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? NMTheme.primaryPurple : NMTheme.cardBg,
                borderRadius: BorderRadius.circular(20),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: NMTheme.primaryPurple.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : NMTheme.cardShadows,
              ),
              alignment: Alignment.center,
              child: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? Colors.white : NMTheme.textDark,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  fontSize: 12.5,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: NMTheme.surface,
              shape: BoxShape.circle,
              boxShadow: NMTheme.cardShadows,
            ),
            child: const Icon(Icons.notifications_off_outlined, size: 52, color: NMTheme.primaryPurple),
          ),
          const SizedBox(height: 16),
          const Text(
            'All Caught Up!',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: NMTheme.textDark,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'No notifications in this filter view.',
            style: TextStyle(color: NMTheme.textSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(TeacherNotification notification) {
    final isExpanded = expandedNotificationId == notification.id;
    final categoryColor = _getCategoryColor(notification.category);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: NMCard(
        padding: const EdgeInsets.all(14),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            setState(() {
              expandedNotificationId = isExpanded ? null : notification.id;
              if (!notification.isRead) {
                _markAsRead(notification.id);
              }
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _getCategoryIcon(notification.category),
                      color: categoryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
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
                                  fontWeight: notification.isRead ? FontWeight.w700 : FontWeight.w800,
                                  fontSize: 14.5,
                                  color: NMTheme.textDark,
                                ),
                              ),
                            ),
                            if (!notification.isRead)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: NMTheme.primaryPurple,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          notification.message,
                          style: TextStyle(
                            color: notification.isRead ? NMTheme.textSecondary : NMTheme.textDark,
                            fontSize: 13,
                            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (isExpanded) ...[
                const SizedBox(height: 10),
                NMInsetContainer(
                  padding: const EdgeInsets.all(10),
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      notification.description,
                      style: const TextStyle(color: NMTheme.textDark, fontSize: 12.5, height: 1.35),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      notification.category,
                      style: TextStyle(
                        color: categoryColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  Text(
                    _formatTime(notification.timestamp),
                    style: const TextStyle(color: NMTheme.textSecondary, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
