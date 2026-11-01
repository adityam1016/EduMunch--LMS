import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase_config.dart';

class TimetableItemModel {
  final String id;
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final String subject;
  final String? professor;
  final String? classroom;
  final String type; // 'class', 'break', 'exam'

  TimetableItemModel({
    required this.id,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.subject,
    this.professor,
    this.classroom,
    this.type = 'class',
  });

  factory TimetableItemModel.fromMap(Map<String, dynamic> map) {
    return TimetableItemModel(
      id: map['id']?.toString() ?? '',
      dayOfWeek: map['day_of_week'] ?? 'Monday',
      startTime: map['start_time'] ?? '',
      endTime: map['end_time'] ?? '',
      subject: map['subject'] ?? '',
      professor: map['professor'],
      classroom: map['classroom'],
      type: map['type'] ?? 'class',
    );
  }
}

class TimetableService {
  static SupabaseClient get _client => Supabase.instance.client;

  /// Fetch timetable entries for a specific day
  static Future<List<TimetableItemModel>> getTimetableForDay(String dayOfWeek) async {
    if (!SupabaseConfig.isConfigured) return [];
    try {
      final response = await _client
          .from('timetables')
          .select('*')
          .eq('day_of_week', dayOfWeek)
          .order('start_time', ascending: true);

      return (response as List)
          .map((item) => TimetableItemModel.fromMap(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching timetable from Supabase: $e');
      return [];
    }
  }

  /// Fetch all timetable entries
  static Future<List<TimetableItemModel>> getAllTimetables() async {
    if (!SupabaseConfig.isConfigured) return [];
    try {
      final response = await _client
          .from('timetables')
          .select('*')
          .order('start_time', ascending: true);

      return (response as List)
          .map((item) => TimetableItemModel.fromMap(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching all timetables from Supabase: $e');
      return [];
    }
  }
}

