import 'package:flutter/material.dart';

/// AppColors defines the 2026 Dark-Mode-First curated color design system for FRINKELs.
abstract class AppColors {
  // Brand & Accent Colors
  static const Color primary = Color(0xFF6C5CE7);
  static const Color primaryLight = Color(0xFFA29BFE);
  static const Color accentCyan = Color(0xFF00CEC9);
  static const Color accentNeon = Color(0xFF55E6C1);
  static const Color accentPurple = Color(0xFFB53471);

  // Background Surfaces (Dark Mode First)
  static const Color backgroundDark = Color(0xFF0A0C14);
  static const Color backgroundSecondary = Color(0xFF121520);
  static const Color surfaceElevated = Color(0xFF1A1D2C);

  // Glassmorphic Tokens
  static const Color glassBackground = Color(0x12FFFFFF); // ~7% white opacity
  static const Color glassBackgroundHover = Color(
    0x1EFFFFFF,
  ); // ~12% white opacity
  static const Color glassBorder = Color(
    0x2BFFFFFF,
  ); // ~17% white opacity border
  static const Color glassBorderHighlight = Color(
    0x66A29BFE,
  ); // Glowing violet border

  // Text Colors
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textTertiary = Color(0xFF64748B);

  // Status & Feedback Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFF43F5E);
  static const Color info = Color(0xFF3B82F6);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, accentCyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [backgroundDark, Color(0xFF0F121E), Color(0xFF151828)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient glassBorderGradient = LinearGradient(
    colors: [Color(0x66FFFFFF), Color(0x11FFFFFF), Color(0x446C5CE7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
