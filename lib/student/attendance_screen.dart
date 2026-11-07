import 'package:flutter/material.dart';
import 'app_drawer.dart';
import '../services/attendance_service.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_widgets.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    _loadAttendance();
  }

  Future<void> _loadAttendance() async {
    final live = await AttendanceService.getAttendanceForDate(selectedDate);
    if (live.isNotEmpty && mounted) {
      setState(() {
        todaysLectures.clear();
        todaysLectures.addAll(live.map((a) {
          String icon = '⚡';
          final subLower = a.subject.toLowerCase();
          if (subLower.contains('chem')) icon = '🧪';
          if (subLower.contains('math')) icon = '📊';
          if (subLower.contains('bio')) icon = '🔬';

          return {
            'subject': a.subject,
            'time': a.timeSlot,
            'status': a.status,
            'icon': icon,
          };
        }));
      });
    }
  }

  final List<Map<String, String>> todaysLectures = [
    {
      'subject': 'Physics',
      'time': '09:30 AM - 11:00 AM',
      'status': 'Attended',
      'icon': '⚡',
    },
    {
      'subject': 'Chemistry',
      'time': '11:15 AM - 12:45 PM',
      'status': 'Missed',
      'icon': '🧪',
    },
    {
      'subject': 'Maths',
      'time': '02:00 PM - 03:30 PM',
      'status': 'Upcoming',
      'icon': '📊',
    },
    {
      'subject': 'Biology',
      'time': '03:45 PM - 05:15 PM',
      'status': 'Upcoming',
      'icon': '🔬',
    },
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: NMTheme.primaryPurple,
              onPrimary: Colors.white,
              surface: NMTheme.surface,
              onSurface: NMTheme.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      _loadAttendance();
    }
  }

  void _previousDate() {
    setState(() {
      selectedDate = selectedDate.subtract(const Duration(days: 1));
    });
    _loadAttendance();
  }

  void _nextDate() {
    setState(() {
      selectedDate = selectedDate.add(const Duration(days: 1));
    });
    _loadAttendance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NMTheme.bg,
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            NMAppBar(
              title: 'Attendance',
              isRoot: false,
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 14),

                    // Date Selector
                    _buildDateSelector(),
                    const SizedBox(height: 18),

                    // Attendance Summary Cards
                    _buildSummaryMetrics(),
                    const SizedBox(height: 18),

                    // Punch In / Out Card
                    _buildPunchCard(),
                    const SizedBox(height: 22),

                    // Today's Lectures
                    const NMSectionHeader(title: "Today's Lectures"),
                    const SizedBox(height: 12),
                    _buildLecturesList(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return NMCard(
      radius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          NMIconButton(
            icon: Icons.chevron_left_rounded,
            size: 38,
            iconSize: 22,
            onTap: _previousDate,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                decoration: NMTheme.insetDecoration(radius: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.calendar_month_rounded,
                      size: 18,
                      color: Color(0xFF7C3AED),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${selectedDate.day} ${_getMonth(selectedDate.month)} ${selectedDate.year}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: NMTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          NMIconButton(
            icon: Icons.chevron_right_rounded,
            size: 38,
            iconSize: 22,
            onTap: _nextDate,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryMetrics() {
    return Row(
      children: [
        Expanded(
          child: NMCard(
            radius: 18,
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Present', style: TextStyle(fontSize: 12.5, color: NMTheme.textSecondary)),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  '92.4%',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF10B981),
                  ),
                ),
                const Text('48 of 52 classes', style: TextStyle(fontSize: 10.5, color: NMTheme.textMuted)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: NMCard(
            radius: 18,
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Status', style: TextStyle(fontSize: 12.5, color: NMTheme.textSecondary)),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(color: Color(0xFF7C3AED), shape: BoxShape.circle),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Good',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF7C3AED),
                  ),
                ),
                const Text('Above 75% limit', style: TextStyle(fontSize: 10.5, color: NMTheme.textMuted)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPunchCard() {
    return Row(
      children: [
        Expanded(
          child: NMCard(
            radius: 18,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Punch In',
                  style: TextStyle(fontSize: 12.5, color: NMTheme.textSecondary, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                const Text(
                  '09:02 AM',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: NMTheme.textPrimary),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'On-time',
                    style: TextStyle(fontSize: 11, color: Color(0xFF10B981), fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: NMCard(
            radius: 18,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Punch Out',
                  style: TextStyle(fontSize: 12.5, color: NMTheme.textSecondary, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Pending',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: NMTheme.textMuted),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: NMTheme.insetDecoration(radius: 6),
                  child: const Text(
                    'Auto checkout',
                    style: TextStyle(fontSize: 11, color: NMTheme.textSecondary, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLecturesList() {
    return Column(
      children: todaysLectures.map((lecture) {
        return _buildLectureCard(lecture);
      }).toList(),
    );
  }

  Widget _buildLectureCard(Map<String, String> lecture) {
    Color statusColor = _getStatusColor(lecture['status']!);
    Color statusBgColor = _getStatusBgColor(lecture['status']!);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: NMCard(
        radius: 18,
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: NMTheme.insetDecoration(radius: 12),
              alignment: Alignment.center,
              child: Text(
                lecture['icon']!,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lecture['subject']!,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: NMTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    lecture['time']!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: NMTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                lecture['status']!,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Attended':
        return const Color(0xFF10B981);
      case 'Missed':
        return const Color(0xFFEF4444);
      case 'Upcoming':
        return const Color(0xFFD97706);
      default:
        return NMTheme.textSecondary;
    }
  }

  Color _getStatusBgColor(String status) {
    switch (status) {
      case 'Attended':
        return const Color(0xFF10B981).withOpacity(0.12);
      case 'Missed':
        return const Color(0xFFEF4444).withOpacity(0.12);
      case 'Upcoming':
        return const Color(0xFFD97706).withOpacity(0.12);
      default:
        return NMTheme.sunkenBg;
    }
  }

  String _getMonth(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}
