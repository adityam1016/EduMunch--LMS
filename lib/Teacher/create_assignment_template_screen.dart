import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'create_mcq_questions_screen.dart';

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
    'Hindi',
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
        // Auto-calculate total marks based on questions
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

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

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

    // Return the template to the previous screen
    Get.back(result: template);
  }

  void _showSnackbar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text(
          'Create Assignment Template',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () => Get.back(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
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
              hint: 'Brief description of the assignment...',
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
              const SizedBox(height: 100),
            ] else ...[
              const SizedBox(height: 80),
            ],
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: ElevatedButton.icon(
          onPressed: _isSaving ? null : _saveTemplate,
          icon: _isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
              : const Icon(Icons.check, color: Colors.white),
          label: Text(
            _isSaving ? 'Creating...' : 'Create Template',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            disabledBackgroundColor: Colors.grey.shade400,
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Assignment Type',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildTypeCard(
                type: 'Theory',
                icon: Icons.description,
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTypeCard(
                type: 'MCQ',
                icon: Icons.quiz,
                color: const Color(0xFF7C3AED),
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
    required Color color,
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
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: isSelected ? color : Colors.grey),
            const SizedBox(height: 8),
            Text(
              type,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? color : Colors.grey,
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
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedSubject,
          hint: const Text('Select Subject'),
          isExpanded: true,
          decoration: _inputDecoration(),
          items: _subjects
              .map((subject) => DropdownMenuItem(
                    value: subject,
                    child: Text(subject),
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
      ],
    );
  }

  Widget _buildMcqSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'MCQ Questions',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              '${_mcqQuestions.length} Questions',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: _createMcqQuestions,
          icon: Icon(
            _mcqQuestions.isEmpty ? Icons.add : Icons.edit,
            color: Colors.white,
          ),
          label: Text(
            _mcqQuestions.isEmpty ? 'Add MCQ Questions' : 'Edit Questions',
            style: const TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7C3AED),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        if (_mcqQuestions.isNotEmpty) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Text(
                  '${_mcqQuestions.length} questions added',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
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
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: _inputDecoration(hint: hint),
          validator: validator,
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({String hint = ''}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: const Color(0xFF7C3AED), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }
}
