import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'teacher_app_drawer.dart';
import 'teacher_doubt_discussion_screen.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_widgets.dart';

class TeacherDoubtsScreen extends StatefulWidget {
  const TeacherDoubtsScreen({super.key});

  @override
  State<TeacherDoubtsScreen> createState() => _TeacherDoubtsScreenState();
}

class _TeacherDoubtsScreenState extends State<TeacherDoubtsScreen> {
  final List<Map<String, dynamic>> _doubts = [
    {
      'id': 1,
      'studentName': 'Rahul Sharma',
      'studentInitials': 'RS',
      'subject': 'Mathematics',
      'topic': 'Quadratic Equations',
      'question': 'How do I solve complex quadratic equations using the discriminant method when roots are imaginary?',
      'status': 'New',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'isResolved': false,
    },
    {
      'id': 2,
      'studentName': 'Priya Verma',
      'studentInitials': 'PV',
      'subject': 'Physics',
      'topic': "Newton's Laws",
      'question': 'Can you clarify why action and reaction pairs never cancel each other out in equilibrium?',
      'status': 'In Progress',
      'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
      'isResolved': false,
    },
    {
      'id': 3,
      'studentName': 'Amit Kumar',
      'studentInitials': 'AK',
      'subject': 'Chemistry',
      'topic': 'Chemical Bonding',
      'question': 'What causes the difference in bond angle between water (104.5°) and ammonia (107°)?',
      'status': 'Resolved',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'isResolved': true,
    },
  ];

  bool _isLoading = false;
  String _selectedFilter = 'All'; // All, New, In Progress, Resolved

  Timer? _pollingTimer;
  static const Duration _pollingInterval = Duration(seconds: 15);

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchDoubts() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(_pollingInterval, (timer) {
      if (mounted && !_isLoading) {
        // silent refresh
      }
    });
  }

  List<Map<String, dynamic>> get _filteredDoubts {
    if (_selectedFilter == 'All') return _doubts;
    return _doubts.where((doubt) => doubt['status'] == _selectedFilter).toList();
  }

  String _getRelativeTime(DateTime timestamp) {
    final difference = DateTime.now().difference(timestamp);
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const TeacherAppDrawer(),
      backgroundColor: NMTheme.bg,
      body: SafeArea(
        child: Column(
          children: [
            NMAppBar(
              title: 'Student Doubts',
              isRoot: true,
              onSearchTap: () {},
              onNotificationTap: () {},
            ),
            _buildFilterPills(),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: NMTheme.primaryPurple))
                  : _filteredDoubts.isEmpty
                      ? _buildEmptyWidget()
                      : RefreshIndicator(
                          onRefresh: _fetchDoubts,
                          color: NMTheme.primaryPurple,
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                            itemCount: _filteredDoubts.length,
                            itemBuilder: (context, index) {
                              return _buildDoubtCard(context, _filteredDoubts[index]);
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPills() {
    final filters = ['All', 'New', 'In Progress', 'Resolved'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: filters.map((filter) {
          final isSelected = _selectedFilter == filter;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = filter),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: isSelected ? NMTheme.primaryPurple : NMTheme.cardBg,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: NMTheme.primaryPurple.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : NMTheme.cardShadows,
                ),
                alignment: Alignment.center,
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected ? Colors.white : NMTheme.textDark,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: NMTheme.surface,
              shape: BoxShape.circle,
              boxShadow: NMTheme.cardShadows,
            ),
            child: const Icon(Icons.check_circle_outline_rounded, size: 54, color: NMTheme.accentTeal),
          ),
          const SizedBox(height: 16),
          Text(
            'No ${_selectedFilter.toLowerCase()} doubts',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: NMTheme.textDark,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'All doubts under this category are cleared.',
            style: TextStyle(color: NMTheme.textSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildDoubtCard(BuildContext context, Map<String, dynamic> doubt) {
    Color statusColor;
    if (doubt['status'] == 'New') {
      statusColor = const Color(0xFFE53935);
    } else if (doubt['status'] == 'Resolved') {
      statusColor = NMTheme.accentTeal;
    } else {
      statusColor = const Color(0xFFFB8C00);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: NMCard(
        padding: const EdgeInsets.all(16),
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            Get.to(() => TeacherDoubtDiscussionScreen(doubt: doubt));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: NMTheme.surface,
                      shape: BoxShape.circle,
                      boxShadow: NMTheme.cardShadows,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      doubt['studentInitials'],
                      style: const TextStyle(
                        color: NMTheme.primaryPurple,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doubt['studentName'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            color: NMTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: NMTheme.primaryPurple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            doubt['subject'],
                            style: const TextStyle(
                              color: NMTheme.primaryPurple,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    _getRelativeTime(doubt['timestamp']),
                    style: const TextStyle(color: NMTheme.textSecondary, fontSize: 11.5, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              NMInsetContainer(
                padding: const EdgeInsets.all(12),
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Topic: ${doubt['topic']}',
                      style: const TextStyle(
                        color: NMTheme.primaryPurple,
                        fontWeight: FontWeight.w700,
                        fontSize: 12.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doubt['question'],
                      style: const TextStyle(color: NMTheme.textDark, height: 1.35, fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      doubt['status'],
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 11.5,
                      ),
                    ),
                  ),
                  Row(
                    children: const [
                      Text(
                        'Open Discussion',
                        style: TextStyle(
                          color: NMTheme.primaryPurple,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_ios_rounded, size: 12, color: NMTheme.primaryPurple),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
