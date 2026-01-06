import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'app_drawer.dart';

class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({super.key});

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  int selectedFilterIndex = 0;
  final List<String> filters = ['All', 'Pending', 'Submitted', 'Graded'];

  final List<Map<String, dynamic>> assignments = [
    {
      'id': 1,
      'title': 'Essay on Climate Change',
      'type': 'Text',
      'icon': Icons.description,
      'status': 'Pending',
      'statusColor': const Color(0xFFFFB74D),
      'dueDate': '25 Oct 2024',
      'timeStatus': 'Upcoming',
      'assignmentType': 'file',
      'description': 'Write a comprehensive essay on the impacts of climate change on global ecosystems.',
      'instructions': [
        {
          'question': 'Question 1: Introduction',
          'details': 'Start with a strong thesis statement about climate change and its significance. (250-300 words)'
        },
        {
          'question': 'Question 2: Body Paragraphs',
          'details': 'Discuss at least 3 major impacts of climate change. (500-600 words)'
        },
        {
          'question': 'Question 3: Conclusion',
          'details': 'Summarize your findings and propose actionable solutions. (200-250 words)'
        },
      ],
      'submissions': [],
    },
    {
      'id': 2,
      'title': 'Physics Quiz - Mechanics',
      'type': 'MCQ',
      'icon': Icons.quiz,
      'status': 'Pending',
      'statusColor': const Color(0xFFEF5350),
      'dueDate': '30 Oct 2024',
      'timeStatus': 'Upcoming',
      'assignmentType': 'mcq',
      'description': 'Solve MCQ questions on mechanics and Newton\'s laws of motion.',
      'questions': [
        {
          'id': 1,
          'question': 'What is the SI unit of force?',
          'options': ['Joule', 'Newton', 'Pascal', 'Watt'],
          'correctAnswer': 1,
        },
        {
          'id': 2,
          'question': 'If an object moves with constant velocity, what is the net force acting on it?',
          'options': ['Zero', 'Maximum', 'Infinity', 'Depends on mass'],
          'correctAnswer': 0,
        },
        {
          'id': 3,
          'question': 'Which law states that action and reaction are equal and opposite?',
          'options': ['First Law', 'Second Law', 'Third Law', 'Law of Gravity'],
          'correctAnswer': 2,
        },
        {
          'id': 4,
          'question': 'What is the formula for kinetic energy?',
          'options': ['mgh', '1/2 mv²', 'F = ma', 'P = W/t'],
          'correctAnswer': 1,
        },
      ],
      'submissions': [],
    },
    {
      'id': 3,
      'title': 'Chemistry MCQ - Chemical Reactions',
      'type': 'MCQ',
      'icon': Icons.quiz,
      'status': 'Submitted',
      'statusColor': const Color(0xFF66BB6A),
      'dueDate': '22 Oct 2024',
      'timeStatus': 'Submitted: 22 Oct 2024',
      'assignmentType': 'mcq',
      'description': 'Answer MCQ questions on chemical reactions and balancing equations.',
      'questions': [
        {
          'id': 1,
          'question': 'What is the pH of a neutral solution?',
          'options': ['0', '7', '14', '1'],
          'correctAnswer': 1,
        },
        {
          'id': 2,
          'question': 'In the reaction 2H2 + O2 → 2H2O, what is O2 called?',
          'options': ['Catalyst', 'Reactant', 'Product', 'Inhibitor'],
          'correctAnswer': 1,
        },
        {
          'id': 3,
          'question': 'Which type of reaction is A + B → AB?',
          'options': ['Decomposition', 'Combination', 'Displacement', 'Redox'],
          'correctAnswer': 1,
        },
      ],
      'submissions': [],
    },
    {
      'id': 4,
      'title': 'Art Project - Landscape',
      'type': 'Image',
      'icon': Icons.image,
      'status': 'Graded: A+',
      'statusColor': const Color(0xFF42A5F5),
      'dueDate': '10 Oct 2024',
      'timeStatus': 'Submitted: 10 Oct 2024',
      'assignmentType': 'file',
      'description': 'Create a landscape artwork using any medium.',
      'instructions': [
        {
          'question': 'Requirement 1: Composition',
          'details': 'Include foreground, middle ground, and background elements.'
        },
      ],
      'submissions': [
        {'name': 'Landscape_Art.jpg', 'type': 'JPEG', 'date': '10 Oct 2024'}
      ],
    },
  ];

  List<Map<String, dynamic>> getFilteredAssignments() {
    if (selectedFilterIndex == 0) return assignments;
    
    String filter = filters[selectedFilterIndex];
    return assignments
        .where((assignment) => assignment['status'].toString().contains(filter))
        .toList();
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Text':
        return const Color(0xFF7E57C2);
      case 'MCQ':
        return const Color(0xFFEF5350);
      case 'Image':
        return const Color(0xFFEF5350);
      case 'PDF':
        return const Color(0xFFFF7043);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredAssignments = getFilteredAssignments();

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
                      'Assignments',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Filter Chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(filters.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedFilterIndex = index;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: selectedFilterIndex == index
                                ? const Color(0xFF42A5F5)
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(20),
                            border: selectedFilterIndex == index
                                ? null
                                : Border.all(color: Colors.grey[300]!),
                          ),
                          child: Text(
                            filters[index],
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: selectedFilterIndex == index
                                  ? Colors.white
                                  : Colors.grey[700],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),

            // Assignments List
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: filteredAssignments.map((assignment) {
                    return _buildAssignmentCard(assignment);
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignmentCard(Map<String, dynamic> assignment) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AssignmentDetailsScreen(
              assignment: assignment,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey[200]!, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Status Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _getTypeColor(assignment['type']).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    assignment['icon'],
                    size: 24,
                    color: _getTypeColor(assignment['type']),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        assignment['title'],
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        assignment['type'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: assignment['statusColor'].withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    assignment['status'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: assignment['statusColor'],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Due Date and Time Status Row
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: Colors.grey[400],
                ),
                const SizedBox(width: 6),
                Text(
                  'Due: ${assignment['dueDate']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: assignment['timeStatus'].contains('Overdue')
                        ? const Color(0xFFEF5350).withOpacity(0.1)
                        : assignment['timeStatus'].contains('Upcoming')
                            ? const Color(0xFFFFB74D).withOpacity(0.1)
                            : const Color(0xFF66BB6A).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    assignment['timeStatus'],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: assignment['timeStatus'].contains('Overdue')
                          ? const Color(0xFFEF5350)
                          : assignment['timeStatus'].contains('Upcoming')
                              ? const Color(0xFFFFB74D)
                              : const Color(0xFF66BB6A),
                    ),
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

class AssignmentDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> assignment;

  const AssignmentDetailsScreen({
    super.key,
    required this.assignment,
  });

  @override
  State<AssignmentDetailsScreen> createState() =>
      _AssignmentDetailsScreenState();
}

class _AssignmentDetailsScreenState extends State<AssignmentDetailsScreen> {
  List<Map<String, String>> uploadedFiles = [];
  Map<int, int?> selectedAnswers = {};
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.assignment['submissions'] != null) {
      uploadedFiles = List<Map<String, String>>.from(
        widget.assignment['submissions'].map((e) => Map<String, String>.from(e)),
      );
    }
  }

  Future<void> _pickFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          uploadedFiles.add({
            'name': image.name,
            'type': 'Image',
            'path': image.path,
          });
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${image.name} captured and added'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          uploadedFiles.add({
            'name': image.name,
            'type': 'Image',
            'path': image.path,
          });
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${image.name} selected and added'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _removeFile(int index) {
    setState(() {
      uploadedFiles.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('File removed'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isMCQ = widget.assignment['assignmentType'] == 'mcq';
    bool isFileUpload = widget.assignment['assignmentType'] == 'file';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
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
                  ),
                  const Expanded(
                    child: Text(
                      'Assignment Details',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      widget.assignment['title'],
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Description
                    Text(
                      widget.assignment['description'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),

                    if (isMCQ) ...[
                      // MCQ Section
                      Text(
                        'Questions',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...List.generate(
                        widget.assignment['questions'].length,
                        (index) {
                          final question = widget.assignment['questions'][index];
                          return _buildMCQQuestion(question, index);
                        },
                      ),
                      const SizedBox(height: 20),
                    ] else if (isFileUpload) ...[
                      // Instructions Section
                      Text(
                        'Instructions',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...List.generate(
                        widget.assignment['instructions'].length,
                        (index) {
                          final instruction =
                              widget.assignment['instructions'][index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  instruction['question'],
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  instruction['details'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),

                      // Your Submission Section
                      Text(
                        'Your Submission',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Uploaded Files
                      if (uploadedFiles.isNotEmpty)
                        ...List.generate(uploadedFiles.length, (index) {
                          final file = uploadedFiles[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color:
                                        const Color(0xFF42A5F5).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.file_present,
                                    size: 20,
                                    color: Color(0xFF42A5F5),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        file['name'] ?? 'File',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        file['type'] ?? 'Unknown',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _removeFile(index);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    child: const Icon(
                                      Icons.close,
                                      size: 18,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),

                      if (uploadedFiles.isEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.grey[300]!,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'No files uploaded yet',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),

                      const SizedBox(height: 20),
                    ],
                  ],
                ),
              ),
            ),

            // Upload/Submit Section at Bottom
            if (isMCQ)
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
                  child: ElevatedButton(
                    onPressed: () {
                      int answered =
                          selectedAnswers.values.where((v) => v != null).length;
                      int total = widget.assignment['questions'].length;

                      if (answered < total) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Please answer all $total questions ($answered/$total answered)'),
                            backgroundColor: Colors.orange,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                        return;
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('MCQ submitted with $answered/$total answers'),
                          backgroundColor: Colors.green,
                          duration: const Duration(seconds: 1),
                        ),
                      );

                      Future.delayed(const Duration(milliseconds: 500), () {
                        Navigator.of(context).pop();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF42A5F5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Submit MCQ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            else if (isFileUpload)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Colors.grey[200]!),
                  ),
                ),
                child: Column(
                  children: [
                    // Upload Options - Clean UI
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _pickFromCamera,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 14,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.camera_alt,
                                  size: 18,
                                  color: Colors.black54,
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  'Camera',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: _pickFromGallery,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 14,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.image,
                                  size: 18,
                                  color: Colors.black54,
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  'Gallery',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (uploadedFiles.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please upload at least one file'),
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors.orange,
                              ),
                            );
                            return;
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Assignment submitted with ${uploadedFiles.length} file(s)',
                              ),
                              duration: const Duration(seconds: 1),
                              backgroundColor: Colors.green,
                            ),
                          );

                          Future.delayed(const Duration(milliseconds: 500), () {
                            Navigator.of(context).pop();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF42A5F5),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Submit Assignment',
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
          ],
        ),
      ),
    );
  }

  Widget _buildMCQQuestion(Map<String, dynamic> question, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Q${question['id']}: ${question['question']}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          ...List.generate(
            question['options'].length,
            (optionIndex) {
              final option = question['options'][optionIndex];
              final isSelected = selectedAnswers[question['id']] == optionIndex;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedAnswers[question['id']] = optionIndex;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF42A5F5).withOpacity(0.15)
                        : Colors.white,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF42A5F5)
                          : Colors.grey[300]!,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF42A5F5)
                                : Colors.grey[400]!,
                            width: isSelected ? 6 : 2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          option,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: isSelected
                                ? const Color(0xFF42A5F5)
                                : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
