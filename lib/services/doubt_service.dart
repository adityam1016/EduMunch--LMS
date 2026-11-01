import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase_config.dart';

class DoubtModel {
  final String id;
  final String studentEmail;
  final String subject;
  final String title;
  final String question;
  final String status; // 'open', 'in_progress', 'resolved'
  final DateTime createdAt;
  final List<DoubtMessageModel> messages;

  DoubtModel({
    required this.id,
    required this.studentEmail,
    required this.subject,
    required this.title,
    required this.question,
    required this.status,
    required this.createdAt,
    this.messages = const [],
  });

  factory DoubtModel.fromMap(Map<String, dynamic> map, {List<DoubtMessageModel>? messages}) {
    return DoubtModel(
      id: map['id']?.toString() ?? '',
      studentEmail: map['student_email'] ?? '',
      subject: map['subject'] ?? 'General',
      title: map['title'] ?? '',
      question: map['question'] ?? '',
      status: map['status'] ?? 'open',
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : DateTime.now(),
      messages: messages ?? [],
    );
  }
}

class DoubtMessageModel {
  final String id;
  final String doubtId;
  final String senderName;
  final String senderRole; // 'student', 'teacher'
  final String message;
  final DateTime createdAt;

  DoubtMessageModel({
    required this.id,
    required this.doubtId,
    required this.senderName,
    required this.senderRole,
    required this.message,
    required this.createdAt,
  });

  factory DoubtMessageModel.fromMap(Map<String, dynamic> map) {
    return DoubtMessageModel(
      id: map['id']?.toString() ?? '',
      doubtId: map['doubt_id']?.toString() ?? '',
      senderName: map['sender_name'] ?? 'User',
      senderRole: map['sender_role'] ?? 'student',
      message: map['message'] ?? '',
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : DateTime.now(),
    );
  }
}

class DoubtService {
  static SupabaseClient get _client => Supabase.instance.client;

  /// Fetch all doubts for student (or all doubts if studentEmail is null)
  static Future<List<DoubtModel>> getDoubts({String? studentEmail}) async {
    if (!SupabaseConfig.isConfigured) return [];
    try {
      var query = _client.from('doubts').select('*');
      if (studentEmail != null && studentEmail.isNotEmpty) {
        query = query.eq('student_email', studentEmail);
      }

      final response = await query.order('created_at', ascending: false);
      final List<DoubtModel> doubtsList = [];

      for (var item in (response as List)) {
        final doubtId = item['id'].toString();
        // Fetch messages for this doubt
        List<DoubtMessageModel> msgs = [];
        try {
          final msgRes = await _client
              .from('doubt_messages')
              .select('*')
              .eq('doubt_id', doubtId)
              .order('created_at', ascending: true);
          msgs = (msgRes as List)
              .map((m) => DoubtMessageModel.fromMap(m as Map<String, dynamic>))
              .toList();
        } catch (_) {}

        doubtsList.add(DoubtModel.fromMap(item as Map<String, dynamic>, messages: msgs));
      }

      return doubtsList;
    } catch (e) {
      print('Error fetching doubts: $e');
      return [];
    }
  }

  /// Create a new doubt
  static Future<DoubtModel?> createDoubt({
    required String studentEmail,
    required String subject,
    required String title,
    required String question,
  }) async {
    if (!SupabaseConfig.isConfigured) return null;
    try {
      final res = await _client.from('doubts').insert({
        'student_email': studentEmail,
        'subject': subject,
        'title': title,
        'question': question,
        'status': 'open',
      }).select().single();

      final newDoubt = DoubtModel.fromMap(res);

      // Create initial message
      try {
        await _client.from('doubt_messages').insert({
          'doubt_id': newDoubt.id,
          'sender_name': 'You',
          'sender_role': 'student',
          'message': question,
        });
      } catch (_) {}

      return newDoubt;
    } catch (e) {
      print('Error creating doubt: $e');
      return null;
    }
  }

  /// Send message in a doubt thread
  static Future<bool> sendMessage({
    required String doubtId,
    required String senderName,
    required String senderRole,
    required String message,
  }) async {
    if (!SupabaseConfig.isConfigured) return false;
    try {
      await _client.from('doubt_messages').insert({
        'doubt_id': doubtId,
        'sender_name': senderName,
        'sender_role': senderRole,
        'message': message,
      });
      return true;
    } catch (e) {
      print('Error sending message: $e');
      return false;
    }
  }
}

