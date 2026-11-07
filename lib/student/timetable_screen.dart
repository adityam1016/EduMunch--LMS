import 'package:flutter/material.dart';
import 'app_drawer.dart';
import '../services/timetable_service.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_widgets.dart';

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
    _loadTimetable();
  }

  Future<void> _loadTimetable() async {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    final currentDay = days[selectedDate.weekday - 1];
    final live = await TimetableService.getTimetableForDay(currentDay);
    if (live.isNotEmpty && mounted) {
      setState(() {
        dailyTimetableData.clear();
        dailyTimetableData.addAll(live.map((t) => {
              'time': t.startTime,
              'endTime': t.endTime,
              'subject': t.subject,
              'professor': t.professor ?? '',
              'type': t.type,
            }));
      });
    }
  }

  final List<Map<String, dynamic>> dailyTimetableData = [
    {
      'time': '09:00 AM',
      'endTime': '10:30 AM',
      'subject': 'Physics',
      'professor': 'Dr. Rajesh Kumar',
      'type': 'class',
      'room': 'Lab 2',
      'colors': [Color(0xFF0C6E5A), Color(0xFF074F40)],
    },
    {
      'time': '10:45 AM',
      'endTime': '12:00 PM',
      'subject': 'Mathematics',
      'professor': 'Prof. Amit Sharma',
      'type': 'class',
      'room': 'Room 104',
      'colors': [Color(0xFF1B7696), Color(0xFF135B74)],
    },
    {
      'time': '12:00 PM',
      'endTime': '01:00 PM',
      'subject': 'Lunch Break',
      'professor': '',
      'type': 'break',
      'room': 'Cafeteria',
    },
    {
      'time': '01:00 PM',
      'endTime': '02:30 PM',
      'subject': 'Chemistry',
      'professor': 'Dr. Priya Singh',
      'type': 'class',
      'room': 'Chem Hall',
      'colors': [Color(0xFFC46513), Color(0xFFA04E09)],
    },
    {
      'time': '03:00 PM',
      'endTime': '04:30 PM',
      'subject': 'Calculus Revision',
      'professor': 'Mentor Session',
      'type': 'class',
      'room': 'Online Live',
      'colors': [Color(0xFF381868), Color(0xFF4C218E)],
    },
  ];

  final Map<String, List<Map<String, dynamic>>> weeklyTimetableData = {
    'Monday': [
      {'time': '09:00 AM - 10:30 AM', 'subject': 'Physics', 'professor': 'Dr. Rajesh Kumar'},
      {'time': '10:45 AM - 12:00 PM', 'subject': 'Mathematics', 'professor': 'Prof. Amit Sharma'},
      {'time': '01:00 PM - 02:30 PM', 'subject': 'Chemistry', 'professor': 'Dr. Priya Singh'},
    ],
    'Tuesday': [
      {'time': '09:00 AM - 10:30 AM', 'subject': 'Mathematics', 'professor': 'Prof. Amit Sharma'},
      {'time': '11:00 AM - 12:30 PM', 'subject': 'Physics Lab', 'professor': 'Dr. Rajesh Kumar'},
      {'time': '01:30 PM - 03:00 PM', 'subject': 'Doubt Session', 'professor': 'Faculty Group'},
    ],
    'Wednesday': [
      {'time': '09:00 AM - 10:30 AM', 'subject': 'Chemistry', 'professor': 'Dr. Priya Singh'},
      {'time': '11:00 AM - 12:30 PM', 'subject': 'Biology', 'professor': 'Dr. Singh'},
      {'time': '01:00 PM - 02:30 PM', 'subject': 'Computer Science', 'professor': 'Prof. Patel'},
    ],
    'Thursday': [
      {'time': '09:00 AM - 10:30 AM', 'subject': 'Physics', 'professor': 'Dr. Rajesh Kumar'},
      {'time': '10:45 AM - 12:00 PM', 'subject': 'Mathematics', 'professor': 'Prof. Amit Sharma'},
      {'time': '01:00 PM - 02:30 PM', 'subject': 'Chemistry Lab', 'professor': 'Dr. Priya Singh'},
    ],
    'Friday': [
      {'time': '09:00 AM - 10:30 AM', 'subject': 'Mathematics', 'professor': 'Prof. Amit Sharma'},
      {'time': '11:00 AM - 12:30 PM', 'subject': 'Mock Test 1', 'professor': 'Exam Cell'},
      {'time': '01:30 PM - 03:00 PM', 'subject': 'Paper Discussion', 'professor': 'All Mentors'},
    ],
    'Saturday': [
      {'time': '09:00 AM - 11:00 AM', 'subject': 'Revision - Physics', 'professor': 'Dr. Rajesh Kumar'},
      {'time': '11:30 AM - 01:00 PM', 'subject': 'Revision - Chemistry', 'professor': 'Dr. Priya Singh'},
    ],
    'Sunday': [
      {'time': 'Self-Study', 'subject': 'Weekly Self Review', 'professor': 'Self Paced'},
    ],
  };

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
      _loadTimetable();
    }
  }

  void _previousDate() {
    setState(() => selectedDate = selectedDate.subtract(const Duration(days: 1)));
    _loadTimetable();
  }

  void _nextDate() {
    setState(() => selectedDate = selectedDate.add(const Duration(days: 1)));
    _loadTimetable();
  }

  String _getDayName(DateTime date) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[date.weekday - 1];
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NMTheme.bg,
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            NMAppBar(
              title: 'Timetable',
              isRoot: false,
            ),
            const SizedBox(height: 10),

            // Daily / Weekly Inset Toggle Pill
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: NMTheme.insetDecoration(radius: 18),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isWeeklyView = false),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          decoration: BoxDecoration(
                            color: !isWeeklyView ? NMTheme.surface : Colors.transparent,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: !isWeeklyView ? NMTheme.raisedShadow(offset: 2.5, blur: 5) : [],
                          ),
                          child: Text(
                            'Daily Schedule',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: !isWeeklyView ? FontWeight.w800 : FontWeight.w600,
                              color: !isWeeklyView ? NMTheme.primaryPurple : NMTheme.textMuted,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isWeeklyView = true),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          decoration: BoxDecoration(
                            color: isWeeklyView ? NMTheme.surface : Colors.transparent,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: isWeeklyView ? NMTheme.raisedShadow(offset: 2.5, blur: 5) : [],
                          ),
                          child: Text(
                            'Weekly Overview',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: isWeeklyView ? FontWeight.w800 : FontWeight.w600,
                              color: isWeeklyView ? NMTheme.primaryPurple : NMTheme.textMuted,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Content
            Expanded(
              child: !isWeeklyView ? _buildDailyView() : _buildWeeklyView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyView() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date Picker Card
          NMCard(
            radius: 20,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                NMIconButton(
                  icon: Icons.chevron_left_rounded,
                  size: 38,
                  iconSize: 22,
                  onTap: _previousDate,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 12),
                      decoration: NMTheme.insetDecoration(radius: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.calendar_today_rounded, size: 16, color: Color(0xFF7C3AED)),
                          const SizedBox(width: 8),
                          Text(
                            '${_getDayName(selectedDate)}, ${selectedDate.day} ${_getMonthName(selectedDate.month)}',
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: NMTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                NMIconButton(
                  icon: Icons.chevron_right_rounded,
                  size: 38,
                  iconSize: 22,
                  onTap: _nextDate,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Daily lecture list
          ...dailyTimetableData.map((item) {
            final isBreak = item['type'] == 'break';
            if (isBreak) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: NMTheme.insetDecoration(radius: 14),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.restaurant_rounded, size: 16, color: NMTheme.textMuted),
                      const SizedBox(width: 8),
                      Text(
                        '${item['subject']} (${item['time']} - ${item['endTime']})',
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: NMTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final colors = (item['colors'] as List<Color>?) ?? [const Color(0xFF1B7696), const Color(0xFF135B74)];

            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: colors,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: NMTheme.coloredCardShadow(colors[0], opacity: 0.35),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item['subject'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item['room'] ?? 'Lab',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['professor'] as String,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.access_time_rounded, color: Colors.white, size: 15),
                            const SizedBox(width: 6),
                            Text(
                              '${item['time']} - ${item['endTime']}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        NMWhitePillBadge(
                          text: item['room'] != null ? 'Active' : 'Scheduled',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildWeeklyView() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      itemCount: weeklyTimetableData.entries.length,
      itemBuilder: (context, index) {
        final entry = weeklyTimetableData.entries.elementAt(index);
        final day = entry.key;
        final classes = entry.value;

        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: NMCard(
            radius: 20,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      day,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: NMTheme.primaryPurple,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: NMTheme.insetDecoration(radius: 8),
                      child: Text(
                        '${classes.length} Slots',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: NMTheme.textSecondary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...classes.map((c) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: NMTheme.insetDecoration(radius: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 34,
                          decoration: BoxDecoration(
                            color: const Color(0xFF7C3AED),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                c['subject'] as String,
                                style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: NMTheme.textPrimary),
                              ),
                              Text(
                                '${c['time']} · ${c['professor']}',
                                style: const TextStyle(fontSize: 11.5, color: NMTheme.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }
}
