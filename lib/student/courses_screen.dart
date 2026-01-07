import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'app_drawer.dart';
import 'doubts_screen.dart';

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

  @override
  void initState() {
    super.initState();
    _currentScreen = 'subjects';
    _selectedSubject = '';
    _selectedCourse = '';
  }

  final List<Map<String, dynamic>> subjects = [
    {'name': 'Physics', 'icon': '⚡', 'color': const Color(0xFF42A5F5)},
    {'name': 'Chemistry', 'icon': '🧪', 'color': const Color(0xFF7E57C2)},
    {'name': 'Maths', 'icon': '📊', 'color': const Color(0xFF66BB6A)},
  ];

  final Map<String, List<Map<String, dynamic>>> coursesBySubject = {
    'Physics': [
      {
        'name': 'Kinematics',
        'status': 'In Progress',
        'progress': 0.65,
        'statusColor': Colors.blue,
      },
      {
        'name': 'Electromagnetism',
        'status': 'Not Started',
        'progress': 0.0,
        'statusColor': Colors.grey,
      },
    ],
    'Chemistry': [
      {
        'name': 'Organic Chemistry Basics',
        'status': 'Completed',
        'progress': 1.0,
        'statusColor': Colors.green,
      },
      {
        'name': 'Stoichiometry',
        'status': 'In Progress',
        'progress': 0.45,
        'statusColor': Colors.blue,
      },
    ],
    'Maths': [
      {
        'name': 'Calculus Fundamentals',
        'status': 'Not Started',
        'progress': 0.0,
        'statusColor': Colors.grey,
      },
      {
        'name': 'Algebra Refresher',
        'status': 'In Progress',
        'progress': 0.8,
        'statusColor': Colors.blue,
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
          'duration': '12:34',
          'youtubeLink':
              'https://www.youtube.com/live/hY9zZrYuDVk?si=F2MyJwnAslLg0rII',
        },
        {
          'title': 'Projectile Motion',
          'status': 'In Progress',
          'duration': '18:45',
          'youtubeLink':
              'https://www.youtube.com/live/hY9zZrYuDVk?si=F2MyJwnAslLg0rII',
        },
        {
          'title': 'Kinematic Equations Explained',
          'status': 'Not Started',
          'duration': '15:20',
          'youtubeLink':
              'https://www.youtube.com/live/hY9zZrYuDVk?si=F2MyJwnAslLg0rII',
        },
      ],
      'notes': [
        {
          'title': 'Introduction to Motion',
          'content':
              'Motion is the change in position of an object with respect to time. Key concepts include displacement, velocity, and acceleration.',
        },
        {
          'title': 'Velocity vs Speed',
          'content':
              'Speed is the rate of change of distance. Velocity is the rate of change of displacement. Velocity is a vector quantity.',
        },
        {
          'title': 'Acceleration',
          'content':
              'Acceleration is the rate of change of velocity. It can be positive or negative (deceleration). Units: m/s²',
        },
      ],
    },
    'Electromagnetism': {
      'progress': 0,
      'videos': [
        {
          'title': 'Electric Field Basics',
          'status': 'Not Started',
          'duration': '14:20',
          'youtubeLink':
              'https://www.youtube.com/live/hY9zZrYuDVk?si=F2MyJwnAslLg0rII',
        },
      ],
      'notes': [
        {
          'title': 'What is Electromagnetism?',
          'content':
              'Electromagnetism is the study of electric and magnetic fields and their interactions.',
        },
      ],
    },
    'Organic Chemistry Basics': {
      'progress': 100,
      'videos': [
        {
          'title': 'Carbon and Its Compounds',
          'status': 'Completed',
          'duration': '16:50',
          'youtubeLink':
              'https://www.youtube.com/live/hY9zZrYuDVk?si=F2MyJwnAslLg0rII',
        },
      ],
      'notes': [
        {
          'title': 'Organic Chemistry Fundamentals',
          'content':
              'Organic chemistry is the branch of chemistry that deals with carbon compounds.',
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
          'youtubeLink':
              'https://www.youtube.com/live/hY9zZrYuDVk?si=F2MyJwnAslLg0rII',
        },
      ],
      'notes': [
        {
          'title': 'Mole Concept',
          'content':
              'A mole is defined as the amount of substance that contains as many particles as there are atoms in 12g of carbon-12.',
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
          'youtubeLink':
              'https://www.youtube.com/live/hY9zZrYuDVk?si=F2MyJwnAslLg0rII',
        },
      ],
      'notes': [
        {
          'title': 'What is a Limit?',
          'content':
              'A limit is the value that a function approaches as the input approaches some value.',
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
          'youtubeLink':
              'https://www.youtube.com/live/hY9zZrYuDVk?si=F2MyJwnAslLg0rII',
        },
        {
          'title': 'Quadratic Equations',
          'status': 'In Progress',
          'duration': '17:20',
          'youtubeLink':
              'https://www.youtube.com/live/hY9zZrYuDVk?si=F2MyJwnAslLg0rII',
        },
      ],
      'notes': [
        {
          'title': 'Algebraic Identities',
          'content':
              '(a+b)² = a² + 2ab + b², (a-b)² = a² - 2ab + b², a² - b² = (a+b)(a-b)',
        },
      ],
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  if (_currentScreen != 'subjects')
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_currentScreen == 'details') {
                            _currentScreen = 'courses';
                          } else {
                            _currentScreen = 'subjects';
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Color(0xFF1A237E),
                          size: 24,
                        ),
                      ),
                    )
                  else
                    Builder(
                      builder: (context) => GestureDetector(
                        onTap: () {
                          Scaffold.of(context).openDrawer();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.menu,
                            color: Color(0xFF1A237E),
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  const Expanded(
                    child: Text(
                      'Courses',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E),
                      ),
                    ),
                  ),
                  SizedBox(width: 40),
                ],
              ),
            ),

            // Content
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
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Choose your subject',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          ...subjects.map((subject) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedSubject = subject['name'];
                  _currentScreen = 'courses';
                });
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: subject['color'].withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: subject['color'], width: 1.5),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: subject['color'].withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        subject['icon'],
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      subject['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildCoursesScreen() {
    final courses = coursesBySubject[_selectedSubject] ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Courses',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          ...courses.map((course) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCourse = course['name'];
                  _currentScreen = 'details';
                });
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3F2FD),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.rocket_launch,
                            size: 20,
                            color: Color(0xFF42A5F5),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                course['name'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                course['status'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: course['statusColor'],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward,
                          size: 20,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: course['progress'],
                        minHeight: 6,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          course['statusColor'],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildCourseDetailsScreen() {
    final details = courseDetails[_selectedCourse];
    if (details == null) return const SizedBox();

    final videos = details['videos'] as List<Map<String, dynamic>>;
    final notes = details['notes'] as List<Map<String, dynamic>>;
    final progress = details['progress'] as int;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _selectedCourse,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),

          // Course Progress
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Course Progress',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      '$progress%',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF42A5F5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress / 100,
                    minHeight: 8,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF42A5F5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Videos Section
          _buildExpandableSection(
            title: 'Videos',
            children: videos.map((video) {
              return _buildVideoCard(video);
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Notes Section
          _buildExpandableSection(
            title: 'Notes',
            children: notes.map((note) {
              return _buildNoteCard(note);
            }).toList(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required List<Widget> children,
  }) {
    _expandedSections.putIfAbsent(title, () => false);
    return StatefulBuilder(
      builder: (context, setBuilderState) {
        bool isExpanded = _expandedSections[title] ?? false;
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
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.black54,
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
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            note['title'],
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            note['content'],
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.green;
      case 'In Progress':
        return Colors.blue;
      case 'Not Started':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}

// Lazy-loading YouTube Video Card Widget
class _VideoContentCard extends StatefulWidget {
  final String videoTitle;
  final String youtubeLink;
  final String duration;
  final String status;
  final Color statusColor;

  const _VideoContentCard({
    Key? key,
    required this.videoTitle,
    required this.youtubeLink,
    required this.duration,
    required this.status,
    required this.statusColor,
  }) : super(key: key);

  @override
  State<_VideoContentCard> createState() => _VideoContentCardState();
}

class _VideoContentCardState extends State<_VideoContentCard> {
  YoutubePlayerController? _controller;
  bool _isPlayerReady = false;
  bool _hasPlayedOnce = false;

  @override
  void initState() {
    super.initState();
    // Don't initialize controller here - only when play button is pressed
  }

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
      _hasPlayedOnce = true;
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
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video Player or Thumbnail
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: _isPlayerReady && _controller != null
                ? AspectRatio(
                    aspectRatio: 16 / 9,
                    child: YoutubePlayer(
                      controller: _controller!,
                      showVideoProgressIndicator: true,
                      progressIndicatorColor: Colors.red,
                      progressColors: const ProgressBarColors(
                        playedColor: Colors.red,
                        handleColor: Colors.redAccent,
                      ),
                    ),
                  )
                : Stack(
                    children: [
                      // Thumbnail
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.network(
                          _getThumbnailUrl(),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.video_library,
                                size: 64,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                      // Play Button Overlay
                      Positioned.fill(
                        child: Container(
                          color: Colors.black.withOpacity(0.3),
                          child: Center(
                            child: GestureDetector(
                              onTap: _initializeController,
                              child: Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.red.withOpacity(0.4),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Duration Badge
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            widget.duration,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),

          // Video Info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.videoTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: widget.statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    widget.status,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: widget.statusColor,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // View Notes Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // View Notes functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Opening notes...'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    icon: const Icon(Icons.note_outlined, size: 18),
                    label: const Text('View Notes'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF42A5F5),
                      side: const BorderSide(
                        color: Color(0xFF42A5F5),
                        width: 1.5,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
