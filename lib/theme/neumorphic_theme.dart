import 'package:flutter/material.dart';

class NMTheme {
  // Base Palette - Exact Soft UI / Neumorphism clay colors
  static const Color bg = Color(0xFFE8EEF5);
  static const Color surface = Color(0xFFEBF1F8);
  static const Color cardBg = Color(0xFFEEF3F9);
  static const Color white = Color(0xFFFFFFFF);

  // Neumorphic Dual Shadows
  static const Color shadowLight = Color(0xFFFFFFFF);
  static const Color shadowDark = Color(0xFFBAC5D5);
  static const Color shadowDarkSubtle = Color(0xFFCAD4E0);

  // Typography Colors
  static const Color textPrimary = Color(0xFF1E2538);
  static const Color textSecondary = Color(0xFF5E697C);
  static const Color textMuted = Color(0xFF8A97A9);

  // Accent Colors matching the design
  static const Color primaryPurple = Color(0xFF381868);
  static const Color primaryPurpleLight = Color(0xFF4C218E);
  static const Color accentTeal = Color(0xFF0C6E5A);
  static const Color accentTealLight = Color(0xFF0F8A71);
  static const Color accentBlue = Color(0xFF1B7696);
  static const Color accentBlueLight = Color(0xFF2293BA);
  static const Color accentAmber = Color(0xFFD97706);
  static const Color accentGreen = Color(0xFF10B981);
  static const Color accentRed = Color(0xFFEF4444);

  // Inset Surface Color
  static const Color sunkenBg = Color(0xFFE1E7F0);
  static const Color sunkenBorder = Color(0xFFD3DDEB);

  // Reusable Raised Box Shadows
  static List<BoxShadow> raisedShadow({
    double offset = 4,
    double blur = 8,
    double opacity = 0.85,
    Color? darkColor,
  }) {
    return [
      BoxShadow(
        color: shadowLight,
        offset: Offset(-offset, -offset),
        blurRadius: blur,
        spreadRadius: 0,
      ),
      BoxShadow(
        color: (darkColor ?? shadowDark).withOpacity(opacity),
        offset: Offset(offset, offset),
        blurRadius: blur,
        spreadRadius: 0,
      ),
    ];
  }

  // Soft Raised Button / Pill Shadow
  static List<BoxShadow> buttonShadow({double offset = 3, double blur = 6}) {
    return [
      BoxShadow(
        color: shadowLight,
        offset: Offset(-offset, -offset),
        blurRadius: blur,
      ),
      BoxShadow(
        color: shadowDark.withOpacity(0.8),
        offset: Offset(offset, offset),
        blurRadius: blur,
      ),
    ];
  }

  // Colored Card Glow / Drop Shadow
  static List<BoxShadow> coloredCardShadow(Color color, {double opacity = 0.35}) {
    return [
      BoxShadow(
        color: color.withOpacity(opacity),
        offset: const Offset(0, 8),
        blurRadius: 16,
        spreadRadius: 0,
      ),
      BoxShadow(
        color: Colors.white.withOpacity(0.12),
        offset: const Offset(-2, -2),
        blurRadius: 6,
      ),
    ];
  }

  // Inset / Sunken Container Decoration
  static BoxDecoration insetDecoration({
    double radius = 16,
    Color? backgroundColor,
    Color? borderColor,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? sunkenBg,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: borderColor ?? sunkenBorder,
        width: 1.2,
      ),
    );
  }

  // Raised Card Decoration
  static BoxDecoration cardDecoration({
    double radius = 24,
    Color? color,
    List<BoxShadow>? shadows,
    Border? border,
  }) {
    return BoxDecoration(
      color: color ?? cardBg,
      borderRadius: BorderRadius.circular(radius),
      border: border ?? Border.all(color: Colors.white.withOpacity(0.6), width: 1),
      boxShadow: shadows ?? raisedShadow(offset: 5, blur: 10),
    );
  }
}
