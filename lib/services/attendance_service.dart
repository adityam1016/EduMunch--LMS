import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase_config.dart';

class AttendanceModel {
  final String id;
  final String? studentEmail;
  final String subject;
  final DateTime date;
  final String timeSlot;
  final String status;
  final String? markedBy;
  final String? remarks;

  AttendanceModel({
    required this.id,
    this.studentEmail,
    required this.subject,
    required this.date,
    required this.timeSlot,
    required this.status,
    this.markedBy,
    this.remarks,
  });

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      id: map['id']?.toString() ?? '',
      studentEmail: map['student_email'],
      subject: map['subject'] ?? 'Subject',
      date: map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
      timeSlot: map['time_slot'] ?? '09:30 AM - 11:00 AM',
      status: map['status'] ?? 'Present',
      markedBy: map['marked_by'],
      remarks: map['remarks'],
    );
  }
}

class AttendanceService {
  static SupabaseClient get _client => Supabase.instance.client;

  /// Fetch attendance for a specific date (and optional student email)
  static Future<List<AttendanceModel>> getAttendanceForDate(DateTime date, {String? studentEmail}) async {
    if (!SupabaseConfig.isConfigured) return [];
    try {
      final dateStr = date.toIso8601String().split('T').first;
      var query = _client.from('attendance').select('*').eq('date', dateStr);

      if (studentEmail != null && studentEmail.isNotEmpty) {
        query = query.eq('student_email', studentEmail);
      }

      final response = await query.order('created_at', ascending: true);
      return (response as List)
          .map((item) => AttendanceModel.fromMap(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching attendance from Supabase: $e');
      return [];
    }
  }

  /// Mark student attendance (Teacher)
  static Future<bool> markAttendance({
    required String studentEmail,
    required String subject,
    required String status,
    required String timeSlot,
    required String markedBy,
  }) async {
    if (!SupabaseConfig.isConfigured) return false;
    try {
      await _client.from('attendance').insert({
        'student_email': studentEmail,
        'subject': subject,
        'date': DateTime.now().toIso8601String().split('T').first,
        'time_slot': timeSlot,
        'status': status,
        'marked_by': markedBy,
      });
      return true;
    } catch (e) {
      print('Error recording attendance in Supabase: $e');
      return false;
    }
  }
}

