import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'teacher_app_drawer.dart';
import 'teacher_doubt_discussion_screen.dart';

class TeacherDoubtsScreen extends StatefulWidget {
  const TeacherDoubtsScreen({super.key});

  @override
  State<TeacherDoubtsScreen> createState() => _TeacherDoubtsScreenState();
}

class _TeacherDoubtsScreenState extends State<TeacherDoubtsScreen> {
  // Sample data - Replace with API data
  List<Map<String, dynamic>> _doubts = [
    {
      'id': 1,
      'studentName': 'Rahul Sharma',
      'studentInitials': 'RS',
      'subject': 'Mathematics',
      'topic': 'Quadratic Equations',
      'question': 'How do I solve complex quadratic equations using the discriminant method?',
      'status': 'New',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'isResolved': false,
    },
    {
      'id': 2,
      'studentName': 'Priya Verma',
      'studentInitials': 'PV',
      'subject': 'Physics',
      'topic': 'Newton\'s Laws',
      'question': 'Can you explain the difference between Newton\'s second and third law?',
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
      'question': 'What is the difference between ionic and covalent bonds?',
      'status': 'Resolved',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'isResolved': true,
    },
  ];

  bool _isLoading = false;
  String? _errorMessage;
  String _selectedFilter = 'All'; // All, New, In Progress, Resolved

  // Real-time polling
  Timer? _pollingTimer;
  static const Duration _pollingInterval = Duration(seconds: 5);

  @override
  void initState() {
    super.initState();
    _fetchDoubts();
    _startPolling();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchDoubts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(_pollingInterval, (timer) {
      if (mounted && !_isLoading) {
        _refreshDoubts();
      }
    });
  }

  Future<void> _refreshDoubts() async {
    // Silent refresh - no loading indicator
    await Future.delayed(const Duration(milliseconds: 500));
    print('🔄 Doubts refreshed');
  }

  List<Map<String, dynamic>> get _filteredDoubts {
    if (_selectedFilter == 'All') return _doubts;
    return _doubts.where((doubt) {
      switch (_selectedFilter) {
        case 'New':
          return doubt['status'] == 'New';
        case 'In Progress':
          return doubt['status'] == 'In Progress';
        case 'Resolved':
          return doubt['status'] == 'Resolved';
        default:
          return true;
      }
    }).toList();
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
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text(
          'Student Doubts',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black54),
            onPressed: _fetchDoubts,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _buildErrorWidget()
              : Column(
                  children: [
                    _buildFilterChips(),
                    Expanded(
                      child: _filteredDoubts.isEmpty
                          ? _buildEmptyWidget()
                          : RefreshIndicator(
                              onRefresh: _fetchDoubts,
                              child: ListView.builder(
                                padding: const EdgeInsets.all(16.0),
                                itemCount: _filteredDoubts.length,
                                itemBuilder: (context, index) {
                                  return _buildDoubtCard(
                                      context, _filteredDoubts[index]);
                                },
                              ),
                            ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'New', 'In Progress', 'Resolved'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((filter) {
            final isSelected = _selectedFilter == filter;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(filter),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedFilter = filter;
                  });
                },
                backgroundColor: Colors.white,
                selectedColor: const Color(0xFF7C3AED),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                side: BorderSide(
                  color: isSelected ? const Color(0xFF7C3AED) : Colors.grey.shade300,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Failed to load doubts',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Unknown error',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _fetchDoubts,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No ${_selectedFilter.toLowerCase()} doubts',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _selectedFilter == 'All'
                ? 'No student doubts assigned yet'
                : 'Try selecting a different filter',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildDoubtCard(BuildContext context, Map<String, dynamic> doubt) {
    Color statusColor;
    Color statusBgColor;

    if (doubt['status'] == 'New') {
      statusColor = Colors.green;
      statusBgColor = Colors.green.shade50;
    } else if (doubt['status'] == 'Resolved') {
      statusColor = Colors.grey;
      statusBgColor = Colors.grey.shade200;
    } else {
      statusColor = Colors.orange;
      statusBgColor = Colors.orange.shade50;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Get.to(() => TeacherDoubtDiscussionScreen(doubt: doubt));
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFF7C3AED),
                    child: Text(
                      doubt['studentInitials'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F3FF),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            doubt['subject'],
                            style: TextStyle(
                              color: const Color(0xFF6D28D9),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    _getRelativeTime(doubt['timestamp']),
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(left: 52.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Topic: ${doubt['topic']}',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doubt['question'],
                      style: TextStyle(color: Colors.grey[700], height: 1.4),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusBgColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            doubt['status'],
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        if (doubt['status'] == 'New') ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.circle, size: 8, color: Colors.red),
                                const SizedBox(width: 4),
                                Text(
                                  'Needs Response',
                                  style: TextStyle(
                                    color: Colors.red.shade700,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
