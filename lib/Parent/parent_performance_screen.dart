import 'package:flutter/material.dart';
import 'parent_app_drawer.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_widgets.dart';

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
      'color': NMTheme.accentTeal,
      'score': 85,
      'maxScore': 100,
      'rank': 12,
      'averageScore': 78,
      'attendance': 92,
      'topics': [
        {'name': 'Mechanics', 'score': 90},
        {'name': 'Thermodynamics', 'score': 82},
        {'name': 'Electromagnetism', 'score': 88},
        {'name': 'Optics', 'score': 80},
      ],
    },
    {
      'name': 'Chemistry',
      'icon': Icons.biotech_outlined,
      'color': NMTheme.primaryPurple,
      'score': 78,
      'maxScore': 100,
      'rank': 18,
      'averageScore': 75,
      'attendance': 88,
      'topics': [
        {'name': 'Organic Chemistry', 'score': 75},
        {'name': 'Inorganic Chemistry', 'score': 80},
        {'name': 'Physical Chemistry', 'score': 78},
      ],
    },
    {
      'name': 'Mathematics',
      'icon': Icons.functions_rounded,
      'color': NMTheme.accentOcean,
      'score': 95,
      'maxScore': 100,
      'rank': 3,
      'averageScore': 82,
      'attendance': 96,
      'topics': [
        {'name': 'Calculus', 'score': 98},
        {'name': 'Algebra', 'score': 94},
        {'name': 'Trigonometry', 'score': 92},
      ],
    },
  ];

  final List<Map<String, dynamic>> leaderboard = [
    {'rank': 1, 'name': 'Rahul Verma', 'score': 96, 'isCurrent': false},
    {'rank': 2, 'name': 'Priya Sharma', 'score': 94, 'isCurrent': false},
    {'rank': 3, 'name': 'Aditya Mishra', 'score': 92, 'isCurrent': true},
    {'rank': 4, 'name': 'Amit Kumar', 'score': 90, 'isCurrent': false},
    {'rank': 5, 'name': 'Sneha Patel', 'score': 88, 'isCurrent': false},
  ];

  double get overallScore {
    double total = 0;
    for (var s in subjects) {
      total += (s['score'] as int).toDouble();
    }
    return total / subjects.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const ParentAppDrawer(),
      backgroundColor: NMTheme.bg,
      body: SafeArea(
        child: Column(
          children: [
            NMAppBar(
              title: 'Child Performance',
              isRoot: true,
              onSearchTap: () {},
              onNotificationTap: () {},
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOverviewBanner(),
                    const SizedBox(height: 24),
                    const Text(
                      'Subject-wise Analytics',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: NMTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...subjects.map((sub) => _buildSubjectCard(sub)),
                    const SizedBox(height: 24),
                    const Text(
                      'Batch Leaderboard',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: NMTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildLeaderboardCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: NMTheme.primaryGradient,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: NMTheme.primaryPurple.withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cumulative Academic Average',
                  style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  '${overallScore.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Rank #3 in 11th JEE Mains',
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.insights_rounded, color: Colors.white, size: 36),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectCard(Map<String, dynamic> subject) {
    final Color color = subject['color'];
    final int score = subject['score'];
    final List topics = subject['topics'] ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: NMCard(
        padding: const EdgeInsets.all(16),
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(subject['icon'], color: color, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subject['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: NMTheme.textDark,
                        ),
                      ),
                      Text(
                        'Class Rank: #${subject['rank']} • Avg: ${subject['averageScore']}%',
                        style: const TextStyle(color: NMTheme.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Text(
                  '$score%',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            NMInsetContainer(
              height: 8,
              borderRadius: BorderRadius.circular(4),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: score / 100.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: topics.map((t) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: NMTheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: NMTheme.cardShadows,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        t['name'],
                        style: const TextStyle(fontSize: 11.5, color: NMTheme.textDark, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${t['score']}%',
                        style: TextStyle(fontSize: 11.5, color: color, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardCard() {
    return NMCard(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(20),
      child: Column(
        children: leaderboard.map((item) {
          final bool isChild = item['isCurrent'] == true;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isChild ? NMTheme.accentTeal.withOpacity(0.12) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isChild ? Border.all(color: NMTheme.accentTeal.withOpacity(0.3)) : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: item['rank'] == 1
                        ? const Color(0xFFFFB300)
                        : item['rank'] == 2
                            ? const Color(0xFF9E9E9E)
                            : item['rank'] == 3
                                ? NMTheme.accentTeal
                                : NMTheme.surface,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '#${item['rank']}',
                    style: TextStyle(
                      color: item['rank'] <= 3 ? Colors.white : NMTheme.textDark,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        item['name'],
                        style: TextStyle(
                          fontWeight: isChild ? FontWeight.w800 : FontWeight.w600,
                          fontSize: 14,
                          color: isChild ? NMTheme.accentTeal : NMTheme.textDark,
                        ),
                      ),
                      if (isChild) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: NMTheme.accentTeal,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text('Your Child', style: TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ],
                  ),
                ),
                Text(
                  '${item['score']}%',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14.5,
                    color: isChild ? NMTheme.accentTeal : NMTheme.textDark,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
