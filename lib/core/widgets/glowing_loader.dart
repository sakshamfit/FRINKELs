import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';

class GlowingLoader extends StatelessWidget {
  final double size;

  const GlowingLoader({
    super.key,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.accent.withValues(alpha: 0.1),
                  width: 4,
                ),
              ),
            ),
            CircularProgressIndicator(
              strokeWidth: 4,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
            ).animate(onPlay: (controller) => controller.repeat()).rotate(duration: 1.seconds),
          ],
        ),
      ),
    );
  }
}
