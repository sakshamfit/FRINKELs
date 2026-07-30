import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// AppTheme implements the premium, minimal design system for FRINKELs.
/// Inspired by Apple, Linear, and Arc.
abstract class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.backgroundPrimary,
      cardColor: AppColors.cardLight,
      dividerColor: AppColors.dividerLight,
      textTheme: AppTypography.getTextTheme(false),
      colorScheme: const ColorScheme.light(
        primary: AppColors.accent,
        secondary: AppColors.accent,
        surface: AppColors.cardLight,
        error: AppColors.error,
        onPrimary: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      cardColor: AppColors.cardDark,
      dividerColor: AppColors.dividerDark,
      textTheme: AppTypography.getTextTheme(true),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accent,
        secondary: AppColors.accent,
        surface: AppColors.cardDark,
        error: AppColors.error,
        onPrimary: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
