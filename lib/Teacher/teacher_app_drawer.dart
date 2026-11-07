import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth_controller.dart';
import 'teacher_dashboard_screen.dart';
import 'manage_attendance_screen.dart';
import 'assignments_list_screen.dart';
import 'syllabus_tracking_screen.dart';
import 'teacher_doubts_screen.dart';
import 'hr_section_screen.dart';
import 'student_performance_screen.dart';
import 'teacher_notification_screen.dart';
import 'teacher_timetable_screen.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_widgets.dart';

class TeacherAppDrawer extends StatelessWidget {
  const TeacherAppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: NMTheme.bg,
      child: SafeArea(
        child: Column(
          children: [
            // Header Profile Card
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: NMCard(
                radius: 22,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: NMTheme.raisedShadow(offset: 2, blur: 4),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/profile.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.person, color: NMTheme.textSecondary),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Prof. Rahul Tiwari',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: NMTheme.textPrimary,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Mathematics Faculty',
                            style: TextStyle(
                              fontSize: 12,
                              color: NMTheme.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Navigation Items List
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                children: [
                  _buildMenuItem(context, icon: Icons.dashboard_rounded, title: 'Dashboard', onTap: () {
                    Get.back();
                    Get.to(() => const TeacherDashboardScreen());
                  }),
                  _buildMenuItem(context, icon: Icons.notifications_rounded, title: 'Notifications', onTap: () {
                    Get.back();
                    Get.to(() => const TeacherNotificationScreen());
                  }),
                  _buildMenuItem(context, icon: Icons.how_to_reg_rounded, title: 'Manage Attendance', onTap: () {
                    Get.back();
                    Get.to(() => const ManageAttendanceScreen());
                  }),
                  _buildMenuItem(context, icon: Icons.schedule_rounded, title: 'Timetable', onTap: () {
                    Get.back();
                    Get.to(() => const TeacherTimetableScreen());
                  }),
                  _buildMenuItem(context, icon: Icons.menu_book_rounded, title: 'Syllabus Tracking', onTap: () {
                    Get.back();
                    Get.to(() => const SyllabusTrackingScreen());
                  }),
                  _buildMenuItem(context, icon: Icons.assignment_rounded, title: 'Assignments', onTap: () {
                    Get.back();
                    Get.to(() => const AssignmentsListScreen());
                  }),
                  _buildMenuItem(context, icon: Icons.help_rounded, title: 'Student Doubts', onTap: () {
                    Get.back();
                    Get.to(() => const TeacherDoubtsScreen());
                  }),
                  _buildMenuItem(context, icon: Icons.insights_rounded, title: 'Student Performance', onTap: () {
                    Get.back();
                    Get.to(() => const StudentPerformanceScreen());
                  }),
                  _buildMenuItem(context, icon: Icons.badge_rounded, title: 'HR Section', onTap: () {
                    Get.back();
                    Get.to(() => const HRSectionScreen());
                  }),
                ],
              ),
            ),

            // Logout Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () => _showLogoutDialog(context),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFEF4444).withOpacity(0.4),
                        offset: const Offset(0, 4),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout_rounded, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: NMTheme.textSecondary,
                size: 22,
              ),
              const SizedBox(width: 14),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: NMTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: NMTheme.bg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold, color: NMTheme.textPrimary)),
        content: const Text('Are you sure you want to logout?', style: TextStyle(color: NMTheme.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel', style: TextStyle(color: NMTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              final authController = Get.find<AuthController>();
              authController.clearSession();
              Get.back();
              Get.offAllNamed('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
