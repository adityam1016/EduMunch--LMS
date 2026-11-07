import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'create_mcq_assignment_screen.dart';
import 'teacher_app_drawer.dart';
import '../services/assignment_service.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_widgets.dart';

enum AssignmentType { theory, mcq }

class UploadAssignmentScreen extends StatefulWidget {
  const UploadAssignmentScreen({super.key});

  @override
  State<UploadAssignmentScreen> createState() => _UploadAssignmentScreenState();
}

class _UploadAssignmentScreenState extends State<UploadAssignmentScreen> {
  final _formKey = GlobalKey<FormState>();

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
  void dispose() {
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
              primary: NMTheme.primaryPurple,
              onPrimary: Colors.white,
              onSurface: NMTheme.textDark,
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
                primary: NMTheme.primaryPurple,
                onPrimary: Colors.white,
                onSurface: NMTheme.textDark,
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
        Get.to(
          () => CreateMcqAssignmentScreen(
            assignmentTitle: _titleController.text.trim(),
          ),
          transition: Transition.rightToLeft,
          duration: const Duration(milliseconds: 300),
        );
      } else {
        AssignmentService.createAssignment(
          title: _titleController.text.trim(),
          subject: _subjectController.text.trim(),
          description: _instructionsController.text.trim(),
          dueDate: _dueDate!,
          totalMarks: int.tryParse(_maxMarksController.text.trim()) ?? 100,
          createdBy: 'Teacher',
        );
        _showSnackbar('Theory assignment created and saved!');
        Future.delayed(const Duration(milliseconds: 800), () {
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
          backgroundColor: isError ? const Color(0xFFE53935) : NMTheme.accentTeal,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const TeacherAppDrawer(),
      backgroundColor: NMTheme.bg,
      body: SafeArea(
        child: Column(
          children: [
            NMAppBar(
              title: 'Upload Assignment',
              isRoot: true,
              onSearchTap: () {},
              onNotificationTap: () {},
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader('Assignment Details'),
                      const SizedBox(height: 14),
                      _buildTextField(
                        controller: _titleController,
                        label: 'Assignment Title',
                        hint: 'e.g., Chapter 5 - Thermodynamics',
                        icon: Icons.title_rounded,
                      ),
                      const SizedBox(height: 14),
                      _buildTextField(
                        controller: _subjectController,
                        label: 'Subject',
                        hint: 'e.g., Physics',
                        icon: Icons.school_outlined,
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _topicController,
                              label: 'Topic',
                              hint: 'Heat Transfer',
                              icon: Icons.topic_outlined,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTextField(
                              controller: _subTopicController,
                              label: 'Sub-Topic',
                              hint: 'Conduction',
                              icon: Icons.notes_rounded,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _buildTextField(
                        controller: _instructionsController,
                        label: 'Instructions',
                        hint: 'Enter detailed guidance and submission requirements...',
                        icon: Icons.description_outlined,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 24),
                      _buildSectionHeader('Configuration & Deadlines'),
                      const SizedBox(height: 14),
                      _buildBatchDropdown(),
                      const SizedBox(height: 14),
                      _buildDueDateField(),
                      const SizedBox(height: 14),
                      _buildTextField(
                        controller: _maxMarksController,
                        label: 'Maximum Marks',
                        hint: '100',
                        icon: Icons.grade_outlined,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 24),
                      _buildSectionHeader('Assignment Format'),
                      const SizedBox(height: 14),
                      _buildTypeSelector(),
                      const SizedBox(height: 28),
                      _buildSubmitButton(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: NMTheme.primaryPurple,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.w800,
            color: NMTheme.textDark,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: NMTheme.textDark),
        ),
        const SizedBox(height: 6),
        NMCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          borderRadius: BorderRadius.circular(14),
          child: Row(
            crossAxisAlignment: maxLines > 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: maxLines > 1 ? 12 : 0, right: 10),
                child: Icon(icon, color: NMTheme.primaryPurple, size: 20),
              ),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  maxLines: maxLines,
                  keyboardType: keyboardType,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: NMTheme.textDark),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: const TextStyle(color: NMTheme.textSecondary, fontSize: 13),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter $label';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBatchDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Target Batch',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: NMTheme.textDark),
        ),
        const SizedBox(height: 6),
        NMCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          borderRadius: BorderRadius.circular(14),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<String>(
              value: _selectedBatch,
              hint: const Text('Select Batch', style: TextStyle(color: NMTheme.textSecondary, fontSize: 13.5)),
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: NMTheme.primaryPurple),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.groups_outlined, color: NMTheme.primaryPurple, size: 20),
                border: InputBorder.none,
              ),
              items: _batches.map((String batch) {
                return DropdownMenuItem<String>(
                  value: batch,
                  child: Text(batch, style: const TextStyle(fontWeight: FontWeight.w600, color: NMTheme.textDark)),
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
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDueDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Due Date & Time',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: NMTheme.textDark),
        ),
        const SizedBox(height: 6),
        NMCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          borderRadius: BorderRadius.circular(14),
          child: TextFormField(
            controller: _dueDateController,
            readOnly: true,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: NMTheme.textDark),
            decoration: const InputDecoration(
              hintText: 'Select due date and time',
              hintStyle: TextStyle(color: NMTheme.textSecondary, fontSize: 13),
              prefixIcon: Icon(Icons.calendar_month_outlined, color: NMTheme.primaryPurple, size: 20),
              suffixIcon: Icon(Icons.arrow_drop_down_rounded, color: NMTheme.primaryPurple),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
            onTap: _selectDueDate,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a due date';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTypeSelector() {
    return Row(
      children: [
        Expanded(
          child: _buildTypeOption(
            type: AssignmentType.theory,
            title: 'Theory',
            subtitle: 'File submission',
            icon: Icons.description_outlined,
            accentColor: const Color(0xFFFB8C00),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildTypeOption(
            type: AssignmentType.mcq,
            title: 'MCQ Quiz',
            subtitle: 'Auto-graded',
            icon: Icons.quiz_outlined,
            accentColor: NMTheme.primaryPurple,
          ),
        ),
      ],
    );
  }

  Widget _buildTypeOption({
    required AssignmentType type,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
  }) {
    final bool isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? NMTheme.surface : NMTheme.cardBg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
              ? [
                  BoxShadow(color: Colors.black.withOpacity(0.06), offset: const Offset(2, 2), blurRadius: 4),
                  const BoxShadow(color: Colors.white, offset: Offset(-2, -2), blurRadius: 4),
                ]
              : NMTheme.cardShadows,
          border: isSelected ? Border.all(color: accentColor, width: 2) : Border.all(color: Colors.transparent),
        ),
        child: Column(
          children: [
            Icon(icon, size: 26, color: isSelected ? accentColor : NMTheme.textSecondary),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 14.5,
                color: isSelected ? accentColor : NMTheme.textDark,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 11, color: NMTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
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
          onTap: _proceedToNext,
          borderRadius: BorderRadius.circular(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _selectedType == AssignmentType.mcq
                    ? 'Continue to Add Questions'
                    : 'Publish Assignment',
                style: const TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
