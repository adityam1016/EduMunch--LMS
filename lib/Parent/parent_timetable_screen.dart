import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'parent_app_drawer.dart';

class ParentTimetableScreen extends StatefulWidget {
  const ParentTimetableScreen({super.key});

  @override
  State<ParentTimetableScreen> createState() => _ParentTimetableScreenState();
}

class _ParentTimetableScreenState extends State<ParentTimetableScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int selectedDay = DateTime.now().weekday - 1; // 0 = Monday
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _showCalendar = false;

  final List<String> weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  final Map<String, List<Map<String, dynamic>>> weeklyTimetable = {
    'Monday': [
      {
        'subject': 'Physics',
        'time': '08:00 AM - 09:30 AM',
        'teacher': 'Dr. Rajesh Kumar',
        'room': 'Room 201',
        'type': 'Theory',
        'color': const Color(0xFFBA68C8),
      },
      {
        'subject': 'Mathematics',
        'time': '09:45 AM - 11:15 AM',
        'teacher': 'Prof. Anjali Sharma',
        'room': 'Room 105',
        'type': 'Theory',
        'color': const Color(0xFF66BB6A),
      },
      {
        'subject': 'Break',
        'time': '11:15 AM - 11:45 AM',
        'teacher': '',
        'room': '',
        'type': 'Break',
        'color': Colors.grey,
      },
      {
        'subject': 'Chemistry',
        'time': '11:45 AM - 01:15 PM',
        'teacher': 'Dr. Vikram Singh',
        'room': 'Lab 301',
        'type': 'Lab',
        'color': const Color(0xFFBA68C8),
      },
      {
        'subject': 'English',
        'time': '02:00 PM - 03:30 PM',
        'teacher': 'Mrs. Priya Verma',
        'room': 'Room 102',
        'type': 'Theory',
        'color': const Color(0xFFFFCA28),
      },
    ],
    'Tuesday': [
      {
        'subject': 'Mathematics',
        'time': '08:00 AM - 09:30 AM',
        'teacher': 'Prof. Anjali Sharma',
        'room': 'Room 105',
        'type': 'Theory',
        'color': const Color(0xFF66BB6A),
      },
      {
        'subject': 'Physics',
        'time': '09:45 AM - 11:15 AM',
        'teacher': 'Dr. Rajesh Kumar',
        'room': 'Lab 201',
        'type': 'Lab',
        'color': const Color(0xFFBA68C8),
      },
      {
        'subject': 'Break',
        'time': '11:15 AM - 11:45 AM',
        'teacher': '',
        'room': '',
        'type': 'Break',
        'color': Colors.grey,
      },
      {
        'subject': 'Computer Science',
        'time': '11:45 AM - 01:15 PM',
        'teacher': 'Mr. Arun Patel',
        'room': 'Computer Lab',
        'type': 'Practical',
        'color': const Color(0xFF8B5CF6),
      },
      {
        'subject': 'Chemistry',
        'time': '02:00 PM - 03:30 PM',
        'teacher': 'Dr. Vikram Singh',
        'room': 'Room 301',
        'type': 'Theory',
        'color': const Color(0xFFBA68C8),
      },
    ],
    'Wednesday': [
      {
        'subject': 'Chemistry',
        'time': '08:00 AM - 09:30 AM',
        'teacher': 'Dr. Vikram Singh',
        'room': 'Room 301',
        'type': 'Theory',
        'color': const Color(0xFFBA68C8),
      },
      {
        'subject': 'English',
        'time': '09:45 AM - 11:15 AM',
        'teacher': 'Mrs. Priya Verma',
        'room': 'Room 102',
        'type': 'Theory',
        'color': const Color(0xFFFFCA28),
      },
      {
        'subject': 'Break',
        'time': '11:15 AM - 11:45 AM',
        'teacher': '',
        'room': '',
        'type': 'Break',
        'color': Colors.grey,
      },
      {
        'subject': 'Mathematics',
        'time': '11:45 AM - 01:15 PM',
        'teacher': 'Prof. Anjali Sharma',
        'room': 'Room 105',
        'type': 'Theory',
        'color': const Color(0xFF66BB6A),
      },
      {
        'subject': 'Physics',
        'time': '02:00 PM - 03:30 PM',
        'teacher': 'Dr. Rajesh Kumar',
        'room': 'Room 201',
        'type': 'Theory',
        'color': const Color(0xFFBA68C8),
      },
    ],
    'Thursday': [
      {
        'subject': 'Physics',
        'time': '08:00 AM - 09:30 AM',
        'teacher': 'Dr. Rajesh Kumar',
        'room': 'Room 201',
        'type': 'Theory',
        'color': const Color(0xFFBA68C8),
      },
      {
        'subject': 'Chemistry',
        'time': '09:45 AM - 11:15 AM',
        'teacher': 'Dr. Vikram Singh',
        'room': 'Lab 301',
        'type': 'Lab',
        'color': const Color(0xFFBA68C8),
      },
      {
        'subject': 'Break',
        'time': '11:15 AM - 11:45 AM',
        'teacher': '',
        'room': '',
        'type': 'Break',
        'color': Colors.grey,
      },
      {
        'subject': 'Mathematics',
        'time': '11:45 AM - 01:15 PM',
        'teacher': 'Prof. Anjali Sharma',
        'room': 'Room 105',
        'type': 'Theory',
        'color': const Color(0xFF66BB6A),
      },
      {
        'subject': 'Computer Science',
        'time': '02:00 PM - 03:30 PM',
        'teacher': 'Mr. Arun Patel',
        'room': 'Computer Lab',
        'type': 'Practical',
        'color': const Color(0xFF8B5CF6),
      },
    ],
    'Friday': [
      {
        'subject': 'Mathematics',
        'time': '08:00 AM - 09:30 AM',
        'teacher': 'Prof. Anjali Sharma',
        'room': 'Room 105',
        'type': 'Theory',
        'color': const Color(0xFF66BB6A),
      },
      {
        'subject': 'English',
        'time': '09:45 AM - 11:15 AM',
        'teacher': 'Mrs. Priya Verma',
        'room': 'Room 102',
        'type': 'Theory',
        'color': const Color(0xFFFFCA28),
      },
      {
        'subject': 'Break',
        'time': '11:15 AM - 11:45 AM',
        'teacher': '',
        'room': '',
        'type': 'Break',
        'color': Colors.grey,
      },
      {
        'subject': 'Physics',
        'time': '11:45 AM - 01:15 PM',
        'teacher': 'Dr. Rajesh Kumar',
        'room': 'Lab 201',
        'type': 'Lab',
        'color': const Color(0xFFBA68C8),
      },
      {
        'subject': 'Chemistry',
        'time': '02:00 PM - 03:30 PM',
        'teacher': 'Dr. Vikram Singh',
        'room': 'Room 301',
        'type': 'Theory',
        'color': const Color(0xFFBA68C8),
      },
    ],
    'Saturday': [
      {
        'subject': 'Doubt Session',
        'time': '08:00 AM - 09:30 AM',
        'teacher': 'All Teachers',
        'room': 'Room 105',
        'type': 'Session',
        'color': const Color(0xFFEF5350),
      },
      {
        'subject': 'Test Series',
        'time': '09:45 AM - 11:15 AM',
        'teacher': 'Exam Coordinator',
        'room': 'Exam Hall',
        'type': 'Test',
        'color': const Color(0xFF8B5CF6),
      },
      {
        'subject': 'Break',
        'time': '11:15 AM - 11:45 AM',
        'teacher': '',
        'room': '',
        'type': 'Break',
        'color': Colors.grey,
      },
      {
        'subject': 'Extra Classes',
        'time': '11:45 AM - 01:15 PM',
        'teacher': 'Subject Teachers',
        'room': 'Various Rooms',
        'type': 'Optional',
        'color': const Color(0xFFFF9800),
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _selectedDay = _focusedDay;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const ParentAppDrawer(),
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Timetable'),
        elevation: 0,
        backgroundColor: const Color(0xFF7C3AED),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          tabs: const [
            Tab(text: 'Daily View'),
            Tab(text: 'Weekly View'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDailyView(),
          _buildWeeklyView(),
        ],
      ),
    );
  }

  Widget _buildDailyView() {
    return Column(
      children: [
        // Student Info with Calendar Toggle
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                ),
                child: Icon(
                  Icons.person,
                  size: 32,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Aarav Sharma',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Class 11th JEE MAINS',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _showCalendar = !_showCalendar;
                  });
                },
                icon: Icon(
                  _showCalendar ? Icons.close : Icons.calendar_month,
                  color: const Color(0xFF7C3AED),
                ),
                tooltip: _showCalendar ? 'Hide Calendar' : 'Show Calendar',
              ),
            ],
          ),
        ),

        // Calendar View
        if (_showCalendar)
          Container(
            color: Colors.white,
            child: TableCalendar(
              firstDay: DateTime.utc(2024, 1, 1),
              lastDay: DateTime.utc(2026, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (selectedDay.weekday != DateTime.sunday) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    this.selectedDay = selectedDay.weekday - 1;
                    _showCalendar = false;
                  });
                }
              },
              calendarFormat: CalendarFormat.month,
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: const Color(0xFFC4B5FD),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: const Color(0xFF7C3AED),
                  shape: BoxShape.circle,
                ),
                weekendTextStyle: const TextStyle(color: Colors.red),
                outsideDaysVisible: false,
              ),
              headerStyle: HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
                titleTextStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                leftChevronIcon: Icon(
                  Icons.chevron_left,
                  color: const Color(0xFF7C3AED),
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: const Color(0xFF7C3AED),
                ),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekendStyle: const TextStyle(color: Colors.red),
                weekdayStyle: TextStyle(color: Colors.grey[700]),
              ),
              enabledDayPredicate: (day) {
                // Disable Sundays
                return day.weekday != DateTime.sunday;
              },
            ),
          ),

        // Date Selector Card
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Previous Day Button
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    setState(() {
                      DateTime newDate = _selectedDay!.subtract(const Duration(days: 1));
                      // Skip Sunday
                      if (newDate.weekday == DateTime.sunday) {
                        newDate = newDate.subtract(const Duration(days: 1));
                      }
                      _selectedDay = newDate;
                      _focusedDay = newDate;
                      selectedDay = newDate.weekday - 1;
                    });
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                // Date Display (clickable to open calendar)
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _showCalendar = !_showCalendar;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 18,
                          color: const Color(0xFF7C3AED),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          DateFormat('d MMM yyyy').format(_selectedDay ?? DateTime.now()),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Next Day Button
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    setState(() {
                      DateTime newDate = _selectedDay!.add(const Duration(days: 1));
                      // Skip Sunday
                      if (newDate.weekday == DateTime.sunday) {
                        newDate = newDate.add(const Duration(days: 1));
                      }
                      _selectedDay = newDate;
                      _focusedDay = newDate;
                      selectedDay = newDate.weekday - 1;
                    });
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ),

        // Classes List
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${weekDays[selectedDay]}\'s Classes',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ...weeklyTimetable[weekDays[selectedDay]]!
                    .asMap()
                    .entries
                    .map((entry) {
                  final index = entry.key;
                  final classItem = entry.value;
                  return _buildClassCard(classItem, index);
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildClassCard(Map<String, dynamic> classItem, int index) {
    final isBreak = classItem['type'] == 'Break';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: classItem['color'].withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Time and Order Indicator
            Column(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: classItem['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: classItem['color'],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: Colors.grey[600],
                ),
              ],
            ),
            const SizedBox(width: 16),

            // Class Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    classItem['subject'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isBreak ? Colors.grey[600] : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    classItem['time'],
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (!isBreak) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.person_outline,
                            size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            classItem['teacher'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined,
                            size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          classItem['room'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: classItem['color'].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            classItem['type'],
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: classItem['color'],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Student Info
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200],
                  ),
                  child: Icon(
                    Icons.person,
                    size: 32,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Aarav Sharma',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Class 11th JEE MAINS - Weekly Schedule',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Weekly Schedule
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: weekDays.map((day) {
                final classes = weeklyTimetable[day]!;
                return _buildDayCard(day, classes);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayCard(String day, List<Map<String, dynamic>> classes) {
    final isToday = weekDays[DateTime.now().weekday - 1] == day;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isToday ? const Color(0xFF7C3AED) : Colors.grey[300]!,
          width: isToday ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Day Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isToday ? const Color(0xFF7C3AED) : Colors.grey[100],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: isToday ? Colors.white : Colors.grey[700],
                ),
                const SizedBox(width: 8),
                Text(
                  day,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isToday ? Colors.white : Colors.black87,
                  ),
                ),
                if (isToday) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Today',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF7C3AED),
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                Text(
                  '${classes.where((c) => c['type'] != 'Break').length} Classes',
                  style: TextStyle(
                    fontSize: 13,
                    color: isToday ? Colors.white : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Classes
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: classes.map((classItem) {
                final isBreak = classItem['type'] == 'Break';
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: classItem['color'].withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: classItem['color'].withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 40,
                        decoration: BoxDecoration(
                          color: classItem['color'],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    classItem['subject'],
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: isBreak
                                          ? Colors.grey[600]
                                          : Colors.black87,
                                    ),
                                  ),
                                ),
                                if (!isBreak)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: classItem['color'].withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      classItem['type'],
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: classItem['color'],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 14,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  classItem['time'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                if (!isBreak) ...[
                                  const SizedBox(width: 12),
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 14,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    classItem['room'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
