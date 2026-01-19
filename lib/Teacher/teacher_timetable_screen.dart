import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'teacher_app_drawer.dart';

class TimetableEntry {
  final String time;
  final String title;
  final String? center;
  final String duration;
  final String type; // 'class', 'break', 'doubt'
  final DateTime startTime;
  final DateTime endTime;

  TimetableEntry({
    required this.time,
    required this.title,
    this.center,
    required this.duration,
    required this.type,
    required this.startTime,
    required this.endTime,
  });
}

class TeacherTimetableScreen extends StatefulWidget {
  const TeacherTimetableScreen({super.key});

  @override
  State<TeacherTimetableScreen> createState() => _TeacherTimetableScreenState();
}

class _TeacherTimetableScreenState extends State<TeacherTimetableScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _weekStart = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _weekStart = _getWeekStart(DateTime.now());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  DateTime _getWeekStart(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  // Sample timetable data
  List<TimetableEntry> get _allEntries {
    List<TimetableEntry> entries = [];

    // Generate entries for the week
    for (int dayOffset = 0; dayOffset < 7; dayOffset++) {
      final currentDay = _weekStart.add(Duration(days: dayOffset));
      
      // Skip Sunday
      if (currentDay.weekday == DateTime.sunday) continue;

      // Morning classes
      entries.add(TimetableEntry(
        time: '08:00',
        title: 'Mathematics - Class 10A',
        center: 'Room 101',
        duration: '45 min',
        type: 'class',
        startTime: DateTime(currentDay.year, currentDay.month, currentDay.day, 8, 0),
        endTime: DateTime(currentDay.year, currentDay.month, currentDay.day, 8, 45),
      ));

      entries.add(TimetableEntry(
        time: '09:00',
        title: 'Physics - Class 10B',
        center: 'Lab 2',
        duration: '45 min',
        type: 'class',
        startTime: DateTime(currentDay.year, currentDay.month, currentDay.day, 9, 0),
        endTime: DateTime(currentDay.year, currentDay.month, currentDay.day, 9, 45),
      ));

      // Break
      entries.add(TimetableEntry(
        time: '10:00',
        title: 'Morning Break',
        duration: '15 min',
        type: 'break',
        startTime: DateTime(currentDay.year, currentDay.month, currentDay.day, 10, 0),
        endTime: DateTime(currentDay.year, currentDay.month, currentDay.day, 10, 15),
      ));

      entries.add(TimetableEntry(
        time: '10:15',
        title: 'Chemistry - Class 11A',
        center: 'Room 203',
        duration: '45 min',
        type: 'class',
        startTime: DateTime(currentDay.year, currentDay.month, currentDay.day, 10, 15),
        endTime: DateTime(currentDay.year, currentDay.month, currentDay.day, 11, 0),
      ));

      entries.add(TimetableEntry(
        time: '11:15',
        title: 'Mathematics - Class 11B',
        center: 'Room 105',
        duration: '45 min',
        type: 'class',
        startTime: DateTime(currentDay.year, currentDay.month, currentDay.day, 11, 15),
        endTime: DateTime(currentDay.year, currentDay.month, currentDay.day, 12, 0),
      ));

      // Lunch break
      entries.add(TimetableEntry(
        time: '12:00',
        title: 'Lunch Break',
        duration: '45 min',
        type: 'break',
        startTime: DateTime(currentDay.year, currentDay.month, currentDay.day, 12, 0),
        endTime: DateTime(currentDay.year, currentDay.month, currentDay.day, 12, 45),
      ));

      // Afternoon classes
      entries.add(TimetableEntry(
        time: '12:45',
        title: 'Physics - Class 12A',
        center: 'Lab 1',
        duration: '45 min',
        type: 'class',
        startTime: DateTime(currentDay.year, currentDay.month, currentDay.day, 12, 45),
        endTime: DateTime(currentDay.year, currentDay.month, currentDay.day, 13, 30),
      ));

      entries.add(TimetableEntry(
        time: '13:45',
        title: 'Chemistry Lab - Class 12B',
        center: 'Lab 3',
        duration: '60 min',
        type: 'class',
        startTime: DateTime(currentDay.year, currentDay.month, currentDay.day, 13, 45),
        endTime: DateTime(currentDay.year, currentDay.month, currentDay.day, 14, 45),
      ));

      // Doubt clearing session on specific days
      if (currentDay.weekday == DateTime.monday || 
          currentDay.weekday == DateTime.wednesday ||
          currentDay.weekday == DateTime.friday) {
        entries.add(TimetableEntry(
          time: '15:00',
          title: 'Doubt Clearing Session',
          center: 'Room 101',
          duration: '60 min',
          type: 'doubt',
          startTime: DateTime(currentDay.year, currentDay.month, currentDay.day, 15, 0),
          endTime: DateTime(currentDay.year, currentDay.month, currentDay.day, 16, 0),
        ));
      }
    }

    return entries;
  }

  List<TimetableEntry> get _todaySchedule {
    final today = DateTime.now();
    return _allEntries.where((entry) {
      return entry.startTime.year == today.year &&
          entry.startTime.month == today.month &&
          entry.startTime.day == today.day;
    }).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  Map<int, List<TimetableEntry>> get _weeklySchedule {
    final schedule = <int, List<TimetableEntry>>{};

    for (int i = 0; i < 7; i++) {
      final day = _weekStart.add(Duration(days: i));
      schedule[i] = _allEntries.where((entry) {
        return entry.startTime.year == day.year &&
            entry.startTime.month == day.month &&
            entry.startTime.day == day.day;
      }).toList()
        ..sort((a, b) => a.startTime.compareTo(b.startTime));
    }

    return schedule;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const TeacherAppDrawer(),
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text(
          "My Timetable",
          style: TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.grey.withOpacity(0.2),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black54),
            onPressed: () {
              setState(() {
                _weekStart = _getWeekStart(DateTime.now());
              });
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Daily"),
            Tab(text: "Weekly"),
          ],
          labelColor: const Color.fromARGB(255, 200, 54, 222),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF7C3AED),
          indicatorWeight: 3.0,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDailyTimetable(),
          _buildWeeklyTimetable(),
        ],
      ),
    );
  }

  // ==================== DAILY VIEW ====================

  Widget _buildDailyTimetable() {
    final todaySchedule = _todaySchedule;

    if (todaySchedule.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 60, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No classes scheduled for today.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text(
          DateFormat('EEEE, MMMM d').format(DateTime.now()),
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87),
        ),
        const SizedBox(height: 20),
        ...todaySchedule.map((entry) => _buildTimetableEntry(entry)),
      ],
    );
  }

  // ==================== WEEKLY VIEW ====================

  Widget _buildWeeklyTimetable() {
    final weekSchedule = _weeklySchedule;

    return Column(
      children: [
        // Week selector
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  setState(() {
                    _weekStart = _weekStart.subtract(const Duration(days: 7));
                  });
                },
              ),
              Text(
                '${DateFormat('MMM d').format(_weekStart)} - ${DateFormat('MMM d').format(_weekStart.add(const Duration(days: 6)))}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  setState(() {
                    _weekStart = _weekStart.add(const Duration(days: 7));
                  });
                },
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        // Days list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 7,
            itemBuilder: (context, index) {
              final day = _weekStart.add(Duration(days: index));
              final daySchedule = weekSchedule[index] ?? [];
              return _buildDayCard(day, daySchedule);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDayCard(DateTime day, List<TimetableEntry> schedule) {
    final isToday = day.year == DateTime.now().year &&
        day.month == DateTime.now().month &&
        day.day == DateTime.now().day;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: isToday ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isToday
            ? const BorderSide(color: Color(0xFF7C3AED), width: 2)
            : BorderSide.none,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: isToday,
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isToday ? const Color(0xFF7C3AED) : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('EEE').format(day),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isToday ? Colors.white : Colors.grey.shade700,
                  ),
                ),
                Text(
                  '${day.day}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isToday ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          title: Text(
            DateFormat('EEEE, MMMM d').format(day),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          subtitle: Text(
            schedule.isEmpty
                ? 'No classes scheduled'
                : '${schedule.length} class${schedule.length > 1 ? 'es' : ''}',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
          children: schedule.isEmpty
              ? [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'No classes scheduled for this day',
                      style: TextStyle(color: Colors.grey.shade600),
                      textAlign: TextAlign.center,
                    ),
                  )
                ]
              : schedule
                  .map((entry) => Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: _buildCompactEntry(entry),
                      ))
                  .toList(),
        ),
      ),
    );
  }

  Widget _buildCompactEntry(TimetableEntry entry) {
    Color cardColor;
    IconData icon;
    switch (entry.type) {
      case 'doubt':
        cardColor = Colors.yellow.shade100;
        icon = Icons.help_outline;
        break;
      case 'break':
        cardColor = Colors.grey.shade100;
        icon = Icons.coffee_outlined;
        break;
      case 'class':
      default:
        cardColor = const Color(0xFFF5F3FF);
        icon = Icons.class_outlined;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black54, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 12, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      '${entry.time} • ${entry.duration}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                if (entry.center != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Center: ${entry.center}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== COMMON COMPONENTS ====================

  Widget _buildTimetableEntry(TimetableEntry entry) {
    Color cardColor;
    IconData icon;
    switch (entry.type) {
      case 'doubt':
        cardColor = Colors.yellow.shade100;
        icon = Icons.help_outline;
        break;
      case 'break':
        cardColor = Colors.grey.shade100;
        icon = Icons.coffee_outlined;
        break;
      case 'class':
      default:
        cardColor = const Color(0xFFF5F3FF);
        icon = Icons.class_outlined;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.time,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.grey.shade700),
                ),
                Icon(icon, size: 16, color: Colors.grey.shade600),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87),
                  ),
                  if (entry.center != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined,
                            size: 14, color: Colors.black.withOpacity(0.6)),
                        const SizedBox(width: 4),
                        Text(
                          'Center: ${entry.center}',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black.withOpacity(0.6)),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.timer_outlined,
                          size: 14, color: Colors.black.withOpacity(0.5)),
                      const SizedBox(width: 4),
                      Text(
                        'Duration: ${entry.duration}',
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black.withOpacity(0.5)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
