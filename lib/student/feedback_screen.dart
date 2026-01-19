import 'package:flutter/material.dart';
import 'app_drawer.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  // Faculty list with Indian names
  final List<String> facultyList = [
    'Mr. Rajesh Kumar - Physics',
    'Mrs. Priya Sharma - Chemistry',
    'Dr. Arun Singh - Mathematics',
    'Ms. Neha Patel - Biology',
    'Mr. Vikram Desai - English',
    'Mrs. Anjali Nair - History',
    'Mr. Sanjay Gupta - Computer Science',
    'Dr. Kavya Iyer - Economics',
    'Mrs. Deepika Reddy - Geography',
    'Mr. Arjun Verma - Physical Education',
  ];

  String? selectedFaculty;

  // Rating variables
  int clarityRating = 0;
  int engagementRating = 0;
  int approachabilityRating = 0;

  // Text controllers
  final TextEditingController clarityFeedbackController = TextEditingController();
  final TextEditingController engagementFeedbackController = TextEditingController();
  final TextEditingController approachabilityFeedbackController = TextEditingController();
  final TextEditingController additionalFeedbackController = TextEditingController();

  @override
  void dispose() {
    clarityFeedbackController.dispose();
    engagementFeedbackController.dispose();
    approachabilityFeedbackController.dispose();
    additionalFeedbackController.dispose();
    super.dispose();
  }

  void _submitFeedback() {
    if (selectedFaculty == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a faculty member')),
      );
      return;
    }

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Feedback submitted successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    // Reset form
    setState(() {
      selectedFaculty = null;
      clarityRating = 0;
      engagementRating = 0;
      approachabilityRating = 0;
      clarityFeedbackController.clear();
      engagementFeedbackController.clear();
      approachabilityFeedbackController.clear();
      additionalFeedbackController.clear();
    });
  }

  Widget _buildStarRating(int currentRating, Function(int) onRatingChanged) {
    return Row(
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () => onRatingChanged(index + 1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon(
              index < currentRating ? Icons.star : Icons.star_outline,
              color: index < currentRating ? Colors.amber : Colors.grey,
              size: 28,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildFeedbackSection(
    String title,
    String question,
    int rating,
    Function(int) onRatingChanged,
    TextEditingController controller,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF7C3AED),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            question,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 12),
          _buildStarRating(rating, onRatingChanged),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'Optional: Provide specific examples...',
              hintStyle: const TextStyle(color: Color(0xFFAAAAAA)),
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Feedback'),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
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
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Description
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F3FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Your feedback helps us improve. Please be honest and constructive.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF7C3AED),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Select Faculty
            Text(
              'Select Faculty',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFDDDDDD),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                value: selectedFaculty,
                hint: const Text('Select a faculty member'),
                underline: const SizedBox(),
                items: facultyList.map((faculty) {
                  return DropdownMenuItem(
                    value: faculty,
                    child: Text(faculty),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedFaculty = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 32),

            // Clarity of Explanations
            _buildFeedbackSection(
              'Clarity of Explanations',
              'Were the concepts explained clearly and understandably?',
              clarityRating,
              (rating) => setState(() => clarityRating = rating),
              clarityFeedbackController,
            ),

            // Engagement
            _buildFeedbackSection(
              'Engagement',
              'How engaging and interactive were the lessons?',
              engagementRating,
              (rating) => setState(() => engagementRating = rating),
              engagementFeedbackController,
            ),

            // Approachability
            _buildFeedbackSection(
              'Approachability',
              'Did you feel comfortable approaching the teacher with doubts?',
              approachabilityRating,
              (rating) => setState(() => approachabilityRating = rating),
              approachabilityFeedbackController,
            ),

            // Additional Feedback
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Additional Feedback',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF7C3AED),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: additionalFeedbackController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Any other comments, suggestions, or praise?',
                      hintStyle: const TextStyle(color: Color(0xFFAAAAAA)),
                      filled: true,
                      fillColor: const Color(0xFFF5F5F5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _submitFeedback,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C3AED),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  'Submit Feedback',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
