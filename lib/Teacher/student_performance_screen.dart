import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'teacher_app_drawer.dart';

class StudentPerformanceScreen extends StatefulWidget {
  const StudentPerformanceScreen({super.key});

  @override
  State<StudentPerformanceScreen> createState() =>
      _StudentPerformanceScreenState();
}

class _StudentPerformanceScreenState extends State<StudentPerformanceScreen> {
  String _selectedSubject = 'Maths';

  // Sample leaderboard data
  final Map<String, List<Map<String, dynamic>>> _leaderboardData = {
    'Maths': [
      {'rank': 1, 'name': 'Aarav Sharma', 'rollNo': '12345', 'percentage': 95},
      {'rank': 2, 'name': 'Diya Patel', 'rollNo': '67890', 'percentage': 92},
      {'rank': 3, 'name': 'Vihaan Singh', 'rollNo': '24680', 'percentage': 90},
      {
        'rank': 4,
        'name': 'Ananya Reddy',
        'rollNo': '13579',
        'percentage': 88
      },
      {
        'rank': 5,
        'name': 'Ishaan Gupta',
        'rollNo': '97531',
        'percentage': 85
      },
      {
        'rank': 6,
        'name': 'Saanvi Kumar',
        'rollNo': '86420',
        'percentage': 82
      },
      {'rank': 7, 'name': 'Arjun Desai', 'rollNo': '11223', 'percentage': 80},
      {'rank': 8, 'name': 'Myra Iyer', 'rollNo': '77445', 'percentage': 78},
    ],
    'Physics': [
      {
        'rank': 1,
        'name': 'Vihaan Singh',
        'rollNo': '24680',
        'percentage': 94
      },
      {'rank': 2, 'name': 'Aarav Sharma', 'rollNo': '12345', 'percentage': 91},
      {'rank': 3, 'name': 'Diya Patel', 'rollNo': '67890', 'percentage': 89},
      {
        'rank': 4,
        'name': 'Ishaan Gupta',
        'rollNo': '97531',
        'percentage': 86
      },
      {
        'rank': 5,
        'name': 'Ananya Reddy',
        'rollNo': '13579',
        'percentage': 84
      },
    ],
    'Chemistry': [
      {'rank': 1, 'name': 'Diya Patel', 'rollNo': '67890', 'percentage': 96},
      {
        'rank': 2,
        'name': 'Ananya Reddy',
        'rollNo': '13579',
        'percentage': 93
      },
      {'rank': 3, 'name': 'Aarav Sharma', 'rollNo': '12345', 'percentage': 90},
      {
        'rank': 4,
        'name': 'Saanvi Kumar',
        'rollNo': '86420',
        'percentage': 87
      },
      {
        'rank': 5,
        'name': 'Vihaan Singh',
        'rollNo': '24680',
        'percentage': 85
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      drawer: const TeacherAppDrawer(),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () => Get.back(),
        ),
        title: const Text('Student Performance',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 20),
            _buildSubjectFilters(),
            const SizedBox(height: 20),
            _buildLeaderboardList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xFF8B5CF6), const Color(0xFF7C3AED)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C3AED).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Class 12th - JEE Mains',
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                const Text('Top Performers',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_leaderboardData[_selectedSubject]?.length ?? 0} Students',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.leaderboard, color: Colors.white, size: 40),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectFilters() {
    final subjects = ['Maths', 'Physics', 'Chemistry'];
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: subjects.map((subject) {
        final isSelected = _selectedSubject == subject;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedSubject = subject;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF7C3AED) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? const Color(0xFF7C3AED) : Colors.grey[300]!,
                width: 1.5,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xFF7C3AED).withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : [],
            ),
            child: Text(
              subject,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLeaderboardList() {
    final leaderboard = _leaderboardData[_selectedSubject] ?? [];

    if (leaderboard.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Column(
            children: [
              Icon(Icons.people_outline, size: 60, color: Colors.grey),
              SizedBox(height: 16),
              Text('No data available',
                  style: TextStyle(color: Colors.grey, fontSize: 16)),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: leaderboard.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final student = leaderboard[index];
        return _buildRankItem(student);
      },
    );
  }

  Widget _buildRankItem(Map<String, dynamic> student) {
    final int rank = student['rank'];
    final bool isTopThree = rank <= 3;

    Color? rankColor;
    IconData? rankIcon;

    if (rank == 1) {
      rankColor = Colors.amber[600];
      rankIcon = Icons.emoji_events;
    } else if (rank == 2) {
      rankColor = Colors.grey[400];
      rankIcon = Icons.emoji_events;
    } else if (rank == 3) {
      rankColor = Colors.brown[400];
      rankIcon = Icons.emoji_events;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isTopThree
            ? Border.all(color: rankColor!.withOpacity(0.3), width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Rank indicator
          SizedBox(
            width: 36,
            child: isTopThree
                ? Icon(rankIcon, color: rankColor, size: 32)
                : Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        rank.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 16),
          // Student info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.badge_outlined,
                        size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      'Roll No: ${student['rollNo']}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Percentage
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFF8B5CF6), const Color(0xFF7C3AED)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${student['percentage']}%',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
