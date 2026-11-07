import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'app_drawer.dart';
import '../services/course_service.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_widgets.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  late String _currentScreen; // 'subjects', 'courses', 'details'
  late String _selectedSubject;
  late String _selectedCourse;
  final Map<String, bool> _expandedSections = {};
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _currentScreen = 'subjects';
    _selectedSubject = '';
    _selectedCourse = '';
    _loadCoursesFromSupabase();
  }

  Future<void> _loadCoursesFromSupabase() async {
    final liveCourses = await CourseService.getCourses();
    if (liveCourses.isNotEmpty && mounted) {
      setState(() {
        final Map<String, List<Map<String, dynamic>>> grouped = {};
        final List<Map<String, dynamic>> subjectList = [];
        final Set<String> seenSubjects = {};

        for (final c in liveCourses) {
          if (!seenSubjects.contains(c.subject)) {
            seenSubjects.add(c.subject);
            subjectList.add({
              'name': c.subject,
              'icon': c.icon,
              'color': c.color,
            });
          }
          grouped.putIfAbsent(c.subject, () => []).add({
            'name': c.name,
            'status': c.status,
            'progress': c.progress,
            'statusColor': c.status == 'Completed'
                ? const Color(0xFF10B981)
                : (c.status == 'In Progress' ? const Color(0xFF7C3AED) : NMTheme.textMuted),
          });
        }
        subjects.clear();
        subjects.addAll(subjectList);
        coursesBySubject.clear();
        coursesBySubject.addAll(grouped);
      });
    }
  }

  final List<Map<String, dynamic>> subjects = [
    {'name': 'Physics', 'icon': '⚡', 'color': const Color(0xFF0C6E5A)},
    {'name': 'Chemistry', 'icon': '🧪', 'color': const Color(0xFFD97706)},
    {'name': 'Maths', 'icon': '📊', 'color': const Color(0xFF7C3AED)},
  ];

  final Map<String, List<Map<String, dynamic>>> coursesBySubject = {
    'Physics': [
      {
        'name': 'Kinematics',
        'status': 'In Progress',
        'progress': 0.65,
        'statusColor': const Color(0xFF7C3AED),
      },
      {
        'name': 'Electromagnetism',
        'status': 'Not Started',
        'progress': 0.0,
        'statusColor': NMTheme.textMuted,
      },
    ],
    'Chemistry': [
      {
        'name': 'Organic Chemistry Basics',
        'status': 'Completed',
        'progress': 1.0,
        'statusColor': const Color(0xFF10B981),
      },
      {
        'name': 'Stoichiometry',
        'status': 'In Progress',
        'progress': 0.45,
        'statusColor': const Color(0xFF7C3AED),
      },
    ],
    'Maths': [
      {
        'name': 'Calculus Fundamentals',
        'status': 'Not Started',
        'progress': 0.0,
        'statusColor': NMTheme.textMuted,
      },
      {
        'name': 'Algebra Refresher',
        'status': 'In Progress',
        'progress': 0.8,
        'statusColor': const Color(0xFF7C3AED),
      },
    ],
  };

  final Map<String, Map<String, dynamic>> courseDetails = {
    'Kinematics': {
      'progress': 60,
      'videos': [
        {
          'title': 'Motion in 1D',
          'status': 'Completed',
          'duration': '15:20',
          'youtubeLink': 'https://www.youtube.com/live/hY9zZrYuDVk?si=F2MyJwnAslLg0rII',
        },
        {
          'title': 'Acceleration & Velocity',
          'status': 'In Progress',
          'duration': '18:45',
          'youtubeLink': 'https://www.youtube.com/live/hY9zZrYuDVk?si=F2MyJwnAslLg0rII',
        },
      ],
      'notes': [
        {
          'title': 'Formula Sheet',
          'content': 'v = u + at\ns = ut + ½at²\nv² = u² + 2as',
        },
        {
          'title': 'Important Concepts',
          'content': 'Displacement is the shortest distance between two points. Distance is the total path length.',
        },
      ],
    },
    'Organic Chemistry Basics': {
      'progress': 100,
      'videos': [
        {
          'title': 'Hydrocarbons Overview',
          'status': 'Completed',
          'duration': '22:10',
          'youtubeLink': 'https://www.youtube.com/live/hY9zZrYuDVk?si=F2MyJwnAslLg0rII',
        },
      ],
      'notes': [
        {
          'title': 'IUPAC Nomenclature',
          'content': 'Alkanes end in -ane, Alkenes end in -ene, Alkynes end in -yne.',
        },
      ],
    },
    'Stoichiometry': {
      'progress': 45,
      'videos': [
        {
          'title': 'Balancing Chemical Equations',
          'status': 'In Progress',
          'duration': '13:15',
          'youtubeLink': 'https://www.youtube.com/live/hY9zZrYuDVk?si=F2MyJwnAslLg0rII',
        },
      ],
      'notes': [
        {
          'title': 'Mole Concept',
          'content': 'A mole contains 6.022 × 10²³ particles (Avogadro’s number).',
        },
      ],
    },
    'Calculus Fundamentals': {
      'progress': 0,
      'videos': [
        {
          'title': 'Limits and Continuity',
          'status': 'Not Started',
          'duration': '19:30',
          'youtubeLink': 'https://www.youtube.com/live/hY9zZrYuDVk?si=F2MyJwnAslLg0rII',
        },
      ],
      'notes': [
        {
          'title': 'What is a Limit?',
          'content': 'A limit is the value that a function approaches as input approaches some value.',
        },
      ],
    },
    'Algebra Refresher': {
      'progress': 80,
      'videos': [
        {
          'title': 'Linear Equations',
          'status': 'Completed',
          'duration': '11:45',
          'youtubeLink': 'https://www.youtube.com/live/hY9zZrYuDVk?si=F2MyJwnAslLg0rII',
        },
        {
          'title': 'Quadratic Equations',
          'status': 'In Progress',
          'duration': '17:20',
          'youtubeLink': 'https://www.youtube.com/live/hY9zZrYuDVk?si=F2MyJwnAslLg0rII',
        },
      ],
      'notes': [
        {
          'title': 'Algebraic Identities',
          'content': '(a+b)² = a² + 2ab + b²\n(a-b)² = a² - 2ab + b²\na² - b² = (a+b)(a-b)',
        },
      ],
    },
  };

  @override
  Widget build(BuildContext context) {
    String currentTitle = 'Courses';
    if (_currentScreen == 'courses') currentTitle = _selectedSubject;
    if (_currentScreen == 'details') currentTitle = _selectedCourse;

    return Scaffold(
      backgroundColor: NMTheme.bg,
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            NMAppBar(
              title: currentTitle,
              isRoot: _currentScreen == 'subjects',
              onLeadingTap: _currentScreen != 'subjects'
                  ? () {
                      setState(() {
                        if (_currentScreen == 'details') {
                          _currentScreen = 'courses';
                        } else {
                          _currentScreen = 'subjects';
                        }
                      });
                    }
                  : null,
            ),
            Expanded(
              child: _currentScreen == 'subjects'
                  ? _buildSubjectsScreen()
                  : _currentScreen == 'courses'
                      ? _buildCoursesScreen()
                      : _buildCourseDetailsScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectsScreen() {
    final filtered = subjects.where((s) => s['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase())).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 14),
          NMSearchBar(
            hintText: 'Search subjects, topics...',
            onChanged: (q) => setState(() => _searchQuery = q),
          ),
          const SizedBox(height: 20),
          const NMSectionHeader(title: 'Choose Subject'),
          const SizedBox(height: 12),
          ...filtered.map((subject) {
            final courses = coursesBySubject[subject['name']] ?? [];
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: NMCard(
                radius: 22,
                padding: const EdgeInsets.all(16),
                onTap: () {
                  setState(() {
                    _selectedSubject = subject['name'];
                    _currentScreen = 'courses';
                  });
                },
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: NMTheme.insetDecoration(radius: 16),
                      alignment: Alignment.center,
                      child: Text(
                        subject['icon'],
                        style: const TextStyle(fontSize: 26),
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
                              fontSize: 16.5,
                              fontWeight: FontWeight.bold,
                              color: NMTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${courses.length} courses available',
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: NMTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: NMTheme.textMuted,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildCoursesScreen() {
    final courses = coursesBySubject[_selectedSubject] ?? [];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 14),
          NMSectionHeader(
            title: 'Available Modules',
            seeMoreText: 'Filter',
            onSeeMore: () {},
          ),
          const SizedBox(height: 12),
          ...courses.map((course) {
            final double progress = course['progress'] as double;
            final Color statusColor = course['statusColor'] as Color;

            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: NMCard(
                radius: 22,
                padding: const EdgeInsets.all(16),
                onTap: () {
                  setState(() {
                    _selectedCourse = course['name'];
                    _currentScreen = 'details';
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF7C3AED).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.school_rounded,
                            color: Color(0xFF7C3AED),
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                course['name'],
                                style: const TextStyle(
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.bold,
                                  color: NMTheme.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                course['status'],
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: statusColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: NMTheme.textMuted,
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // Sunken Progress Bar
                    Container(
                      height: 8,
                      decoration: NMTheme.insetDecoration(radius: 6),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: progress.clamp(0.0, 1.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: statusColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${(progress * 100).toInt()}% completed',
                      style: const TextStyle(
                        fontSize: 11,
                        color: NMTheme.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildCourseDetailsScreen() {
    final details = courseDetails[_selectedCourse];
    if (details == null) {
      return Center(
        child: Text(
          'Details not available',
          style: TextStyle(color: NMTheme.textSecondary),
        ),
      );
    }

    final videos = details['videos'] as List<Map<String, dynamic>>;
    final notes = details['notes'] as List<Map<String, dynamic>>;
    final progress = details['progress'] as int;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 14),
          // Course Progress Card
          NMCard(
            radius: 20,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Course Progress',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: NMTheme.textPrimary,
                      ),
                    ),
                    Text(
                      '$progress%',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF7C3AED),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  height: 9,
                  decoration: NMTheme.insetDecoration(radius: 6),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: (progress / 100).clamp(0.0, 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF7C3AED),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Videos Section
          _buildExpandableSection(
            title: 'Lectures (${videos.length})',
            children: videos.map((video) => _buildVideoCard(video)).toList(),
          ),
          const SizedBox(height: 16),

          // Notes Section
          _buildExpandableSection(
            title: 'Study Notes (${notes.length})',
            children: notes.map((note) => _buildNoteCard(note)).toList(),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required List<Widget> children,
  }) {
    _expandedSections.putIfAbsent(title, () => true);
    return StatefulBuilder(
      builder: (context, setBuilderState) {
        bool isExpanded = _expandedSections[title] ?? true;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                setBuilderState(() {
                  _expandedSections[title] = !_expandedSections[title]!;
                  isExpanded = _expandedSections[title]!;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: NMTheme.textPrimary,
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    color: NMTheme.textSecondary,
                  ),
                ],
              ),
            ),
            if (isExpanded) ...[const SizedBox(height: 12), ...children],
          ],
        );
      },
    );
  }

  Widget _buildVideoCard(Map<String, dynamic> video) {
    return _VideoContentCard(
      videoTitle: video['title'],
      youtubeLink: video['youtubeLink'],
      duration: video['duration'],
      status: video['status'],
      statusColor: _getStatusColor(video['status']),
    );
  }

  Widget _buildNoteCard(Map<String, dynamic> note) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: NMCard(
        radius: 18,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note['title'],
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.bold,
                color: NMTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              note['content'],
              style: const TextStyle(
                fontSize: 13,
                color: NMTheme.textSecondary,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return const Color(0xFF10B981);
      case 'In Progress':
        return const Color(0xFF7C3AED);
      case 'Not Started':
      default:
        return NMTheme.textMuted;
    }
  }
}

class _VideoContentCard extends StatefulWidget {
  final String videoTitle;
  final String youtubeLink;
  final String duration;
  final String status;
  final Color statusColor;

  const _VideoContentCard({
    required this.videoTitle,
    required this.youtubeLink,
    required this.duration,
    required this.status,
    required this.statusColor,
  });

  @override
  State<_VideoContentCard> createState() => _VideoContentCardState();
}

class _VideoContentCardState extends State<_VideoContentCard> {
  YoutubePlayerController? _controller;
  bool _isPlayerReady = false;

  void _initializeController() {
    if (_controller != null) return;
    final videoId = YoutubePlayer.convertUrlToId(widget.youtubeLink);
    if (videoId == null) return;

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: false,
        loop: false,
      ),
    );

    _controller!.addListener(_onPlayerStateChange);
    setState(() {
      _isPlayerReady = true;
    });
  }

  void _onPlayerStateChange() {
    if (_controller == null) return;
    if (_controller!.value.isFullScreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onPlayerStateChange);
    _controller?.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  String _getThumbnailUrl() {
    final videoId = YoutubePlayer.convertUrlToId(widget.youtubeLink);
    if (videoId == null) return '';
    return 'https://img.youtube.com/vi/$videoId/maxresdefault.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: NMCard(
        radius: 22,
        padding: EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _isPlayerReady && _controller != null
                  ? AspectRatio(
                      aspectRatio: 16 / 9,
                      child: YoutubePlayer(
                        controller: _controller!,
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: const Color(0xFF7C3AED),
                      ),
                    )
                  : Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.network(
                            _getThumbnailUrl(),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: NMTheme.sunkenBg,
                                child: const Icon(Icons.video_library_rounded, size: 48, color: NMTheme.textMuted),
                              );
                            },
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            color: Colors.black.withOpacity(0.35),
                            child: Center(
                              child: GestureDetector(
                                onTap: _initializeController,
                                child: Container(
                                  width: 58,
                                  height: 58,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.play_arrow_rounded,
                                    color: Color(0xFF381868),
                                    size: 36,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.75),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.duration,
                              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.videoTitle,
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.bold,
                        color: NMTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: widget.statusColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            widget.status,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: widget.statusColor,
                            ),
                          ),
                        ),
                        NMWhiteButton(
                          text: 'Study Notes',
                          icon: Icons.notes_rounded,
                          textColor: const Color(0xFF7C3AED),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          radius: 10,
                          onTap: () {},
                        ),
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
