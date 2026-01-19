import 'package:flutter/material.dart';
import 'parent_app_drawer.dart';

class ParentPerformanceScreen extends StatefulWidget {
  const ParentPerformanceScreen({super.key});

  @override
  State<ParentPerformanceScreen> createState() =>
      _ParentPerformanceScreenState();
}

class _ParentPerformanceScreenState extends State<ParentPerformanceScreen> {
  final List<Map<String, dynamic>> subjects = [
    {
      'name': 'Physics',
      'icon': Icons.science_outlined,
      'color': const Color(0xFFBA68C8),
      'score': 85,
      'maxScore': 100,
      'rank': 12,
      'averageScore': 78,
      'totalStudents': 150,
      'attendance': 92,
      'topics': [
        {'name': 'Mechanics', 'score': 90, 'maxScore': 100},
        {'name': 'Thermodynamics', 'score': 82, 'maxScore': 100},
        {'name': 'Electromagnetism', 'score': 88, 'maxScore': 100},
        {'name': 'Optics', 'score': 80, 'maxScore': 100},
      ],
      'recentTests': [
        {'name': 'Unit Test 1', 'score': 88, 'maxScore': 100, 'date': '15 Dec'},
        {'name': 'Mid Term', 'score': 85, 'maxScore': 100, 'date': '22 Dec'},
        {'name': 'Quiz 3', 'score': 82, 'maxScore': 100, 'date': '28 Dec'},
      ],
    },
    {
      'name': 'Chemistry',
      'icon': Icons.biotech_outlined,
      'color': const Color(0xFFBA68C8),
      'score': 78,
      'maxScore': 100,
      'rank': 18,
      'averageScore': 75,
      'totalStudents': 150,
      'attendance': 88,
      'topics': [
        {'name': 'Organic Chemistry', 'score': 75, 'maxScore': 100},
        {'name': 'Inorganic Chemistry', 'score': 80, 'maxScore': 100},
        {'name': 'Physical Chemistry', 'score': 78, 'maxScore': 100},
        {'name': 'Analytical Chemistry', 'score': 79, 'maxScore': 100},
      ],
      'recentTests': [
        {'name': 'Unit Test 1', 'score': 76, 'maxScore': 100, 'date': '16 Dec'},
        {'name': 'Mid Term', 'score': 78, 'maxScore': 100, 'date': '23 Dec'},
        {'name': 'Quiz 3', 'score': 80, 'maxScore': 100, 'date': '29 Dec'},
      ],
    },
    {
      'name': 'Mathematics',
      'icon': Icons.calculate_outlined,
      'color': const Color(0xFF66BB6A),
      'score': 92,
      'maxScore': 100,
      'rank': 5,
      'averageScore': 82,
      'totalStudents': 150,
      'attendance': 95,
      'topics': [
        {'name': 'Calculus', 'score': 95, 'maxScore': 100},
        {'name': 'Algebra', 'score': 90, 'maxScore': 100},
        {'name': 'Trigonometry', 'score': 92, 'maxScore': 100},
        {'name': 'Coordinate Geometry', 'score': 91, 'maxScore': 100},
      ],
      'recentTests': [
        {'name': 'Unit Test 1', 'score': 90, 'maxScore': 100, 'date': '14 Dec'},
        {'name': 'Mid Term', 'score': 92, 'maxScore': 100, 'date': '21 Dec'},
        {'name': 'Quiz 3', 'score': 94, 'maxScore': 100, 'date': '27 Dec'},
      ],
    },
  ];

  final List<Map<String, dynamic>> leaderboard = [
    {
      'rank': 1,
      'name': 'Rahul Verma',
      'score': 95,
      'batch': '11th JEE MAINS',
    },
    {
      'rank': 2,
      'name': 'Priya Sharma',
      'score': 93,
      'batch': '11th JEE MAINS',
    },
    {
      'rank': 3,
      'name': 'Amit Kumar',
      'score': 91,
      'batch': '11th JEE MAINS',
    },
    {
      'rank': 4,
      'name': 'Sneha Patel',
      'score': 89,
      'batch': '11th JEE MAINS',
    },
    {
      'rank': 5,
      'name': 'Aarav Sharma',
      'score': 88,
      'batch': '11th JEE MAINS',
      'isCurrentStudent': true,
    },
  ];

  double get overallScore {
    double total = 0;
    for (var subject in subjects) {
      total += (subject['score'] as int).toDouble();
    }
    return total / subjects.length;
  }

  int get overallRank {
    return 8;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const ParentAppDrawer(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Student Performance'),
        elevation: 0,
        backgroundColor: const Color(0xFF7C3AED),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOverallPerformanceCard(),
            const SizedBox(height: 24),
            Text(
              'Subject Performance',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...subjects.map((subject) => _buildSubjectCard(subject)),
            const SizedBox(height: 24),
            Text(
              'Batch Leaderboard',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildLeaderboard(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallPerformanceCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xFF7C3AED), const Color(0xFF8B5CF6)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C3AED).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Overall Performance',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                'Average Score',
                '${overallScore.toStringAsFixed(1)}%',
                Icons.school,
              ),
              Container(
                width: 1,
                height: 50,
                color: Colors.white.withOpacity(0.3),
              ),
              _buildStatItem(
                'Batch Rank',
                '#$overallRank',
                Icons.emoji_events,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectCard(Map<String, dynamic> subject) {
    final percentage = (subject['score'] / subject['maxScore'] * 100).toInt();
    final color = subject['color'] as Color;

    return GestureDetector(
      onTap: () => _showSubjectDetails(subject),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withOpacity(0.4),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                subject['icon'] as IconData,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        subject['name'],
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        '$percentage%',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.emoji_events_outlined,
                          size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        'Rank: #${subject['rank']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.people_outline,
                          size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        'Avg: ${subject['averageScore']}%',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: percentage / 100,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          ...leaderboard.asMap().entries.map((entry) {
            final index = entry.key;
            final student = entry.value;
            final isLast = index == leaderboard.length - 1;
            final isCurrentStudent = student['isCurrentStudent'] == true;

            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isCurrentStudent
                        ? const Color(0xFFF5F3FF)
                        : Colors.transparent,
                    borderRadius: isLast
                        ? const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          )
                        : null,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _getRankColor(student['rank']),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${student['rank']}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  student['name'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: isCurrentStudent
                                        ? const Color(0xFF7C3AED)
                                        : Colors.black87,
                                  ),
                                ),
                                if (isCurrentStudent) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF7C3AED),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      'You',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              student['batch'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${student['score']}%',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isCurrentStudent
                              ? const Color(0xFF7C3AED)
                              : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isLast) Divider(height: 1, color: Colors.grey[300]),
              ],
            );
          }),
        ],
      ),
    );
  }

  Color _getRankColor(int rank) {
    if (rank == 1) return const Color(0xFFFFD700); // Gold
    if (rank == 2) return const Color(0xFFC0C0C0); // Silver
    if (rank == 3) return const Color(0xFFCD7F32); // Bronze
    return const Color(0xFF7C3AED);
  }

  void _showSubjectDetails(Map<String, dynamic> subject) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _SubjectDetailsSheet(subject: subject),
    );
  }
}

class _SubjectDetailsSheet extends StatelessWidget {
  final Map<String, dynamic> subject;

  const _SubjectDetailsSheet({required this.subject});

  @override
  Widget build(BuildContext context) {
    final color = subject['color'] as Color;
    final percentage = (subject['score'] / subject['maxScore'] * 100).toInt();

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color, color.withOpacity(0.7)],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        subject['icon'] as IconData,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subject['name'],
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Detailed Performance Report',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildDetailStat(
                      'Score',
                      '$percentage%',
                      Icons.grade,
                    ),
                    _buildDetailStat(
                      'Rank',
                      '#${subject['rank']}',
                      Icons.emoji_events,
                    ),
                    _buildDetailStat(
                      'Attendance',
                      '${subject['attendance']}%',
                      Icons.calendar_today,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Topic-wise Performance',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  ...((subject['topics'] as List).map((topic) {
                    final topicPercentage =
                        (topic['score'] / topic['maxScore'] * 100).toInt();
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: color.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                topic['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                '$topicPercentage%',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: color,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: topicPercentage / 100,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(color),
                              minHeight: 8,
                            ),
                          ),
                        ],
                      ),
                    );
                  })),
                  const SizedBox(height: 24),
                  Text(
                    'Recent Test Results',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  ...((subject['recentTests'] as List).map((test) {
                    final testPercentage =
                        (test['score'] / test['maxScore'] * 100).toInt();
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                '$testPercentage',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: color,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  test['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${test['score']}/${test['maxScore']} marks',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            test['date'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  })),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ],
    );
  }
}
