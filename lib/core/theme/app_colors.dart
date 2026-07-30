import 'package:flutter/material.dart';

/// AppColors defines the high-end, minimal curated color system for FRINKELs.
/// Philosophy: Apple, Linear, Arc, Nothing.
abstract class AppColors {
  // Accent & Status
  static const Color accent = Color(0xFF0A72EF);
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);

  // Light Mode Tokens
  static const Color backgroundPrimary = Color(0xFFFCFCFC);
  static const Color backgroundSecondary = Color(0xFFF7F7F7);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF171717);
  static const Color textSecondary = Color(0xFF6F6F6F);
  static const Color dividerLight = Color(0x0F000000); // rgba(0,0,0,.06)

  // Dark Mode Tokens (Pure Black Philosophy)
  static const Color backgroundDark = Color(0xFF000000);
  static const Color cardDark = Color(0xFF0E0E0E);
  static const Color textPrimaryDark = Color(0xFFFCFCFC);
  static const Color textSecondaryDark = Color(0xFFA1A1A1);
  static const Color dividerDark = Color(0x1FFFFFFF); // rgba(255,255,255,.12)

  // Icon Colors
  static const Color iconPrimary = Color(0xFF171717);
  static const Color iconSecondary = Color(0xFF6F6F6F);

  // Brand Gradients (from logo)
  static const List<Color> logoGradient = [
    Color(0xFF0A72EF), // Blue
    Color(0xFF4F46E5), // Indigo
    Color(0xFF7C3AED), // Purple
  ];

  // Semantic colors for UI components
  static const Color primary = Color(0xFF0A72EF); // same as accent
  static const Color primaryDark = Color(0xFFFCFCFC); // same as textPrimaryDark
  static const Color secondary = Color(0xFF7C3AED); // purple from logoGradient

  static const Color softCyanGlow = Color(0xFF00CEC9);
}