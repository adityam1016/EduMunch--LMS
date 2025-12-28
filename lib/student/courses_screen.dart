import 'package:flutter/material.dart';
import 'app_drawer.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  late String _currentScreen; // 'subjects', 'courses', 'details'
  late String _selectedSubject;
  late String _selectedCourse;

  @override
  void initState() {
    super.initState();
    _currentScreen = 'subjects';
    _selectedSubject = '';
    _selectedCourse = '';
  }

  final List<Map<String, dynamic>> subjects = [
    {
      'name': 'Physics',
      'icon': '⚡',
      'color': const Color(0xFF42A5F5),
    },
    {
      'name': 'Chemistry',
      'icon': '🧪',
      'color': const Color(0xFF7E57C2),
    },
    {
      'name': 'Maths',
      'icon': '📊',
      'color': const Color(0xFF66BB6A),
    },
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
          'youtubeLink': 'https://www.youtube.com/live/hY9zZrYuDVk?si=F2MyJwnAslLg0rII'
        },
        {
          'title': 'Projectile Motion',
          'status': 'In Progress',
          'duration': '18:45',
          'youtubeLink': 'https://www.youtube.com/live/hY9zZrYuDVk?si=F2MyJwnAslLg0rII'
        },
        {
          'title': 'Kinematic Equations Explained',
          'status': 'Not Started',
          'duration': '15:20',
          'youtubeLink': 'https://www.youtube.com/live/hY9zZrYuDVk?si=F2MyJwnAslLg0rII'
        },
      ],
      'notes': [
        {
          'title': 'Introduction to Motion',
          'content': 'Motion is the change in position of an object with respect to time. Key concepts include displacement, velocity, and acceleration.',
        },
        {
          'title': 'Velocity vs Speed',
          'content': 'Speed is the rate of change of distance. Velocity is the rate of change of displacement. Velocity is a vector quantity.',
        },
        {
          'title': 'Acceleration',
          'content': 'Acceleration is the rate of change of velocity. It can be positive or negative (deceleration). Units: m/s²',
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
          'youtubeLink': 'https://www.youtube.com/live/hY9zZrYuDVk?si=F2MyJwnAslLg0rII'
        },
      ],
      'notes': [
        {
          'title': 'What is Electromagnetism?',
          'content': 'Electromagnetism is the study of electric and magnetic fields and their interactions.',
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
          'youtubeLink': 'https://www.youtube.com/live/hY9zZrYuDVk?si=F2MyJwnAslLg0rII'
        },
      ],
      'notes': [
        {
          'title': 'Organic Chemistry Fundamentals',
          'content': 'Organic chemistry is the branch of chemistry that deals with carbon compounds.',
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
          'youtubeLink': 'https://www.youtube.com/live/hY9zZrYuDVk?si=F2MyJwnAslLg0rII'
        },
      ],
      'notes': [
        {
          'title': 'Mole Concept',
          'content': 'A mole is defined as the amount of substance that contains as many particles as there are atoms in 12g of carbon-12.',
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
          'youtubeLink': 'https://www.youtube.com/live/hY9zZrYuDVk?si=F2MyJwnAslLg0rII'
        },
      ],
      'notes': [
        {
          'title': 'What is a Limit?',
          'content': 'A limit is the value that a function approaches as the input approaches some value.',
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
          'youtubeLink': 'https://www.youtube.com/live/hY9zZrYuDVk?si=F2MyJwnAslLg0rII'
        },
        {
          'title': 'Quadratic Equations',
          'status': 'In Progress',
          'duration': '17:20',
          'youtubeLink': 'https://www.youtube.com/live/hY9zZrYuDVk?si=F2MyJwnAslLg0rII'
        },
      ],
      'notes': [
        {
          'title': 'Algebraic Identities',
          'content': '(a+b)² = a² + 2ab + b², (a-b)² = a² - 2ab + b², a² - b² = (a+b)(a-b)',
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
                  border: Border.all(
                    color: subject['color'],
                    width: 1.5,
                  ),
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
    return StatefulBuilder(
      builder: (context, setBuilderState) {
        bool isExpanded = true;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                setBuilderState(() {
                  isExpanded = !isExpanded;
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
            if (isExpanded) ...[
              const SizedBox(height: 12),
              ...children,
            ],
          ],
        );
      },
    );
  }

  Widget _buildVideoCard(Map<String, dynamic> video) {
    return GestureDetector(
      onTap: () {
        _showVideoPlayer(video);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.play_circle_outline,
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
                    video['title'],
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(video['status'])
                              .withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          video['status'],
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: _getStatusColor(video['status']),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        video['duration'],
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward,
              size: 18,
              color: Colors.grey,
            ),
          ],
        ),
      ),
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

  void _showVideoPlayer(Map<String, dynamic> video) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return VideoPlayerDialog(video: video);
      },
    );
  }
}

class VideoPlayerDialog extends StatefulWidget {
  final Map<String, dynamic> video;

  const VideoPlayerDialog({
    super.key,
    required this.video,
  });

  @override
  State<VideoPlayerDialog> createState() => _VideoPlayerDialogState();
}

class _VideoPlayerDialogState extends State<VideoPlayerDialog>
    with TickerProviderStateMixin {
  double _playbackSpeed = 1.0;
  String _quality = '720p';
  bool _showControls = true;
  bool _isPlaying = false;

  // Duration and progress tracking
  late Duration _totalDuration;
  late Duration _currentPosition;
  late AnimationController _hideControlsTimer;

  final List<double> _speeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];
  final List<String> _qualities = ['360p', '480p', '720p', '1080p'];

  @override
  void initState() {
    super.initState();
    // Set video duration to 12:30
    _totalDuration = const Duration(minutes: 12, seconds: 30);
    _currentPosition = Duration.zero;

    _hideControlsTimer = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    _hideControlsTimer.addStatusListener((status) {
      if (status == AnimationStatus.completed && _isPlaying) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _hideControlsTimer.dispose();
    super.dispose();
  }

  void _simulatePlayback() {
    if (!_isPlaying) return;

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted && _isPlaying) {
        setState(() {
          final newPosition = _currentPosition +
              Duration(
                milliseconds: (100 * _playbackSpeed).toInt(),
              );
          if (newPosition < _totalDuration) {
            _currentPosition = newPosition;
          } else {
            _isPlaying = false;
            _currentPosition = _totalDuration;
          }
        });
        _simulatePlayback();
      }
    });
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      _showControls = true;
      _hideControlsTimer.forward(from: 0.0);
    });
    if (_isPlaying) {
      _simulatePlayback();
    }
  }

  void _onProgressBarChange(double value) {
    setState(() {
      _currentPosition = Duration(
        seconds: (value * _totalDuration.inSeconds).toInt(),
      );
      _showControls = true;
      _hideControlsTimer.forward(from: 0.0);
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds'
        .replaceFirst(RegExp(r'^0:'), '');
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        color: Colors.black,
        child: OrientationBuilder(
          builder: (context, orientation) {
            return Stack(
              alignment: Alignment.center,
              children: [
                // Video Background
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isPlaying
                            ? Icons.pause_circle
                            : Icons.play_circle,
                        size: 100,
                        color: Colors.white24,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.video['title'],
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // Click to show/hide controls
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showControls = !_showControls;
                      if (_showControls) {
                        _hideControlsTimer.forward(from: 0.0);
                      }
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.transparent,
                  ),
                ),

                // Controls Overlay
                if (_showControls)
                  Positioned.fill(
                    child: AnimatedOpacity(
                      opacity: 1.0,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.5),
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Top Bar
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.video['title'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  GestureDetector(
                                    onTap: () => Navigator.pop(context),
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(4),
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Center Play Button
                            GestureDetector(
                              onTap: _togglePlayPause,
                              child: AnimatedScale(
                                scale: 1.0,
                                duration: const Duration(milliseconds: 100),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF0000)
                                        .withOpacity(0.9),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFFF0000)
                                            .withOpacity(0.4),
                                        blurRadius: 20,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    _isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: Colors.white,
                                    size: 48,
                                  ),
                                ),
                              ),
                            ),

                            // Bottom Controls
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  // Progress Bar
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onHorizontalDragUpdate: (details) {
                                          final box = context.findRenderObject()
                                              as RenderBox;
                                          final localOffset =
                                              box.globalToLocal(
                                            details.globalPosition,
                                          );
                                          final progress = (localOffset.dx /
                                                  box.size.width)
                                              .clamp(0.0, 1.0);
                                          _onProgressBarChange(progress);
                                        },
                                        onHorizontalDragStart: (details) {
                                          _hideControlsTimer.stop();
                                        },
                                        onHorizontalDragEnd: (details) {
                                          _hideControlsTimer
                                              .forward(from: 0.0);
                                        },
                                        child: MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          child: Container(
                                            height: 6,
                                            decoration: BoxDecoration(
                                              color: Colors.white30,
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                            ),
                                            child: Stack(
                                              alignment:
                                                  Alignment.centerLeft,
                                              children: [
                                                // Played portion
                                                Container(
                                                  width: (_currentPosition
                                                              .inMilliseconds /
                                                          _totalDuration
                                                              .inMilliseconds) *
                                                      100,
                                                  decoration: BoxDecoration(
                                                    color: const Color(
                                                        0xFFFF0000),
                                                    borderRadius:
                                                        BorderRadius.circular(3),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      // Time Display
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            _formatDuration(
                                                _currentPosition),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            _formatDuration(
                                                _totalDuration),
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),

                                  // Control Buttons
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Speed Button
                                      GestureDetector(
                                        onTap: () {
                                          _showSpeedMenu(context);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(
                                              _playbackSpeed == 1.0
                                                  ? 0.15
                                                  : 0.25,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            border: Border.all(
                                              color: _playbackSpeed == 1.0
                                                  ? Colors.white30
                                                  : Colors.red,
                                              width: 1,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                '${_playbackSpeed}x',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const Text(
                                                'Speed',
                                                style: TextStyle(
                                                  color: Colors.white60,
                                                  fontSize: 9,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      // Quality Button
                                      GestureDetector(
                                        onTap: () {
                                          _showQualityMenu(context);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(
                                              _quality == '720p'
                                                  ? 0.15
                                                  : 0.25,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            border: Border.all(
                                              color: _quality == '720p'
                                                  ? Colors.white30
                                                  : Colors.red,
                                              width: 1,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                _quality,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const Text(
                                                'Quality',
                                                style: TextStyle(
                                                  color: Colors.white60,
                                                  fontSize: 9,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      // Fullscreen Button
                                      GestureDetector(
                                        onTap: () {
                                          // Fullscreen logic
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white
                                                .withOpacity(0.15),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            border: Border.all(
                                              color: Colors.white30,
                                              width: 1,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              const Icon(
                                                Icons.fullscreen,
                                                color: Colors.white,
                                                size: 14,
                                              ),
                                              const Text(
                                                'Full',
                                                style: TextStyle(
                                                  color: Colors.white60,
                                                  fontSize: 9,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      // Settings Button
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white
                                              .withOpacity(0.15),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: Border.all(
                                            color: Colors.white30,
                                            width: 1,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            const Icon(
                                              Icons.settings,
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                            Text(
                                              _isPlaying ? 'Playing' : 'Ready',
                                              style: const TextStyle(
                                                color: Colors.white60,
                                                fontSize: 9,
                                              ),
                                            ),
                                          ],
                                        ),
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
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showSpeedMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.grey[900],
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Playback Speed',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ..._speeds.map((speed) {
                  bool isSelected = speed == _playbackSpeed;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _playbackSpeed = speed;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFFF0000)
                            : Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${speed}x',
                            style: TextStyle(
                              color:
                                  isSelected ? Colors.white : Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showQualityMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.grey[900],
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Video Quality',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ..._qualities.map((quality) {
                  bool isSelected = quality == _quality;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _quality = quality;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFFF0000)
                            : Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            quality,
                            style: TextStyle(
                              color:
                                  isSelected ? Colors.white : Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }
}
