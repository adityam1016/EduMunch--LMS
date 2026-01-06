import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        name: 'Ethan Carter (You)',
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
                    colors: [Colors.blue[400]!, Colors.blue[700]!],
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
                    backgroundColor: Colors.blue[600],
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
                color: Colors.blue[600],
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
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[600]!),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Academic Performance',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue[600]!,
                Colors.blue[800]!,
              ],
            ),
          ),
        ),
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Student Info Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue[600],
                      ),
                      child: const Center(
                        child: Icon(Icons.person, color: Colors.white, size: 32),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ethan Carter',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Class 12, Section A',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
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
              Text(
                'Monthly Subject-Wise Performance',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: subjectPerformances.map((subject) {
                    return GestureDetector(
                      onTap: () => _showSubjectDetails(subject),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: _buildSubjectCircle(subject),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 32),

              // Class Leaderboard
              Text(
                'Class Leaderboard',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              // Leaderboard Tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['Physics', 'Chemistry', 'Math'].map((subject) {
                    final isSelected = selectedSubject == subject;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedSubject = subject;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blue[600] : Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            subject,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.grey[700],
                              fontWeight: FontWeight.w600,
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
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: entry.isCurrentUser ? Colors.blue[50] : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: entry.isCurrentUser ? Colors.blue[300]! : Colors.grey[300]!,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.amber[600],
                          ),
                          child: Center(
                            child: Text(
                              entry.rank.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.name,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                entry.subject,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: entry.isCurrentUser ? Colors.blue[600] : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${entry.percentage.toStringAsFixed(0)}%',
                            style: TextStyle(
                              color: entry.isCurrentUser ? Colors.white : Colors.grey[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
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
            ? Colors.blue
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
