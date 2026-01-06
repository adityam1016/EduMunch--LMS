import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ParentAttendanceScreen extends StatefulWidget {
  const ParentAttendanceScreen({super.key});

  @override
  State<ParentAttendanceScreen> createState() => _ParentAttendanceScreenState();
}

class _ParentAttendanceScreenState extends State<ParentAttendanceScreen> {
  DateTime _selectedWeekStart = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
  
  // Sample attendance data - Replace with actual API data
  final Map<String, List<Map<String, dynamic>>> weeklyTimetable = {
    'Monday': [
      {
        'subject': 'Mathematics',
        'teacher': 'Mrs. Priya Sharma',
        'time': '08:00 AM - 09:00 AM',
        'room': 'Room 301',
        'status': 'Present',
      },
      {
        'subject': 'Physics',
        'teacher': 'Mr. Rajesh Kumar',
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
        'teacher': 'Mrs. Priya Sharma',
        'time': '09:00 AM - 10:00 AM',
        'room': 'Room 301',
        'status': 'Present',
      },
      {
        'subject': 'Computer Science',
        'teacher': 'Mr. Aditya Mishra',
        'time': '11:00 AM - 12:00 PM',
        'room': 'Computer Lab',
        'status': 'Present',
      },
      {
        'subject': 'Physical Education',
        'teacher': 'Mr. Rahul Kapoor',
        'time': '02:00 PM - 03:00 PM',
        'room': 'Sports Ground',
        'status': 'Present',
      },
    ],
    'Wednesday': [
      {
        'subject': 'History',
        'teacher': 'Mrs. Meera Iyer',
        'time': '08:00 AM - 09:00 AM',
        'room': 'Room 401',
        'status': 'Present',
      },
      {
        'subject': 'Geography',
        'teacher': 'Mr. Deepak Nair',
        'time': '09:00 AM - 10:00 AM',
        'room': 'Room 402',
        'status': 'Late',
      },
      {
        'subject': 'Mathematics',
        'teacher': 'Mrs. Priya Sharma',
        'time': '11:00 AM - 12:00 PM',
        'room': 'Room 301',
        'status': 'Present',
      },
      {
        'subject': 'Physics',
        'teacher': 'Mr. Rajesh Kumar',
        'time': '01:00 PM - 02:00 PM',
        'room': 'Lab 1',
        'status': 'Present',
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
      {
        'subject': 'Biology',
        'teacher': 'Mr. Vikram Singh',
        'time': '11:00 AM - 12:00 PM',
        'room': 'Lab 3',
        'status': 'Present',
      },
      {
        'subject': 'Art & Craft',
        'teacher': 'Mrs. Pooja Desai',
        'time': '02:00 PM - 03:00 PM',
        'room': 'Art Room',
        'status': 'Present',
      },
    ],
    'Friday': [
      {
        'subject': 'Mathematics',
        'teacher': 'Mrs. Priya Sharma',
        'time': '08:00 AM - 09:00 AM',
        'room': 'Room 301',
        'status': 'Present',
      },
      {
        'subject': 'Computer Science',
        'teacher': 'Mr. Aditya Mishra',
        'time': '09:00 AM - 10:00 AM',
        'room': 'Computer Lab',
        'status': 'Absent',
      },
      {
        'subject': 'Physics',
        'teacher': 'Mr. Rajesh Kumar',
        'time': '11:00 AM - 12:00 PM',
        'room': 'Lab 1',
        'status': 'Present',
      },
      {
        'subject': 'Music',
        'teacher': 'Mr. Karan Malhotra',
        'time': '01:00 PM - 02:00 PM',
        'room': 'Music Room',
        'status': 'Present',
      },
    ],
    'Saturday': [
      {
        'subject': 'Library Period',
        'teacher': 'Mrs. Kavita Singh',
        'time': '08:00 AM - 09:00 AM',
        'room': 'Library',
        'status': 'Present',
      },
      {
        'subject': 'Activity Club',
        'teacher': 'Multiple Teachers',
        'time': '09:00 AM - 11:00 AM',
        'room': 'Various Rooms',
        'status': 'Present',
      },
      {
        'subject': 'Sports',
        'teacher': 'Mr. Rahul Kapoor',
        'time': '11:00 AM - 12:30 PM',
        'room': 'Sports Ground',
        'status': 'Present',
      },
    ],
  };

  final List<String> weekDays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Attendance Report',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today, color: Color(0xFF7C4DFF)),
            onPressed: _selectWeek,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildAttendanceSummary(),
          _buildWeekSelector(),
          Expanded(
            child: _buildWeeklyTimetable(),
          ),
        ],
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

    double attendancePercentage = totalClasses > 0 ? (presentCount / totalClasses * 100) : 0;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7C4DFF), Color(0xFF5E35B1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C4DFF).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Overall Attendance',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'This Week',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    '${attendancePercentage.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Attendance Rate',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Container(
                width: 1,
                height: 50,
                color: Colors.white.withOpacity(0.3),
              ),
              _buildStatItem('Present', presentCount, Colors.white),
              _buildStatItem('Absent', absentCount, Colors.redAccent),
              _buildStatItem('Late', lateCount, Colors.orangeAccent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildWeekSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Color(0xFF7C4DFF)),
            onPressed: _previousWeek,
          ),
          Text(
            _getWeekRangeText(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: Color(0xFF7C4DFF)),
            onPressed: _nextWeek,
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyTimetable() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: weekDays.length,
      itemBuilder: (context, index) {
        String day = weekDays[index];
        List<Map<String, dynamic>> lectures = weeklyTimetable[day] ?? [];
        
        return _buildDayCard(day, lectures, index);
      },
    );
  }

  Widget _buildDayCard(String day, List<Map<String, dynamic>> lectures, int dayIndex) {
    DateTime dayDate = _selectedWeekStart.add(Duration(days: dayIndex));
    bool isToday = dayDate.day == DateTime.now().day && 
                   dayDate.month == DateTime.now().month && 
                   dayDate.year == DateTime.now().year;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isToday ? Border.all(color: const Color(0xFF7C4DFF), width: 2) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isToday ? const Color(0xFF7C4DFF) : Colors.grey[100],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      day,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isToday ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (isToday)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Today',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
                Text(
                  '${dayDate.day}/${dayDate.month}/${dayDate.year}',
                  style: TextStyle(
                    fontSize: 14,
                    color: isToday ? Colors.white70 : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (lectures.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'No classes scheduled',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: lectures.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
                color: Colors.grey[200],
              ),
              itemBuilder: (context, index) {
                return _buildLectureCard(lectures[index]);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildLectureCard(Map<String, dynamic> lecture) {
    Color statusColor;
    IconData statusIcon;
    
    switch (lecture['status']) {
      case 'Present':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'Absent':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      case 'Late':
        statusColor = Colors.orange;
        statusIcon = Icons.access_time;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help_outline;
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 60,
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        lecture['subject'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(statusIcon, size: 14, color: statusColor),
                          const SizedBox(width: 4),
                          Text(
                            lecture['status'],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.person_outline, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      lecture['teacher'],
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      lecture['time'],
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.room_outlined, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      lecture['room'],
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _selectWeek() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedWeekStart,
      firstDate: DateTime(2024),
      lastDate: DateTime(2027),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF7C4DFF),
              onPrimary: Colors.white,
              onSurface: Colors.black87,
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

  void _previousWeek() {
    setState(() {
      _selectedWeekStart = _selectedWeekStart.subtract(const Duration(days: 7));
    });
  }

  void _nextWeek() {
    setState(() {
      _selectedWeekStart = _selectedWeekStart.add(const Duration(days: 7));
    });
  }

  String _getWeekRangeText() {
    DateTime weekEnd = _selectedWeekStart.add(const Duration(days: 5));
    return '${_selectedWeekStart.day}/${_selectedWeekStart.month} - ${weekEnd.day}/${weekEnd.month}/${weekEnd.year}';
  }
}
