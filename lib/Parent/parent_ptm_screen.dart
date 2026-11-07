import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'parent_app_drawer.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_widgets.dart';

class ParentPTMScreen extends StatefulWidget {
  const ParentPTMScreen({super.key});

  @override
  State<ParentPTMScreen> createState() => _ParentPTMScreenState();
}

class _ParentPTMScreenState extends State<ParentPTMScreen> {
  bool _showScheduleForm = false;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _agendaController = TextEditingController();

  String _selectedRole = 'Subject Faculty';
  String _selectedTeacher = 'Prof. Aditya Mishra - Mathematics';
  String _selectedMode = 'Online';
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 17, minute: 0);

  final List<String> _roles = ['Subject Faculty', 'Admin Staff'];

  final Map<String, List<String>> _staffByRole = {
    'Subject Faculty': [
      'Prof. Aditya Mishra - Mathematics',
      'Dr. Rajesh Kumar - Physics',
      'Dr. Anjali Verma - Chemistry',
    ],
    'Admin Staff': [
      'Mr. Anil Kumar - Center Head',
      'Mrs. Reena Gupta - Academic Counselor',
    ],
  };

  bool _isSubmitting = false;

  final List<Map<String, dynamic>> meetings = [
    {
      'id': '1',
      'title': 'Academic Progress & Doubt Review',
      'teacherName': 'Prof. Aditya Mishra',
      'subject': 'Mathematics Faculty',
      'date': 'Tomorrow',
      'time': '05:00 PM',
      'duration': '30 mins',
      'status': 'Scheduled',
      'mode': 'Online',
      'meetingLink': 'https://meet.google.com/edumunch-ptm',
      'agenda': 'Review of student score in quadratic equations and calculus roadmap',
    },
    {
      'id': '2',
      'title': 'Physics Lab Performance Discussion',
      'teacherName': 'Dr. Rajesh Kumar',
      'subject': 'Physics Mentor',
      'date': '18 Jan 2026',
      'time': '02:00 PM',
      'duration': '30 mins',
      'status': 'Scheduled',
      'mode': 'In-Person',
      'room': 'Faculty Room 204',
      'agenda': 'Discussion on kinematics problem sets and time management',
    },
    {
      'id': '3',
      'title': 'Mid-Term Comprehensive Review',
      'teacherName': 'Dr. Anjali Verma',
      'subject': 'Chemistry Head',
      'date': '05 Jan 2026',
      'time': '11:00 AM',
      'duration': '30 mins',
      'status': 'Completed',
      'mode': 'In-Person',
      'room': 'Chemistry Lab',
      'agenda': 'Review of organic chemistry test results',
    },
  ];

  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Scheduled', 'Completed'];

  @override
  void dispose() {
    _titleController.dispose();
    _agendaController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
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
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
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
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _scheduleMeeting() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 600));

    final teacherNameParts = _selectedTeacher.split(' - ');

    setState(() {
      meetings.insert(0, {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': _titleController.text.trim(),
        'teacherName': teacherNameParts.first,
        'subject': teacherNameParts.length > 1 ? teacherNameParts[1] : 'Faculty',
        'date': '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
        'time': _selectedTime.format(context),
        'duration': '30 mins',
        'status': 'Scheduled',
        'mode': _selectedMode,
        'meetingLink': _selectedMode == 'Online' ? 'https://meet.google.com/new-meeting' : null,
        'room': _selectedMode == 'In-Person' ? 'Admin Block Room 102' : null,
        'agenda': _agendaController.text.trim(),
      });
      _isSubmitting = false;
      _showScheduleForm = false;
    });

    _titleController.clear();
    _agendaController.clear();

    Get.snackbar(
      'Meeting Requested',
      'Meeting slot booked with faculty. Link sent to registered email.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: NMTheme.accentTeal,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      borderRadius: 14,
    );
  }

  List<Map<String, dynamic>> get _filteredMeetings {
    if (_selectedFilter == 'All') return meetings;
    return meetings.where((m) => m['status'] == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const ParentAppDrawer(),
      backgroundColor: NMTheme.bg,
      body: SafeArea(
        child: Column(
          children: [
            NMAppBar(
              title: 'PTM Schedule',
              isRoot: true,
              onSearchTap: () {},
              onNotificationTap: () {},
            ),
            _buildFilterTabs(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
                child: Column(
                  children: [
                    if (_showScheduleForm) ...[
                      _buildScheduleMeetingForm(),
                      const SizedBox(height: 20),
                    ],
                    ..._filteredMeetings.map((m) => _buildMeetingCard(m)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: !_showScheduleForm
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
                onPressed: () => setState(() => _showScheduleForm = true),
                icon: const Icon(Icons.add_rounded, color: Colors.white),
                label: const Text('Schedule PTM', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                backgroundColor: NMTheme.primaryPurple,
                elevation: 0,
              ),
            )
          : null,
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;

          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8, top: 4, bottom: 4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? NMTheme.primaryPurple : NMTheme.cardBg,
                borderRadius: BorderRadius.circular(20),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: NMTheme.primaryPurple.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : NMTheme.cardShadows,
              ),
              alignment: Alignment.center,
              child: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? Colors.white : NMTheme.textDark,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  fontSize: 12.5,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildScheduleMeetingForm() {
    final staffList = _staffByRole[_selectedRole] ?? [];

    return NMCard(
      padding: const EdgeInsets.all(18),
      borderRadius: BorderRadius.circular(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Book Meeting Slot',
                  style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w800, color: NMTheme.textDark),
                ),
                NMIconButton(
                  icon: Icons.close_rounded,
                  size: 32,
                  iconSize: 18,
                  iconColor: NMTheme.textSecondary,
                  onTap: () => setState(() => _showScheduleForm = false),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Text('Faculty / Staff Member', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: NMTheme.textDark)),
            const SizedBox(height: 6),
            NMCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
              borderRadius: BorderRadius.circular(14),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: staffList.contains(_selectedTeacher) ? _selectedTeacher : (staffList.isNotEmpty ? staffList.first : null),
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: NMTheme.primaryPurple),
                  style: const TextStyle(fontWeight: FontWeight.w700, color: NMTheme.textDark, fontSize: 13.5),
                  items: staffList.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedTeacher = val);
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text('Agenda / Topic', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: NMTheme.textDark)),
            const SizedBox(height: 6),
            NMCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
              borderRadius: BorderRadius.circular(14),
              child: TextFormField(
                controller: _titleController,
                style: const TextStyle(fontSize: 13.5, color: NMTheme.textDark, fontWeight: FontWeight.w600),
                decoration: const InputDecoration(
                  hintText: 'e.g., Term 2 Test Review & Doubts',
                  hintStyle: TextStyle(color: NMTheme.textSecondary, fontSize: 13),
                  border: InputBorder.none,
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Date', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: NMTheme.textDark)),
                      const SizedBox(height: 6),
                      NMCard(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          onTap: _selectDate,
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today_rounded, size: 16, color: NMTheme.primaryPurple),
                              const SizedBox(width: 8),
                              Text('${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Time', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: NMTheme.textDark)),
                      const SizedBox(height: 6),
                      NMCard(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          onTap: _selectTime,
                          child: Row(
                            children: [
                              const Icon(Icons.access_time_rounded, size: 16, color: NMTheme.primaryPurple),
                              const SizedBox(width: 8),
                              Text(_selectedTime.format(context), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                gradient: NMTheme.primaryGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: NMTheme.primaryPurple.withOpacity(0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _isSubmitting ? null : _scheduleMeeting,
                  borderRadius: BorderRadius.circular(16),
                  child: Center(
                    child: _isSubmitting
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text(
                            'Confirm Meeting Booking',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeetingCard(Map<String, dynamic> m) {
    final isOnline = m['mode'] == 'Online';
    final isCompleted = m['status'] == 'Completed';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: NMCard(
        padding: const EdgeInsets.all(16),
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isOnline ? NMTheme.primaryPurple.withOpacity(0.12) : NMTheme.accentTeal.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isOnline ? Icons.videocam_rounded : Icons.apartment_rounded,
                    color: isOnline ? NMTheme.primaryPurple : NMTheme.accentTeal,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        m['title'],
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: NMTheme.textDark),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${m['teacherName']} • ${m['subject']}',
                        style: const TextStyle(fontSize: 12.5, color: NMTheme.textSecondary, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isCompleted ? NMTheme.accentTeal.withOpacity(0.12) : const Color(0xFFFB8C00).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    m['status'],
                    style: TextStyle(
                      color: isCompleted ? NMTheme.accentTeal : const Color(0xFFFB8C00),
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            NMInsetContainer(
              padding: const EdgeInsets.all(10),
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  'Agenda: ${m['agenda']}',
                  style: const TextStyle(color: NMTheme.textDark, fontSize: 12.5, height: 1.3),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded, size: 14, color: NMTheme.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      '${m['date']} • ${m['time']}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: NMTheme.textSecondary),
                    ),
                  ],
                ),
                if (isOnline && !isCompleted)
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.snackbar(
                        'Launching Meeting',
                        'Connecting to Google Meet room...',
                        backgroundColor: NMTheme.primaryPurple,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    icon: const Icon(Icons.video_call_rounded, size: 18),
                    label: const Text('Join Now', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: NMTheme.primaryPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      elevation: 0,
                    ),
                  )
                else
                  Text(
                    m['room'] ?? m['mode'],
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: NMTheme.primaryPurple),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
