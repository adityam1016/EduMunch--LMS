import 'package:flutter/material.dart';
import 'app_drawer.dart';

class DoubtLectureScreen extends StatefulWidget {
  const DoubtLectureScreen({super.key});

  @override
  State<DoubtLectureScreen> createState() => _DoubtLectureScreenState();
}

class _DoubtLectureScreenState extends State<DoubtLectureScreen> {
  int selectedTabIndex = 0;

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
      backgroundColor: Colors.white,
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Builder(
                    builder: (context) => GestureDetector(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.menu,
                          color: Color(0xFF5B21B6),
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Doubt Lectures',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5B21B6),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Tab Selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTabIndex = 0;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: selectedTabIndex == 0
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Doubt Lectures',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: selectedTabIndex == 0
                                  ? const Color(0xFFEF5350)
                                  : Colors.grey[600],
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
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: selectedTabIndex == 1
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Extra Lectures',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: selectedTabIndex == 1
                                  ? const Color(0xFFEF5350)
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Content
            if (selectedTabIndex == 0) ...[
              Expanded(
                child: SingleChildScrollView(
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
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: extraLectures.map((lecture) {
                      return _buildExtraLectureCard(lecture);
                    }).toList(),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDoubtLectureCard(Map<String, dynamic> lecture) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Subject and Status
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lecture['subject'],
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(lecture['status']).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  lecture['status'],
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(lecture['status']),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Topic
          Text(
            lecture['topic'],
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),

          // Mode Badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: _getModeColor(lecture['mode']).withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getModeIcon(lecture['mode']),
                  size: 12,
                  color: _getModeColor(lecture['mode']),
                ),
                const SizedBox(width: 6),
                Text(
                  lecture['mode'],
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: _getModeColor(lecture['mode']),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Date and Time
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 14,
                color: Colors.grey[500],
              ),
              const SizedBox(width: 6),
              Text(
                lecture['date'],
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.access_time,
                size: 14,
                color: Colors.grey[500],
              ),
              const SizedBox(width: 6),
              Text(
                lecture['time'],
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Professor and Students
          Row(
            children: [
              Icon(
                Icons.person,
                size: 14,
                color: Colors.grey[500],
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  lecture['professor'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              Icon(
                Icons.people,
                size: 14,
                color: Colors.grey[500],
              ),
              const SizedBox(width: 6),
              Text(
                '${lecture['students']} students',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          if (lecture['mode'] != 'Offline')
            const SizedBox(height: 12),
          if (lecture['mode'] != 'Offline')
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Joining: ${lecture['topic']}'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF5350),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Join Now',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildExtraLectureCard(Map<String, dynamic> lecture) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Subject and Status
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lecture['subject'],
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getDifficultyColor(lecture['difficulty']).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  lecture['difficulty'],
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: _getDifficultyColor(lecture['difficulty']),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Topic
          Text(
            lecture['topic'],
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),

          // Date and Time
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 14,
                color: Colors.grey[500],
              ),
              const SizedBox(width: 6),
              Text(
                lecture['date'],
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.access_time,
                size: 14,
                color: Colors.grey[500],
              ),
              const SizedBox(width: 6),
              Text(
                lecture['time'],
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Professor and Seats
          Row(
            children: [
              Icon(
                Icons.person,
                size: 14,
                color: Colors.grey[500],
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  lecture['professor'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              Icon(
                Icons.event_seat,
                size: 14,
                color: Colors.grey[500],
              ),
              const SizedBox(width: 6),
              Text(
                lecture['seats'],
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6).withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              lecture['status'],
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8B5CF6),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
