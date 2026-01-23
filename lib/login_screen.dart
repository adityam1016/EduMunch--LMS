import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'auth_controller.dart';
import 'forgot_password_screen.dart';
import 'profile_selection_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isFormFilled = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _userIdController.addListener(_updateFormStatus);
    _passwordController.addListener(_updateFormStatus);
  }

  void _updateFormStatus() {
    setState(() {
      _isFormFilled = _userIdController.text.isNotEmpty && _passwordController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _userIdController.removeListener(_updateFormStatus);
    _passwordController.removeListener(_updateFormStatus);
    _userIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Login Content
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Welcome Text
                    Text(
                      'Welcome to EduMunch',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            offset: const Offset(2, 2),
                            blurRadius: 4,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // White Card Container with gradient
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isDark
                              ? [
                                  const Color(0xFF1E1E1E),
                                  const Color(0xFF1E1E1E).withOpacity(0.9),
                                ]
                              : [
                                  Colors.white,
                                  Colors.white.withOpacity(0.95),
                                ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // User ID Input Field
                          TextField(
                            controller: _userIdController,
                            decoration: InputDecoration(
                              hintText: 'User ID',
                              prefixIcon: const Icon(Icons.person_outline),
                              filled: true,
                              fillColor: Colors.grey[100],
                              hintStyle: const TextStyle(color: Color(0xFF999999)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 2),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Password Input Field
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              prefixIcon: const Icon(Icons.lock_outline),
                              filled: true,
                              fillColor: Colors.grey[100],
                              hintStyle: const TextStyle(color: Color(0xFF999999)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 2),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Login Button
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _isFormFilled && !_isLoading ? _handleLogin : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    _isFormFilled && !_isLoading ? const Color(0xFF7C3AED) : Colors.grey[400],
                                disabledBackgroundColor: Colors.grey[400],
                              ),
                              child: Text(
                                _isLoading ? 'Logging in...' : 'Login',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: _isFormFilled && !_isLoading ? Colors.white : Colors.grey[600],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Forgot Password Link
                          GestureDetector(
                            onTap: () {
                              Get.to(() => const ForgotPasswordScreen());
                            },
                            child: Text(
                              'Forgot Password?',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogin() async {
    final username = _userIdController.text.trim();
    final password = _passwordController.text.trim();

    setState(() {
      _isLoading = true;
    });

    // Test internet connectivity first
    try {
      final result = await InternetAddress.lookup('google.com').timeout(
        const Duration(seconds: 5),
      );
      if (result.isEmpty || result[0].rawAddress.isEmpty) {
        throw SocketException('No internet connection');
      }
    } on SocketException catch (_) {
      setState(() {
        _isLoading = false;
      });
      Get.snackbar(
        'No Internet',
        'Please check your internet connection and try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        duration: const Duration(seconds: 5),
      );
      return;
    } catch (e) {
      print('Connectivity check error: $e');
    }

    try {
      final supabase = Supabase.instance.client;
      print('Attempting login for: $username');
      
      // 1. Authenticate with Supabase
      final response = await supabase.auth.signInWithPassword(
        email: username,
        password: password,
      );

      final userId = response.user?.id;
      final email = (response.user?.email ?? username).toLowerCase();

      if (userId == null) {
        throw Exception('User ID not found');
      }

      // 2. Fetch user role from database
      String? userRole;
      
      try {
        // Fetch from 'user_profiles' table
        final userResponse = await supabase
            .from('user_profiles')
            .select('role')
            .eq('id', userId)
            .maybeSingle();

        userRole = userResponse?['role']?.toString();
        print('Fetched role from database: $userRole');
      } catch (e) {
        print('Could not fetch from user_profiles table: $e');
        
        // Fallback: try 'profiles' table
        try {
          final profileResponse = await supabase
              .from('profiles')
              .select('role')
              .eq('id', userId)
              .maybeSingle();

          userRole = profileResponse?['role']?.toString();
          print('Fetched role from profiles table: $userRole');
        } catch (e2) {
          print('Could not fetch from profiles table: $e2');
        }
      }

      // 3. If role not found in database, fallback to email-based detection
      if (userRole == null || userRole.isEmpty) {
        if (email.startsWith('student')) {
          userRole = 'student';
        } else if (email.startsWith('teacher')) {
          userRole = 'teacher';
        } else if (email.startsWith('parent')) {
          userRole = 'parent';
        }
      }

      // Normalize role to lowercase for comparison
      final roleLower = userRole?.toLowerCase() ?? '';

      // 4. Route based on role
      if (roleLower == 'student') {
        // Show profile selection dialog for student role
        setState(() {
          _isLoading = false;
        });
        
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => ProfileSelectionDialog(email: email),
            );
          }
        });
        return;
      } else if (roleLower == 'teacher') {
        final authController = Get.find<AuthController>();
        await authController.setSession(email: email, role: 'Teacher');

        setState(() {
          _isLoading = false;
        });

        Get.offAllNamed('/teacher-dashboard');
        Get.snackbar(
          'Login Successful',
          'Welcome Teacher!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade900,
        );
        return;
      } else if (roleLower == 'parent') {
        final authController = Get.find<AuthController>();
        await authController.setSession(email: email, role: 'Parent');

        setState(() {
          _isLoading = false;
        });

        Get.offAllNamed('/parent-dashboard');
        Get.snackbar(
          'Login Successful',
          'Welcome Parent!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade900,
        );
        return;
      } else {
        setState(() {
          _isLoading = false;
        });
        
        Get.snackbar(
          'Login Failed',
          'User role not recognized. Please contact administrator.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.shade100,
          colorText: Colors.orange.shade900,
        );
      }
    } on AuthException catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      Get.snackbar(
        'Login Failed',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        duration: const Duration(seconds: 5),
      );
    } on SocketException catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      Get.snackbar(
        'Network Error',
        'Please check your internet connection and try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        duration: const Duration(seconds: 5),
      );
      print('Network error: $e');
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      Get.snackbar(
        'Login Failed',
        'An error occurred. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        duration: const Duration(seconds: 5),
      );
      print('Login error: $e');
    }
  }
}
