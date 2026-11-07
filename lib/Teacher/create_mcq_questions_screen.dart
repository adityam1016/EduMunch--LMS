import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_widgets.dart';

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
          SnackBar(
            content: const Text('Question updated'),
            backgroundColor: NMTheme.accentTeal,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      } else {
        _questions.add(question);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Question added to test'),
            backgroundColor: NMTheme.accentTeal,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
      _clearForm();
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
  }

  void _deleteQuestion(int index) {
    setState(() {
      _questions.removeAt(index);
      if (_editingIndex == index) {
        _clearForm();
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Question deleted'),
        backgroundColor: const Color(0xFFE53935),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _saveQuestions() {
    if (_questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please add at least one question'),
          backgroundColor: const Color(0xFFE53935),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    Get.back(result: _questions);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NMTheme.bg,
      body: SafeArea(
        child: Column(
          children: [
            NMAppBar(
              title: 'MCQ Builder',
              isRoot: false,
              onLeadingTap: () => Get.back(),
              onSearchTap: () {},
              onNotificationTap: () {},
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
                  children: [
                    _buildQuestionInputCard(),
                    const SizedBox(height: 24),
                    if (_questions.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Questions Bank',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: NMTheme.textDark,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: NMTheme.primaryPurple.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${_questions.length} Added',
                              style: const TextStyle(
                                color: NMTheme.primaryPurple,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ..._questions.asMap().entries.map((entry) {
                        return _buildQuestionCard(entry.key, entry.value);
                      }),
                    ],
                    if (_questions.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Container(
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
                            onTap: _saveQuestions,
                            borderRadius: BorderRadius.circular(16),
                            child: Center(
                              child: Text(
                                'Save ${_questions.length} Question${_questions.length > 1 ? 's' : ''}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionInputCard() {
    return NMCard(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(20),
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
                child: const Icon(Icons.quiz_outlined, color: NMTheme.primaryPurple, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                _editingIndex != null ? 'Edit Question #${_editingIndex! + 1}' : 'New Question',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: NMTheme.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          NMCard(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            borderRadius: BorderRadius.circular(14),
            child: TextFormField(
              controller: _questionController,
              maxLines: 3,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: NMTheme.textDark),
              decoration: const InputDecoration(
                hintText: 'Type question here...',
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
          const SizedBox(height: 16),
          const Text(
            'Options (Tap radio to mark correct answer)',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: NMTheme.textDark),
          ),
          const SizedBox(height: 10),
          _buildOptionField(0, _option1Controller, 'A'),
          const SizedBox(height: 8),
          _buildOptionField(1, _option2Controller, 'B'),
          const SizedBox(height: 8),
          _buildOptionField(2, _option3Controller, 'C'),
          const SizedBox(height: 8),
          _buildOptionField(3, _option4Controller, 'D'),
          const SizedBox(height: 14),
          Row(
            children: [
              const Text('Marks:', style: TextStyle(fontWeight: FontWeight.w700, color: NMTheme.textDark)),
              const SizedBox(width: 12),
              SizedBox(
                width: 70,
                child: NMCard(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  borderRadius: BorderRadius.circular(10),
                  child: TextFormField(
                    controller: _marksController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w800, color: NMTheme.textDark),
                    decoration: const InputDecoration(border: InputBorder.none),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _clearForm,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    side: BorderSide(color: Colors.grey.shade400),
                  ),
                  child: const Text('Reset', style: TextStyle(color: NMTheme.textSecondary, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _addOrUpdateQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: NMTheme.primaryPurple,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    _editingIndex != null ? 'Update Question' : 'Add Question',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ],
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
          activeColor: NMTheme.accentTeal,
        ),
        Expanded(
          child: NMCard(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            borderRadius: BorderRadius.circular(12),
            child: TextFormField(
              controller: controller,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: isCorrect ? FontWeight.w700 : FontWeight.w500,
                color: isCorrect ? NMTheme.accentTeal : NMTheme.textDark,
              ),
              decoration: InputDecoration(
                hintText: 'Option $label',
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
        ),
      ],
    );
  }

  Widget _buildQuestionCard(int index, Map<String, dynamic> question) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: NMCard(
        padding: const EdgeInsets.all(14),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    question['question'],
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14.5,
                      color: NMTheme.textDark,
                    ),
                  ),
                ),
                NMIconButton(
                  icon: Icons.edit_outlined,
                  size: 32,
                  iconSize: 17,
                  iconColor: NMTheme.primaryPurple,
                  onTap: () => _editQuestion(index),
                ),
                const SizedBox(width: 6),
                NMIconButton(
                  icon: Icons.delete_outline_rounded,
                  size: 32,
                  iconSize: 17,
                  iconColor: const Color(0xFFE53935),
                  onTap: () => _deleteQuestion(index),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...List.generate(4, (optIndex) {
              final isCorrect = question['correctAnswer'] == optIndex;
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isCorrect
                            ? NMTheme.accentTeal.withOpacity(0.15)
                            : NMTheme.surface,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        String.fromCharCode(65 + optIndex),
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
                        question['options'][optIndex],
                        style: TextStyle(
                          fontSize: 13,
                          color: isCorrect ? NMTheme.accentTeal : NMTheme.textDark,
                          fontWeight: isCorrect ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ),
                    if (isCorrect)
                      const Icon(Icons.check_circle_rounded, color: NMTheme.accentTeal, size: 16),
                  ],
                ),
              );
            }),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: NMTheme.primaryPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${question['marks']} Mark${question['marks'] > 1 ? 's' : ''}',
                style: const TextStyle(
                  color: NMTheme.primaryPurple,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
