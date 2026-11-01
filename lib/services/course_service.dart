import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase_config.dart';

class CourseModel {
  final String id;
  final String subject;
  final String name;
  final String description;
  final String status;
  final double progress;
  final String icon;
  final Color color;
  final String? instructorName;
  final String? videoUrl;

  CourseModel({
    required this.id,
    required this.subject,
    required this.name,
    required this.description,
    required this.status,
    required this.progress,
    required this.icon,
    required this.color,
    this.instructorName,
    this.videoUrl,
  });

  factory CourseModel.fromMap(Map<String, dynamic> map) {
    Color parsedColor = const Color(0xFF8B5CF6);
    if (map['color_hex'] != null) {
      try {
        final hex = (map['color_hex'] as String).replaceAll('#', '');
        parsedColor = Color(int.parse('0xFF$hex'));
      } catch (_) {}
    }

    return CourseModel(
      id: map['id']?.toString() ?? '',
      subject: map['subject'] ?? 'General',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      status: map['status'] ?? 'In Progress',
      progress: (map['progress'] as num?)?.toDouble() ?? 0.0,
      icon: map['icon'] ?? '⚡',
      color: parsedColor,
      instructorName: map['instructor_name'],
      videoUrl: map['video_url'],
    );
  }
}

class CourseService {
  static SupabaseClient get _client => Supabase.instance.client;

  /// Fetch all courses from Supabase
  static Future<List<CourseModel>> getCourses() async {
    if (!SupabaseConfig.isConfigured) return [];
    try {
      final response = await _client
          .from('courses')
          .select('*')
          .order('created_at', ascending: false);

      return (response as List)
          .map((item) => CourseModel.fromMap(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching courses from Supabase: $e');
      return [];
    }
  }

  /// Update course progress
  static Future<bool> updateCourseProgress(String courseId, double progress) async {
    if (!SupabaseConfig.isConfigured) return false;
    try {
      String status = 'In Progress';
      if (progress >= 1.0) status = 'Completed';
      if (progress <= 0.0) status = 'Not Started';

      await _client.from('courses').update({
        'progress': progress,
        'status': status,
      }).eq('id', courseId);
      return true;
    } catch (e) {
      print('Error updating course progress: $e');
      return false;
    }
  }
}

