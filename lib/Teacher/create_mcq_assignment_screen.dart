import 'package:flutter/material.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_widgets.dart';

class McqQuestion {
  String question;
  List<String> options;
  int correctAnswerIndex;

  McqQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
  });

  String get correctAnswer => options[correctAnswerIndex];
}

class CreateMcqAssignmentScreen extends StatefulWidget {
  final String assignmentTitle;
  const CreateMcqAssignmentScreen({super.key, required this.assignmentTitle});

  @override
  State<CreateMcqAssignmentScreen> createState() =>
      _CreateMcqAssignmentScreenState();
}

class _CreateMcqAssignmentScreenState extends State<CreateMcqAssignmentScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  int? _correctAnswerIndex;
  final List<McqQuestion> _savedQuestions = [];
  bool _isAddingQuestion = true;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _questionController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    _animationController.dispose();
    super.dispose();
  }

  void _clearFields() {
    _questionController.clear();
    for (var controller in _optionControllers) {
      controller.clear();
    }
    setState(() {
      _correctAnswerIndex = null;
    });
    _formKey.currentState?.reset();
  }

  void _addQuestion() {
    if (_formKey.currentState!.validate()) {
      if (_correctAnswerIndex == null) {
        _showSnackbar('Please select a correct answer', isError: true);
        return;
      }

      setState(() {
        _savedQuestions.add(McqQuestion(
          question: _questionController.text.trim(),
          options: _optionControllers.map((c) => c.text.trim()).toList(),
          correctAnswerIndex: _correctAnswerIndex!,
        ));
        _isAddingQuestion = false;
      });

      _clearFields();
      _showSnackbar('Question added successfully!');
      _animationController.forward(from: 0);
    }
  }

  void _editQuestion(int index) {
    final question = _savedQuestions[index];
    setState(() {
      _questionController.text = question.question;
      for (int i = 0; i < 4; i++) {
        _optionControllers[i].text = question.options[i];
      }
      _correctAnswerIndex = question.correctAnswerIndex;
      _savedQuestions.removeAt(index);
      _isAddingQuestion = true;
    });
  }

  void _deleteQuestion(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: NMTheme.bg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Delete Question', style: TextStyle(fontWeight: FontWeight.bold, color: NMTheme.textDark)),
        content: const Text('Are you sure you want to remove this question?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: NMTheme.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() {
                _savedQuestions.removeAt(index);
              });
              _showSnackbar('Question removed');
            },
            child: const Text('Delete', style: TextStyle(color: Color(0xFFE53935), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _saveAssignment() {
    if (_savedQuestions.isEmpty) {
      _showSnackbar('Please add at least one question', isError: true);
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: NMTheme.bg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Save MCQ Assignment', style: TextStyle(fontWeight: FontWeight.bold, color: NMTheme.textDark)),
        content: Text(
            'Save "${widget.assignmentTitle}" with ${_savedQuestions.length} questions?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: NMTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _showSnackbar('Assignment saved successfully!');
              Future.delayed(const Duration(milliseconds: 700), () {
                if (mounted) Navigator.of(context).pop();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: NMTheme.primaryPurple,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showSnackbar(String message, {bool isError = false}) {
    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? const Color(0xFFE53935) : NMTheme.accentTeal,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NMTheme.bg,
      body: SafeArea(
        child: Column(
          children: [
            NMAppBar(
              title: widget.assignmentTitle,
              isRoot: false,
              onLeadingTap: () {
                if (_savedQuestions.isEmpty &&
                    _questionController.text.isEmpty &&
                    _optionControllers.every((c) => c.text.isEmpty)) {
                  Navigator.pop(context);
                } else {
                  _showExitDialog();
                }
              },
              onSearchTap: () {},
              onNotificationTap: () {},
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildQuestionInputCard(),
                    const SizedBox(height: 24),
                    if (_savedQuestions.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Saved Questions',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: NMTheme.textDark,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _isAddingQuestion = true;
                              });
                            },
                            icon: const Icon(Icons.add_circle_outline_rounded, size: 18, color: NMTheme.primaryPurple),
                            label: const Text(
                              'Add More',
                              style: TextStyle(color: NMTheme.primaryPurple, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ..._savedQuestions.asMap().entries.map((entry) {
                        return _buildQuestionCard(entry.value, entry.key);
                      }),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _isAddingQuestion
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: NMTheme.primaryPurple.withOpacity(0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: FloatingActionButton.extended(
                onPressed: _addQuestion,
                icon: const Icon(Icons.add_rounded, color: Colors.white),
                label: const Text('Add Question', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                backgroundColor: NMTheme.primaryPurple,
                elevation: 0,
              ),
            )
          : null,
    );
  }

  Widget _buildQuestionInputCard() {
    return NMCard(
      padding: const EdgeInsets.all(18),
      borderRadius: BorderRadius.circular(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: NMTheme.surface,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: NMTheme.cardShadows,
                  ),
                  child: const Icon(Icons.edit_note_rounded, color: NMTheme.primaryPurple, size: 22),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Add New Question',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: NMTheme.textDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Question Text',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: NMTheme.textDark),
            ),
            const SizedBox(height: 6),
            NMCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              borderRadius: BorderRadius.circular(14),
              child: TextFormField(
                controller: _questionController,
                maxLines: 3,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: NMTheme.textDark),
                decoration: const InputDecoration(
                  hintText: 'Enter question text...',
                  hintStyle: TextStyle(color: NMTheme.textSecondary, fontSize: 13),
                  border: InputBorder.none,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a question';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Options (Choose radio for correct answer)',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: NMTheme.textDark),
            ),
            const SizedBox(height: 10),
            ..._buildOptionFields(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildOptionFields() {
    final optionLabels = ['A', 'B', 'C', 'D'];
    return List.generate(4, (index) {
      final isSelected = _correctAnswerIndex == index;
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Radio<int>(
              value: index,
              groupValue: _correctAnswerIndex,
              onChanged: (value) {
                setState(() {
                  _correctAnswerIndex = value;
                });
              },
              activeColor: NMTheme.accentTeal,
            ),
            Expanded(
              child: NMCard(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                borderRadius: BorderRadius.circular(12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isSelected ? NMTheme.accentTeal : NMTheme.surface,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        optionLabels[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : NMTheme.textDark,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _optionControllers[index],
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? NMTheme.accentTeal : NMTheme.textDark,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Option ${optionLabels[index]}',
                          hintStyle: const TextStyle(color: NMTheme.textSecondary, fontSize: 13),
                          border: InputBorder.none,
                        ),
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
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildQuestionCard(McqQuestion question, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: NMCard(
        padding: const EdgeInsets.all(14),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: NMTheme.primaryPurple.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Q${index + 1}',
                    style: const TextStyle(
                      color: NMTheme.primaryPurple,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    question.question,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5, color: NMTheme.textDark),
                  ),
                ),
                NMIconButton(
                  icon: Icons.edit_outlined,
                  size: 30,
                  iconSize: 16,
                  iconColor: NMTheme.primaryPurple,
                  onTap: () => _editQuestion(index),
                ),
                const SizedBox(width: 4),
                NMIconButton(
                  icon: Icons.delete_outline_rounded,
                  size: 30,
                  iconSize: 16,
                  iconColor: const Color(0xFFE53935),
                  onTap: () => _deleteQuestion(index),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...question.options.asMap().entries.map((entry) {
              final isCorrect = entry.key == question.correctAnswerIndex;
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isCorrect ? NMTheme.accentTeal.withOpacity(0.15) : NMTheme.surface,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        String.fromCharCode(65 + entry.key),
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                          color: isCorrect ? NMTheme.accentTeal : NMTheme.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isCorrect ? FontWeight.w700 : FontWeight.w500,
                          color: isCorrect ? NMTheme.accentTeal : NMTheme.textDark,
                        ),
                      ),
                    ),
                    if (isCorrect)
                      const Icon(Icons.check_circle_rounded, color: NMTheme.accentTeal, size: 16),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: NMTheme.bg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Discard Changes?', style: TextStyle(fontWeight: FontWeight.bold, color: NMTheme.textDark)),
        content: const Text('You have unsaved changes. Are you sure you want to exit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: NMTheme.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Discard', style: TextStyle(color: Color(0xFFE53935), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
