import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateMcqQuestionsScreen extends StatefulWidget {
  final String assignmentTitle;

  const CreateMcqQuestionsScreen({
    super.key,
    required this.assignmentTitle,
  });

  @override
  State<CreateMcqQuestionsScreen> createState() =>
      _CreateMcqQuestionsScreenState();
}

class _CreateMcqQuestionsScreenState extends State<CreateMcqQuestionsScreen> {
  final List<Map<String, dynamic>> _questions = [];
  final _formKey = GlobalKey<FormState>();

  final _questionController = TextEditingController();
  final _option1Controller = TextEditingController();
  final _option2Controller = TextEditingController();
  final _option3Controller = TextEditingController();
  final _option4Controller = TextEditingController();
  final _marksController = TextEditingController(text: '1');

  int _correctAnswerIndex = 0;
  int? _editingIndex;

  @override
  void dispose() {
    _questionController.dispose();
    _option1Controller.dispose();
    _option2Controller.dispose();
    _option3Controller.dispose();
    _option4Controller.dispose();
    _marksController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _questionController.clear();
    _option1Controller.clear();
    _option2Controller.clear();
    _option3Controller.clear();
    _option4Controller.clear();
    _marksController.text = '1';
    _correctAnswerIndex = 0;
    _editingIndex = null;
    setState(() {});
  }

  void _addOrUpdateQuestion() {
    if (!_formKey.currentState!.validate()) return;

    final question = {
      'question': _questionController.text.trim(),
      'options': [
        _option1Controller.text.trim(),
        _option2Controller.text.trim(),
        _option3Controller.text.trim(),
        _option4Controller.text.trim(),
      ],
      'correctAnswer': _correctAnswerIndex,
      'marks': int.parse(_marksController.text),
    };

    setState(() {
      if (_editingIndex != null) {
        _questions[_editingIndex!] = question;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Question updated'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        _questions.add(question);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Question added'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      _clearForm();
    });

    // Scroll to bottom to show the new question
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 300),
        );
      }
    });
  }

  void _editQuestion(int index) {
    final question = _questions[index];
    setState(() {
      _editingIndex = index;
      _questionController.text = question['question'];
      _option1Controller.text = question['options'][0];
      _option2Controller.text = question['options'][1];
      _option3Controller.text = question['options'][2];
      _option4Controller.text = question['options'][3];
      _correctAnswerIndex = question['correctAnswer'];
      _marksController.text = question['marks'].toString();
    });

    // Scroll to top to show the form
    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _deleteQuestion(int index) {
    setState(() {
      _questions.removeAt(index);
      if (_editingIndex == index) {
        _clearForm();
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Question deleted'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _saveQuestions() {
    if (_questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one question'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Get.back(result: _questions);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'MCQ Questions',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              widget.assignmentTitle,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 12,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () => Get.back(),
        ),
        actions: [
          if (_questions.isNotEmpty)
            TextButton.icon(
              onPressed: _saveQuestions,
              icon: const Icon(Icons.check, color: Colors.green),
              label: const Text(
                'Save',
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildQuestionInputCard(),
            const SizedBox(height: 24),
            if (_questions.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Questions Added',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7C3AED).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_questions.length} Questions',
                      style: const TextStyle(
                        color: const Color(0xFF7C3AED),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ..._questions.asMap().entries.map((entry) {
                return _buildQuestionCard(entry.key, entry.value);
              }).toList(),
            ],
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: _questions.isNotEmpty
          ? Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: ElevatedButton.icon(
                onPressed: _saveQuestions,
                icon: const Icon(Icons.check, color: Colors.white),
                label: Text(
                  'Save ${_questions.length} Question${_questions.length > 1 ? 's' : ''}',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildQuestionInputCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7C3AED).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.quiz, color: const Color(0xFF7C3AED)),
                ),
                const SizedBox(width: 12),
                Text(
                  _editingIndex != null ? 'Edit Question' : 'Add New Question',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _questionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Question',
                hintText: 'Enter your question...',
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a question';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Options',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            _buildOptionField(0, _option1Controller, 'A'),
            const SizedBox(height: 8),
            _buildOptionField(1, _option2Controller, 'B'),
            const SizedBox(height: 8),
            _buildOptionField(2, _option3Controller, 'C'),
            const SizedBox(height: 8),
            _buildOptionField(3, _option4Controller, 'D'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _marksController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Marks',
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
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
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _clearForm,
                    icon: const Icon(Icons.clear),
                    label: const Text('Clear'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: _addOrUpdateQuestion,
                    icon: Icon(
                      _editingIndex != null ? Icons.update : Icons.add,
                      color: Colors.white,
                    ),
                    label: Text(
                      _editingIndex != null ? 'Update' : 'Add Question',
                      style: const TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7C3AED),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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

  Widget _buildOptionField(
    int index,
    TextEditingController controller,
    String label,
  ) {
    final isCorrect = _correctAnswerIndex == index;
    return Row(
      children: [
        Radio<int>(
          value: index,
          groupValue: _correctAnswerIndex,
          onChanged: (value) {
            setState(() {
              _correctAnswerIndex = value!;
            });
          },
          activeColor: Colors.green,
        ),
        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Option $label',
              hintText: 'Enter option...',
              filled: true,
              fillColor: isCorrect
                  ? Colors.green.withOpacity(0.05)
                  : Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isCorrect ? Colors.green : Colors.grey.shade300,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isCorrect ? Colors.green : Colors.grey.shade300,
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
    );
  }

  Widget _buildQuestionCard(int index, Map<String, dynamic> question) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7C3AED).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Q${index + 1}',
                    style: const TextStyle(
                      color: const Color(0xFF7C3AED),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    question['question'],
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _editQuestion(index),
                      color: const Color(0xFF7C3AED),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20),
                      onPressed: () => _deleteQuestion(index),
                      color: Colors.red,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...List.generate(4, (optIndex) {
              final isCorrect = question['correctAnswer'] == optIndex;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isCorrect
                            ? Colors.green.withOpacity(0.1)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: isCorrect ? Colors.green : Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        String.fromCharCode(65 + optIndex),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: isCorrect ? Colors.green : Colors.grey.shade700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        question['options'][optIndex],
                        style: TextStyle(
                          fontSize: 14,
                          color: isCorrect ? Colors.green : Colors.black87,
                          fontWeight: isCorrect ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                    if (isCorrect)
                      const Icon(Icons.check_circle, color: Colors.green, size: 18),
                  ],
                ),
              );
            }),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF7C3AED).withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${question['marks']} Mark${question['marks'] > 1 ? 's' : ''}',
                style: const TextStyle(
                  color: const Color(0xFF7C3AED),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
