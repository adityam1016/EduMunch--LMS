import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';

// Enum for view states
enum PortalView { portalHome, mcqView, theoryView }

// Question model for MCQ
class Question {
  final String text;
  final List<String> options;
  final int correctIndex;

  Question({
    required this.text,
    required this.options,
    required this.correctIndex,
  });
}

// Theory Question model
class TheoryQuestion {
  final String text;
  String answer;
  File? uploadedImage;

  TheoryQuestion({
    required this.text,
    this.answer = '',
    this.uploadedImage,
  });
}

class TestPortalScreen extends StatefulWidget {
  const TestPortalScreen({super.key});

  @override
  State<TestPortalScreen> createState() => _TestPortalScreenState();
}

class _TestPortalScreenState extends State<TestPortalScreen> {
  PortalView currentView = PortalView.portalHome;
  int currentQuestionIndex = 0;
  int mcqScore = 0;
  List<int> selectedAnswers = [];
  bool showMCQResult = false;

  // Timer variables
  Timer? _timer;
  int _remainingSeconds = 3 * 60 * 60; // 3 hours in seconds
  bool _timerStarted = false;

  // MCQ Questions
  late List<Question> mcqQuestions;

  // Theory Questions
  late List<TheoryQuestion> theoryQuestions;

  @override
  void initState() {
    super.initState();
    _initializeMCQQuestions();
    _initializeTheoryQuestions();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (_timerStarted) return;
    _timerStarted = true;
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
          
          // Show warning at 5 minutes remaining
          if (_remainingSeconds == 5 * 60) {
            _showTimeWarning('5 minutes remaining!');
          }
          // Show critical warning at 1 minute remaining
          if (_remainingSeconds == 60) {
            _showTimeWarning('Only 1 minute left!');
          }
        } else {
          timer.cancel();
          _autoSubmitExam();
        }
      });
    });
  }

  void _showTimeWarning(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange[700],
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _autoSubmitExam() {
    _timer?.cancel();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Time expired! Exam submitted automatically.'),
        backgroundColor: Colors.red,
      ),
    );
    _submitMCQExam();
  }

  Color _getTimerColor() {
    if (_remainingSeconds <= 60) return Colors.red;
    if (_remainingSeconds <= 5 * 60) return Colors.orange;
    return Colors.green;
  }

  // Widget to display a visual timer
  Widget _buildTimerDisplay() {
    final hours = _remainingSeconds ~/ 3600;
    final minutes = (_remainingSeconds % 3600) ~/ 60;
    final secs = _remainingSeconds % 60;
    final timerColor = _getTimerColor();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            timerColor.withOpacity(0.1),
            timerColor.withOpacity(0.05),
          ],
        ),
        border: Border.all(color: timerColor.withOpacity(0.3), width: 2),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.schedule,
                color: timerColor,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                'Exam Time Remaining',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: timerColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Large timer display
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: timerColor, width: 2),
            ),
            child: Text(
              '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: timerColor,
                fontFamily: 'monospace',
                letterSpacing: 4,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Timer status message
          Text(
            _remainingSeconds <= 60
                ? '⚠️ Only ${secs}s left!'
                : _remainingSeconds <= 5 * 60
                    ? '⚠️ Less than ${minutes}m remaining'
                    : '✓ ${hours}h ${minutes}m remaining',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: timerColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _initializeMCQQuestions() {
    mcqQuestions = [
      Question(
        text: 'What is the capital of France?',
        options: ['London', 'Berlin', 'Paris', 'Madrid'],
        correctIndex: 2,
      ),
      Question(
        text: 'Which planet is known as the Red Planet?',
        options: ['Venus', 'Mars', 'Jupiter', 'Saturn'],
        correctIndex: 1,
      ),
      Question(
        text: 'What is the largest ocean on Earth?',
        options: ['Atlantic', 'Indian', 'Arctic', 'Pacific'],
        correctIndex: 3,
      ),
      Question(
        text: 'Who wrote "Romeo and Juliet"?',
        options: ['Jane Austen', 'William Shakespeare', 'Charles Dickens', 'Mark Twain'],
        correctIndex: 1,
      ),
      Question(
        text: 'What is the chemical symbol for Gold?',
        options: ['Go', 'Gd', 'Au', 'Ag'],
        correctIndex: 2,
      ),
      Question(
        text: 'Which country is home to the Kangaroo?',
        options: ['Brazil', 'Australia', 'South Africa', 'India'],
        correctIndex: 1,
      ),
      Question(
        text: 'What is the smallest prime number?',
        options: ['0', '1', '2', '3'],
        correctIndex: 2,
      ),
      Question(
        text: 'Who painted the Mona Lisa?',
        options: ['Vincent van Gogh', 'Pablo Picasso', 'Leonardo da Vinci', 'Michelangelo'],
        correctIndex: 2,
      ),
      Question(
        text: 'What is the speed of light?',
        options: ['300,000 km/s', '150,000 km/s', '450,000 km/s', '200,000 km/s'],
        correctIndex: 0,
      ),
      Question(
        text: 'Which gas do plants absorb from the atmosphere?',
        options: ['Oxygen', 'Nitrogen', 'Carbon Dioxide', 'Hydrogen'],
        correctIndex: 2,
      ),
    ];
    selectedAnswers = List<int>.filled(mcqQuestions.length, -1);
  }

  void _initializeTheoryQuestions() {
    theoryQuestions = [
      TheoryQuestion(text: 'Explain the process of photosynthesis.'),
      TheoryQuestion(text: 'Describe the water cycle and its importance.'),
      TheoryQuestion(text: 'What is the theory of evolution? Explain with examples.'),
      TheoryQuestion(text: 'Discuss the causes and effects of global warming.'),
      TheoryQuestion(text: 'Explain the structure and functions of the human heart.'),
    ];
  }

  void _submitMCQExam() {
    mcqScore = 0;
    for (int i = 0; i < mcqQuestions.length; i++) {
      if (selectedAnswers[i] == mcqQuestions[i].correctIndex) {
        mcqScore++;
      }
    }
    setState(() {
      showMCQResult = true;
    });
  }

  void _handleImageUpload(int questionIndex) {
    // Placeholder for image picker
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Image upload would be handled by ImagePicker plugin'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Student Assessment Portal',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        centerTitle: true,
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
      ),
      body: _buildCurrentView(),
    );
  }

  Widget _buildCurrentView() {
    switch (currentView) {
      case PortalView.portalHome:
        return _buildPortalHome();
      case PortalView.mcqView:
        return _buildMCQView();
      case PortalView.theoryView:
        return _buildTheoryView();
    }
  }

  // Portal Home - Dashboard
  Widget _buildPortalHome() {
    // Reset timer when returning to portal home
    if (_timerStarted) {
      _timer?.cancel();
      _timerStarted = false;
      _remainingSeconds = 3 * 60 * 60;
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue[600]!, Colors.blue[800]!],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to Assessment Portal',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Choose an exam type to begin your test',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                border: Border.all(color: Colors.amber[300]!, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.amber[800],
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Exam Duration',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.amber[900],
                          ),
                        ),
                        Text(
                          '3 hours (180 minutes) - Timer starts when exam begins',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.amber[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Section Title
            Text(
              'Select Exam Type',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Theory Exam Card
            _buildExamCard(
              context,
              title: 'Theory Exam',
              subtitle: '5 Descriptive Questions',
              icon: Icons.description_outlined,
              onTap: () {
                setState(() {
                  currentView = PortalView.theoryView;
                  _remainingSeconds = 3 * 60 * 60;
                  _timerStarted = false;
                });
              },
              color1: const Color(0xFF6A5ACD),
              color2: const Color(0xFF8B7DD8),
            ),
            const SizedBox(height: 24),
            // MCQ Exam Card
            _buildExamCard(
              context,
              title: 'MCQ Exam',
              subtitle: '10 Multiple Choice Questions',
              icon: Icons.quiz_outlined,
              onTap: () {
                setState(() {
                  currentView = PortalView.mcqView;
                  currentQuestionIndex = 0;
                  showMCQResult = false;
                  _remainingSeconds = 3 * 60 * 60;
                  _timerStarted = false;
                });
              },
              color1: const Color(0xFF1565C0),
              color2: const Color(0xFF1976D2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExamCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    required Color color1,
    required Color color2,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color1,
                color2,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: color1.withOpacity(0.5),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: color2.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(-5, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          subtitle,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.15),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '3 hours duration',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
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

  // MCQ View
  Widget _buildMCQView() {
    // Start timer on MCQ view load
    if (!_timerStarted && currentView == PortalView.mcqView) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startTimer();
      });
    }

    if (showMCQResult) {
      _timer?.cancel();
      return _buildMCQResult();
    }

    return Column(
      children: [
        // Enhanced Timer Display
        Padding(
          padding: const EdgeInsets.all(16),
          child: _buildTimerDisplay(),
        ),
        // Question and Options
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue[50]!, Colors.blue[100]!],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Question ${currentQuestionIndex + 1}/${mcqQuestions.length}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[900],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.blue[600],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${((currentQuestionIndex + 1) / mcqQuestions.length * 100).toStringAsFixed(0)}%',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: (currentQuestionIndex + 1) / mcqQuestions.length,
                          minHeight: 8,
                          backgroundColor: Colors.blue[200],
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[600]!),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Question Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                      ),
                    ],
                    border: Border.all(color: Colors.blue[100]!),
                  ),
                  child: Text(
                    mcqQuestions[currentQuestionIndex].text,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Options Title
                Text(
                  'Select the correct answer:',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 12),
                ..._buildOptionsList(),
              ],
            ),
          ),
        ),
        // Navigation Buttons
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              if (currentQuestionIndex > 0)
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentQuestionIndex--;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[400],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Previous'),
                  ),
                ),
              if (currentQuestionIndex > 0) const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: currentQuestionIndex < mcqQuestions.length - 1
                      ? () {
                    setState(() {
                      currentQuestionIndex++;
                    });
                  }
                      : _submitMCQExam,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    currentQuestionIndex < mcqQuestions.length - 1
                        ? 'Next'
                        : 'Submit',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildOptionsList() {
    return List.generate(
      mcqQuestions[currentQuestionIndex].options.length,
      (index) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: GestureDetector(
          onTap: () {
            setState(() {
              selectedAnswers[currentQuestionIndex] = index;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              border: Border.all(
                color: selectedAnswers[currentQuestionIndex] == index
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[300]!,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
              color: selectedAnswers[currentQuestionIndex] == index
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                  : Colors.transparent,
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selectedAnswers[currentQuestionIndex] == index
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey[400]!,
                      width: 2,
                    ),
                  ),
                  child: selectedAnswers[currentQuestionIndex] == index
                      ? Center(
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    mcqQuestions[currentQuestionIndex].options[index],
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: selectedAnswers[currentQuestionIndex] == index
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMCQResult() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: mcqScore >= 7
                    ? Colors.green.withOpacity(0.1)
                    : Colors.orange.withOpacity(0.1),
              ),
              child: Center(
                child: Icon(
                  mcqScore >= 7 ? Icons.check_circle : Icons.info,
                  size: 60,
                  color: mcqScore >= 7 ? Colors.green : Colors.orange,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Exam Completed!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Your Score',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$mcqScore/10',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${(mcqScore / 10 * 100).toStringAsFixed(1)}%',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: mcqScore >= 7 ? Colors.green : Colors.orange,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _timer?.cancel();
                  setState(() {
                    currentView = PortalView.portalHome;
                    currentQuestionIndex = 0;
                    showMCQResult = false;
                    _timerStarted = false;
                    _remainingSeconds = 3 * 60 * 60; // Reset timer
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Back to Portal'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Theory View
  Widget _buildTheoryView() {
    // Start timer on Theory view load
    if (!_timerStarted && currentView == PortalView.theoryView) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startTimer();
      });
    }

    return Column(
      children: [
        // Enhanced Timer Display
        Padding(
          padding: const EdgeInsets.all(16),
          child: _buildTimerDisplay(),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: List.generate(
                theoryQuestions.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _buildTheoryQuestionCard(index),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _timer?.cancel();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Theory exam submitted successfully!'),
                  ),
                );
                setState(() {
                  currentView = PortalView.portalHome;
                  _timerStarted = false;
                  _remainingSeconds = 3 * 60 * 60; // Reset timer
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Submit Theory Exam'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTheoryQuestionCard(int index) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    theoryQuestions[index].text,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Answer Text Field
            TextField(
              maxLines: 10,
              onChanged: (value) {
                theoryQuestions[index].answer = value;
              },
              decoration: InputDecoration(
                hintText: 'Answer here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 12),
            // Image Upload Section
            if (theoryQuestions[index].uploadedImage == null)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _handleImageUpload(index),
                  icon: const Icon(Icons.image_outlined),
                  label: const Text('Upload Image'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Image Preview:',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[400]!),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.image,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          theoryQuestions[index].uploadedImage = null;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                      ),
                      child: const Text('Remove Image'),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
