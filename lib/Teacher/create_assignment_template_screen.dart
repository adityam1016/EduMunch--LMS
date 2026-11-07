import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'create_mcq_questions_screen.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_widgets.dart';

class CreateAssignmentTemplateScreen extends StatefulWidget {
  const CreateAssignmentTemplateScreen({super.key});

  @override
  State<CreateAssignmentTemplateScreen> createState() =>
      _CreateAssignmentTemplateScreenState();
}

class _CreateAssignmentTemplateScreenState
    extends State<CreateAssignmentTemplateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _totalMarksController = TextEditingController();
  final _durationController = TextEditingController();

  String _selectedType = 'Theory';
  String? _selectedSubject;
  List<Map<String, dynamic>> _mcqQuestions = [];

  final List<String> _subjects = [
    'Mathematics',
    'Physics',
    'Chemistry',
    'Biology',
    'English',
    'Computer Science',
  ];

  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _totalMarksController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _createMcqQuestions() async {
    if (_titleController.text.trim().isEmpty) {
      _showSnackbar('Please enter assignment title first', isError: true);
      return;
    }

    final result = await Get.to(() => CreateMcqQuestionsScreen(
          assignmentTitle: _titleController.text.trim(),
        ));

    if (result != null && result is List<Map<String, dynamic>>) {
      setState(() {
        _mcqQuestions = result;
        if (_mcqQuestions.isNotEmpty) {
          int totalMarks = _mcqQuestions.fold(
              0, (sum, q) => sum + (q['marks'] as int? ?? 0));
          _totalMarksController.text = totalMarks.toString();
        }
      });
    }
  }

  Future<void> _saveTemplate() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedSubject == null) {
      _showSnackbar('Please select a subject', isError: true);
      return;
    }

    if (_selectedType == 'MCQ' && _mcqQuestions.isEmpty) {
      _showSnackbar('Please add MCQ questions', isError: true);
      return;
    }

    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 600));

    final template = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'title': _titleController.text.trim(),
      'subject': _selectedSubject,
      'type': _selectedType,
      'totalMarks': int.parse(_totalMarksController.text),
      'description': _descriptionController.text.trim(),
      'duration': _durationController.text.trim(),
      'createdDate': DateTime.now(),
      'assignedTo': [],
      if (_selectedType == 'MCQ') ...{
        'totalQuestions': _mcqQuestions.length,
        'questions': _mcqQuestions,
      },
    };

    setState(() => _isSaving = false);
    Get.back(result: template);
  }

  void _showSnackbar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? const Color(0xFFE53935) : NMTheme.accentTeal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NMTheme.bg,
      body: SafeArea(
        child: Column(
          children: [
            NMAppBar(
              title: 'New Template',
              isRoot: false,
              onLeadingTap: () => Get.back(),
              onSearchTap: () {},
              onNotificationTap: () {},
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  children: [
                    _buildTypeSelector(),
                    const SizedBox(height: 20),
                    _buildSubjectDropdown(),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'Assignment Title',
                      hint: 'e.g., Quadratic Equations Practice',
                      controller: _titleController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter assignment title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'Description',
                      hint: 'Brief description of learning objectives...',
                      controller: _descriptionController,
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            label: 'Total Marks',
                            hint: '50',
                            controller: _totalMarksController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Required';
                              }
                              if (int.tryParse(value) == null) {
                                return 'Invalid';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            label: 'Duration',
                            hint: '60 mins',
                            controller: _durationController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    if (_selectedType == 'MCQ') ...[
                      _buildMcqSection(),
                    ],
                    const SizedBox(height: 24),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Assignment Format',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5, color: NMTheme.textDark),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildTypeCard(
                type: 'Theory',
                icon: Icons.description_outlined,
                accentColor: const Color(0xFFFB8C00),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTypeCard(
                type: 'MCQ',
                icon: Icons.quiz_outlined,
                accentColor: NMTheme.primaryPurple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeCard({
    required String type,
    required IconData icon,
    required Color accentColor,
  }) {
    final isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type;
          if (type == 'Theory') {
            _mcqQuestions = [];
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: isSelected ? NMTheme.surface : NMTheme.cardBg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    offset: const Offset(2, 2),
                    blurRadius: 4,
                  ),
                  const BoxShadow(
                    color: Colors.white,
                    offset: const Offset(-2, -2),
                    blurRadius: 4,
                  ),
                ]
              : NMTheme.cardShadows,
          border: isSelected ? Border.all(color: accentColor, width: 2) : Border.all(color: Colors.transparent),
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: isSelected ? accentColor : NMTheme.textSecondary),
            const SizedBox(height: 8),
            Text(
              type,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 15,
                color: isSelected ? accentColor : NMTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Subject',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5, color: NMTheme.textDark),
        ),
        const SizedBox(height: 8),
        NMCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          borderRadius: BorderRadius.circular(14),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<String>(
              value: _selectedSubject,
              hint: const Text('Select Subject', style: TextStyle(color: NMTheme.textSecondary)),
              isExpanded: true,
              decoration: const InputDecoration(border: InputBorder.none),
              items: _subjects
                  .map((subject) => DropdownMenuItem(
                        value: subject,
                        child: Text(
                          subject,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: NMTheme.textDark),
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSubject = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a subject';
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMcqSection() {
    return NMCard(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'MCQ Questions Pool',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: NMTheme.textDark),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: NMTheme.primaryPurple.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${_mcqQuestions.length} added',
                  style: const TextStyle(
                    color: NMTheme.primaryPurple,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: _createMcqQuestions,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: NMTheme.surface,
                borderRadius: BorderRadius.circular(14),
                boxShadow: NMTheme.cardShadows,
                border: Border.all(color: NMTheme.primaryPurple.withOpacity(0.3)),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _mcqQuestions.isEmpty ? Icons.add_circle_outline_rounded : Icons.edit_note_rounded,
                    color: NMTheme.primaryPurple,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _mcqQuestions.isEmpty ? 'Configure MCQ Questions' : 'Edit MCQ Questions',
                    style: const TextStyle(
                      color: NMTheme.primaryPurple,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: NMTheme.textDark),
        ),
        const SizedBox(height: 8),
        NMCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          borderRadius: BorderRadius.circular(14),
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: NMTheme.textDark),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: NMTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.normal),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        gradient: NMTheme.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: NMTheme.primaryPurple.withOpacity(0.35),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isSaving ? null : _saveTemplate,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: _isSaving
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_rounded, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Save Template',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
