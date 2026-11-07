import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'parent_app_drawer.dart';
import 'parent_notification_screen.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_widgets.dart';

class ParentDashboard extends StatefulWidget {
  const ParentDashboard({super.key});

  @override
  State<ParentDashboard> createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> {
  final Map<String, String> childData = const {
    'name': 'Aditya Mishra',
    'batch': '11th JEE MAINS',
    'center': 'Kota Main Center',
    'branch': 'Science Stream (PCM)',
    'studentId': '202400123',
    'rollNo': '11-A-42',
  };

  final List<Map<String, dynamic>> _quickActions = [
    {
      'name': 'Attendance',
      'icon': Icons.calendar_today_outlined,
      'route': '/parent-attendance',
      'color': NMTheme.accentOcean,
    },
    {
      'name': 'Performance',
      'icon': Icons.trending_up_rounded,
      'route': '/parent-performance',
      'color': NMTheme.accentTeal,
    },
    {
      'name': 'Fee Payment',
      'icon': Icons.account_balance_wallet_outlined,
      'route': '/payments',
      'color': NMTheme.primaryPurple,
    },
    {
      'name': 'Timetable',
      'icon': Icons.schedule_outlined,
      'route': '/parent-timetable',
      'color': const Color(0xFFFB8C00),
    },
    {
      'name': 'PTM Calls',
      'icon': Icons.groups_outlined,
      'route': '/ptm',
      'color': const Color(0xFF43A047),
    },
    {
      'name': 'Grievance',
      'icon': Icons.support_agent_outlined,
      'route': '/parent-grievance',
      'color': const Color(0xFFE53935),
    },
  ];

  bool _isProfileExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NMTheme.bg,
      drawer: const ParentAppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            NMAppBar(
              title: 'EduMunch',
              isRoot: true,
              unreadCount: 2,
              onSearchTap: () {},
              onNotificationTap: () => Get.to(() => const ParentNotificationScreen()),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildChildProfileCard(),
                    const SizedBox(height: 24),
                    _buildTodayScheduleSection(),
                    const SizedBox(height: 24),
                    _buildLiveHighlightCard(),
                    const SizedBox(height: 24),
                    _buildPerformanceAnalytics(),
                    const SizedBox(height: 24),
                    const NMSectionHeader(title: 'Quick Access'),
                    const SizedBox(height: 12),
                    _buildQuickActionGrid(),
                    const SizedBox(height: 24),
                    const NMSectionHeader(title: 'Recent Teacher Updates'),
                    const SizedBox(height: 12),
                    _buildRecentUpdates(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChildProfileCard() {
    return NMCard(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(24),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: NMTheme.surface,
                  boxShadow: NMTheme.cardShadows,
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/profile.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.face_rounded,
                        size: 38,
                        color: NMTheme.primaryPurple,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      childData['name']!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: NMTheme.textDark,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      childData['batch']!,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: NMTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'ID: ${childData['studentId']}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: NMTheme.accentTeal,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: NMTheme.primaryPurple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Child View',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: NMTheme.primaryPurple,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              NMIconButton(
                icon: _isProfileExpanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                size: 36,
                iconSize: 22,
                iconColor: NMTheme.textSecondary,
                onTap: () {
                  setState(() {
                    _isProfileExpanded = !_isProfileExpanded;
                  });
                },
              ),
            ],
          ),
          if (_isProfileExpanded) ...[
            const SizedBox(height: 16),
            Divider(color: Colors.grey.withOpacity(0.2), height: 1),
            const SizedBox(height: 14),
            _buildProfileDetailRow('Center', childData['center']!),
            const SizedBox(height: 8),
            _buildProfileDetailRow('Branch / Stream', childData['branch']!),
            const SizedBox(height: 8),
            _buildProfileDetailRow('Roll Number', childData['rollNo']!),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => Get.toNamed('/parent-performance'),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: NMTheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: NMTheme.cardShadows,
                ),
                alignment: Alignment.center,
                child: const Text(
                  'View Complete Academic Profile →',
                  style: TextStyle(
                    color: NMTheme.primaryPurple,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProfileDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12.5,
            color: NMTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            color: NMTheme.textDark,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildTodayScheduleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NMSectionHeader(
          title: "Today's Schedule",
          onSeeMore: () => Get.toNamed('/parent-timetable'),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: ListView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            children: [
              // Physics Teal Card
              Container(
                width: 250,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: NMTheme.physicsTealGradient,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: NMTheme.accentTeal.withOpacity(0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 7),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Physics',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        NMGlowingNowBadge(text: 'NOW'),
                      ],
                    ),
                    const Text(
                      'Dr. Rajesh Kumar',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.access_time_rounded, color: Colors.white70, size: 14),
                            SizedBox(width: 4),
                            Text(
                              '11:00 - 12:00',
                              style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const NMWhitePillBadge(text: '11/13'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              // Mathematics Ocean Blue Card
              Container(
                width: 250,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: NMTheme.mathsOceanGradient,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: NMTheme.accentOcean.withOpacity(0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 7),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Mathematics',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'NEXT',
                            style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      'Prof. Aditya Mishra',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.access_time_rounded, color: Colors.white70, size: 14),
                            SizedBox(width: 4),
                            Text(
                              '12:15 - 01:15',
                              style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const NMWhitePillBadge(text: '08/13'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLiveHighlightCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: NMTheme.livePurpleGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: NMTheme.primaryPurple.withOpacity(0.4),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.groups_rounded,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const NMLiveBadge(),
              const SizedBox(height: 14),
              const SizedBox(
                width: 220,
                child: Text(
                  'Parent-Teacher Online Meet',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'With Class Mentor • Today 7:00 PM',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: const [
                  Icon(Icons.timer_outlined, color: Colors.white70, size: 14),
                  SizedBox(width: 4),
                  Text(
                    '30 min slot',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              NMWhiteButton(
                label: 'Join Meeting',
                onTap: () => Get.toNamed('/ptm'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceAnalytics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NMSectionHeader(
          title: 'Child Performance Analytics',
          onSeeMore: () => Get.toNamed('/parent-performance'),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: NMCard(
                padding: const EdgeInsets.all(14),
                borderRadius: BorderRadius.circular(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Attendance',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: NMTheme.textDark,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: NMTheme.accentTeal.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            '94%',
                            style: TextStyle(
                              color: NMTheme.accentTeal,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    NMInsetContainer(
                      height: 8,
                      borderRadius: BorderRadius.circular(4),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: 0.94,
                        child: Container(
                          decoration: BoxDecoration(
                            color: NMTheme.accentTeal,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '32 of 34 classes attended',
                      style: TextStyle(fontSize: 11, color: NMTheme.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: NMCard(
                padding: const EdgeInsets.all(14),
                borderRadius: BorderRadius.circular(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Avg Test Score',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: NMTheme.textDark,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: NMTheme.primaryPurple.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            '88%',
                            style: TextStyle(
                              color: NMTheme.primaryPurple,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    NMInsetContainer(
                      height: 8,
                      borderRadius: BorderRadius.circular(4),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: 0.88,
                        child: Container(
                          decoration: BoxDecoration(
                            color: NMTheme.primaryPurple,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Rank #3 in Batch',
                      style: TextStyle(fontSize: 11, color: NMTheme.textSecondary, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _quickActions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.95,
      ),
      itemBuilder: (context, index) {
        final item = _quickActions[index];
        final Color color = item['color'];

        return NMCard(
          padding: const EdgeInsets.all(10),
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            onTap: () => Get.toNamed(item['route']),
            borderRadius: BorderRadius.circular(18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    item['icon'],
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item['name'],
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: NMTheme.textDark,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecentUpdates() {
    return Column(
      children: [
        _buildUpdateItem(
          icon: Icons.check_circle_outline_rounded,
          iconColor: NMTheme.accentTeal,
          title: 'Mathematics Unit Test Result',
          subtitle: 'Scored 95/100 (Highest in Class 11-A)',
          time: 'Yesterday',
        ),
        const SizedBox(height: 10),
        _buildUpdateItem(
          icon: Icons.fact_check_outlined,
          iconColor: NMTheme.accentOcean,
          title: 'Attendance Marked Present',
          subtitle: 'All 4 lecture periods attended today',
          time: 'Today, 2:00 PM',
        ),
        const SizedBox(height: 10),
        _buildUpdateItem(
          icon: Icons.receipt_long_outlined,
          iconColor: NMTheme.primaryPurple,
          title: 'Term 2 Fee Receipt Generated',
          subtitle: 'Invoice #EM-2024-892 paid successfully',
          time: '3 days ago',
        ),
      ],
    );
  }

  Widget _buildUpdateItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return NMCard(
      padding: const EdgeInsets.all(14),
      borderRadius: BorderRadius.circular(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: NMTheme.textDark,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: NMTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: const TextStyle(fontSize: 11, color: NMTheme.textSecondary),
          ),
        ],
      ),
    );
  }
}
