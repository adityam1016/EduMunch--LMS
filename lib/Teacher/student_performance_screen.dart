import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'teacher_app_drawer.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_widgets.dart';

class StudentPerformanceScreen extends StatefulWidget {
  const StudentPerformanceScreen({super.key});

  @override
  State<StudentPerformanceScreen> createState() =>
      _StudentPerformanceScreenState();
}

class _StudentPerformanceScreenState extends State<StudentPerformanceScreen> {
  String _selectedSubject = 'Maths';

  final Map<String, List<Map<String, dynamic>>> _leaderboardData = {
    'Maths': [
      {'rank': 1, 'name': 'Aarav Sharma', 'rollNo': '2024001', 'percentage': 95},
      {'rank': 2, 'name': 'Diya Patel', 'rollNo': '2024002', 'percentage': 92},
      {'rank': 3, 'name': 'Vihaan Singh', 'rollNo': '2024003', 'percentage': 90},
      {'rank': 4, 'name': 'Ananya Reddy', 'rollNo': '2024004', 'percentage': 88},
      {'rank': 5, 'name': 'Ishaan Gupta', 'rollNo': '2024005', 'percentage': 85},
      {'rank': 6, 'name': 'Saanvi Kumar', 'rollNo': '2024006', 'percentage': 82},
      {'rank': 7, 'name': 'Arjun Desai', 'rollNo': '2024007', 'percentage': 80},
    ],
    'Physics': [
      {'rank': 1, 'name': 'Vihaan Singh', 'rollNo': '2024003', 'percentage': 94},
      {'rank': 2, 'name': 'Aarav Sharma', 'rollNo': '2024001', 'percentage': 91},
      {'rank': 3, 'name': 'Diya Patel', 'rollNo': '2024002', 'percentage': 89},
      {'rank': 4, 'name': 'Ishaan Gupta', 'rollNo': '2024005', 'percentage': 86},
      {'rank': 5, 'name': 'Ananya Reddy', 'rollNo': '2024004', 'percentage': 84},
    ],
    'Chemistry': [
      {'rank': 1, 'name': 'Diya Patel', 'rollNo': '2024002', 'percentage': 96},
      {'rank': 2, 'name': 'Ananya Reddy', 'rollNo': '2024004', 'percentage': 93},
      {'rank': 3, 'name': 'Aarav Sharma', 'rollNo': '2024001', 'percentage': 90},
      {'rank': 4, 'name': 'Saanvi Kumar', 'rollNo': '2024006', 'percentage': 87},
      {'rank': 5, 'name': 'Vihaan Singh', 'rollNo': '2024003', 'percentage': 85},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NMTheme.bg,
      drawer: const TeacherAppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            NMAppBar(
              title: 'Leaderboard',
              isRoot: false,
              onLeadingTap: () => Get.back(),
              onSearchTap: () {},
              onNotificationTap: () {},
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  children: [
                    _buildHeaderCard(),
                    const SizedBox(height: 18),
                    _buildSubjectFilters(),
                    const SizedBox(height: 18),
                    _buildLeaderboardList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
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
                  'Class 11th • JEE Mains',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Top Performers',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_leaderboardData[_selectedSubject]?.length ?? 0} Students Ranked',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                    ),
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
            child: const Icon(Icons.emoji_events_rounded, color: Colors.amberAccent, size: 38),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectFilters() {
    final subjects = ['Maths', 'Physics', 'Chemistry'];

    return Row(
      children: subjects.map((subject) {
        final isSelected = _selectedSubject == subject;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedSubject = subject),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 11),
              decoration: BoxDecoration(
                color: isSelected ? NMTheme.primaryPurple : NMTheme.cardBg,
                borderRadius: BorderRadius.circular(14),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: NMTheme.primaryPurple.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : NMTheme.cardShadows,
              ),
              alignment: Alignment.center,
              child: Text(
                subject,
                style: TextStyle(
                  color: isSelected ? Colors.white : NMTheme.textDark,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLeaderboardList() {
    final leaderboard = _leaderboardData[_selectedSubject] ?? [];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: leaderboard.length,
      itemBuilder: (context, index) {
        final student = leaderboard[index];
        return _buildRankItem(student);
      },
    );
  }

  Widget _buildRankItem(Map<String, dynamic> student) {
    final int rank = student['rank'];
    final bool isTopThree = rank <= 3;

    Color badgeColor;
    if (rank == 1) {
      badgeColor = const Color(0xFFFFB300);
    } else if (rank == 2) {
      badgeColor = const Color(0xFF9E9E9E);
    } else if (rank == 3) {
      badgeColor = const Color(0xFFCD7F32);
    } else {
      badgeColor = NMTheme.textSecondary;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: NMCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isTopThree ? badgeColor.withOpacity(0.18) : NMTheme.surface,
                shape: BoxShape.circle,
                boxShadow: isTopThree ? null : NMTheme.cardShadows,
              ),
              alignment: Alignment.center,
              child: isTopThree
                  ? Icon(Icons.emoji_events_rounded, color: badgeColor, size: 20)
                  : Text(
                      '#$rank',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        color: NMTheme.textDark,
                      ),
                    ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14.5,
                      color: NMTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Roll No: ${student['rollNo']}',
                    style: const TextStyle(
                      color: NMTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 6),
                  NMInsetContainer(
                    height: 6,
                    borderRadius: BorderRadius.circular(3),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: student['percentage'] / 100.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: isTopThree ? NMTheme.accentTeal : NMTheme.accentOcean,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${student['percentage']}%',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: isTopThree ? NMTheme.accentTeal : NMTheme.primaryPurple,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Score',
                  style: TextStyle(fontSize: 11, color: NMTheme.textSecondary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
