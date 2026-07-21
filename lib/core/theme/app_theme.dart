import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// AppTheme builds the ThemeData configured for 2026 Dark Mode First design system.
abstract class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.accentCyan,
        surface: AppColors.surfaceElevated,
        error: AppColors.error,
        onPrimary: AppColors.textPrimary,
        onSecondary: AppColors.backgroundDark,
        onSurface: AppColors.textPrimary,
        onError: AppColors.textPrimary,
      ),
      textTheme: TextTheme(
        displayLarge: AppTypography.displayLarge,
        displayMedium: AppTypography.displayMedium,
        titleLarge: AppTypography.titleLarge,
        titleMedium: AppTypography.titleMedium,
        bodyLarge: AppTypography.bodyLarge,
        bodyMedium: AppTypography.bodyMedium,
        labelLarge: AppTypography.labelLarge,
        labelSmall: AppTypography.labelSmall,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
    );
  }
}
