import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class PremiumLogo extends StatelessWidget {
  final double size;
  final bool hasGlow;

  const PremiumLogo({super.key, this.size = 100, this.hasGlow = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.28), // 28 radius logic
        boxShadow: hasGlow
            ? [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.2),
                  blurRadius: size * 0.4,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: AppColors.softCyanGlow.withValues(alpha: 0.1),
                  blurRadius: size * 0.2,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.28),
        child: Image.asset(
          'assets/images/logo.png',
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // High-quality geometric fallback if image is missing
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: AppColors.logoGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.auto_awesome_mosaic_rounded,
                  color: Colors.white,
                  size: size * 0.5,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
