import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'teacher_app_drawer.dart';
import '../services/attendance_service.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_widgets.dart';

class ManageAttendanceScreen extends StatefulWidget {
  const ManageAttendanceScreen({super.key});

  @override
  State<ManageAttendanceScreen> createState() => _ManageAttendanceScreenState();
}

class _ManageAttendanceScreenState extends State<ManageAttendanceScreen> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedSession;

  final List<String> _sessions = [
    'Mathematics - 9:00 AM',
    'Physics - 11:00 AM',
    'Chemistry - 2:00 PM',
  ];

  final List<StudentAttendance> _students = [
    StudentAttendance(id: '2024001', name: 'Aarav Sharma', status: 'P'),
    StudentAttendance(id: '2024002', name: 'Priya Patel', status: 'P'),
    StudentAttendance(id: '2024003', name: 'Rohan Kumar', status: 'P'),
    StudentAttendance(id: '2024004', name: 'Sneha Singh', status: 'P'),
    StudentAttendance(id: '2024005', name: 'Arjun Mehta', status: 'A'),
    StudentAttendance(id: '2024006', name: 'Ananya Verma', status: 'L'),
    StudentAttendance(id: '2024007', name: 'Rahul Gupta', status: 'H'),
    StudentAttendance(id: '2024008', name: 'Kavya Reddy', status: 'P'),
  ];

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedSession = _sessions.first;
  }

  int get _totalStudents => _students.length;
  int get _presentCount => _students.where((s) => s.status == 'P').length;
  int get _absentCount => _students.where((s) => s.status == 'A').length;
  int get _lateCount => _students.where((s) => s.status == 'L').length;
  int get _halfDayCount => _students.where((s) => s.status == 'H').length;

  void _updateAttendanceStatus(StudentAttendance student, String newStatus) {
    setState(() {
      student.status = newStatus;
    });
  }

  void _markAllPresent() {
    setState(() {
      for (var student in _students) {
        student.status = 'P';
      }
    });
  }

  Future<void> _saveAttendance() async {
    setState(() => _isSubmitting = true);

    try {
      final sessionParts = (_selectedSession ?? 'General - 09:00 AM').split(' - ');
      final subject = sessionParts.first;
      final timeSlot = sessionParts.length > 1 ? sessionParts[1] : '09:00 AM';

      for (var student in _students) {
        String fullStatus = 'Present';
        if (student.status == 'A') fullStatus = 'Absent';
        if (student.status == 'L') fullStatus = 'Late';
        if (student.status == 'H') fullStatus = 'Excused';

        final email = '${student.name.toLowerCase().replaceAll(' ', '.')}@student.edumunch.com';

        await AttendanceService.markAttendance(
          studentEmail: email,
          subject: subject,
          status: fullStatus,
          timeSlot: timeSlot,
          markedBy: 'Teacher',
        );
      }
    } catch (_) {}

    if (mounted) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Attendance saved successfully!'),
          backgroundColor: NMTheme.accentTeal,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NMTheme.bg,
      drawer: const TeacherAppDrawer(),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                NMAppBar(
                  title: 'Attendance',
                  isRoot: true,
                  onSearchTap: () {},
                  onNotificationTap: () {},
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSessionDropdown(),
                        const SizedBox(height: 16),
                        _buildDateNavigation(),
                        const SizedBox(height: 20),
                        _buildAttendanceSummary(),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Student Roster',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: NMTheme.textDark,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: _isSubmitting ? null : _markAllPresent,
                              icon: const Icon(Icons.done_all_rounded, size: 16, color: NMTheme.accentTeal),
                              label: const Text(
                                'Mark All Present',
                                style: TextStyle(
                                  color: NMTheme.accentTeal,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ..._students.map((student) => _buildStudentCard(student)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: _buildSaveButton(),
            ),
            if (_isSubmitting)
              Container(
                color: Colors.black.withOpacity(0.25),
                child: Center(
                  child: NMCard(
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        CircularProgressIndicator(color: NMTheme.primaryPurple),
                        SizedBox(height: 16),
                        Text(
                          'Submitting Attendance...',
                          style: TextStyle(fontWeight: FontWeight.w600, color: NMTheme.textDark),
                        ),
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

  Widget _buildSessionDropdown() {
    return NMCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      borderRadius: BorderRadius.circular(16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: _selectedSession,
          hint: const Text('Select a Session', style: TextStyle(color: NMTheme.textSecondary)),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: NMTheme.primaryPurple),
          style: const TextStyle(
            color: NMTheme.textDark,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
          onChanged: _isSubmitting
              ? null
              : (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedSession = newValue;
                    });
                  }
                },
          items: _sessions.map<DropdownMenuItem<String>>((String session) {
            return DropdownMenuItem<String>(
              value: session,
              child: Row(
                children: [
                  const Icon(Icons.school_outlined, size: 18, color: NMTheme.primaryPurple),
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

  Widget _buildDateNavigation() {
    final String displayDate = DateFormat('EEEE, MMM d, yyyy').format(_selectedDate);
    return NMCard(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      borderRadius: BorderRadius.circular(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          NMIconButton(
            icon: Icons.chevron_left_rounded,
            size: 38,
            iconSize: 22,
            iconColor: NMTheme.primaryPurple,
            onTap: _isSubmitting ? () {} : () => _changeDate(-1),
          ),
          InkWell(
            onTap: _isSubmitting ? null : _showDatePicker,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month_outlined, size: 18, color: NMTheme.primaryPurple),
                  const SizedBox(width: 8),
                  Text(
                    displayDate,
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
            size: 38,
            iconSize: 22,
            iconColor: NMTheme.primaryPurple,
            onTap: _isSubmitting ? () {} : () => _changeDate(1),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceSummary() {
    return Row(
      children: [
        _buildMetricTile('Total', '$_totalStudents', NMTheme.textDark, Colors.grey.shade400),
        const SizedBox(width: 8),
        _buildMetricTile('Present', '$_presentCount', NMTheme.accentTeal, NMTheme.accentTeal),
        const SizedBox(width: 8),
        _buildMetricTile('Absent', '$_absentCount', const Color(0xFFE53935), const Color(0xFFE53935)),
        const SizedBox(width: 8),
        _buildMetricTile('Late', '$_lateCount', const Color(0xFFFB8C00), const Color(0xFFFB8C00)),
        const SizedBox(width: 8),
        _buildMetricTile('Half Day', '$_halfDayCount', NMTheme.primaryPurple, NMTheme.primaryPurple),
      ],
    );
  }

  Widget _buildMetricTile(String title, String count, Color countColor, Color accentColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: NMTheme.cardBg,
          borderRadius: BorderRadius.circular(14),
          boxShadow: NMTheme.cardShadows,
          border: Border.all(color: accentColor.withOpacity(0.2), width: 1.2),
        ),
        child: Column(
          children: [
            Text(
              count,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: countColor,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              title,
              style: const TextStyle(
                color: NMTheme.textSecondary,
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentCard(StudentAttendance student) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: NMCard(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        borderRadius: BorderRadius.circular(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: NMTheme.surface,
                      boxShadow: NMTheme.cardShadows,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      student.name[0].toUpperCase(),
                      style: const TextStyle(
                        color: NMTheme.primaryPurple,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14.5,
                            color: NMTheme.textDark,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Roll: ${student.id}',
                          style: const TextStyle(
                            color: NMTheme.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                _buildStatusButton('P', student, NMTheme.accentTeal),
                _buildStatusButton('A', student, const Color(0xFFE53935)),
                _buildStatusButton('L', student, const Color(0xFFFB8C00)),
                _buildStatusButton('H', student, NMTheme.primaryPurple),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusButton(String status, StudentAttendance student, Color color) {
    final bool isSelected = student.status == status;
    return GestureDetector(
      onTap: _isSubmitting ? null : () => _updateAttendanceStatus(student, status),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 3),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isSelected ? color : NMTheme.surface,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ]
              : NMTheme.cardShadows,
        ),
        alignment: Alignment.center,
        child: Text(
          status,
          style: TextStyle(
            color: isSelected ? Colors.white : NMTheme.textDark,
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
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
          onTap: _isSubmitting ? null : _saveAttendance,
          borderRadius: BorderRadius.circular(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_outline_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                _isSubmitting ? 'Saving...' : 'Save Attendance',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StudentAttendance {
  final String id;
  final String name;
  String status;

  StudentAttendance({
    required this.id,
    required this.name,
    required this.status,
  });
}
