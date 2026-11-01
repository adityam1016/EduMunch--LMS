import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase_config.dart';

class UserProfile {
  final String id;
  final String email;
  final String fullName;
  final String role; // 'student', 'teacher', 'parent', 'admin'
  final String? phone;
  final String? avatarUrl;

  UserProfile({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    this.phone,
    this.avatarUrl,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id']?.toString() ?? '',
      email: map['email'] ?? '',
      fullName: map['full_name'] ?? '',
      role: (map['role'] ?? 'student').toString().toLowerCase(),
      phone: map['phone'],
      avatarUrl: map['avatar_url'],
    );
  }
}

class AuthService {
  static SupabaseClient get _client => Supabase.instance.client;

  /// Sign Up a new user with email, password, and metadata
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
    required String role, // 'student', 'teacher', 'parent'
    String? phone,
  }) async {
    if (!SupabaseConfig.isConfigured) {
      throw Exception('Supabase is not configured');
    }

    final roleLower = role.toLowerCase().trim();

    final response = await _client.auth.signUp(
      email: email.trim(),
      password: password,
      data: {
        'full_name': fullName.trim(),
        'role': roleLower,
        if (phone != null && phone.isNotEmpty) 'phone': phone.trim(),
      },
    );

    // If user record is created, also verify or insert user_profiles if trigger didn't run
    final user = response.user;
    if (user != null) {
      try {
        await _client.from('user_profiles').upsert({
          'id': user.id,
          'email': user.email ?? email.trim(),
          'full_name': fullName.trim(),
          'role': roleLower,
          if (phone != null && phone.isNotEmpty) 'phone': phone.trim(),
        });
      } catch (e) {
        print('Profile upsert notice: $e');
      }
    }

    return response;
  }

  /// Sign In with email and password
  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    if (!SupabaseConfig.isConfigured) {
      throw Exception('Supabase is not configured');
    }

    return await _client.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// Fetch user profile by Auth user ID
  static Future<UserProfile?> getUserProfile(String userId) async {
    if (!SupabaseConfig.isConfigured) return null;

    try {
      final data = await _client
          .from('user_profiles')
          .select('*')
          .eq('id', userId)
          .maybeSingle();

      if (data != null) {
        return UserProfile.fromMap(data);
      }
    } catch (e) {
      print('Error fetching profile from user_profiles: $e');
    }

    return null;
  }

  /// Send password reset email
  static Future<void> sendPasswordResetEmail(String email) async {
    if (!SupabaseConfig.isConfigured) {
      throw Exception('Supabase is not configured');
    }

    await _client.auth.resetPasswordForEmail(email.trim());
  }

  /// Update password for the currently logged in session
  static Future<void> updatePassword(String newPassword) async {
    if (!SupabaseConfig.isConfigured) {
      throw Exception('Supabase is not configured');
    }

    await _client.auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }

  /// Sign out current user
  static Future<void> signOut() async {
    if (!SupabaseConfig.isConfigured) return;

    try {
      await _client.auth.signOut();
    } catch (e) {
      print('Sign out notice: $e');
    }
  }

  /// Get current authenticated Supabase user
  static User? get currentUser {
    if (!SupabaseConfig.isConfigured) return null;
    try {
      return _client.auth.currentUser;
    } catch (_) {
      return null;
    }
  }
}

