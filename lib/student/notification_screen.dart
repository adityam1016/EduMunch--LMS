import 'package:flutter/material.dart';
import 'app_drawer.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy notifications data
    final notifications = [
      {
        'title': 'Physics Class Scheduled',
        'message': 'Your Physics class with Mr. Sharma is scheduled for tomorrow at 10:00 AM.',
        'time': '2 hours ago',
        'type': 'class',
        'isRead': false,
      },
      {
        'title': 'Mathematics Exam Alert',
        'message': 'Unit Test for Mathematics is scheduled on 30th December 2025 at 9:00 AM.',
        'time': '5 hours ago',
        'type': 'exam',
        'isRead': false,
      },
      {
        'title': 'Chemistry Lab Session',
        'message': 'Practical session for Chemistry has been rescheduled to 3:00 PM today.',
        'time': '1 day ago',
        'type': 'class',
        'isRead': true,
      },
      {
        'title': 'JEE Mock Test Results',
        'message': 'Your JEE Mock Test 5 results are now available. Check your score in the Result section.',
        'time': '2 days ago',
        'type': 'exam',
        'isRead': true,
      },
      {
        'title': 'Biology Class Cancelled',
        'message': 'Tomorrow\'s Biology class has been cancelled due to unavoidable circumstances.',
        'time': '2 days ago',
        'type': 'class',
        'isRead': true,
      },
      {
        'title': 'English Mid-Term Exam',
        'message': 'Mid-term examination for English is scheduled on 5th January 2026.',
        'time': '3 days ago',
        'type': 'exam',
        'isRead': true,
      },
      {
        'title': 'Doubt Session Available',
        'message': 'Special doubt clearing session for Physics is available this Saturday.',
        'time': '4 days ago',
        'type': 'class',
        'isRead': true,
      },
      {
        'title': 'Assignment Deadline',
        'message': 'Chemistry assignment submission deadline is tomorrow. Please submit before 5:00 PM.',
        'time': '5 days ago',
        'type': 'exam',
        'isRead': true,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Color(0xFF1A237E),
                        size: 20,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Notifications',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('All notifications marked as read'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    child: const Text(
                      'Mark all read',
                      style: TextStyle(
                        color: Color(0xFF2962FF),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Notifications List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return _buildNotificationCard(
                    title: notification['title'] as String,
                    message: notification['message'] as String,
                    time: notification['time'] as String,
                    type: notification['type'] as String,
                    isRead: notification['isRead'] as bool,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard({
    required String title,
    required String message,
    required String time,
    required String type,
    required bool isRead,
  }) {
    final isClass = type == 'class';
    final iconColor = isClass ? const Color(0xFF42A5F5) : const Color(0xFFEF5350);
    final icon = isClass ? Icons.class_outlined : Icons.assignment_outlined;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isRead ? Colors.grey[50] : const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: isRead ? FontWeight.w500 : FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    if (!isRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF2962FF),
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black38,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
