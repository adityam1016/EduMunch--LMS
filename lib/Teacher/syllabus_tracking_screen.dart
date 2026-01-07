import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

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

  // Sample data - Replace with actual API data
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
      'description': 'Covered basic derivative rules and chain rule',
      'date': '2 days ago',
    },
    {
      'topic': 'Algebra - Linear Equations',
      'description': 'Solved complex linear equations with multiple variables',
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
              primary: Colors.blueAccent,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
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

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

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
          backgroundColor: isError ? Colors.redAccent : Colors.green,
          behavior: SnackBarBehavior.floating,
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
          'Syllabus Tracking',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSessionDropdown(),
            const SizedBox(height: 16),
            _buildDateSelector(),
            const SizedBox(height: 24),
            _buildRecentRemarksCard(),
            const SizedBox(height: 24),
            const Text(
              'Syllabus Entry',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildDisplayField(label: 'Subject', value: _selectedSubject ?? '-'),
            const SizedBox(height: 16),
            _buildTopicDropdown(),
            const SizedBox(height: 16),
            if (_selectedTopic != null &&
                _topicSubTopics.containsKey(_selectedTopic)) ...[
              _buildSubTopicDropdown(),
              const SizedBox(height: 16),
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
              const SizedBox(height: 16),
            ],
            _buildTextField(
              label: 'Description / Details',
              hint: 'Describe what was taught in detail...',
              controller: _descriptionController,
              maxLines: 4,
            ),
            const SizedBox(height: 80),
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
          onPressed: _isSubmitting ? null : _saveSyllabus,
          icon: _isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
              : const Icon(Icons.save_alt_rounded, color: Colors.white),
          label: Text(
            _isSubmitting ? 'Saving...' : 'Save Syllabus Entry',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
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

  Widget _buildSessionDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: _selectedSession,
          hint: const Text('Select Lecture Session'),
          icon: const Icon(Icons.keyboard_arrow_down),
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 16,
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
              child: Text(
                session,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _isSubmitting ? null : () => _changeDate(-1),
          ),
          Expanded(
            child: InkWell(
              onTap: _isSubmitting ? null : _showDatePicker,
              child: Center(
                child: Text(
                  DateFormat('MMMM d, yyyy').format(_selectedDate),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _isSubmitting ||
                    DateUtils.isSameDay(_selectedDate, DateTime.now())
                ? null
                : () => _changeDate(1),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentRemarksCard() {
    if (_recentRemarks.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.grey.shade600),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'No remarks for this session yet.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      );
    }

    final latest = _recentRemarks.first;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Latest Remark',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  latest['date']!,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              latest['topic']!,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 6),
            Text(
              latest['description']!,
              style: const TextStyle(color: Colors.black87, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisplayField({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: value == '-' ? Colors.grey[600] : Colors.black87,
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
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedTopic,
          hint: const Text('Select Topic'),
          isExpanded: true,
          decoration: _inputDecoration(),
          onChanged: _isSubmitting || topics.isEmpty
              ? null
              : (String? newValue) {
                  setState(() {
                    _selectedTopic = newValue;
                    _selectedSubTopic = null;
                    _showManualSubtopic = false;
                    _manualSubTopicController.clear();
                  });
                },
          items: topics
              .map<DropdownMenuItem<String>>(
                (String topic) => DropdownMenuItem<String>(
                  value: topic,
                  child: Text(topic, style: const TextStyle(fontSize: 16)),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildSubTopicDropdown() {
    final subTopics = _topicSubTopics[_selectedTopic] ?? [];
    final itemsWithOther = [...subTopics, 'Other (Enter Manually)...'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sub-Topic (Optional)',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedSubTopic,
          hint: const Text('Select Sub-Topic (or Other)'),
          isExpanded: true,
          decoration: _inputDecoration(),
          onChanged: _isSubmitting
              ? null
              : (String? newValue) {
                  setState(() {
                    _selectedSubTopic = newValue;
                    _showManualSubtopic =
                        newValue == 'Other (Enter Manually)...';
                    if (!_showManualSubtopic) {
                      _manualSubTopicController.clear();
                    }
                  });
                },
          items: itemsWithOther
              .map<DropdownMenuItem<String>>(
                (String subTopic) => DropdownMenuItem<String>(
                  value: subTopic,
                  child: Text(
                    subTopic,
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: subTopic == 'Other (Enter Manually)...'
                          ? FontStyle.italic
                          : FontStyle.normal,
                      color: subTopic == 'Other (Enter Manually)...'
                          ? Colors.grey[700]
                          : Colors.black87,
                    ),
                  ),
                ),
              )
              .toList(),
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
        Text('$label *', style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          readOnly: _isSubmitting,
          decoration: _inputDecoration(hint: hint),
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
        borderSide: const BorderSide(color: Colors.blueAccent, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2.0),
      ),
    );
  }
}
