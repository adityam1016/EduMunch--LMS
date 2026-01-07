import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'create_mcq_assignment_screen.dart';

enum AssignmentType { theory, mcq }

class UploadAssignmentScreen extends StatefulWidget {
  const UploadAssignmentScreen({super.key});

  @override
  State<UploadAssignmentScreen> createState() =>
      _UploadAssignmentScreenState();
}

class _UploadAssignmentScreenState extends State<UploadAssignmentScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Form Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _subTopicController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _maxMarksController = TextEditingController();

  String? _selectedBatch;
  AssignmentType _selectedType = AssignmentType.theory;
  DateTime? _dueDate;

  final List<String> _batches = [
    '11th JEE MAINS',
    '12th JEE ADVANCED',
    '10th BOARDS',
    'NEET Batch A',
    'NEET Batch B',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _titleController.dispose();
    _subjectController.dispose();
    _topicController.dispose();
    _subTopicController.dispose();
    _instructionsController.dispose();
    _dueDateController.dispose();
    _maxMarksController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blueAccent,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Colors.blueAccent,
                onPrimary: Colors.white,
                onSurface: Colors.black87,
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null && mounted) {
        setState(() {
          _dueDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _dueDateController.text =
              '${pickedDate.day}/${pickedDate.month}/${pickedDate.year} at ${pickedTime.format(context)}';
        });
      }
    }
  }

  void _proceedToNext() {
    if (_formKey.currentState!.validate()) {
      if (_selectedBatch == null) {
        _showSnackbar('Please select a batch', isError: true);
        return;
      }
      if (_dueDate == null) {
        _showSnackbar('Please select a due date', isError: true);
        return;
      }

      if (_selectedType == AssignmentType.mcq) {
        // Navigate to MCQ creation screen
        Get.to(
          () => CreateMcqAssignmentScreen(
            assignmentTitle: _titleController.text.trim(),
          ),
          transition: Transition.rightToLeft,
          duration: const Duration(milliseconds: 300),
        );
      } else {
        // For theory type, show success and go back
        _showSnackbar('Theory assignment created successfully!');
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) Get.back();
        });
      }
    }
  }

  void _showSnackbar(String message, {bool isError = false}) {
    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.redAccent : Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text(
          'Upload Assignment',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () => Get.back(),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('Assignment Details'),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _titleController,
                  label: 'Assignment Title',
                  hint: 'e.g., Chapter 5 - Thermodynamics',
                  icon: Icons.title_outlined,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _subjectController,
                  label: 'Subject',
                  hint: 'e.g., Physics',
                  icon: Icons.book_outlined,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _topicController,
                  label: 'Topic',
                  hint: 'e.g., Heat Transfer',
                  icon: Icons.topic_outlined,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _subTopicController,
                  label: 'Sub-Topic',
                  hint: 'e.g., Conduction',
                  icon: Icons.notes_outlined,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _instructionsController,
                  label: 'Instructions',
                  hint: 'Enter detailed instructions for students...',
                  icon: Icons.description_outlined,
                  maxLines: 4,
                ),
                const SizedBox(height: 24),
                _buildSectionHeader('Assignment Configuration'),
                const SizedBox(height: 16),
                _buildBatchDropdown(),
                const SizedBox(height: 16),
                _buildDueDateField(),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _maxMarksController,
                  label: 'Maximum Marks',
                  hint: 'e.g., 100',
                  icon: Icons.grade_outlined,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                _buildSectionHeader('Assignment Type'),
                const SizedBox(height: 16),
                _buildTypeSelector(),
                const SizedBox(height: 32),
                _buildSubmitButton(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Widget _buildBatchDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedBatch,
      decoration: InputDecoration(
        labelText: 'Select Batch',
        prefixIcon: const Icon(Icons.class_outlined, color: Colors.blueAccent),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      items: _batches.map((String batch) {
        return DropdownMenuItem<String>(
          value: batch,
          child: Text(batch),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedBatch = newValue;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Please select a batch';
        }
        return null;
      },
    );
  }

  Widget _buildDueDateField() {
    return TextFormField(
      controller: _dueDateController,
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Due Date & Time',
        hintText: 'Select due date and time',
        prefixIcon: const Icon(Icons.calendar_today_outlined,
            color: Colors.blueAccent),
        suffixIcon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      onTap: _selectDueDate,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a due date';
        }
        return null;
      },
    );
  }

  Widget _buildTypeSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          _buildTypeOption(
            type: AssignmentType.theory,
            title: 'Theory / Upload',
            subtitle: 'Students will write and upload their answers',
            icon: Icons.description_outlined,
            color: Colors.blue,
          ),
          Divider(height: 1, color: Colors.grey[300]),
          _buildTypeOption(
            type: AssignmentType.mcq,
            title: 'Multiple Choice Questions',
            subtitle: 'Create MCQ-based assignment with auto-grading',
            icon: Icons.quiz_outlined,
            color: Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildTypeOption({
    required AssignmentType type,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    final bool isSelected = _selectedType == type;
    return InkWell(
      onTap: () => setState(() => _selectedType = type),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected ? color.withOpacity(0.1) : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? color : Colors.grey[600],
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.black87 : Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Radio<AssignmentType>(
              value: type,
              groupValue: _selectedType,
              onChanged: (AssignmentType? value) {
                if (value != null) {
                  setState(() => _selectedType = value);
                }
              },
              activeColor: color,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _proceedToNext,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _selectedType == AssignmentType.mcq
                  ? 'Continue to Add Questions'
                  : 'Create Assignment',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward, size: 20),
          ],
        ),
      ),
    );
  }
}
