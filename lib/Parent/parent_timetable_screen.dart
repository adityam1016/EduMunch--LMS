import 'package:flutter/material.dart';
import 'parent_app_drawer.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_widgets.dart';

class ParentTimetableScreen extends StatefulWidget {
  const ParentTimetableScreen({super.key});

  @override
  State<ParentTimetableScreen> createState() => _ParentTimetableScreenState();
}

class _ParentTimetableScreenState extends State<ParentTimetableScreen> {
  int _selectedDayIndex = 0; // 0 = Monday

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
        'color': NMTheme.accentTeal,
      },
      {
        'subject': 'Mathematics',
        'time': '09:45 AM - 11:15 AM',
        'teacher': 'Prof. Aditya Mishra',
        'room': 'Room 105',
        'type': 'Theory',
        'color': NMTheme.accentOcean,
      },
      {
        'subject': 'Morning Break',
        'time': '11:15 AM - 11:45 AM',
        'teacher': '',
        'room': 'Cafeteria',
        'type': 'Break',
        'color': Colors.grey,
      },
      {
        'subject': 'Chemistry Lab',
        'time': '11:45 AM - 01:15 PM',
        'teacher': 'Dr. Anjali Verma',
        'room': 'Lab 301',
        'type': 'Practical',
        'color': NMTheme.primaryPurple,
      },
    ],
    'Tuesday': [
      {
        'subject': 'Mathematics',
        'time': '08:00 AM - 09:30 AM',
        'teacher': 'Prof. Aditya Mishra',
        'room': 'Room 105',
        'type': 'Theory',
        'color': NMTheme.accentOcean,
      },
      {
        'subject': 'Physics Lab',
        'time': '09:45 AM - 11:15 AM',
        'teacher': 'Dr. Rajesh Kumar',
        'room': 'Lab 201',
        'type': 'Practical',
        'color': NMTheme.accentTeal,
      },
      {
        'subject': 'Computer Science',
        'time': '11:45 AM - 01:15 PM',
        'teacher': 'Prof. Rahul Tiwari',
        'room': 'Computer Lab',
        'type': 'Practical',
        'color': const Color(0xFFFB8C00),
      },
    ],
    'Wednesday': [
      {
        'subject': 'Chemistry',
        'time': '08:00 AM - 09:30 AM',
        'teacher': 'Dr. Anjali Verma',
        'room': 'Room 301',
        'type': 'Theory',
        'color': NMTheme.primaryPurple,
      },
      {
        'subject': 'Physics',
        'time': '09:45 AM - 11:15 AM',
        'teacher': 'Dr. Rajesh Kumar',
        'room': 'Room 201',
        'type': 'Theory',
        'color': NMTheme.accentTeal,
      },
    ],
    'Thursday': [
      {
        'subject': 'Mathematics',
        'time': '08:00 AM - 09:30 AM',
        'teacher': 'Prof. Aditya Mishra',
        'room': 'Room 105',
        'type': 'Theory',
        'color': NMTheme.accentOcean,
      },
      {
        'subject': 'Chemistry',
        'time': '09:45 AM - 11:15 AM',
        'teacher': 'Dr. Anjali Verma',
        'room': 'Room 301',
        'type': 'Theory',
        'color': NMTheme.primaryPurple,
      },
    ],
    'Friday': [
      {
        'subject': 'Physics Problem Set',
        'time': '08:00 AM - 09:30 AM',
        'teacher': 'Dr. Rajesh Kumar',
        'room': 'Room 201',
        'type': 'Tutorial',
        'color': NMTheme.accentTeal,
      },
      {
        'subject': 'Live Doubt Session',
        'time': '09:45 AM - 11:15 AM',
        'teacher': 'Prof. Aditya Mishra',
        'room': 'Auditorium',
        'type': 'Doubt',
        'color': NMTheme.primaryPurple,
      },
    ],
    'Saturday': [
      {
        'subject': 'Weekly Mock Assessment',
        'time': '09:00 AM - 12:00 PM',
        'teacher': 'Exam Invigilation',
        'room': 'Hall A',
        'type': 'Exam',
        'color': const Color(0xFFE53935),
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    final String currentDay = weekDays[_selectedDayIndex];
    final List<Map<String, dynamic>> schedule = weeklyTimetable[currentDay] ?? [];

    return Scaffold(
      drawer: const ParentAppDrawer(),
      backgroundColor: NMTheme.bg,
      body: SafeArea(
        child: Column(
          children: [
            NMAppBar(
              title: 'Timetable',
              isRoot: true,
              onSearchTap: () {},
              onNotificationTap: () {},
            ),
            _buildDaySelector(),
            Expanded(
              child: schedule.isEmpty
                  ? _buildEmptyDay()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: schedule.length,
                      itemBuilder: (context, index) {
                        return _buildLectureCard(schedule[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDaySelector() {
    return Container(
      height: 52,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: weekDays.length,
        itemBuilder: (context, index) {
          final day = weekDays[index];
          final isSelected = _selectedDayIndex == index;

          return GestureDetector(
            onTap: () => setState(() => _selectedDayIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8, top: 4, bottom: 4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? NMTheme.primaryPurple : NMTheme.cardBg,
                borderRadius: BorderRadius.circular(16),
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
                day,
                style: TextStyle(
                  color: isSelected ? Colors.white : NMTheme.textDark,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyDay() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: NMTheme.surface,
              shape: BoxShape.circle,
              boxShadow: NMTheme.cardShadows,
            ),
            child: const Icon(Icons.event_available_rounded, size: 52, color: NMTheme.accentTeal),
          ),
          const SizedBox(height: 16),
          const Text(
            'No Classes Scheduled',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: NMTheme.textDark),
          ),
          const SizedBox(height: 6),
          const Text('No lecture slots for this day.', style: TextStyle(color: NMTheme.textSecondary, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildLectureCard(Map<String, dynamic> item) {
    final Color color = item['color'];
    final bool isBreak = item['type'] == 'Break';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: NMCard(
        padding: const EdgeInsets.all(14),
        borderRadius: BorderRadius.circular(18),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isBreak
                    ? Icons.coffee_rounded
                    : item['type'] == 'Exam'
                        ? Icons.edit_calendar_rounded
                        : Icons.school_rounded,
                color: color,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['subject'],
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: NMTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.access_time_rounded, size: 12, color: NMTheme.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        item['time'],
                        style: const TextStyle(fontSize: 12, color: NMTheme.textSecondary, fontWeight: FontWeight.w500),
                      ),
                      if (item['room'].isNotEmpty) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.location_on_outlined, size: 12, color: NMTheme.textSecondary),
                        const SizedBox(width: 2),
                        Text(
                          item['room'],
                          style: const TextStyle(fontSize: 12, color: NMTheme.textSecondary, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ],
                  ),
                  if (item['teacher'].isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      item['teacher'],
                      style: const TextStyle(fontSize: 11.5, color: NMTheme.primaryPurple, fontWeight: FontWeight.w600),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                item['type'],
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
