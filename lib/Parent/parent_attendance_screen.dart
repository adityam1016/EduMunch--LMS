import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'parent_app_drawer.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_widgets.dart';

class ParentAttendanceScreen extends StatefulWidget {
  const ParentAttendanceScreen({super.key});

  @override
  State<ParentAttendanceScreen> createState() => _ParentAttendanceScreenState();
}

class _ParentAttendanceScreenState extends State<ParentAttendanceScreen> {
  DateTime _selectedWeekStart = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));

  final Map<String, List<Map<String, dynamic>>> weeklyTimetable = {
    'Monday': [
      {
        'subject': 'Mathematics',
        'teacher': 'Prof. Aditya Mishra',
        'time': '08:00 AM - 09:00 AM',
        'room': 'Room 301',
        'status': 'Present',
      },
      {
        'subject': 'Physics',
        'teacher': 'Dr. Rajesh Kumar',
        'time': '09:00 AM - 10:00 AM',
        'room': 'Lab 1',
        'status': 'Present',
      },
      {
        'subject': 'English',
        'teacher': 'Mrs. Sunita Rao',
        'time': '11:00 AM - 12:00 PM',
        'room': 'Room 205',
        'status': 'Present',
      },
      {
        'subject': 'Chemistry',
        'teacher': 'Dr. Anjali Verma',
        'time': '01:00 PM - 02:00 PM',
        'room': 'Lab 2',
        'status': 'Present',
      },
    ],
    'Tuesday': [
      {
        'subject': 'Biology',
        'teacher': 'Mr. Vikram Singh',
        'time': '08:00 AM - 09:00 AM',
        'room': 'Lab 3',
        'status': 'Absent',
      },
      {
        'subject': 'Mathematics',
        'teacher': 'Prof. Aditya Mishra',
        'time': '09:00 AM - 10:00 AM',
        'room': 'Room 301',
        'status': 'Present',
      },
      {
        'subject': 'Computer Science',
        'teacher': 'Prof. Rahul Tiwari',
        'time': '11:00 AM - 12:00 PM',
        'room': 'Computer Lab',
        'status': 'Present',
      },
    ],
    'Wednesday': [
      {
        'subject': 'Physics Lab',
        'teacher': 'Dr. Rajesh Kumar',
        'time': '08:00 AM - 09:00 AM',
        'room': 'Lab 1',
        'status': 'Present',
      },
      {
        'subject': 'Mathematics',
        'teacher': 'Prof. Aditya Mishra',
        'time': '09:00 AM - 10:00 AM',
        'room': 'Room 301',
        'status': 'Present',
      },
      {
        'subject': 'Chemistry',
        'teacher': 'Dr. Anjali Verma',
        'time': '11:00 AM - 12:00 PM',
        'room': 'Lab 2',
        'status': 'Late',
      },
    ],
    'Thursday': [
      {
        'subject': 'Chemistry',
        'teacher': 'Dr. Anjali Verma',
        'time': '08:00 AM - 09:00 AM',
        'room': 'Lab 2',
        'status': 'Present',
      },
      {
        'subject': 'English',
        'teacher': 'Mrs. Sunita Rao',
        'time': '09:00 AM - 10:00 AM',
        'room': 'Room 205',
        'status': 'Present',
      },
    ],
    'Friday': [
      {
        'subject': 'Mathematics',
        'teacher': 'Prof. Aditya Mishra',
        'time': '08:00 AM - 09:00 AM',
        'room': 'Room 301',
        'status': 'Present',
      },
      {
        'subject': 'Physics',
        'teacher': 'Dr. Rajesh Kumar',
        'time': '11:00 AM - 12:00 PM',
        'room': 'Lab 1',
        'status': 'Present',
      },
    ],
  };

  final List<String> weekDays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];

  void _selectWeek() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedWeekStart,
      firstDate: DateTime(2025),
      lastDate: DateTime(2027),
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
      setState(() {
        _selectedWeekStart = picked.subtract(Duration(days: picked.weekday - 1));
      });
    }
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
              title: 'Attendance',
              isRoot: true,
              onSearchTap: () {},
              onNotificationTap: () {},
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  children: [
                    _buildAttendanceSummary(),
                    const SizedBox(height: 16),
                    _buildWeekSelector(),
                    const SizedBox(height: 16),
                    ...weekDays.map((day) => _buildDayAttendance(day)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceSummary() {
    int totalClasses = 0;
    int presentCount = 0;
    int absentCount = 0;
    int lateCount = 0;

    weeklyTimetable.forEach((day, lectures) {
      for (var lecture in lectures) {
        totalClasses++;
        if (lecture['status'] == 'Present') presentCount++;
        if (lecture['status'] == 'Absent') absentCount++;
        if (lecture['status'] == 'Late') lateCount++;
      }
    });

    double percentage = totalClasses > 0 ? (presentCount / totalClasses * 100) : 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: NMTheme.primaryGradient,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: NMTheme.primaryPurple.withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Overall Attendance',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.fact_check_rounded, color: Colors.white, size: 32),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildSummaryPill('Total', '$totalClasses', Colors.white.withOpacity(0.2)),
              const SizedBox(width: 8),
              _buildSummaryPill('Present', '$presentCount', NMTheme.accentTeal),
              const SizedBox(width: 8),
              _buildSummaryPill('Absent', '$absentCount', const Color(0xFFE53935)),
              const SizedBox(width: 8),
              _buildSummaryPill('Late', '$lateCount', const Color(0xFFFB8C00)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryPill(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekSelector() {
    final endOfWeek = _selectedWeekStart.add(const Duration(days: 5));
    final format = DateFormat('MMM d');

    return NMCard(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      borderRadius: BorderRadius.circular(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          NMIconButton(
            icon: Icons.chevron_left_rounded,
            size: 36,
            iconSize: 22,
            iconColor: NMTheme.primaryPurple,
            onTap: () {
              setState(() {
                _selectedWeekStart = _selectedWeekStart.subtract(const Duration(days: 7));
              });
            },
          ),
          InkWell(
            onTap: _selectWeek,
            child: Row(
              children: [
                const Icon(Icons.calendar_month_rounded, size: 16, color: NMTheme.primaryPurple),
                const SizedBox(width: 8),
                Text(
                  '${format.format(_selectedWeekStart)} – ${format.format(endOfWeek)}, ${_selectedWeekStart.year}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: NMTheme.textDark,
                  ),
                ),
              ],
            ),
          ),
          NMIconButton(
            icon: Icons.chevron_right_rounded,
            size: 36,
            iconSize: 22,
            iconColor: NMTheme.primaryPurple,
            onTap: () {
              setState(() {
                _selectedWeekStart = _selectedWeekStart.add(const Duration(days: 7));
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDayAttendance(String day) {
    final lectures = weeklyTimetable[day] ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: NMCard(
        padding: const EdgeInsets.all(16),
        borderRadius: BorderRadius.circular(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  day,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w800,
                    color: NMTheme.textDark,
                  ),
                ),
                Text(
                  '${lectures.length} Classes',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: NMTheme.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...lectures.map((lecture) => _buildLectureItem(lecture)),
          ],
        ),
      ),
    );
  }

  Widget _buildLectureItem(Map<String, dynamic> lecture) {
    Color statusColor;
    if (lecture['status'] == 'Present') {
      statusColor = NMTheme.accentTeal;
    } else if (lecture['status'] == 'Absent') {
      statusColor = const Color(0xFFE53935);
    } else {
      statusColor = const Color(0xFFFB8C00);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: NMTheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: NMTheme.cardShadows,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lecture['subject'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: NMTheme.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${lecture['time']} • ${lecture['room']}',
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: NMTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              lecture['status'],
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.w800,
                fontSize: 11.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
