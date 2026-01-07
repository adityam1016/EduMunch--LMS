import 'package:flutter/material.dart';

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
  List<McqQuestion> _savedQuestions = [];
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
        title: const Text('Delete Question'),
        content: const Text('Are you sure you want to delete this question?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() {
                _savedQuestions.removeAt(index);
              });
              _showSnackbar('Question deleted');
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
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

    // Here you would save the assignment
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Save Assignment'),
        content: Text(
            'Save "${widget.assignmentTitle}" with ${_savedQuestions.length} questions?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _showSnackbar('Assignment saved successfully!');
              Future.delayed(const Duration(seconds: 1), () {
                if (mounted) Navigator.of(context).pop();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
            ),
            child: const Text('Save'),
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
        title: Text(
          widget.assignmentTitle,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () {
            if (_savedQuestions.isEmpty &&
                _questionController.text.isEmpty &&
                _optionControllers.every((c) => c.text.isEmpty)) {
              Navigator.pop(context);
            } else {
              _showExitDialog();
            }
          },
        ),
        actions: [
          if (_savedQuestions.isNotEmpty)
            TextButton.icon(
              onPressed: _saveAssignment,
              icon: const Icon(Icons.save_outlined, size: 20),
              label: const Text('Save'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.blueAccent,
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Progress Indicator
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Icon(Icons.question_answer_outlined,
                    color: Colors.blueAccent, size: 20),
                const SizedBox(width: 8),
                Text(
                  '${_savedQuestions.length} Questions Added',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                if (_savedQuestions.isNotEmpty)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.green.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      'Ready to Save',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question Input Form
                  _buildQuestionInputCard(),
                  const SizedBox(height: 24),

                  // Saved Questions List
                  if (_savedQuestions.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Saved Questions',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              _isAddingQuestion = true;
                            });
                          },
                          icon: const Icon(Icons.add_circle_outline, size: 20),
                          label: const Text('Add More'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ..._savedQuestions.asMap().entries.map((entry) {
                      int index = entry.key;
                      McqQuestion question = entry.value;
                      return _buildQuestionCard(question, index);
                    }).toList(),
                    const SizedBox(height: 80),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _isAddingQuestion
          ? FloatingActionButton.extended(
              onPressed: _addQuestion,
              icon: const Icon(Icons.add),
              label: const Text('Add Question'),
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
            )
          : null,
    );
  }

  Widget _buildQuestionInputCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
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
                      color: Colors.blueAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.edit_outlined,
                        color: Colors.blueAccent, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Add New Question',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Question Text Field
              const Text(
                'Question',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _questionController,
                maxLines: 3,
                decoration: _inputDecoration(
                  hint: 'Enter your question here...',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a question';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Options
              const Text(
                'Options',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              ..._buildOptionFields(),

              const SizedBox(height: 16),

              // Correct Answer Info
              if (_correctAnswerIndex != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.green.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green[700], size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Correct Answer: ${String.fromCharCode(65 + _correctAnswerIndex!)}',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
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

  List<Widget> _buildOptionFields() {
    final optionLabels = ['A', 'B', 'C', 'D'];
    return List.generate(4, (index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
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
              activeColor: Colors.blueAccent,
            ),
            Expanded(
              child: TextFormField(
                controller: _optionControllers[index],
                decoration: _inputDecoration(
                  hint: 'Option ${optionLabels[index]}',
                  prefix: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: _correctAnswerIndex == index
                          ? Colors.blueAccent
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      optionLabels[index],
                      style: TextStyle(
                        color: _correctAnswerIndex == index
                            ? Colors.white
                            : Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
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
      );
    });
  }

  Widget _buildQuestionCard(McqQuestion question, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blueAccent.withOpacity(0.1),
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            question.question,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'Correct: ${String.fromCharCode(65 + question.correctAnswerIndex)}',
              style: TextStyle(
                color: Colors.green[700],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 20),
                color: Colors.blueAccent,
                onPressed: () => _editQuestion(index),
                tooltip: 'Edit',
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 20),
                color: Colors.redAccent,
                onPressed: () => _deleteQuestion(index),
                tooltip: 'Delete',
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const SizedBox(height: 12),
                  ...question.options.asMap().entries.map((entry) {
                    int optIndex = entry.key;
                    String option = entry.value;
                    bool isCorrect = optIndex == question.correctAnswerIndex;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: isCorrect
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.grey[100],
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: isCorrect
                                    ? Colors.green
                                    : Colors.grey[300]!,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                String.fromCharCode(65 + optIndex),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isCorrect
                                      ? Colors.green[700]
                                      : Colors.grey[700],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              option,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[800],
                                fontWeight: isCorrect
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          if (isCorrect)
                            Icon(Icons.check_circle,
                                color: Colors.green[700], size: 18),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint, Widget? prefix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      filled: true,
      fillColor: Colors.grey[50],
      prefix: prefix,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      errorStyle: const TextStyle(fontSize: 11),
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Discard Changes?'),
        content: const Text(
            'You have unsaved changes. Are you sure you want to exit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Discard', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
