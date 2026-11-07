import 'package:flutter/material.dart';
import 'app_drawer.dart';
import 'package:get/get.dart';
import '../auth_controller.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_widgets.dart';

class SubjectPerformance {
  final String name;
  final double percentage;
  final String grade;
  final int rank;
  final int totalMarks;
  final int obtainedMarks;
  final int totalStudents;
  final List<String> topicsPerformed;
  final List<String> topicsToImprove;

  SubjectPerformance({
    required this.name,
    required this.percentage,
    required this.grade,
    required this.rank,
    required this.totalMarks,
    required this.obtainedMarks,
    required this.totalStudents,
    required this.topicsPerformed,
    required this.topicsToImprove,
  });
}

class LeaderboardEntry {
  final String name;
  final int rank;
  final double percentage;
  final String subject;
  final bool isCurrentUser;

  LeaderboardEntry({
    required this.name,
    required this.rank,
    required this.percentage,
    required this.subject,
    required this.isCurrentUser,
  });
}

class AcademicPerformanceScreen extends StatefulWidget {
  const AcademicPerformanceScreen({super.key});

  @override
  State<AcademicPerformanceScreen> createState() =>
      _AcademicPerformanceScreenState();
}

class _AcademicPerformanceScreenState extends State<AcademicPerformanceScreen> {
  late List<SubjectPerformance> subjectPerformances;
  late List<LeaderboardEntry> leaderboard;
  String selectedSubject = 'Physics';

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    String currentUserName = 'You';
    try {
      final authController = Get.find<AuthController>();
      final email = authController.email;
      if (email != null && email.isNotEmpty) {
        final part = email.split('@').first;
        currentUserName = part
            .split('.')
            .map((w) =>
                w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
            .join(' ');
      }
    } catch (_) {}
    subjectPerformances = [
      SubjectPerformance(
        name: 'Physics',
        percentage: 85,
        grade: 'A',
        rank: 3,
        totalMarks: 100,
        obtainedMarks: 85,
        totalStudents: 45,
        topicsPerformed: ['Mechanics', 'Electromagnetism', 'Thermodynamics'],
        topicsToImprove: ['Optics', 'Modern Physics'],
      ),
      SubjectPerformance(
        name: 'Chemistry',
        percentage: 92,
        grade: 'A+',
        rank: 1,
        totalMarks: 100,
        obtainedMarks: 92,
        totalStudents: 45,
        topicsPerformed: ['Organic Chemistry', 'Inorganic Chemistry', 'Physical Chemistry'],
        topicsToImprove: [],
      ),
      SubjectPerformance(
        name: 'Math',
        percentage: 78,
        grade: 'B+',
        rank: 8,
        totalMarks: 100,
        obtainedMarks: 78,
        totalStudents: 45,
        topicsPerformed: ['Algebra', 'Geometry'],
        topicsToImprove: ['Calculus', 'Trigonometry'],
      ),
    ];

    leaderboard = [
      LeaderboardEntry(
        name: 'Olivia Chen',
        rank: 1,
        percentage: 95,
        subject: 'Physics',
        isCurrentUser: false,
      ),
      LeaderboardEntry(
        name: 'Liam Taylor',
        rank: 2,
        percentage: 90,
        subject: 'Physics',
        isCurrentUser: false,
      ),
      LeaderboardEntry(
        name: '$currentUserName (You)',
        rank: 3,
        percentage: 85,
        subject: 'Physics',
        isCurrentUser: true,
      ),
    ];
  }

  void _showSubjectDetails(SubjectPerformance subject) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildDetailedResultBottomSheet(subject),
    );
  }

  Widget _buildDetailedResultBottomSheet(SubjectPerformance subject) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        color: Colors.white,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${subject.name} Performance',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Scores Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [const Color(0xFF8B5CF6), const Color(0xFF7C3AED)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildScoreItem('Obtained Marks', subject.obtainedMarks.toString(), Colors.white),
                        Container(
                          width: 2,
                          height: 60,
                          color: Colors.white.withOpacity(0.3),
                        ),
                        _buildScoreItem('Total Marks', subject.totalMarks.toString(), Colors.white),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Grade and Rank
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildBadge(
                          'Grade',
                          subject.grade,
                          Colors.amber,
                          Colors.white,
                        ),
                        _buildBadge(
                          'Class Rank',
                          '${subject.rank}/${subject.totalStudents}',
                          Colors.green,
                          Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Performance Overview
              Text(
                'Performance Overview',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _buildProgressBar('Overall Score', subject.percentage),
              const SizedBox(height: 20),

              // Topics Performed Well
              if (subject.topicsPerformed.isNotEmpty) ...[
                Text(
                  'Topics You\'ve Performed Well In',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: subject.topicsPerformed.map((topic) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        border: Border.all(color: Colors.green[300]!),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle, color: Colors.green[600], size: 18),
                          const SizedBox(width: 6),
                          Text(
                            topic,
                            style: TextStyle(
                              color: Colors.green[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
              ],

              // Topics to Improve
              if (subject.topicsToImprove.isNotEmpty) ...[
                Text(
                  'Topics to Improve',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: subject.topicsToImprove.map((topic) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        border: Border.all(color: Colors.orange[300]!),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.warning_amber, color: Colors.orange[600], size: 18),
                          const SizedBox(width: 6),
                          Text(
                            topic,
                            style: TextStyle(
                              color: Colors.orange[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
              ],

              // Action Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  label: const Text('Close'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C3AED),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: color.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(String label, String value, Color bgColor, Color textColor) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white.withOpacity(0.8),
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: bgColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: bgColor),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(String label, double percentage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            Text(
              '${percentage.toStringAsFixed(0)}%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF7C3AED),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: percentage / 100,
            minHeight: 10,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF7C3AED)),
          ),
        ),
      ],
    );
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
              title: 'Results',
              isRoot: false,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Student Info Card
                    NMCard(
                      radius: 22,
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: NMTheme.raisedShadow(offset: 2, blur: 4),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/profile.png',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.person, color: NMTheme.textSecondary),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Aditya Mishra',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: NMTheme.textPrimary,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  '11th JEE MAINS · ID: 202400123',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    color: NMTheme.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Monthly Subject-Wise Performance
                    const NMSectionHeader(title: 'Subject-Wise Performance'),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: subjectPerformances.map((subject) {
                          return GestureDetector(
                            onTap: () => _showSubjectDetails(subject),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 14),
                              child: NMCard(
                                radius: 20,
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: NMTheme.insetDecoration(radius: 14),
                                      alignment: Alignment.center,
                                      child: Text(
                                        '${subject.percentage.toInt()}%',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 14,
                                          color: NMTheme.primaryPurple,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      subject.name,
                                      style: const TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.bold,
                                        color: NMTheme.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      'Grade ${subject.grade}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF10B981),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 26),

                    // Class Leaderboard
                    const NMSectionHeader(title: 'Class Leaderboard'),
                    const SizedBox(height: 12),

                    // Leaderboard Tabs
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: ['Physics', 'Chemistry', 'Math'].map((subject) {
                          final isSelected = selectedSubject == subject;
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedSubject = subject;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected ? NMTheme.surface : NMTheme.cardBg,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected ? const Color(0xFF7C3AED) : Colors.white.withOpacity(0.8),
                                    width: isSelected ? 1.5 : 1,
                                  ),
                                  boxShadow: isSelected
                                      ? NMTheme.raisedShadow(offset: 2, blur: 4)
                                      : NMTheme.raisedShadow(offset: 3, blur: 6),
                                ),
                                child: Text(
                                  subject,
                                  style: TextStyle(
                                    color: isSelected ? const Color(0xFF7C3AED) : NMTheme.textSecondary,
                                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                    fontSize: 12.5,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Leaderboard List
                    Column(
                      children: leaderboard.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: NMCard(
                            radius: 18,
                            padding: const EdgeInsets.all(14),
                            border: entry.isCurrentUser
                                ? Border.all(color: const Color(0xFF7C3AED), width: 1.5)
                                : null,
                            child: Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: entry.rank == 1
                                        ? const Color(0xFFD97706)
                                        : (entry.rank == 2 ? const Color(0xFF64748B) : const Color(0xFF7C3AED)),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    entry.rank.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        entry.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: entry.isCurrentUser ? const Color(0xFF7C3AED) : NMTheme.textPrimary,
                                        ),
                                      ),
                                      Text(
                                        entry.subject,
                                        style: const TextStyle(
                                          fontSize: 11.5,
                                          color: NMTheme.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                NMWhitePillBadge(
                                  text: '${entry.percentage.toStringAsFixed(0)}%',
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectCircle(SubjectPerformance subject) {
    final color = subject.percentage >= 90
        ? Colors.green
        : subject.percentage >= 80
            ? const Color(0xFF7C3AED)
            : subject.percentage >= 70
                ? Colors.orange
                : Colors.red;

    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.1),
            border: Border.all(color: color, width: 3),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${subject.percentage.toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: color,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subject.grade,
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          subject.name,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          'Rank: ${subject.rank}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
