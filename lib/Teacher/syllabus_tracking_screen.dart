import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'teacher_app_drawer.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_widgets.dart';

class SyllabusTrackingScreen extends StatefulWidget {
  const SyllabusTrackingScreen({super.key});

  @override
  State<SyllabusTrackingScreen> createState() => _SyllabusTrackingScreenState();
}

class _SyllabusTrackingScreenState extends State<SyllabusTrackingScreen> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedSession;
  String? _selectedSubject;
  String? _selectedTopic;
  String? _selectedSubTopic;
  bool _showManualSubtopic = false;

  final TextEditingController _manualSubTopicController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isSubmitting = false;

  final List<String> _sessions = [
    'Mathematics - 9:00 AM',
    'Physics - 11:00 AM',
    'Chemistry - 2:00 PM',
  ];

  final Map<String, List<String>> _subjectTopics = {
    'Mathematics': ['Algebra', 'Calculus', 'Geometry', 'Trigonometry'],
    'Physics': ['Mechanics', 'Thermodynamics', 'Optics', 'Electromagnetism'],
    'Chemistry': ['Organic Chemistry', 'Inorganic Chemistry', 'Physical Chemistry'],
  };

  final Map<String, List<String>> _topicSubTopics = {
    'Algebra': ['Linear Equations', 'Quadratic Equations', 'Polynomials'],
    'Calculus': ['Limits', 'Derivatives', 'Integrals'],
    'Mechanics': ['Motion', 'Force', 'Energy'],
    'Thermodynamics': ['Heat Transfer', 'Laws of Thermodynamics'],
  };

  final List<Map<String, String>> _recentRemarks = [
    {
      'topic': 'Calculus - Derivatives',
      'description': 'Covered basic derivative rules and chain rule with practical problem solving.',
      'date': '2 days ago',
    },
    {
      'topic': 'Algebra - Linear Equations',
      'description': 'Solved complex systems of linear equations with multiple variables.',
      'date': '5 days ago',
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedSession = _sessions.first;
    _extractSubjectFromSession();
  }

  @override
  void dispose() {
    _manualSubTopicController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _extractSubjectFromSession() {
    if (_selectedSession != null) {
      _selectedSubject = _selectedSession!.split(' - ')[0];
    }
  }

  void _changeDate(int days) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: days));
    });
  }

  Future<void> _showDatePicker() async {
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
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

    if (newDate != null && newDate != _selectedDate) {
      setState(() {
        _selectedDate = newDate;
      });
    }
  }

  Future<void> _saveSyllabus() async {
    if (_selectedTopic == null) {
      _showSnackbar('Please select a topic', isError: true);
      return;
    }

    if (_showManualSubtopic && _manualSubTopicController.text.trim().isEmpty) {
      _showSnackbar('Please enter the sub-topic', isError: true);
      return;
    }

    if (_descriptionController.text.trim().isEmpty) {
      _showSnackbar('Please enter a description', isError: true);
      return;
    }

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 600));

    if (mounted) {
      setState(() => _isSubmitting = false);
      _showSnackbar('Syllabus entry saved successfully!');
      _clearFields();
    }
  }

  void _clearFields() {
    setState(() {
      _selectedTopic = null;
      _selectedSubTopic = null;
      _showManualSubtopic = false;
      _manualSubTopicController.clear();
      _descriptionController.clear();
    });
  }

  void _showSnackbar(String message, {bool isError = false}) {
    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? const Color(0xFFE53935) : NMTheme.accentTeal,
          behavior: SnackBarBehavior.floating,
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
              title: 'Syllabus Tracker',
              isRoot: true,
              onSearchTap: () {},
              onNotificationTap: () {},
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSessionDropdown(),
                    const SizedBox(height: 14),
                    _buildDateSelector(),
                    const SizedBox(height: 20),
                    _buildRecentRemarksCard(),
                    const SizedBox(height: 24),
                    const Text(
                      'Log Class Coverage',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: NMTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildDisplayField(label: 'Subject', value: _selectedSubject ?? '-'),
                    const SizedBox(height: 14),
                    _buildTopicDropdown(),
                    const SizedBox(height: 14),
                    if (_selectedTopic != null &&
                        _topicSubTopics.containsKey(_selectedTopic)) ...[
                      _buildSubTopicDropdown(),
                      const SizedBox(height: 14),
                    ],
                    if (_showManualSubtopic ||
                        (_selectedTopic != null &&
                            !_topicSubTopics.containsKey(_selectedTopic))) ...[
                      _buildTextField(
                        label: 'Enter Sub-Topic Taught',
                        hint: 'Specify sub-topic name...',
                        controller: _manualSubTopicController,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 14),
                    ],
                    _buildTextField(
                      label: 'Lesson Overview & Homework',
                      hint: 'Describe lecture scope, key formulas derived, homework assigned...',
                      controller: _descriptionController,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 28),
                    _buildSaveButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionDropdown() {
    return NMCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      borderRadius: BorderRadius.circular(14),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: _selectedSession,
          hint: const Text('Select Lecture Session', style: TextStyle(color: NMTheme.textSecondary)),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: NMTheme.primaryPurple),
          style: const TextStyle(
            color: NMTheme.textDark,
            fontWeight: FontWeight.w700,
            fontSize: 14.5,
          ),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedSession = newValue;
                _extractSubjectFromSession();
                _clearFields();
              });
            }
          },
          items: _sessions.map<DropdownMenuItem<String>>((String session) {
            return DropdownMenuItem<String>(
              value: session,
              child: Row(
                children: [
                  const Icon(Icons.class_outlined, size: 18, color: NMTheme.primaryPurple),
                  const SizedBox(width: 10),
                  Text(session),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return NMCard(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      borderRadius: BorderRadius.circular(14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          NMIconButton(
            icon: Icons.chevron_left_rounded,
            size: 36,
            iconSize: 22,
            iconColor: NMTheme.primaryPurple,
            onTap: _isSubmitting ? () {} : () => _changeDate(-1),
          ),
          InkWell(
            onTap: _isSubmitting ? null : _showDatePicker,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_rounded, size: 16, color: NMTheme.primaryPurple),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('MMMM d, yyyy').format(_selectedDate),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: NMTheme.textDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
          NMIconButton(
            icon: Icons.chevron_right_rounded,
            size: 36,
            iconSize: 22,
            iconColor: NMTheme.primaryPurple,
            onTap: _isSubmitting ? () {} : () => _changeDate(1),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentRemarksCard() {
    if (_recentRemarks.isEmpty) return const SizedBox.shrink();
    final latest = _recentRemarks.first;

    return NMCard(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: NMTheme.accentTeal.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Latest Entry',
                  style: TextStyle(
                    color: NMTheme.accentTeal,
                    fontWeight: FontWeight.w800,
                    fontSize: 11.5,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                latest['date']!,
                style: const TextStyle(color: NMTheme.textSecondary, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            latest['topic']!,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: NMTheme.textDark),
          ),
          const SizedBox(height: 6),
          NMInsetContainer(
            padding: const EdgeInsets.all(10),
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                latest['description']!,
                style: const TextStyle(color: NMTheme.textSecondary, fontSize: 12.5, height: 1.35),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisplayField({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: NMTheme.textDark)),
        const SizedBox(height: 6),
        NMCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          borderRadius: BorderRadius.circular(14),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              value,
              style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: NMTheme.primaryPurple),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopicDropdown() {
    final topics = _selectedSubject != null
        ? (_subjectTopics[_selectedSubject] ?? [])
        : <String>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Topic Taught *',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: NMTheme.textDark),
        ),
        const SizedBox(height: 6),
        NMCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          borderRadius: BorderRadius.circular(14),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<String>(
              value: _selectedTopic,
              hint: const Text('Select Topic', style: TextStyle(color: NMTheme.textSecondary, fontSize: 13.5)),
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: NMTheme.primaryPurple),
              decoration: const InputDecoration(border: InputBorder.none),
              items: topics.map((String topic) {
                return DropdownMenuItem<String>(
                  value: topic,
                  child: Text(topic, style: const TextStyle(fontWeight: FontWeight.w600, color: NMTheme.textDark)),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedTopic = newValue;
                  _selectedSubTopic = null;
                  _showManualSubtopic = false;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubTopicDropdown() {
    final subTopics = _selectedTopic != null
        ? (_topicSubTopics[_selectedTopic] ?? [])
        : <String>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sub-Topic',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: NMTheme.textDark),
        ),
        const SizedBox(height: 6),
        NMCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          borderRadius: BorderRadius.circular(14),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<String>(
              value: _selectedSubTopic,
              hint: const Text('Select Sub-Topic', style: TextStyle(color: NMTheme.textSecondary, fontSize: 13.5)),
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: NMTheme.primaryPurple),
              decoration: const InputDecoration(border: InputBorder.none),
              items: [
                ...subTopics.map((String subTopic) {
                  return DropdownMenuItem<String>(
                    value: subTopic,
                    child: Text(subTopic, style: const TextStyle(fontWeight: FontWeight.w600, color: NMTheme.textDark)),
                  );
                }),
                const DropdownMenuItem<String>(
                  value: '__other__',
                  child: Text('+ Other (Manual Entry)', style: TextStyle(color: NMTheme.accentTeal, fontWeight: FontWeight.w700)),
                ),
              ],
              onChanged: (String? newValue) {
                setState(() {
                  if (newValue == '__other__') {
                    _selectedSubTopic = null;
                    _showManualSubtopic = true;
                  } else {
                    _selectedSubTopic = newValue;
                    _showManualSubtopic = false;
                  }
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          borderRadius: BorderRadius.circular(14),
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: NMTheme.textDark),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: NMTheme.textSecondary, fontSize: 13),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
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
          onTap: _isSubmitting ? null : _saveSyllabus,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: _isSubmitting
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.bookmark_added_rounded, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Save Syllabus Entry',
                        style: TextStyle(
                          fontSize: 15.5,
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
