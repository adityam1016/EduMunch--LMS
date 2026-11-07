import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'teacher_app_drawer.dart';
import 'teacher_notification_screen.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_widgets.dart';

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  final Map<String, String> teacherData = const {
    'name': 'Prof. Rahul Tiwari',
    'subject': 'Mathematics Faculty',
    'experience': '12 years',
    'employeeId': 'TCH2024089',
    'department': 'Science Faculty',
  };

  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'Attendance',
      'icon': Icons.how_to_reg_rounded,
      'color': const Color(0xFF0C6E5A),
      'route': '/manage-attendance',
    },
    {
      'name': 'Assignments',
      'icon': Icons.assignment_rounded,
      'color': const Color(0xFF1B7696),
      'route': '/assignments-list',
    },
    {
      'name': 'Syllabus',
      'icon': Icons.menu_book_rounded,
      'color': const Color(0xFF7C3AED),
      'route': '/syllabus-tracking',
    },
    {
      'name': 'Doubts',
      'icon': Icons.help_rounded,
      'color': const Color(0xFFD97706),
      'route': '/teacher-doubts',
    },
  ];

  bool _isProfileExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NMTheme.bg,
      drawer: const TeacherAppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            NMAppBar(
              title: 'EduMunch',
              isRoot: true,
              onSearchTap: () {},
              onNotificationTap: () => Get.to(() => const TeacherNotificationScreen()),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 14),

                    // Teacher Profile Card
                    _buildProfileCard(context),

                    const SizedBox(height: 22),

                    // Today's Classes Slider
                    _buildSectionHeader(
                      context,
                      "Today's Schedule",
                      onSeeMore: () => Get.toNamed('/teacher-timetable'),
                    ),
                    const SizedBox(height: 12),
                    _buildScheduleSlider(context),

                    const SizedBox(height: 22),

                    // Next Live Class Highlight Card
                    _buildHighlightCard(context),

                    const SizedBox(height: 24),

                    // Teaching Tools
                    _buildSectionHeader(context, 'Teaching Tools'),
                    const SizedBox(height: 12),
                    _buildCategoryList(context),

                    const SizedBox(height: 24),

                    // Class Stats in Neumorphic Cards
                    _buildSectionHeader(context, 'Faculty Overview'),
                    const SizedBox(height: 12),
                    _buildClassStats(context),

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
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: NMTheme.surface,
                  border: Border.all(color: Colors.white, width: 2.5),
                  boxShadow: NMTheme.raisedShadow(offset: 2.5, blur: 5),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/profile.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.person, color: NMTheme.textSecondary, size: 36),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      teacherData['name']!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: NMTheme.textPrimary,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      teacherData['subject']!,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: NMTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'ID: ${teacherData['employeeId']}',
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
              ),
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
            Container(height: 1, color: NMTheme.shadowDark.withOpacity(0.3)),
            const SizedBox(height: 12),
            _buildDetailRow('Experience', teacherData['experience']!),
            _buildDetailRow('Employee ID', teacherData['employeeId']!),
            _buildDetailRow('Department', teacherData['department']!),
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
            width: 95,
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: NMTheme.textSecondary),
            ),
          ),
          const Text(': ', style: TextStyle(fontSize: 13, color: NMTheme.textSecondary)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: NMTheme.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleSlider(BuildContext context) {
    final classes = [
      {
        'subject': 'Class 11 JEE',
        'topic': 'Limits & Continuity',
        'time': '11:00 - 12:00',
        'type': 'Theory',
        'students': 45,
        'room': 'Room 204',
        'colors': [const Color(0xFF0C6E5A), const Color(0xFF074F40)],
        'isCurrent': true,
      },
      {
        'subject': 'Class 12 Boards',
        'topic': 'Definite Integration',
        'time': '12:30 - 01:30',
        'type': 'Practical',
        'students': 38,
        'room': 'Room 105',
        'colors': [const Color(0xFF1B7696), const Color(0xFF135B74)],
        'isCurrent': false,
      },
      {
        'subject': 'Doubt Session',
        'topic': 'Calculus Doubt Clearing',
        'time': '03:00 - 04:00',
        'type': 'Online',
        'students': 25,
        'room': 'Google Meet',
        'colors': [const Color(0xFFC46513), const Color(0xFFA04E09)],
        'isCurrent': false,
      },
    ];

    return SizedBox(
      height: 145,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: classes.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final c = classes[index];
          final isCurrent = c['isCurrent'] as bool;
          final colors = c['colors'] as List<Color>;

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      c['subject'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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
                        child: Text(
                          c['room'] as String,
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
                Text(
                  c['topic'] as String,
                  style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13, fontWeight: FontWeight.w500),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.access_time_rounded, color: Colors.white, size: 14),
                            const SizedBox(width: 5),
                            Text(
                              c['time'] as String,
                              style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.22),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            c['type'] as String,
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    NMWhitePillBadge(
                      text: '${c['students']} Students',
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

  Widget _buildHighlightCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF381868), Color(0xFF4C218E)],
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: NMTheme.coloredCardShadow(const Color(0xFF381868), opacity: 0.45),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const NMLiveBadge(),
                const SizedBox(height: 12),
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
                Text(
                  'With Batch 11-A · Today 5:00 PM',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.people_outline_rounded, color: Colors.white.withOpacity(0.85), size: 15),
                    const SizedBox(width: 5),
                    Text(
                      '45 Students Enrolled',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                NMWhiteButton(
                  text: 'Start Class',
                  textColor: const Color(0xFF381868),
                  onTap: () => Get.toNamed('/teacher-timetable'),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Container(
            width: 78,
            height: 78,
            decoration: BoxDecoration(
              color: const Color(0xFF2E1256),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  offset: const Offset(2, 2),
                  blurRadius: 4,
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.1),
                  offset: const Offset(-2, -2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: const Center(
              child: Icon(Icons.cast_for_education_rounded, color: Colors.white, size: 36),
            ),
          ),
        ],
      ),
    );
  }

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
                      child: Icon(cat['icon'] as IconData, size: 20, color: color),
                    ),
                    Text(
                      cat['name'] as String,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: NMTheme.textPrimary),
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

  Widget _buildClassStats(BuildContext context) {
    final stats = [
      {'label': 'Total Classes', 'value': '24', 'icon': Icons.school_rounded, 'color': const Color(0xFF7C3AED)},
      {'label': 'Assignments', 'value': '12', 'icon': Icons.assignment_rounded, 'color': const Color(0xFF0C6E5A)},
      {'label': 'Pending Doubts', 'value': '8', 'icon': Icons.help_rounded, 'color': const Color(0xFFD97706)},
    ];

    return Row(
      children: stats.map((stat) {
        final color = stat['color'] as Color;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
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
                    child: Icon(stat['icon'] as IconData, color: color, size: 22),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    stat['value'] as String,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: NMTheme.textPrimary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    stat['label'] as String,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: NMTheme.textMuted),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, {VoidCallback? onSeeMore}) {
    return NMSectionHeader(title: title, onSeeMore: onSeeMore);
  }
}
