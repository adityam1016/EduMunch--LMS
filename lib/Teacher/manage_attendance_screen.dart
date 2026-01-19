import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'teacher_app_drawer.dart';

class ManageAttendanceScreen extends StatefulWidget {
  const ManageAttendanceScreen({super.key});

  @override
  State<ManageAttendanceScreen> createState() => _ManageAttendanceScreenState();
}

class _ManageAttendanceScreenState extends State<ManageAttendanceScreen> {
  // State
  DateTime _selectedDate = DateTime.now();
  String? _selectedSession;
  
  // Sample data - Replace with actual API data
  final List<String> _sessions = [
    'Mathematics - 9:00 AM',
    'Physics - 11:00 AM',
    'Chemistry - 2:00 PM',
  ];

  final List<StudentAttendance> _students = [
    StudentAttendance(id: '1', name: 'Aarav Sharma', status: 'P'),
    StudentAttendance(id: '2', name: 'Priya Patel', status: 'P'),
    StudentAttendance(id: '3', name: 'Rohan Kumar', status: 'P'),
    StudentAttendance(id: '4', name: 'Sneha Singh', status: 'P'),
    StudentAttendance(id: '5', name: 'Arjun Mehta', status: 'A'),
    StudentAttendance(id: '6', name: 'Ananya Verma', status: 'L'),
    StudentAttendance(id: '7', name: 'Rahul Gupta', status: 'H'),
    StudentAttendance(id: '8', name: 'Kavya Reddy', status: 'P'),
  ];

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedSession = _sessions.first;
  }

  // Attendance counts
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

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Attendance saved successfully!'),
          backgroundColor: Colors.green,
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
              primary: const Color(0xFF7C3AED),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const TeacherAppDrawer(),
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text(
          'Manage Attendance',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black54),
            onPressed: _isSubmitting ? null : () {
              // Refresh data
            },
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _buildSessionDropdown(),
              const SizedBox(height: 16),
              _buildDateNavigation(),
              const SizedBox(height: 16),
              Expanded(child: _buildBodyContent()),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildSaveButton(),
          ),
          if (_isSubmitting)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text("Submitting Attendance...")
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSessionDropdown() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
      child: Container(
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
            hint: const Text("Select a Session"),
            icon: const Icon(Icons.keyboard_arrow_down),
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 16,
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
                child: Text(
                  session,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildDateNavigation() {
    final String displayDate = DateFormat('MMMM d, yyyy').format(_selectedDate);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            onPressed: _isSubmitting ? null : () => _changeDate(-1),
          ),
          Expanded(
            child: InkWell(
              onTap: _isSubmitting ? null : _showDatePicker,
              child: Center(
                child: Text(
                  displayDate,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 20),
            onPressed: _isSubmitting ? null : () => _changeDate(1),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 90, left: 16, right: 16, top: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAttendanceSummary(),
          const SizedBox(height: 24),
          const Text(
            'Student List',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildMarkAllPresentButton(),
          const SizedBox(height: 20),
          ..._students.map((student) => _buildStudentCard(student)).toList(),
        ],
      ),
    );
  }

  Widget _buildAttendanceSummary() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSummaryCard('Total', _totalStudents, Colors.grey),
            _buildSummaryCard('Present', _presentCount, Colors.green),
            _buildSummaryCard('Absent', _absentCount, Colors.red),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSummaryCard('Late', _lateCount, Colors.orange),
            _buildSummaryCard('Half Day', _halfDayCount, const Color(0xFF7C3AED)),
            // Empty card for balance
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, int count, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 3,
              offset: const Offset(0, 1),
            )
          ],
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarkAllPresentButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: _isSubmitting ? null : _markAllPresent,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(color: const Color(0xFFDDD6FE)),
        ),
        child: const Text(
          'Mark All Present',
          style: TextStyle(
            color: const Color(0xFF7C3AED),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildStudentCard(StudentAttendance student) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFF7C3AED).withOpacity(0.1),
                child: Text(
                  student.name[0].toUpperCase(),
                  style: const TextStyle(
                    color: const Color(0xFF7C3AED),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'ID: ${student.id}',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              _buildStatusButton('P', student, Colors.green),
              _buildStatusButton('A', student, Colors.red),
              _buildStatusButton('L', student, Colors.orange),
              _buildStatusButton('H', student, const Color(0xFF7C3AED)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusButton(
      String status, StudentAttendance student, Color color) {
    final bool isSelected = student.status == status;
    return GestureDetector(
      onTap: _isSubmitting ? null : () => _updateAttendanceStatus(student, status),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: isSelected ? Border.all(color: color, width: 2) : null,
        ),
        alignment: Alignment.center,
        child: Text(
          status,
          style: TextStyle(
            color: isSelected ? Colors.white : color,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          )
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: _isSubmitting ? null : _saveAttendance,
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        label: Text(
          _isSubmitting ? 'Saving...' : 'Save Attendance',
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7C3AED),
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          disabledBackgroundColor: Colors.grey.shade400,
        ),
      ),
    );
  }
}

// Student Attendance Model
class StudentAttendance {
  final String id;
  final String name;
  String status; // P, A, L, H

  StudentAttendance({
    required this.id,
    required this.name,
    required this.status,
  });
}
