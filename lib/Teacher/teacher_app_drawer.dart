import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'teacher_dashboard_screen.dart';
import 'manage_attendance_screen.dart';
import 'assignments_list_screen.dart';
import 'syllabus_tracking_screen.dart';
import 'teacher_doubts_screen.dart';
import 'hr_section_screen.dart';
import 'student_performance_screen.dart';
import 'teacher_notification_screen.dart';
import 'teacher_timetable_screen.dart';

class TeacherAppDrawer extends StatelessWidget {
  const TeacherAppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            // Drawer Header with Gradient
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 50, bottom: 24, left: 20, right: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1565C0),
                    Color(0xFF1976D2),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Image
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/profile.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Prof. Rahul Tiwari',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Mathematics Department',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            // Menu Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildMenuItem(
                    context,
                    icon: Icons.dashboard_outlined,
                    title: 'Dashboard',
                    onTap: () {
                      Get.back();
                      Get.to(() => const TeacherDashboardScreen());
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    onTap: () {
                      Get.back();
                      Get.to(() => const TeacherNotificationScreen());
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.check_box_outlined,
                    title: 'Manage Attendance',
                    onTap: () {
                      Get.back();
                      Get.to(() => const ManageAttendanceScreen());
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.schedule_outlined,
                    title: 'Timetable',
                    onTap: () {
                      Get.back();
                      Get.to(() => const TeacherTimetableScreen());
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.assignment_turned_in_outlined,
                    title: 'Syllabus Tracking',
                    onTap: () {
                      Get.back();
                      Get.to(() => const SyllabusTrackingScreen());
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.assignment_outlined,
                    title: 'Assignments',
                    onTap: () {
                      Get.back();
                      Get.to(() => const AssignmentsListScreen());
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.help_outline,
                    title: 'Doubts',
                    onTap: () {
                      Get.back();
                      Get.to(() => const TeacherDoubtsScreen());
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.bar_chart_outlined,
                    title: 'Student Performance',
                    onTap: () {
                      Get.back();
                      Get.to(() => const StudentPerformanceScreen());
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.business_center_outlined,
                    title: 'HR Section',
                    onTap: () {
                      Get.back();
                      Get.to(() => const HRSectionScreen());
                    },
                  ),
                  const Divider(height: 32),
                ],
              ),
            ),

            // Logout Button
            Container(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showLogoutDialog(context);
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF5350),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.primary,
        size: 24,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Logout',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black54),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(); // Close dialog
              Get.offAllNamed('/role-selection');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF5350),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
