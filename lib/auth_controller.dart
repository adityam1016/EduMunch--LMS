import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  // Observable properties
  final Rx<String?> _email = Rx<String?>(null);
  final Rx<String?> _role = Rx<String?>(null);
  final RxBool _isLoading = false.obs;
  
  // Session storage keys
  static const String _keyEmail = 'auth_email';
  static const String _keyRole = 'auth_role';
  static const String _keySessionTimestamp = 'session_timestamp';
  
  // Session timeout (24 hours)
  static const int _sessionTimeoutHours = 24;

  // Getters
  String? get email => _email.value;
  String? get role => _role.value;
  bool get isLoggedIn => _email.value != null && _role.value != null;
  bool get isLoading => _isLoading.value;
  
  // Reactive getters for UI
  Rx<String?> get emailStream => _email;
  Rx<String?> get roleStream => _role;

  @override
  void onInit() {
    super.onInit();
    _initializeSession();
  }

  /// Initialize session from stored data or Supabase
  Future<void> _initializeSession() async {
    try {
      _isLoading.value = true;
      
      // Check if there's an active Supabase session
      final supabaseSession = Supabase.instance.client.auth.currentSession;
      
      if (supabaseSession != null) {
        // Validate Supabase session
        await _loadFromSupabase();
      } else {
        // Try to restore from local storage
        await _loadFromLocalStorage();
      }
    } catch (e) {
      print('Error initializing session: $e');
      await clearSession();
    } finally {
      _isLoading.value = false;
    }
  }

  /// Load session from Supabase
  Future<void> _loadFromSupabase() async {
    final session = Supabase.instance.client.auth.currentSession;
    final userEmail = session?.user.email;
    
    if (userEmail == null) {
      await clearSession();
      return;
    }

    final lower = userEmail.toLowerCase();
    String? detectedRole;
    
    if (lower.startsWith('student')) {
      detectedRole = 'Student';
    } else if (lower.startsWith('teacher')) {
      detectedRole = 'Teacher';
    }

    if (detectedRole != null) {
      await setSession(email: lower, role: detectedRole);
    }
  }

  /// Load session from local storage
  Future<void> _loadFromLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedEmail = prefs.getString(_keyEmail);
      final storedRole = prefs.getString(_keyRole);
      final timestamp = prefs.getInt(_keySessionTimestamp);

      if (storedEmail != null && storedRole != null && timestamp != null) {
        // Check if session is still valid
        final sessionTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
        final now = DateTime.now();
        final difference = now.difference(sessionTime).inHours;

        if (difference < _sessionTimeoutHours) {
          _email.value = storedEmail;
          _role.value = storedRole;
          print('Session restored from local storage');
        } else {
          print('Session expired');
          await clearSession();
        }
      }
    } catch (e) {
      print('Error loading from local storage: $e');
    }
  }

  /// Set session and persist to local storage
  Future<void> setSession({required String email, required String role}) async {
    try {
      _email.value = email;
      _role.value = role;

      // Save to local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyEmail, email);
      await prefs.setString(_keyRole, role);
      await prefs.setInt(_keySessionTimestamp, DateTime.now().millisecondsSinceEpoch);
      
      print('Session saved: $email as $role');
    } catch (e) {
      print('Error saving session: $e');
    }
  }

  /// Clear session and logout
  Future<void> clearSession() async {
    try {
      _isLoading.value = true;
      
      // Sign out from Supabase
      await Supabase.instance.client.auth.signOut();
      
      // Clear local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyEmail);
      await prefs.remove(_keyRole);
      await prefs.remove(_keySessionTimestamp);
      
      // Clear in-memory state
      _email.value = null;
      _role.value = null;
      
      print('Session cleared');
    } catch (e) {
      print('Error clearing session: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Validate current session
  Future<bool> validateSession() async {
    try {
      final supabaseSession = Supabase.instance.client.auth.currentSession;
      
      if (supabaseSession == null) {
        // Check local storage validity
        final prefs = await SharedPreferences.getInstance();
        final timestamp = prefs.getInt(_keySessionTimestamp);
        
        if (timestamp != null) {
          final sessionTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
          final now = DateTime.now();
          final difference = now.difference(sessionTime).inHours;
          
          if (difference >= _sessionTimeoutHours) {
            await clearSession();
            return false;
          }
        }
      }
      
      return isLoggedIn;
    } catch (e) {
      print('Error validating session: $e');
      return false;
    }
  }

  /// Refresh session timestamp
  Future<void> refreshSession() async {
    if (isLoggedIn) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_keySessionTimestamp, DateTime.now().millisecondsSinceEpoch);
      print('Session refreshed');
    }
  }

  /// Get session duration in hours
  Future<int> getSessionDuration() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt(_keySessionTimestamp);
      
      if (timestamp != null) {
        final sessionTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
        final now = DateTime.now();
        return now.difference(sessionTime).inHours;
      }
    } catch (e) {
      print('Error getting session duration: $e');
    }
    return 0;
  }

  /// Initialize from Supabase (for backwards compatibility)
  Future<void> initFromSupabase() async {
    await _loadFromSupabase();
  }
}
