import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// AppTypography implements the minimal, premium typography system for FRINKELs.
/// Philosophy: Geist Sans (Inter fallback), Negative tracking on headlines.
abstract class AppTypography {
  // Negative tracking for premium feel
  static const double _headlineTracking = -1.2;
  static const double _sectionTracking = -0.6;
  static const double _cardTracking = -0.4;

  static TextStyle title = GoogleFonts.inter(
    fontSize: 40,
    fontWeight: FontWeight.w700,
    letterSpacing: _headlineTracking,
    height: 1.1,
  );

  static TextStyle section = GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: _sectionTracking,
  );

  static TextStyle cardTitle = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: _cardTracking,
  );

  static TextStyle body = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  static TextStyle caption = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  static TextStyle tiny = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );

  static TextStyle caption2 = GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w400,
  );

  /// Get theme-aware text styles
  static TextTheme getTextTheme(bool isDark) {
    final baseColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final secondaryColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return TextTheme(
      displayLarge: title.copyWith(color: baseColor),
      headlineMedium: section.copyWith(color: baseColor),
      titleLarge: cardTitle.copyWith(color: baseColor),
      bodyLarge: body.copyWith(color: baseColor),
      bodyMedium: body.copyWith(color: baseColor, fontSize: 14),
      labelMedium: caption.copyWith(color: secondaryColor),
      labelSmall: tiny.copyWith(color: secondaryColor),
    );
  }
}
