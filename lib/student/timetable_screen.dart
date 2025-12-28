import 'package:flutter/material.dart';
import 'app_drawer.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  late DateTime selectedDate;
  bool isWeeklyView = false;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  final List<Map<String, dynamic>> dailyTimetableData = [
    {
      'time': '09:00 AM',
      'endTime': '11:00 AM',
      'subject': 'Physics',
      'professor': 'Prof. Sharma',
      'type': 'class',
    },
    {
      'time': '10:00 AM',
      'endTime': '11:00 AM',
      'subject': 'Doubt Lecture',
      'professor': 'Chemistry',
      'type': 'class',
    },
    {
      'time': '11:00 AM',
      'endTime': '12:00 PM',
      'subject': 'Biology',
      'professor': 'Prof. Singh',
      'type': 'class',
    },
    {
      'time': '12:00 PM',
      'endTime': '01:00 PM',
      'subject': 'Lunch Break',
      'professor': '',
      'type': 'break',
    },
    {
      'time': '01:00 PM',
      'endTime': '02:00 PM',
      'subject': 'Physics',
      'professor': 'Prof. Sharma',
      'type': 'class',
    },
    {
      'time': '02:00 PM',
      'endTime': '03:00 PM',
      'subject': 'Chemistry',
      'professor': 'Prof. Gupta',
      'type': 'class',
    },
  ];

  final Map<String, List<Map<String, dynamic>>> weeklyTimetableData = {
    'Monday': [
      {
        'time': '09:00 AM - 11:00 AM',
        'subject': 'Physics',
        'professor': 'Prof. Sharma',
      },
      {
        'time': '11:00 AM - 12:30 PM',
        'subject': 'Mathematics',
        'professor': 'Prof. Kumar',
      },
      {
        'time': '01:00 PM - 02:30 PM',
        'subject': 'Chemistry',
        'professor': 'Prof. Gupta',
      },
    ],
    'Tuesday': [
      {
        'time': '09:00 AM - 10:30 AM',
        'subject': 'Biology',
        'professor': 'Prof. Singh',
      },
      {
        'time': '10:30 AM - 12:00 PM',
        'subject': 'English',
        'professor': 'Prof. Desai',
      },
      {
        'time': '01:00 PM - 02:30 PM',
        'subject': 'Physics Lab',
        'professor': 'Prof. Sharma',
      },
    ],
    'Wednesday': [
      {
        'time': '09:00 AM - 11:00 AM',
        'subject': 'Chemistry',
        'professor': 'Prof. Gupta',
      },
      {
        'time': '11:00 AM - 12:30 PM',
        'subject': 'History',
        'professor': 'Prof. Verma',
      },
      {
        'time': '01:00 PM - 02:30 PM',
        'subject': 'Mathematics',
        'professor': 'Prof. Kumar',
      },
    ],
    'Thursday': [
      {
        'time': '09:00 AM - 10:30 AM',
        'subject': 'Physics',
        'professor': 'Prof. Sharma',
      },
      {
        'time': '10:30 AM - 12:00 PM',
        'subject': 'Biology',
        'professor': 'Prof. Singh',
      },
      {
        'time': '01:00 PM - 02:30 PM',
        'subject': 'Computer Science',
        'professor': 'Prof. Patel',
      },
    ],
    'Friday': [
      {
        'time': '09:00 AM - 11:00 AM',
        'subject': 'Mathematics',
        'professor': 'Prof. Kumar',
      },
      {
        'time': '11:00 AM - 12:30 PM',
        'subject': 'Chemistry Lab',
        'professor': 'Prof. Gupta',
      },
      {
        'time': '01:00 PM - 02:30 PM',
        'subject': 'General Science',
        'professor': 'Prof. Reddy',
      },
    ],
    'Saturday': [
      {
        'time': '09:00 AM - 10:30 AM',
        'subject': 'Revision - Physics',
        'professor': 'Prof. Sharma',
      },
      {
        'time': '10:30 AM - 12:00 PM',
        'subject': 'Revision - Chemistry',
        'professor': 'Prof. Gupta',
      },
    ],
    'Sunday': [
      {
        'time': 'Weekend',
        'subject': 'No Classes - Self Study',
        'professor': 'Self Paced',
      },
    ],
  };

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _previousDate() {
    setState(() {
      selectedDate = selectedDate.subtract(const Duration(days: 1));
    });
  }

  void _nextDate() {
    setState(() {
      selectedDate = selectedDate.add(const Duration(days: 1));
    });
  }

  String _getDayName(DateTime date) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[date.weekday - 1];
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Builder(
                    builder: (context) => GestureDetector(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.menu,
                          color: Color(0xFF1A237E),
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Timetable',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // View Toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isWeeklyView = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: !isWeeklyView
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Daily',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: !isWeeklyView
                                  ? const Color(0xFF42A5F5)
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isWeeklyView = true;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isWeeklyView
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Weekly',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isWeeklyView
                                  ? const Color(0xFF42A5F5)
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Content
            if (!isWeeklyView) ...[
              // Date Selector for Daily View
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!, width: 1),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: _previousDate,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            size: 20,
                            color: Color(0xFF42A5F5),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _selectDate(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border:
                                  Border.all(color: Colors.grey[300]!),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  size: 18,
                                  color: Color(0xFF42A5F5),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${_getDayName(selectedDate)}, ${selectedDate.day} ${_getMonthName(selectedDate.month)}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: _nextDate,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: const Icon(
                            Icons.arrow_forward,
                            size: 20,
                            color: Color(0xFF42A5F5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: dailyTimetableData.map((item) {
                      return _buildDailyCard(item);
                    }).toList(),
                  ),
                ),
              ),
            ] else ...[
              // Weekly View - Horizontal Cards
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: weeklyTimetableData.entries.map((entry) {
                        return _buildWeeklyDayCard(entry.key, entry.value);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyCard(Map<String, dynamic> item) {
    bool isBreak = item['type'] == 'break';

    if (isBreak) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            item['subject'],
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
            ),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF42A5F5),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${item['time']} - ${item['endTime']}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['subject'],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item['professor'],
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyDayCard(
    String day,
    List<Map<String, dynamic>> classes,
  ) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 12, bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Day Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF42A5F5).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              day,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF42A5F5),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Classes List
          ...classes.map((classItem) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    classItem['subject'],
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    classItem['time'],
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    classItem['professor'],
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.black54,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
