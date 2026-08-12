import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'primary_button.dart';

class ErrorState extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;

  const ErrorState({
    super.key,
    required this.title,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryColor = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                LucideIcons.triangle_alert,
                size: 32,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: AppTypography.cardTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: AppTypography.body.copyWith(color: secondaryColor),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 32),
              FrinkelsButton.primary(text: 'Try Again', onPressed: onRetry),
            ],
          ],
        ),
      ),
    );
  }
}
