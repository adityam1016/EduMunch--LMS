import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_drawer.dart';
import 'notification_screen.dart';
import '../auth_controller.dart';
import '../services/services.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_widgets.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  Map<String, String> studentData = {
    'name': 'Aditya Mishra',
    'batch': '11th JEE MAINS',
    'center': 'Kota Main Center',
    'branch': 'Science',
    'studentId': '202400123',
  };

  final List<Map<String, dynamic>> _performanceData = [
    {
      'subject': 'Mathematics',
      'score': 85,
      'total': 100,
      'trend': 'up',
      'percentage': 85.0,
      'color': const Color(0xFF7C3AED),
    },
    {
      'subject': 'Physics',
      'score': 78,
      'total': 100,
      'trend': 'up',
      'percentage': 78.0,
      'color': const Color(0xFF0C6E5A),
    },
    {
      'subject': 'Chemistry',
      'score': 92,
      'total': 100,
      'trend': 'down',
      'percentage': 92.0,
      'color': const Color(0xFFD97706),
    },
  ];

  final Map<String, dynamic> _overallPerformance = {
    'averageScore': 85.0,
    'rank': 12,
    'totalStudents': 150,
    'testsCompleted': 24,
    'attendance': 94.5,
  };

  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'Live classes',
      'icon': Icons.play_circle_fill_rounded,
      'color': const Color(0xFF4C218E),
      'route': '/doubt-lecture',
    },
    {
      'name': 'Assignments',
      'icon': Icons.assignment_rounded,
      'color': const Color(0xFF0C6E5A),
      'route': '/assignments',
    },
    {
      'name': 'Tests',
      'icon': Icons.quiz_rounded,
      'color': const Color(0xFF1B7696),
      'route': '/test-portal',
    },
    {
      'name': 'Doubts',
      'icon': Icons.help_rounded,
      'color': const Color(0xFFD97706),
      'route': '/doubts',
    },
  ];

  bool _isProfileExpanded = false;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    try {
      final authController = Get.find<AuthController>();
      final email = authController.email;
      final user = AuthService.currentUser;

      String name = 'Aditya Mishra';
      String studentId = '202400123';

      if (user != null) {
        studentId = user.id.substring(0, 8).toUpperCase();
        final profile = await AuthService.getUserProfile(user.id);
        if (profile != null && profile.fullName.isNotEmpty) {
          name = profile.fullName;
        }
      }

      if (name == 'Student' && email != null && email.isNotEmpty) {
        final usernamePart = email.split('@').first;
        name = usernamePart
            .split('.')
            .map((w) =>
                w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
            .join(' ');
      }

      if (mounted) {
        setState(() {
          studentData = {
            'name': name.isNotEmpty ? name : 'Aditya Mishra',
            'batch': '11th JEE MAINS',
            'center': 'Kota Main Center',
            'branch': 'Science',
            'studentId': studentId,
          };
        });
      }

      // Load live courses for performance analytics
      final courses = await CourseService.getCourses();
      if (courses.isNotEmpty && mounted) {
        setState(() {
          _performanceData.clear();
          for (var c in courses.take(4)) {
            _performanceData.add({
              'subject': c.name,
              'score': (c.progress * 100).toInt(),
              'total': 100,
              'trend': c.progress > 0.5 ? 'up' : 'down',
              'percentage': c.progress * 100,
              'color': c.color,
            });
          }
        });
      }
    } catch (e) {
      debugPrint('Dashboard load warning: $e');
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
            // Neumorphic Top Bar
            NMAppBar(
              title: 'EduMunch',
              isRoot: true,
              onSearchTap: () => Get.toNamed('/courses'),
              onNotificationTap: () => Get.to(() => const NotificationScreen()),
            ),

            // Scrollable Body
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 14),

                    // User Profile Card
                    _buildProfileCard(context),

                    const SizedBox(height: 22),

                    // Today's Schedule Section
                    _buildSectionHeader(
                      context,
                      'Today\'s Schedule',
                      onSeeMore: () => Get.toNamed('/timetable'),
                    ),
                    const SizedBox(height: 12),
                    _buildScheduleSlider(context),

                    const SizedBox(height: 22),

                    // Live Lecture Highlight Card (Calculus)
                    _buildHighlightCard(context),

                    const SizedBox(height: 24),

                    // Performance Analytics Section
                    _buildSectionHeader(
                      context,
                      'Your Performance Analytics',
                      onSeeMore: () => Get.toNamed('/academic-performance'),
                    ),
                    const SizedBox(height: 12),
                    _buildPerformanceAnalytics(context),

                    const SizedBox(height: 24),

                    // Categories Section
                    _buildSectionHeader(
                      context,
                      'Categories',
                      onSeeMore: () => Get.toNamed('/courses'),
                    ),
                    const SizedBox(height: 12),
                    _buildCategoryList(context),

                    const SizedBox(height: 24),

                    // Quick Actions
                    _buildSectionHeader(context, 'Quick actions'),
                    const SizedBox(height: 12),
                    _buildQuickActionsGrid(context),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Profile Card with soft dual shadow, avatar, name, batch, green ID & expandable details
  Widget _buildProfileCard(BuildContext context) {
    return NMCard(
      radius: 26,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      onTap: () {
        setState(() {
          _isProfileExpanded = !_isProfileExpanded;
        });
      },
      child: Column(
        children: [
          Row(
            children: [
              // Avatar with soft inset border
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: NMTheme.surface,
                  border: Border.all(
                    color: Colors.white,
                    width: 2.5,
                  ),
                  boxShadow: NMTheme.raisedShadow(offset: 2.5, blur: 5),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/profile.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFFDDE5F0),
                        child: const Icon(
                          Icons.person,
                          size: 38,
                          color: Color(0xFF5E697C),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Student Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      studentData['name'] ?? 'Aditya Mishra',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: NMTheme.textPrimary,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      studentData['batch'] ?? '11th JEE MAINS',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: NMTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'ID: ${studentData['studentId'] ?? '202400123'}',
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
              ),

              // Caret dropdown icon
              Icon(
                _isProfileExpanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                color: NMTheme.textSecondary,
                size: 26,
              ),
            ],
          ),

          if (_isProfileExpanded) ...[
            const SizedBox(height: 14),
            Container(
              height: 1,
              color: NMTheme.shadowDark.withOpacity(0.3),
            ),
            const SizedBox(height: 12),
            _buildDetailRow('Batch', studentData['batch']!),
            _buildDetailRow('Center', studentData['center']!),
            _buildDetailRow('Branch', studentData['branch']!),
            _buildDetailRow('Student ID', studentData['studentId']!),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: NMTheme.textSecondary,
              ),
            ),
          ),
          const Text(
            ': ',
            style: TextStyle(
              fontSize: 13,
              color: NMTheme.textSecondary,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: NMTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Today's Schedule horizontal scroll matching Physics teal card and Maths blue card
  Widget _buildScheduleSlider(BuildContext context) {
    final lectures = [
      {
        'subject': 'Physics',
        'faculty': 'Dr. Rajesh Kumar',
        'time': '11:00 - 12:00',
        'type': 'Theory',
        'attended': 11,
        'total': 13,
        'colors': [const Color(0xFF0C6E5A), const Color(0xFF074F40)],
        'isCurrent': true,
      },
      {
        'subject': 'Mathematics',
        'faculty': 'Prof. Amit Sharma',
        'time': '12:00 - 13:00',
        'type': 'Practical',
        'attended': 9,
        'total': 12,
        'colors': [const Color(0xFF1B7696), const Color(0xFF135B74)],
        'isCurrent': false,
      },
      {
        'subject': 'Chemistry',
        'faculty': 'Dr. Priya Singh',
        'time': '14:00 - 15:00',
        'type': 'Theory',
        'attended': 10,
        'total': 11,
        'colors': [const Color(0xFFC46513), const Color(0xFFA04E09)],
        'isCurrent': false,
      },
    ];

    return SizedBox(
      height: 145,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: lectures.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final lecture = lectures[index];
          final isCurrent = lecture['isCurrent'] as bool;
          final colors = lecture['colors'] as List<Color>;

          return Container(
            width: 290,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: NMTheme.coloredCardShadow(colors[0], opacity: 0.4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top row: Subject + NOW badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      lecture['subject'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.2,
                      ),
                    ),
                    if (isCurrent)
                      const NMGlowingNowBadge()
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'NEXT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),

                // Faculty
                Text(
                  lecture['faculty'] as String,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                // Bottom row: Time + Theory badge + Attendance count pill
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time_rounded,
                              color: Colors.white,
                              size: 14,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              lecture['time'] as String,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.22),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            lecture['type'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // White Pill Badge with attended/total (e.g. 11/13)
                    NMWhitePillBadge(
                      text: '${lecture['attended']}/${lecture['total']}',
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Live Revision Card matching the purple card in reference
  Widget _buildHighlightCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF381868),
            Color(0xFF4C218E),
          ],
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: NMTheme.coloredCardShadow(const Color(0xFF381868), opacity: 0.45),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Content on the left
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Live badge with 3 dots
                const NMLiveBadge(),

                const SizedBox(height: 12),

                // Title
                const Text(
                  'Complete Calculus Revision',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.2,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 5),

                // Subtitle
                Text(
                  'With your mentor · Today 7:00 PM',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 10),

                // Duration
                Row(
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      color: Colors.white.withOpacity(0.85),
                      size: 15,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '45 min',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // White Neumorphic Button: "Join now"
                NMWhiteButton(
                  text: 'Join now',
                  textColor: const Color(0xFF381868),
                  onTap: () => Get.toNamed('/doubt-lecture'),
                ),
              ],
            ),
          ),

          const SizedBox(width: 14),

          // 3D Sunken Box with Book Icon
          Container(
            width: 78,
            height: 78,
            decoration: BoxDecoration(
              color: const Color(0xFF2E1256),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.15),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  offset: const Offset(2, 2),
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.1),
                  offset: const Offset(-2, -2),
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.menu_book_rounded,
                color: Colors.white,
                size: 38,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Neumorphic Performance Analytics Section matching "Sunken", "Metrics", "Gradients"
  Widget _buildPerformanceAnalytics(BuildContext context) {
    return Column(
      children: [
        // Top 2 Preview Cards from the reference image ("Sunken" & "Metrics")
        Row(
          children: [
            // Left Card: "Sunken" container with "4.0%" pill and purple bottom tab
            Expanded(
              child: NMCard(
                radius: 20,
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Sunken',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: NMTheme.textPrimary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: NMTheme.insetDecoration(radius: 8),
                          child: const Text(
                            '4.0%',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF7C3AED),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 28,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Gradient',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Right Card: "Metrics" container with "50%" pill and "Gradients 11.00%"
            Expanded(
              child: NMCard(
                radius: 20,
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Metrics',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: NMTheme.textPrimary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: NMTheme.insetDecoration(radius: 8),
                          child: const Text(
                            '50%',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF10B981),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Gradients',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: NMTheme.textSecondary,
                          ),
                        ),
                        Text(
                          '11.00%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        // Overall Performance Card (Neumorphic Raised Card with rich details)
        NMCard(
          radius: 22,
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Overall Performance',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: NMTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${_overallPerformance['averageScore'].toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF381868),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const Text(
                        'Average Score',
                        style: TextStyle(
                          fontSize: 12,
                          color: NMTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.trending_up_rounded,
                              color: Color(0xFF10B981),
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Rank ${_overallPerformance['rank']}',
                              style: const TextStyle(
                                color: Color(0xFF10B981),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'of ${_overallPerformance['totalStudents']} students',
                        style: const TextStyle(
                          color: NMTheme.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricWell(
                      'Tests Completed',
                      '${_overallPerformance['testsCompleted']}',
                      Icons.assignment_turned_in_rounded,
                      const Color(0xFF7C3AED),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricWell(
                      'Attendance',
                      '${_overallPerformance['attendance']}%',
                      Icons.check_circle_rounded,
                      const Color(0xFF10B981),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Subject-wise Performance Cards with Sunken Progress Tracks
        ..._performanceData.map((subject) {
          final color = subject['color'] as Color;
          final pct = (subject['percentage'] as double) / 100;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: NMCard(
              radius: 18,
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            subject['subject'] as String,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: NMTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            subject['trend'] == 'up'
                                ? Icons.arrow_upward_rounded
                                : Icons.arrow_downward_rounded,
                            size: 15,
                            color: subject['trend'] == 'up'
                                ? const Color(0xFF10B981)
                                : const Color(0xFFEF4444),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '${subject['score']}/${subject['total']}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: NMTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Sunken progress track
                  Container(
                    height: 9,
                    decoration: NMTheme.insetDecoration(radius: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: pct.clamp(0.0, 1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${(pct * 100).toInt()}% completed',
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: NMTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildMetricWell(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: NMTheme.insetDecoration(radius: 14),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: NMTheme.textPrimary,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: NMTheme.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Horizontal Neumorphic Category Tiles
  Widget _buildCategoryList(BuildContext context) {
    return SizedBox(
      height: 105,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final color = cat['color'] as Color;

          return GestureDetector(
            onTap: () {
              final route = cat['route'] as String?;
              if (route != null) Get.toNamed(route);
            },
            child: NMCard(
              radius: 20,
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                width: 115,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        cat['icon'] as IconData,
                        size: 20,
                        color: color,
                      ),
                    ),
                    Text(
                      cat['name'] as String,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: NMTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Quick Actions Grid with soft tactile cards
  Widget _buildQuickActionsGrid(BuildContext context) {
    final quickActions = [
      {
        'icon': Icons.calendar_month_rounded,
        'label': 'Timetable',
        'route': '/timetable',
        'color': const Color(0xFF1B7696),
      },
      {
        'icon': Icons.insights_rounded,
        'label': 'Results',
        'route': '/result',
        'color': const Color(0xFF7C3AED),
      },
      {
        'icon': Icons.chat_bubble_outline_rounded,
        'label': 'Feedback',
        'route': '/feedback',
        'color': const Color(0xFF0C6E5A),
      },
    ];

    return Row(
      children: quickActions.map((item) {
        final color = item['color'] as Color;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: GestureDetector(
              onTap: () {
                final route = item['route'] as String?;
                if (route != null) Get.toNamed(route);
              },
              child: NMCard(
                radius: 20,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        item['icon'] as IconData,
                        color: color,
                        size: 22,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['label'] as String,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: NMTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, {VoidCallback? onSeeMore}) {
    return NMSectionHeader(
      title: title,
      onSeeMore: onSeeMore,
    );
  }
}
