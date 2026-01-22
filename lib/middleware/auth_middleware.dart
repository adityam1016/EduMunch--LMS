import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth_controller.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();
    
    // If user is not logged in, redirect to login
    if (!authController.isLoggedIn) {
      return const RouteSettings(name: '/login');
    }
    
    return null;
  }
}

class RoleMiddleware extends GetMiddleware {
  final String requiredRole;
  
  RoleMiddleware({required this.requiredRole});

  @override
  int? get priority => 2;

  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();
    
    // Check if user has the required role
    if (authController.role != requiredRole) {
      // Redirect to appropriate dashboard based on current role
      switch (authController.role) {
        case 'Student':
          return const RouteSettings(name: '/dashboard');
        case 'Parent':
          return const RouteSettings(name: '/parent-dashboard');
        case 'Teacher':
          return const RouteSettings(name: '/teacher-dashboard');
        default:
          return const RouteSettings(name: '/login');
      }
    }
    
    return null;
  }
}
