import 'package:flutter/material.dart';
import 'parent_app_drawer.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_widgets.dart';

class ParentNotificationModel {
  final String id;
  final String title;
  final String message;
  final String description;
  final DateTime timestamp;
  bool isRead;
  final String category;

  ParentNotificationModel({
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
  final List<ParentNotificationModel> notifications = [
    ParentNotificationModel(
      id: '1',
      title: 'Assignment Submitted',
      message: 'Aditya submitted Math assignment',
      description:
          'Aditya has successfully submitted his Math assignment on Quadratic Equations. The submission was completed on time.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      category: 'Academic',
    ),
    ParentNotificationModel(
      id: '2',
      title: 'Parent-Teacher Meeting Scheduled',
      message: 'Online PTM scheduled with Class Mentor',
      description:
          'An online parent-teacher meeting has been scheduled for tomorrow at 5:00 PM. Please join via Google Meet.',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      category: 'Meeting',
    ),
    ParentNotificationModel(
      id: '3',
      title: 'Attendance Alert',
      message: 'Attendance recorded: Present for all classes',
      description:
          'Aditya attended all 4 lecture sessions today including Physics and Chemistry practicals.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      category: 'Attendance',
    ),
    ParentNotificationModel(
      id: '4',
      title: 'Test Results Available',
      message: 'Mathematics Unit Test #2 Published',
      description:
          'Mathematics test results have been published. Aditya scored 95/100 (Highest in Class 11-A).',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
      category: 'Result',
    ),
    ParentNotificationModel(
      id: '5',
      title: 'Fee Installment Reminder',
      message: 'Installment 3 due on 15 March',
      description:
          'The final installment of ₹1,00,000 for Session 2025-26 is due on 15 March. Pay via online gateway to avoid late fees.',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
      category: 'Payment',
    ),
  ];

  String selectedFilter = 'All';
  String? expandedNotificationId;

  List<ParentNotificationModel> get filteredNotifications {
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
        return NMTheme.primaryPurple;
      case 'Meeting':
        return NMTheme.accentTeal;
      case 'Attendance':
        return NMTheme.accentOcean;
      case 'Result':
        return const Color(0xFF43A047);
      case 'Payment':
        return const Color(0xFFFB8C00);
      default:
        return NMTheme.primaryPurple;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Academic':
        return Icons.school_outlined;
      case 'Meeting':
        return Icons.groups_outlined;
      case 'Attendance':
        return Icons.fact_check_outlined;
      case 'Result':
        return Icons.grade_outlined;
      case 'Payment':
        return Icons.account_balance_wallet_outlined;
      default:
        return Icons.notifications_none_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const ParentAppDrawer(),
      backgroundColor: NMTheme.bg,
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
    final filters = ['All', 'Unread', 'Academic', 'Meeting', 'Attendance', 'Result', 'Payment'];

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
            'No Notifications',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: NMTheme.textDark,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'All updates have been read.',
            style: TextStyle(color: NMTheme.textSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(ParentNotificationModel notification) {
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
