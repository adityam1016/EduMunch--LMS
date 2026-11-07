import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth_controller.dart';
import '../widgets/parent_pin_dialog.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_widgets.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final userEmail = authController.email ?? 'aditya.mishra@edumunch.com';
    final usernamePart = userEmail.split('@').first;
    final displayName = usernamePart
        .split('.')
        .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
        .join(' ');

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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName.isNotEmpty ? displayName : 'Aditya Mishra',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: NMTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            userEmail,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
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
                  _buildMenuItem(context, icon: Icons.dashboard_rounded, title: 'Dashboard', route: '/dashboard'),
                  _buildMenuItem(context, icon: Icons.notifications_rounded, title: 'Notifications', route: '/notifications'),
                  _buildMenuItem(context, icon: Icons.calendar_today_rounded, title: 'Attendance', route: '/attendance'),
                  _buildMenuItem(context, icon: Icons.school_rounded, title: 'Courses', route: '/courses'),
                  _buildMenuItem(context, icon: Icons.access_time_filled_rounded, title: 'Timetable', route: '/timetable'),
                  _buildMenuItem(context, icon: Icons.play_circle_fill_rounded, title: 'Doubt Lecture', route: '/doubt-lecture'),
                  _buildMenuItem(context, icon: Icons.assignment_rounded, title: 'Assignments', route: '/assignments'),
                  _buildMenuItem(context, icon: Icons.help_rounded, title: 'Doubts', route: '/doubts'),
                  _buildMenuItem(context, icon: Icons.quiz_rounded, title: 'Test Portal', route: '/test-portal'),
                  _buildMenuItem(context, icon: Icons.trending_up_rounded, title: 'Academic Performance', route: '/academic-performance'),
                  _buildMenuItem(context, icon: Icons.emoji_events_rounded, title: 'Result', route: '/result'),
                  _buildMenuItem(context, icon: Icons.feedback_rounded, title: 'Feedback', route: '/feedback'),
                  const SizedBox(height: 12),

                  // Switch to Parent Option in Neumorphic Card
                  NMCard(
                    radius: 16,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    onTap: () => _showParentPinDialog(context),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF7C3AED).withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.supervised_user_circle_rounded,
                            color: Color(0xFF7C3AED),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Switch to Parent',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF7C3AED),
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'View as Parent',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: NMTheme.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14,
                          color: Color(0xFF7C3AED),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
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

  void _showParentPinDialog(BuildContext context) async {
    Get.back();
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const ParentPinDialog(),
    );

    if (result == true) {
      final authController = Get.find<AuthController>();
      authController.setSession(
        email: authController.email ?? 'parent@edumunch.com',
        role: 'Parent',
      );
      Get.offAllNamed('/parent-dashboard');
    }
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
  }) {
    final currentRoute = Get.currentRoute;
    final isSelected = currentRoute == route;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: GestureDetector(
        onTap: () {
          Get.back();
          Get.toNamed(route);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: isSelected ? NMTheme.sunkenBg : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: isSelected ? Border.all(color: NMTheme.sunkenBorder, width: 1.2) : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? const Color(0xFF7C3AED) : NMTheme.textSecondary,
                size: 22,
              ),
              const SizedBox(width: 14),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected ? const Color(0xFF7C3AED) : NMTheme.textPrimary,
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
        title: const Text(
          'Logout',
          style: TextStyle(fontWeight: FontWeight.bold, color: NMTheme.textPrimary),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: NMTheme.textSecondary),
        ),
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
