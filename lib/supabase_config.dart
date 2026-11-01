/// Supabase Configuration for EduMunch LMS
class SupabaseConfig {
  /// Supabase Project URL
  static const String url = 'https://iuvhyhlvbdzkjcxmopjv.supabase.co';

  /// Supabase Anon / Public API Key
  static const String anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml1dmh5aGx2YmR6a2pjeG1vcGp2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTMxMTAzMTMsImV4cCI6MjEwODY4NjMxM30.GfNZQB0PM-9z5GUl3f1XIUJPhLs77Oj6CvBVk_Co9jM';

  /// Returns true if valid credentials have been configured
  static bool get isConfigured =>
      url.isNotEmpty &&
      !url.contains('YOUR_SUPABASE') &&
      anonKey.isNotEmpty &&
      !anonKey.contains('YOUR_SUPABASE');
}
