import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Wait for animations and session validation
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final authController = Get.find<AuthController>();
    
    // Validate session
    final isValid = await authController.validateSession();

    if (!mounted) return;

    if (isValid && authController.isLoggedIn) {
      // Session is valid, navigate to appropriate dashboard
      String route;
      switch (authController.role) {
        case 'Parent':
          route = '/parent-dashboard';
          break;
        case 'Teacher':
          route = '/teacher-dashboard';
          break;
        default:
          route = '/dashboard';
          break;
      }
      Get.offNamed(route);
    } else {
      // No valid session, go to login
      Get.offNamed('/login');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: Image.asset(
            'assets/logo.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
}
