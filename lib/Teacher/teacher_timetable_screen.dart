import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'teacher_app_drawer.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_widgets.dart';

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

class _TeacherTimetableScreenState extends State<TeacherTimetableScreen> {
  int _selectedTabIndex = 0; // 0: Daily, 1: Weekly
  DateTime _weekStart = DateTime.now();

  @override
  void initState() {
    super.initState();
    _weekStart = _getWeekStart(DateTime.now());
  }

  DateTime _getWeekStart(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  List<TimetableEntry> get _allEntries {
    List<TimetableEntry> entries = [];

    for (int dayOffset = 0; dayOffset < 7; dayOffset++) {
      final currentDay = _weekStart.add(Duration(days: dayOffset));
      if (currentDay.weekday == DateTime.sunday) continue;

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

      entries.add(TimetableEntry(
        time: '12:00',
        title: 'Lunch Break',
        duration: '45 min',
        type: 'break',
        startTime: DateTime(currentDay.year, currentDay.month, currentDay.day, 12, 0),
        endTime: DateTime(currentDay.year, currentDay.month, currentDay.day, 12, 45),
      ));

      entries.add(TimetableEntry(
        time: '12:45',
        title: 'Physics - Class 12A',
        center: 'Lab 1',
        duration: '45 min',
        type: 'class',
        startTime: DateTime(currentDay.year, currentDay.month, currentDay.day, 12, 45),
        endTime: DateTime(currentDay.year, currentDay.month, currentDay.day, 13, 30),
      ));

      if (currentDay.weekday == DateTime.monday ||
          currentDay.weekday == DateTime.wednesday ||
          currentDay.weekday == DateTime.friday) {
        entries.add(TimetableEntry(
          time: '15:00',
          title: 'Live Doubt Clearing Session',
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
            _buildTabSelector(),
            Expanded(
              child: _selectedTabIndex == 0
                  ? _buildDailyTimetable()
                  : _buildWeeklyTimetable(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: NMInsetContainer(
        padding: const EdgeInsets.all(4),
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedTabIndex = 0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: _selectedTabIndex == 0 ? NMTheme.cardBg : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: _selectedTabIndex == 0 ? NMTheme.cardShadows : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Daily View',
                    style: TextStyle(
                      color: _selectedTabIndex == 0 ? NMTheme.primaryPurple : NMTheme.textSecondary,
                      fontWeight: FontWeight.w800,
                      fontSize: 13.5,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedTabIndex = 1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: _selectedTabIndex == 1 ? NMTheme.cardBg : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: _selectedTabIndex == 1 ? NMTheme.cardShadows : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Weekly View',
                    style: TextStyle(
                      color: _selectedTabIndex == 1 ? NMTheme.primaryPurple : NMTheme.textSecondary,
                      fontWeight: FontWeight.w800,
                      fontSize: 13.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyTimetable() {
    final todaySchedule = _todaySchedule;

    if (todaySchedule.isEmpty) {
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
            const Text('You have no teaching lectures assigned for today.', style: TextStyle(color: NMTheme.textSecondary, fontSize: 13)),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('EEEE, MMMM d').format(DateTime.now()),
              style: const TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.w800,
                color: NMTheme.textDark,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: NMTheme.accentTeal.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${todaySchedule.length} Sessions',
                style: const TextStyle(color: NMTheme.accentTeal, fontWeight: FontWeight.w700, fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ...todaySchedule.map((entry) => _buildTimetableEntryCard(entry)),
      ],
    );
  }

  Widget _buildWeeklyTimetable() {
    final weekSchedule = _weeklySchedule;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
          child: NMCard(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
                      _weekStart = _weekStart.subtract(const Duration(days: 7));
                    });
                  },
                ),
                Text(
                  '${DateFormat('MMM d').format(_weekStart)} – ${DateFormat('MMM d').format(_weekStart.add(const Duration(days: 6)))}',
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: NMTheme.textDark,
                  ),
                ),
                NMIconButton(
                  icon: Icons.chevron_right_rounded,
                  size: 36,
                  iconSize: 22,
                  iconColor: NMTheme.primaryPurple,
                  onTap: () {
                    setState(() {
                      _weekStart = _weekStart.add(const Duration(days: 7));
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
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

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: NMCard(
        padding: const EdgeInsets.all(12),
        borderRadius: BorderRadius.circular(16),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: isToday,
            tilePadding: EdgeInsets.zero,
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isToday ? NMTheme.primaryPurple : NMTheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: NMTheme.cardShadows,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('EEE').format(day),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isToday ? Colors.white70 : NMTheme.textSecondary,
                    ),
                  ),
                  Text(
                    '${day.day}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: isToday ? Colors.white : NMTheme.textDark,
                    ),
                  ),
                ],
              ),
            ),
            title: Text(
              DateFormat('EEEE, MMMM d').format(day),
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 14,
                color: isToday ? NMTheme.primaryPurple : NMTheme.textDark,
              ),
            ),
            subtitle: Text(
              schedule.isEmpty ? 'Free day' : '${schedule.length} lecture slots',
              style: const TextStyle(color: NMTheme.textSecondary, fontSize: 12),
            ),
            children: schedule.isEmpty
                ? [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Text('No classes scheduled for this day', style: TextStyle(color: NMTheme.textSecondary, fontSize: 12.5)),
                    ),
                  ]
                : schedule.map((entry) => Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: _buildTimetableEntryCard(entry, compact: true),
                    )).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildTimetableEntryCard(TimetableEntry entry, {bool compact = false}) {
    Color accentColor;
    IconData icon;

    if (entry.type == 'doubt') {
      accentColor = NMTheme.accentTeal;
      icon = Icons.quiz_outlined;
    } else if (entry.type == 'break') {
      accentColor = Colors.grey;
      icon = Icons.coffee_outlined;
    } else if (entry.title.contains('Physics')) {
      accentColor = NMTheme.accentTeal;
      icon = Icons.science_outlined;
    } else if (entry.title.contains('Chemistry')) {
      accentColor = NMTheme.primaryPurple;
      icon = Icons.biotech_outlined;
    } else {
      accentColor = NMTheme.accentOcean;
      icon = Icons.functions_rounded;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: NMCard(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: compact ? 10 : 14),
        borderRadius: BorderRadius.circular(14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: accentColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14.5,
                      color: NMTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.access_time_rounded, size: 12, color: NMTheme.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        '${entry.time} • ${entry.duration}',
                        style: const TextStyle(fontSize: 12, color: NMTheme.textSecondary, fontWeight: FontWeight.w500),
                      ),
                      if (entry.center != null) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.location_on_outlined, size: 12, color: NMTheme.textSecondary),
                        const SizedBox(width: 2),
                        Text(
                          entry.center!,
                          style: const TextStyle(fontSize: 12, color: NMTheme.textSecondary, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            if (entry.type == 'doubt')
              const NMGlowingNowBadge(text: 'LIVE')
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: NMTheme.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  entry.type.toUpperCase(),
                  style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: NMTheme.textSecondary),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
