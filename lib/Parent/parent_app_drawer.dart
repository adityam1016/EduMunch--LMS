import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth_controller.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_widgets.dart';

class ParentAppDrawer extends StatelessWidget {
  const ParentAppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: NMTheme.bg,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: NMCard(
                padding: const EdgeInsets.all(16),
                borderRadius: BorderRadius.circular(20),
                child: Row(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: NMTheme.surface,
                        boxShadow: NMTheme.cardShadows,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.family_restroom_rounded,
                        color: NMTheme.primaryPurple,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Manoj Sharma',
                            style: TextStyle(
                              fontSize: 16.5,
                              fontWeight: FontWeight.w800,
                              color: NMTheme.textDark,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          const Text(
                            'Parent Account',
                            style: TextStyle(
                              fontSize: 12.5,
                              color: NMTheme.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: NMTheme.accentTeal.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'CHILD: Aditya Mishra',
                              style: TextStyle(
                                color: NMTheme.accentTeal,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                children: [
                  _buildDrawerTile(
                    icon: Icons.dashboard_outlined,
                    title: 'Parent Dashboard',
                    route: '/parent-dashboard',
                  ),
                  _buildDrawerTile(
                    icon: Icons.calendar_today_outlined,
                    title: 'Attendance Record',
                    route: '/parent-attendance',
                  ),
                  _buildDrawerTile(
                    icon: Icons.trending_up_rounded,
                    title: 'Student Performance',
                    route: '/parent-performance',
                  ),
                  _buildDrawerTile(
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'Fees & Payments',
                    route: '/payments',
                  ),
                  _buildDrawerTile(
                    icon: Icons.schedule_outlined,
                    title: 'Class Timetable',
                    route: '/parent-timetable',
                  ),
                  _buildDrawerTile(
                    icon: Icons.groups_outlined,
                    title: 'Parent-Teacher Meeting',
                    route: '/ptm',
                  ),
                  _buildDrawerTile(
                    icon: Icons.support_agent_outlined,
                    title: 'Grievance & Support',
                    route: '/parent-grievance',
                  ),
                  const SizedBox(height: 12),
                  Divider(color: Colors.grey.withOpacity(0.2), height: 1),
                  const SizedBox(height: 12),
                  // Switch to Student Mode
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: NMCard(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        onTap: () => _showStudentPinDialog(context),
                        borderRadius: BorderRadius.circular(14),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: NMTheme.accentOcean.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.school_outlined,
                                color: NMTheme.accentOcean,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Text(
                                'Switch to Student Mode',
                                style: TextStyle(
                                  color: NMTheme.accentOcean,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: NMTheme.accentOcean),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () => _showLogoutDialog(context),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: NMTheme.surface,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: NMTheme.cardShadows,
                    border: Border.all(color: const Color(0xFFE53935).withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.logout_rounded, color: Color(0xFFE53935), size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Logout',
                        style: TextStyle(
                          color: Color(0xFFE53935),
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
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

  Widget _buildDrawerTile({
    required IconData icon,
    required String title,
    required String route,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: NMCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: () {
            Get.back();
            Get.toNamed(route);
          },
          borderRadius: BorderRadius.circular(14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: NMTheme.primaryPurple.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: NMTheme.primaryPurple, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: NMTheme.textDark,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right_rounded, size: 18, color: NMTheme.textSecondary),
            ],
          ),
        ),
      ),
    );
  }

  void _showStudentPinDialog(BuildContext context) {
    Get.back();
    final authController = Get.find<AuthController>();
    final userEmail = authController.email ?? 'student@edumunch.com';

    Get.offAllNamed('/dashboard');
    Get.snackbar(
      'Access Granted',
      'Switched to Student view',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: NMTheme.accentTeal,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );

    authController.setSession(
      email: userEmail,
      role: 'Student',
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: NMTheme.bg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Logout',
          style: TextStyle(fontWeight: FontWeight.w800, color: NMTheme.textDark),
        ),
        content: const Text(
          'Are you sure you want to sign out from Parent Portal?',
          style: TextStyle(color: NMTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel', style: TextStyle(color: NMTheme.textSecondary, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () {
              final authController = Get.find<AuthController>();
              authController.clearSession();
              Get.back();
              Get.offAllNamed('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Logout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
