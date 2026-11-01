import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase_config.dart';

class AssignmentModel {
  final String id;
  final String title;
  final String subject;
  final String description;
  final DateTime dueDate;
  final int totalMarks;
  final String? attachmentUrl;
  final String? createdBy;

  AssignmentModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.description,
    required this.dueDate,
    this.totalMarks = 100,
    this.attachmentUrl,
    this.createdBy,
  });

  factory AssignmentModel.fromMap(Map<String, dynamic> map) {
    return AssignmentModel(
      id: map['id']?.toString() ?? '',
      title: map['title'] ?? '',
      subject: map['subject'] ?? 'General',
      description: map['description'] ?? '',
      dueDate: map['due_date'] != null
          ? DateTime.parse(map['due_date'])
          : DateTime.now().add(const Duration(days: 7)),
      totalMarks: (map['total_marks'] as num?)?.toInt() ?? 100,
      attachmentUrl: map['attachment_url'],
      createdBy: map['created_by'],
    );
  }
}

class AssignmentService {
  static SupabaseClient get _client => Supabase.instance.client;

  /// Fetch all assignments
  static Future<List<AssignmentModel>> getAssignments() async {
    if (!SupabaseConfig.isConfigured) return [];
    try {
      final response = await _client
          .from('assignments')
          .select('*')
          .order('due_date', ascending: true);

      return (response as List)
          .map((item) => AssignmentModel.fromMap(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching assignments from Supabase: $e');
      return [];
    }
  }

  /// Create a new assignment (Teacher)
  static Future<bool> createAssignment({
    required String title,
    required String subject,
    required String description,
    required DateTime dueDate,
    int totalMarks = 100,
    String? createdBy,
  }) async {
    if (!SupabaseConfig.isConfigured) return false;
    try {
      await _client.from('assignments').insert({
        'title': title,
        'subject': subject,
        'description': description,
        'due_date': dueDate.toIso8601String(),
        'total_marks': totalMarks,
        'created_by': createdBy,
      });
      return true;
    } catch (e) {
      print('Error creating assignment in Supabase: $e');
      return false;
    }
  }

  /// Submit an assignment (Student)
  static Future<bool> submitAssignment({
    required String assignmentId,
    required String studentEmail,
    String? fileUrl,
  }) async {
    if (!SupabaseConfig.isConfigured) return false;
    try {
      await _client.from('assignment_submissions').upsert({
        'assignment_id': assignmentId,
        'student_email': studentEmail,
        'file_url': fileUrl,
        'status': 'submitted',
        'submitted_at': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      print('Error submitting assignment: $e');
      return false;
    }
  }

  /// Get submissions for a student
  static Future<List<Map<String, dynamic>>> getStudentSubmissions(String studentEmail) async {
    if (!SupabaseConfig.isConfigured) return [];
    try {
      final res = await _client
          .from('assignment_submissions')
          .select('*')
          .eq('student_email', studentEmail);
      return List<Map<String, dynamic>>.from(res as List);
    } catch (e) {
      print('Error fetching submissions: $e');
      return [];
    }
  }
}

