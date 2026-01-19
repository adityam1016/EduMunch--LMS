import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'app_drawer.dart';
import 'doubt_discussion_screen.dart';

class DoubtsScreen extends StatefulWidget {
  const DoubtsScreen({Key? key}) : super(key: key);

  @override
  State<DoubtsScreen> createState() => _DoubtsScreenState();
}

class _DoubtsScreenState extends State<DoubtsScreen> {
  int _currentIndex = 0; // 0 = My Doubts, 1 = Ask Doubt
  
  List<Map<String, dynamic>> doubts = [
    {
      'id': 1,
      'title': 'Math Problem',
      'status': 'Pending',
      'submittedTime': 'Submitted 2024-01-20 10:30 AM',
      'subject': 'Mathematics',
      'faculty': 'Prof. Sharma',
      'description': 'Unable to understand the integration by parts method. Can you explain with more examples?',
      'messages': [
        {'sender': 'You', 'text': 'Hi Prof. Sharma, I am having trouble with integration by parts. Can you help?', 'time': '10:30 AM', 'isStudent': true},
        {'sender': 'Prof. Sharma', 'text': 'Sure! Let me break it down for you. Integration by parts is based on the product rule of differentiation.', 'time': '10:35 AM', 'isStudent': false},
        {'sender': 'You', 'text': 'Can you give me an example?', 'time': '10:40 AM', 'isStudent': true},
        {'sender': 'Prof. Sharma', 'text': 'Let\'s take ∫x*e^x dx. Here u = x and dv = e^x dx. Apply the formula: ∫u dv = uv - ∫v du', 'time': '10:45 AM', 'isStudent': false},
      ],
    },
    {
      'id': 2,
      'title': 'Science Question',
      'status': 'Resolved',
      'submittedTime': 'Submitted 2024-01-18 02:15 PM',
      'subject': 'Physics',
      'faculty': 'Prof. Gupta',
      'description': 'What is the difference between elastic and inelastic collisions?',
      'messages': [
        {'sender': 'You', 'text': 'Prof. Gupta, can you explain elastic and inelastic collisions?', 'time': '2:15 PM', 'isStudent': true},
        {'sender': 'Prof. Gupta', 'text': 'In elastic collisions, kinetic energy is conserved. In inelastic collisions, some energy is lost.', 'time': '2:20 PM', 'isStudent': false},
        {'sender': 'You', 'text': 'Got it! Thanks', 'time': '2:22 PM', 'isStudent': true},
        {'sender': 'Prof. Gupta', 'text': 'You\'re welcome! Keep practicing!', 'time': '2:25 PM', 'isStudent': false},
      ],
    },
    {
      'id': 3,
      'title': 'History Essay',
      'status': 'Pending',
      'submittedTime': 'Submitted 2024-01-15 09:45 AM',
      'subject': 'History',
      'faculty': 'Prof. Singh',
      'description': 'Help with essay on the French Revolution',
      'messages': [
        {'sender': 'You', 'text': 'Prof. Singh, I need guidance on the French Revolution essay.', 'time': '9:45 AM', 'isStudent': true},
        {'sender': 'Prof. Singh', 'text': 'Focus on the three main phases: Moderate Phase, Radical Phase, and Directory.', 'time': '9:50 AM', 'isStudent': false},
      ],
    },
    {
      'id': 4,
      'title': 'English Assignment',
      'status': 'Resolved',
      'submittedTime': 'Submitted 2024-01-12 04:00 PM',
      'subject': 'English',
      'faculty': 'Prof. Sharma',
      'description': 'Grammar questions on tenses',
      'messages': [
        {'sender': 'You', 'text': 'Prof. Sharma, I have questions about past perfect tense.', 'time': '4:00 PM', 'isStudent': true},
        {'sender': 'Prof. Sharma', 'text': 'Past perfect is used for the earlier action when two past actions are mentioned.', 'time': '4:05 PM', 'isStudent': false},
      ],
    },
  ];

  // Form variables for Ask a Doubt
  String? _selectedSubject;
  String? _selectedFaculty;
  String? _selectedTopic;
  String? _selectedSubtopic;
  TextEditingController _descriptionController = TextEditingController();
  List<Map<String, String>> attachments = [];
  final ImagePicker _imagePicker = ImagePicker();
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  Timer? _recordingTimer;
  int _recordingDuration = 0;

  List<String> subjects = ['Mathematics', 'Physics', 'Chemistry', 'Biology', 'History', 'English'];
  List<String> faculties = ['Prof. Sharma', 'Prof. Gupta', 'Prof. Singh', 'Prof. Kumar', 'Prof. Patel'];
  List<String> topics = ['Concepts', 'Problem Solving', 'Assignments', 'Exam Preparation', 'Other'];
  List<String> subtopics = ['Fundamentals', 'Advanced', 'Examples', 'Practice', 'Clarification'];

  @override
  void dispose() {
    _descriptionController.dispose();
    _recordingTimer?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _pickFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: ImageSource.camera, imageQuality: 85);
      if (image != null) {
        setState(() {
          attachments.add({
            'name': image.name,
            'type': 'Image',
            'path': image.path,
          });
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image captured successfully'),
            duration: Duration(seconds: 1),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (image != null) {
        setState(() {
          attachments.add({
            'name': image.name,
            'type': 'Image',
            'path': image.path,
          });
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image selected successfully'),
            duration: Duration(seconds: 1),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _removeAttachment(int index) {
    setState(() {
      attachments.removeAt(index);
    });
  }

  void _submitDoubt() {
    if (_selectedSubject == null || _selectedFaculty == null || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Doubt submitted successfully'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ),
    );

    setState(() {
      doubts.insert(0, {
        'id': doubts.length + 1,
        'title': _descriptionController.text.split('\n').first.length > 20
            ? _descriptionController.text.substring(0, 20) + '...'
            : _descriptionController.text.split('\n').first,
        'status': 'Pending',
        'submittedTime': 'Just now',
        'subject': _selectedSubject,
        'faculty': _selectedFaculty,
        'description': _descriptionController.text,
        'messages': [
          {'sender': 'You', 'text': _descriptionController.text, 'time': 'Just now', 'isStudent': true},
        ],
      });

      _selectedSubject = null;
      _selectedFaculty = null;
      _selectedTopic = null;
      _selectedSubtopic = null;
      _descriptionController.clear();
      attachments.clear();
      _currentIndex = 0;
    });
  }

  Color _getStatusColor(String status) {
    if (status == 'Pending') return const Color(0xFFFFA726);
    if (status == 'Resolved') return const Color(0xFF66BB6A);
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    if (_currentIndex == 1) {
      return _buildAskDoubtScreen();
    } else {
      return _buildMyDoubtsScreen();
    }
  }

  Widget _buildMyDoubtsScreen() {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFF8B5CF6)),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'My Doubts',
          style: TextStyle(
            color: Color(0xFF8B5CF6),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          Expanded(
            child: doubts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.help_outline, size: 80, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text(
                          'No doubts yet',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: doubts.length,
                    itemBuilder: (context, index) {
                      final doubt = doubts[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => DoubtDiscussionScreen(
                                doubt: doubt,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: doubt['subject'] == 'Mathematics'
                                      ? const Color(0xFF7C3AED).withOpacity(0.15)
                                      : doubt['subject'] == 'Physics'
                                          ? const Color(0xFF7C3AED).withOpacity(0.15)
                                          : doubt['subject'] == 'Chemistry'
                                              ? Colors.orange.withOpacity(0.15)
                                              : doubt['subject'] == 'Biology'
                                                  ? Colors.green.withOpacity(0.15)
                                                  : doubt['subject'] == 'History'
                                                      ? Colors.red.withOpacity(0.15)
                                                      : Colors.teal.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  doubt['subject'] == 'Mathematics'
                                      ? Icons.calculate
                                      : doubt['subject'] == 'Physics'
                                          ? Icons.science
                                          : doubt['subject'] == 'Chemistry'
                                              ? Icons.science
                                              : doubt['subject'] == 'Biology'
                                                  ? Icons.bug_report
                                                  : doubt['subject'] == 'History'
                                                      ? Icons.history
                                                      : Icons.language,
                                  color: doubt['subject'] == 'Mathematics'
                                      ? const Color(0xFF7C3AED)
                                      : doubt['subject'] == 'Physics'
                                          ? const Color(0xFF7C3AED)
                                          : doubt['subject'] == 'Chemistry'
                                              ? Colors.orange
                                              : doubt['subject'] == 'Biology'
                                                  ? Colors.green
                                                  : doubt['subject'] == 'History'
                                                      ? Colors.red
                                                      : Colors.teal,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            doubt['title'],
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: _getStatusColor(doubt['status']).withOpacity(0.15),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            doubt['status'],
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: _getStatusColor(doubt['status']),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      doubt['submittedTime'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                },
                icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                label: const Text(
                  'Upload Doubt',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5CF6),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAskDoubtScreen() {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF8B5CF6)),
          onPressed: () {
            setState(() {
              _currentIndex = 0;
            });
          },
        ),
        title: const Text(
          'Ask a Doubt',
          style: TextStyle(
            color: Color(0xFF8B5CF6),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subject
            const Text(
              'Subject',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                underline: const SizedBox(),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                value: _selectedSubject,
                hint: const Text('Select a Subject'),
                items: subjects.map((subject) {
                  return DropdownMenuItem(
                    value: subject,
                    child: Text(subject),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSubject = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),

            // Faculty
            const Text(
              'Faculty',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                underline: const SizedBox(),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                value: _selectedFaculty,
                hint: const Text('Select a Faculty'),
                items: faculties.map((faculty) {
                  return DropdownMenuItem(
                    value: faculty,
                    child: Text(faculty),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedFaculty = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),

            // Topic
            const Text(
              'Topic',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                underline: const SizedBox(),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                value: _selectedTopic,
                hint: const Text('Select Topic'),
                items: topics.map((topic) {
                  return DropdownMenuItem(
                    value: topic,
                    child: Text(topic),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTopic = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),

            // Sub-topic
            const Text(
              'Sub-topic',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                underline: const SizedBox(),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                value: _selectedSubtopic,
                hint: const Text('Select Sub-topic'),
                items: subtopics.map((subtopic) {
                  return DropdownMenuItem(
                    value: subtopic,
                    child: Text(subtopic),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSubtopic = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),

            // Description
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Describe your doubt in detail...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF8B5CF6)),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Attachments
            const Text(
              'Attachments',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: _pickFromCamera,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7C3AED).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: const Color(0xFF7C3AED),
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Camera',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: _pickFromGallery,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7C3AED).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.image,
                          color: const Color(0xFF7C3AED),
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Gallery',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: _startVoiceRecording,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.mic,
                          color: Colors.orange,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Voice',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Attached files
            if (attachments.isNotEmpty)
              Column(
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: attachments.asMap().entries.map((entry) {
                      final index = entry.key;
                      final attachment = entry.value;
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.image, size: 16, color: const Color(0xFF7C3AED)),
                            const SizedBox(width: 6),
                            Text(
                              attachment['name']!.length > 15
                                  ? attachment['name']!.substring(0, 15) + '...'
                                  : attachment['name']!,
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => _removeAttachment(index),
                              child: const Icon(Icons.close, size: 14, color: Colors.red),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                ],
              ),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitDoubt,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5CF6),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Submit Doubt',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startVoiceRecording() async {
    if (await _audioRecorder.hasPermission()) {
      _showRecordingDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Microphone permission required'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showRecordingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF7C3AED).withOpacity(0.1),
                      const Color(0xFFEDE9FE),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Animated microphone icon
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.8, end: 1.2),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeInOut,
                      builder: (context, scale, child) {
                        return Transform.scale(
                          scale: _isRecording ? scale : 1.0,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: _isRecording ? Colors.red : Colors.orange,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: (_isRecording ? Colors.red : Colors.orange)
                                      .withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Icon(
                              _isRecording ? Icons.stop : Icons.mic,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        );
                      },
                      onEnd: () {
                        if (_isRecording && mounted) {
                          setDialogState(() {});
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    // Status text
                    Text(
                      _isRecording ? 'Recording...' : 'Ready to Record',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7C3AED),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Timer
                    if (_isRecording)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Text(
                          _formatDuration(_recordingDuration),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            fontFeatures: [FontFeature.tabularFigures()],
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Cancel button
                        if (_isRecording)
                          OutlinedButton.icon(
                            onPressed: () async {
                              await _cancelRecording();
                              Navigator.pop(dialogContext);
                            },
                            icon: const Icon(Icons.close),
                            label: const Text('Cancel'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.grey[700],
                              side: BorderSide(color: Colors.grey[400]!),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                          ),
                        // Record/Stop button
                        ElevatedButton.icon(
                          onPressed: () async {
                            if (_isRecording) {
                              await _stopRecording();
                              Navigator.pop(dialogContext);
                            } else {
                              await _startRecordingAudio(setDialogState);
                            }
                          },
                          icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                          label: Text(_isRecording ? 'Stop' : 'Start'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                _isRecording ? Colors.red : Colors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _startRecordingAudio(Function setDialogState) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path =
          '${directory.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await _audioRecorder.start(
        const RecordConfig(encoder: AudioEncoder.aacLc),
        path: path,
      );

      setState(() {
        _isRecording = true;
        _recordingDuration = 0;
      });

      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
          setState(() {
            _recordingDuration++;
          });
          setDialogState(() {});
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to start recording: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      _recordingTimer?.cancel();

      if (path != null) {
        setState(() {
          attachments.add({
            'name': 'voice_${_formatDuration(_recordingDuration)}.m4a',
            'type': 'Voice',
            'path': path,
          });
          _isRecording = false;
          _recordingDuration = 0;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Voice recorded successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isRecording = false;
        _recordingDuration = 0;
      });
    }
  }

  Future<void> _cancelRecording() async {
    await _audioRecorder.stop();
    _recordingTimer?.cancel();
    setState(() {
      _isRecording = false;
      _recordingDuration = 0;
    });
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}