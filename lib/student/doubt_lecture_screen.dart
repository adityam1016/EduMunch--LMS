import 'package:flutter/material.dart';
import 'app_drawer.dart';
import '../services/timetable_service.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_widgets.dart';

class DoubtLectureScreen extends StatefulWidget {
  const DoubtLectureScreen({super.key});

  @override
  State<DoubtLectureScreen> createState() => _DoubtLectureScreenState();
}

class _DoubtLectureScreenState extends State<DoubtLectureScreen> {
  int selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadDoubtLectures();
  }

  Future<void> _loadDoubtLectures() async {
    try {
      final items = await TimetableService.getAllTimetables();
      if (items.isNotEmpty && mounted) {
        setState(() {
          int id = 1;
          doubtLectures.clear();
          doubtLectures.addAll(items.map((t) => {
                'id': id++,
                'subject': t.subject,
                'topic': '${t.subject} Discussion & Problem Solving',
                'date': t.dayOfWeek,
                'time': '${t.startTime} - ${t.endTime}',
                'professor': t.professor ?? 'Faculty',
                'students': 35 + (id * 3),
                'status': id == 1 ? 'Ongoing' : 'Upcoming',
                'mode': 'Online',
                'link': 'https://meet.google.com/edumunch-class',
              }));
        });
      }
    } catch (_) {}
  }

  final List<Map<String, dynamic>> doubtLectures = [
    {
      'id': 1,
      'subject': 'Physics',
      'topic': 'Circular Motion and Gravitation',
      'date': '28 Dec 2024',
      'time': '04:00 PM - 05:30 PM',
      'professor': 'Prof. Sharma',
      'students': 45,
      'status': 'Ongoing',
      'mode': 'Online',
      'link': 'https://meet.google.com/xyz-abc-123',
    },
    {
      'id': 2,
      'subject': 'Chemistry',
      'topic': 'Chemical Bonding and Reactions',
      'date': '28 Dec 2024',
      'time': '05:30 PM - 07:00 PM',
      'professor': 'Prof. Gupta',
      'students': 38,
      'status': 'Upcoming',
      'mode': 'Online',
      'link': 'https://meet.google.com/abc-123-xyz',
    },
    {
      'id': 3,
      'subject': 'Mathematics',
      'topic': 'Calculus - Integration',
      'date': '29 Dec 2024',
      'time': '03:00 PM - 04:30 PM',
      'professor': 'Prof. Kumar',
      'students': 52,
      'status': 'Upcoming',
      'mode': 'Offline',
      'link': 'https://meet.google.com/def-456-ghi',
    },
    {
      'id': 4,
      'subject': 'Biology',
      'topic': 'Cell Biology and Genetics',
      'date': '30 Dec 2024',
      'time': '04:00 PM - 05:30 PM',
      'professor': 'Prof. Singh',
      'students': 41,
      'status': 'Scheduled',
      'mode': 'Hybrid',
      'link': 'https://meet.google.com/jkl-789-mno',
    },
    {
      'id': 5,
      'subject': 'Physics',
      'topic': 'Thermodynamics',
      'date': '27 Dec 2024',
      'time': '03:00 PM - 04:30 PM',
      'professor': 'Prof. Sharma',
      'students': 48,
      'status': 'Completed',
      'mode': 'Online',
      'link': 'https://meet.google.com/pqr-012-stu',
    },
  ];

  final List<Map<String, dynamic>> extraLectures = [
    {
      'id': 1,
      'subject': 'Physics',
      'topic': 'JEE Advanced Problem Solving - Mechanics',
      'date': '31 Dec 2024',
      'time': '11:00 AM - 01:00 PM',
      'professor': 'Prof. Sharma',
      'difficulty': 'Advanced',
      'seats': '30/50',
      'status': 'Open for Registration',
      'link': 'https://meet.google.com/extra-001',
    },
    {
      'id': 2,
      'subject': 'Chemistry',
      'topic': 'Organic Chemistry - Reaction Mechanisms',
      'date': '02 Jan 2025',
      'time': '02:00 PM - 04:00 PM',
      'professor': 'Prof. Gupta',
      'difficulty': 'Advanced',
      'seats': '25/40',
      'status': 'Open for Registration',
      'link': 'https://meet.google.com/extra-002',
    },
    {
      'id': 3,
      'subject': 'Mathematics',
      'topic': 'Probability and Statistics',
      'date': '03 Jan 2025',
      'time': '10:00 AM - 12:00 PM',
      'professor': 'Prof. Kumar',
      'difficulty': 'Intermediate',
      'seats': '35/45',
      'status': 'Open for Registration',
      'link': 'https://meet.google.com/extra-003',
    },
    {
      'id': 4,
      'subject': 'Biology',
      'topic': 'Human Physiology - Comprehensive Review',
      'date': '04 Jan 2025',
      'time': '03:00 PM - 05:00 PM',
      'professor': 'Prof. Singh',
      'difficulty': 'Intermediate',
      'seats': '28/50',
      'status': 'Open for Registration',
      'link': 'https://meet.google.com/extra-004',
    },
    {
      'id': 5,
      'subject': 'Physics',
      'topic': 'Modern Physics & Quantum Mechanics',
      'date': '05 Jan 2025',
      'time': '04:00 PM - 06:00 PM',
      'professor': 'Prof. Reddy',
      'difficulty': 'Advanced',
      'seats': '20/35',
      'status': 'Limited Seats',
      'link': 'https://meet.google.com/extra-005',
    },
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Ongoing':
        return const Color(0xFF66BB6A);
      case 'Upcoming':
        return const Color(0xFF8B5CF6);
      case 'Scheduled':
        return Colors.orange;
      case 'Completed':
        return Colors.grey;
      case 'Open for Registration':
        return const Color(0xFF8B5CF6);
      case 'Limited Seats':
        return const Color(0xFFEF5350);
      default:
        return Colors.grey;
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Beginner':
        return const Color(0xFF66BB6A);
      case 'Intermediate':
        return const Color(0xFFFFB74D);
      case 'Advanced':
        return const Color(0xFFEF5350);
      default:
        return Colors.grey;
    }
  }

  Color _getModeColor(String mode) {
    switch (mode) {
      case 'Online':
        return const Color(0xFF8B5CF6);
      case 'Offline':
        return const Color(0xFFEF5350);
      case 'Hybrid':
        return const Color(0xFFFFB74D);
      default:
        return Colors.grey;
    }
  }

  IconData _getModeIcon(String mode) {
    switch (mode) {
      case 'Online':
        return Icons.video_call;
      case 'Offline':
        return Icons.location_on;
      case 'Hybrid':
        return Icons.language;
      default:
        return Icons.help;
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
            NMAppBar(
              title: 'Live Lectures',
              isRoot: false,
            ),
            const SizedBox(height: 10),

            // Inset Tab Selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: NMTheme.insetDecoration(radius: 18),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTabIndex = 0;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          decoration: BoxDecoration(
                            color: selectedTabIndex == 0 ? NMTheme.surface : Colors.transparent,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: selectedTabIndex == 0 ? NMTheme.raisedShadow(offset: 2.5, blur: 5) : [],
                          ),
                          child: Text(
                            'Doubt Lectures',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: selectedTabIndex == 0 ? FontWeight.w800 : FontWeight.w600,
                              color: selectedTabIndex == 0 ? NMTheme.primaryPurple : NMTheme.textMuted,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTabIndex = 1;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          decoration: BoxDecoration(
                            color: selectedTabIndex == 1 ? NMTheme.surface : Colors.transparent,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: selectedTabIndex == 1 ? NMTheme.raisedShadow(offset: 2.5, blur: 5) : [],
                          ),
                          child: Text(
                            'Extra Lectures',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: selectedTabIndex == 1 ? FontWeight.w800 : FontWeight.w600,
                              color: selectedTabIndex == 1 ? NMTheme.primaryPurple : NMTheme.textMuted,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Content
            if (selectedTabIndex == 0) ...[
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: doubtLectures.map((lecture) {
                      return _buildDoubtLectureCard(lecture);
                    }).toList(),
                  ),
                ),
              ),
            ] else ...[
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: extraLectures.map((lecture) {
                      return _buildExtraLectureCard(lecture);
                    }).toList(),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDoubtLectureCard(Map<String, dynamic> lecture) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: NMCard(
        radius: 22,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    lecture['subject'],
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: NMTheme.primaryPurple,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _getStatusColor(lecture['status']).withOpacity(0.14),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    lecture['status'],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: _getStatusColor(lecture['status']),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Text(
              lecture['topic'],
              style: const TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.bold,
                color: NMTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: NMTheme.insetDecoration(radius: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getModeIcon(lecture['mode']),
                        size: 13,
                        color: _getModeColor(lecture['mode']),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        lecture['mode'],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: _getModeColor(lecture['mode']),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.access_time_rounded, size: 13, color: NMTheme.textMuted),
                const SizedBox(width: 5),
                Text(
                  lecture['time'],
                  style: const TextStyle(fontSize: 12, color: NMTheme.textSecondary, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(Icons.person_outline_rounded, size: 14, color: NMTheme.textMuted),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    lecture['professor'],
                    style: const TextStyle(fontSize: 12, color: NMTheme.textSecondary),
                  ),
                ),
                const Icon(Icons.group_outlined, size: 14, color: NMTheme.textMuted),
                const SizedBox(width: 5),
                Text(
                  '${lecture['students']} joined',
                  style: const TextStyle(fontSize: 11.5, color: NMTheme.textMuted),
                ),
              ],
            ),
            if (lecture['mode'] != 'Offline') ...[
              const SizedBox(height: 14),
              NMWhiteButton(
                text: 'Join Live Now',
                icon: Icons.video_call_rounded,
                textColor: const Color(0xFF381868),
                radius: 12,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Connecting to ${lecture['topic']}...'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildExtraLectureCard(Map<String, dynamic> lecture) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: NMCard(
        radius: 22,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    lecture['subject'],
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: NMTheme.primaryPurple,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _getDifficultyColor(lecture['difficulty']).withOpacity(0.14),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    lecture['difficulty'],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: _getDifficultyColor(lecture['difficulty']),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Text(
              lecture['topic'],
              style: const TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.bold,
                color: NMTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(Icons.access_time_rounded, size: 13, color: NMTheme.textMuted),
                const SizedBox(width: 5),
                Text(
                  lecture['time'],
                  style: const TextStyle(fontSize: 12, color: NMTheme.textSecondary, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                const Icon(Icons.event_seat_rounded, size: 13, color: NMTheme.textMuted),
                const SizedBox(width: 5),
                Text(
                  lecture['seats'],
                  style: const TextStyle(fontSize: 11.5, color: NMTheme.textMuted),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  lecture['professor'],
                  style: const TextStyle(fontSize: 12, color: NMTheme.textSecondary),
                ),
                NMWhiteButton(
                  text: 'Register',
                  icon: Icons.app_registration_rounded,
                  textColor: const Color(0xFF7C3AED),
                  radius: 10,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
