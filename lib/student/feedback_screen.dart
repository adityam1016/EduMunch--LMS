import 'package:flutter/material.dart';
import 'app_drawer.dart';
import 'package:get/get.dart';
import '../auth_controller.dart';
import '../services/feedback_service.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_widgets.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final List<String> facultyList = [
    'Dr. Rajesh Kumar - Physics',
    'Prof. Amit Sharma - Mathematics',
    'Dr. Priya Singh - Chemistry',
    'Ms. Neha Patel - Biology',
    'Mr. Sanjay Gupta - Computer Science',
  ];

  String? selectedFaculty;

  int clarityRating = 0;
  int engagementRating = 0;
  int approachabilityRating = 0;

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
    final authController = Get.find<AuthController>();
    final email = authController.email ?? 'student@edumunch.com';
    if (selectedFaculty == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a faculty member')),
      );
      return;
    }

    FeedbackService.submitFeedback(
      studentEmail: email,
      facultyName: selectedFaculty!,
      clarityRating: clarityRating,
      engagementRating: engagementRating,
      approachabilityRating: approachabilityRating,
      additionalComments: additionalFeedbackController.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Feedback submitted successfully!'),
        backgroundColor: Color(0xFF10B981),
      ),
    );

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
        final isFilled = index < currentRating;
        return GestureDetector(
          onTap: () => onRatingChanged(index + 1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon(
              isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
              color: isFilled ? const Color(0xFFD97706) : NMTheme.textMuted,
              size: 32,
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: NMCard(
        radius: 20,
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.bold,
                color: NMTheme.primaryPurple,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              question,
              style: const TextStyle(
                fontSize: 13,
                color: NMTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            _buildStarRating(rating, onRatingChanged),
            const SizedBox(height: 14),
            Container(
              decoration: NMTheme.insetDecoration(radius: 14),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              child: TextField(
                controller: controller,
                maxLines: 2,
                style: const TextStyle(fontSize: 13.5, color: NMTheme.textPrimary),
                decoration: const InputDecoration(
                  hintText: 'Optional: Provide specific examples...',
                  hintStyle: TextStyle(color: NMTheme.textMuted, fontSize: 13),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NMTheme.bg,
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            NMAppBar(
              title: 'Faculty Feedback',
              isRoot: false,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Info Card
                    NMCard(
                      radius: 20,
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: const [
                          Icon(Icons.shield_outlined, color: Color(0xFF7C3AED), size: 24),
                          SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              'Your ratings are confidential and directly help us maintain academic excellence.',
                              style: TextStyle(
                                fontSize: 13,
                                color: NMTheme.textSecondary,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    const NMSectionHeader(title: 'Select Faculty Member'),
                    const SizedBox(height: 10),

                    // Dropdown in Neumorphic Card
                    NMCard(
                      radius: 18,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: selectedFaculty,
                          hint: const Text('Choose a teacher or mentor', style: TextStyle(color: NMTheme.textMuted, fontSize: 14)),
                          items: facultyList.map((faculty) {
                            return DropdownMenuItem(
                              value: faculty,
                              child: Text(
                                faculty,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: NMTheme.textPrimary),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedFaculty = value;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Rating Sections
                    _buildFeedbackSection(
                      'Clarity of Explanations',
                      'Were core concepts and derivations articulated clearly?',
                      clarityRating,
                      (rating) => setState(() => clarityRating = rating),
                      clarityFeedbackController,
                    ),

                    _buildFeedbackSection(
                      'Student Engagement',
                      'Did the faculty encourage problem-solving and participation?',
                      engagementRating,
                      (rating) => setState(() => engagementRating = rating),
                      engagementFeedbackController,
                    ),

                    _buildFeedbackSection(
                      'Approachability & Doubt Clearing',
                      'Was the teacher patient and accessible for clearing doubts?',
                      approachabilityRating,
                      (rating) => setState(() => approachabilityRating = rating),
                      approachabilityFeedbackController,
                    ),

                    // Additional Comments
                    NMCard(
                      radius: 20,
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Additional Comments',
                            style: TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.bold,
                              color: NMTheme.primaryPurple,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            decoration: NMTheme.insetDecoration(radius: 14),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            child: TextField(
                              controller: additionalFeedbackController,
                              maxLines: 3,
                              style: const TextStyle(fontSize: 13.5, color: NMTheme.textPrimary),
                              decoration: const InputDecoration(
                                hintText: 'Any other recommendations, notes, or praise...',
                                hintStyle: TextStyle(color: NMTheme.textMuted, fontSize: 13),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Submit Button
                    GestureDetector(
                      onTap: _submitFeedback,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF381868), Color(0xFF4C218E)],
                          ),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: NMTheme.coloredCardShadow(const Color(0xFF381868), opacity: 0.4),
                        ),
                        alignment: Alignment.center,
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
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
