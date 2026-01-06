import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ParentAppDrawer extends StatelessWidget {
  const ParentAppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      child: Container(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        child: Column(
          children: [
            // Header Gradient
            Container(
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
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
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
                                  color: Colors.grey,
                                  size: 30,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Manoj Sharma',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Parent',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Menu Items
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      _buildMenuItem(
                        context,
                        icon: Icons.dashboard_outlined,
                        title: 'Dashboard',
                        route: '/parent-dashboard',
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.assignment_outlined,
                        title: 'Grievance',
                        route: '/parent-grievance',
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.people_outline,
                        title: 'Parent-Teacher Meeting',
                        route: '/ptm',
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.calendar_today_outlined,
                        title: 'Attendance Record',
                        route: '/parent-attendance',
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.trending_up,
                        title: 'Student Performance',
                        route: '/parent-performance',
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.account_balance_wallet,
                        title: 'Payments',
                        route: '/payments',
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.emoji_events_outlined,
                        title: 'Results',
                        route: '/parent-results',
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.schedule,
                        title: 'Timetable',
                        route: '/parent-timetable',
                      ),
                      const Divider(height: 32),
                    ],
                  ),
                ),
              ),
            ),

            // Logout Button
            Container(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  onPressed: () {
                    Get.offAllNamed('/role-selection');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[400],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
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
    required String route,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color(0xFF1565C0),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        Get.toNamed(route);
      },
    );
  }
}
