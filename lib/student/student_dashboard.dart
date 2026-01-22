import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_drawer.dart';
import 'notification_screen.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  final Map<String, String> studentData = const {
    'name': 'Aditya Mishra',
    'batch': '11th JEE MAINS',
    'center': 'Kota Main Center',
    'branch': 'Science',
    'studentId': '202400123',
  };

  final List<Map<String, dynamic>> _todaySessions = [
    {
      'title': 'Complete Calculus Revision',
      'subtitle': 'Live with your mentor',
      'duration': '45 min',
      'rating': 4.8,
    },
    {
      'title': 'Physics: Laws of Motion',
      'subtitle': 'Practice problem solving',
      'duration': '60 min',
      'rating': 4.6,
    },
    {
      'title': 'Chemistry: Organic Basics',
      'subtitle': 'Quick concept recap',
      'duration': '40 min',
      'rating': 4.7,
    },
  ];

  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'Live classes',
      'icon': Icons.play_circle_outline,
      'color': const Color(0xFF8B5CF6),
      'route': '/doubt-lecture',
    },
    {
      'name': 'Assignments',
      'icon': Icons.assignment_outlined,
      'color': const Color(0xFF26A69A),
      'route': '/assignments',
    },
    {
      'name': 'Tests',
      'icon': Icons.quiz_outlined,
      'color': const Color(0xFF66BB6A),
      'route': '/test-portal',
    },
    {
      'name': 'Doubts',
      'icon': Icons.help_outline,
      'color': const Color(0xFFFFB74D),
      'route': '/doubts',
    },
  ];

  late final PageController _sessionPageController;
  int _currentSessionIndex = 0;
  bool _isProfileExpanded = false;

  @override
  void initState() {
    super.initState();
    _sessionPageController = PageController(viewportFraction: 0.9);
  }

  @override
  void dispose() {
    _sessionPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildProfileCard(context),
                    const SizedBox(height: 20),
                    _buildSearchBar(context),
                    const SizedBox(height: 24),
                    _buildHighlightCard(context),
                    const SizedBox(height: 24),
                    _buildSectionHeader(
                      context,
                      'Your Today Session',
                      onSeeMore: () => Get.toNamed('/timetable'),
                    ),
                    const SizedBox(height: 12),
                    _buildTodaySessionList(context),
                    const SizedBox(height: 24),
                    _buildSectionHeader(
                      context,
                      'Categories',
                      onSeeMore: () => Get.toNamed('/courses'),
                    ),
                    const SizedBox(height: 12),
                    _buildCategoryList(context),
                    const SizedBox(height: 24),
                    _buildSectionHeader(context, 'Quick actions'),
                    const SizedBox(height: 12),
                    _buildQuickActionsGrid(context),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF7C3AED),
            Color(0xFF8B5CF6),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => Scaffold.of(context).openDrawer(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.menu,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(
                'EduMunch',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            GestureDetector(
              onTap: () => Get.to(() => const NotificationScreen()),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isProfileExpanded = !_isProfileExpanded;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF4CAF50),
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/profile.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        studentData['name']!,
                        style:
                            Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        studentData['batch']!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        'ID: ${studentData['studentId']}',
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(
                              color: const Color(0xFF4CAF50),
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  _isProfileExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.grey,
                ),
              ],
            ),
            if (_isProfileExpanded) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),
              _buildDetailRow(context, 'Name', studentData['name']!),
              _buildDetailRow(context, 'Batch', studentData['batch']!),
              _buildDetailRow(context, 'Center', studentData['center']!),
              _buildDetailRow(context, 'Branch', studentData['branch']!),
              _buildDetailRow(
                  context, 'Student ID', studentData['studentId']!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          Text(
            ': ',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed('/courses'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(
              'Search courses, tests, doubts...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlightCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Live',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Complete Calculus Revision',
                  style:
                      Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                ),
                const SizedBox(height: 4),
                Text(
                  'With your mentor · Today 7:00 PM',
                  style:
                      Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.timer_outlined,
                        color: Colors.white, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      '45 min',
                      style:
                          Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.white,
                              ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Get.toNamed('/doubt-lecture');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF7C3AED),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Join now',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white.withOpacity(0.15),
            ),
            child: const Icon(
              Icons.menu_book_outlined,
              color: Colors.white,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title,
      {VoidCallback? onSeeMore}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        if (onSeeMore != null)
          GestureDetector(
            onTap: onSeeMore,
            child: Text(
              'See more',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF7C3AED),
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
      ],
    );
  }

  Widget _buildTodaySessionList(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 170,
          child: PageView.builder(
            controller: _sessionPageController,
            itemCount: _todaySessions.length,
            onPageChanged: (index) {
              setState(() {
                _currentSessionIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final session = _todaySessions[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () {
                    Get.snackbar(
                      'Session selected',
                      session['title'] as String,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          session['title'] as String,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          session['subtitle'] as String,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                size: 16, color: Color(0xFFFFB300)),
                            const SizedBox(width: 4),
                            Text(
                              (session['rating'] as double)
                                  .toStringAsFixed(1),
                              style:
                                  Theme.of(context).textTheme.bodySmall,
                            ),
                            const Spacer(),
                            const Icon(Icons.timer_outlined,
                                size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              session['duration'] as String,
                              style:
                                  Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_todaySessions.length, (index) {
            final bool isActive = index == _currentSessionIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 6,
              width: isActive ? 18 : 8,
              decoration: BoxDecoration(
                color:
                    isActive ? const Color(0xFF7C3AED) : Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCategoryList(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final Color color = category['color'] as Color;
          return GestureDetector(
            onTap: () {
              final route = category['route'] as String?;
              if (route != null) {
                Get.toNamed(route);
              }
            },
            child: Container(
              width: 130,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withOpacity(0.85),
                    color.withOpacity(0.65),
                  ],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      category['icon'] as IconData,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    category['name'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context) {
    final quickActions = [
      {
        'icon': Icons.schedule_outlined,
        'label': 'Timetable',
        'route': '/timetable',
      },
      {
        'icon': Icons.emoji_events_outlined,
        'label': 'Results',
        'route': '/result',
      },
      {
        'icon': Icons.feedback_outlined,
        'label': 'Feedback',
        'route': '/feedback',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemCount: quickActions.length,
      itemBuilder: (context, index) {
        final item = quickActions[index];
        return GestureDetector(
          onTap: () {
            final route = item['route'] as String?;
            if (route != null) {
              Get.toNamed(route);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF3E8FF),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    color: const Color(0xFF7C3AED),
                    size: 22,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  item['label'] as String,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
