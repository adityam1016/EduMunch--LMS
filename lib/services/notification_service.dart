import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase_config.dart';

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String description;
  final String category;
  final String targetRole;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.description,
    required this.category,
    required this.targetRole,
    this.isRead = false,
    required this.createdAt,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id']?.toString() ?? '',
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? 'General',
      targetRole: map['target_role'] ?? 'all',
      isRead: map['is_read'] ?? false,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : DateTime.now(),
    );
  }
}

class NotificationService {
  static SupabaseClient get _client => Supabase.instance.client;

  /// Fetch notifications for a given role ('student', 'teacher', 'parent', 'all')
  static Future<List<NotificationModel>> getNotifications({String role = 'student'}) async {
    if (!SupabaseConfig.isConfigured) return [];
    try {
      final roleLower = role.toLowerCase();
      final response = await _client
          .from('notifications')
          .select('*')
          .or('target_role.eq.all,target_role.eq.$roleLower')
          .order('created_at', ascending: false);

      return (response as List)
          .map((item) => NotificationModel.fromMap(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching notifications from Supabase: $e');
      return [];
    }
  }

  /// Mark notification as read
  static Future<void> markAsRead(String notificationId) async {
    if (!SupabaseConfig.isConfigured) return;
    try {
      await _client
          .from('notifications')
          .update({'is_read': true})
          .eq('id', notificationId);
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }
}

