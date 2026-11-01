import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase_config.dart';

class FeedbackService {
  static SupabaseClient get _client => Supabase.instance.client;

  /// Submit feedback for a faculty member
  static Future<bool> submitFeedback({
    required String studentEmail,
    required String facultyName,
    required int clarityRating,
    required int engagementRating,
    required int approachabilityRating,
    String? additionalComments,
  }) async {
    if (!SupabaseConfig.isConfigured) return false;
    try {
      await _client.from('notifications').insert({
        'title': 'New Student Feedback',
        'message': 'Feedback received for $facultyName: Clarity: $clarityRating/5, Engagement: $engagementRating/5, Approachability: $approachabilityRating/5. $additionalComments',
        'description': additionalComments ?? 'No additional comments',
        'category': 'General',
        'target_role': 'teacher',
      });
      return true;
    } catch (e) {
      print('Feedback notice: $e');
      return false;
    }
  }
}

