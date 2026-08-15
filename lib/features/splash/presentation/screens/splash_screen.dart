import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/premium_logo.dart';
import '../../../../features/auth/presentation/controllers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startFlow();
  }

  void _startFlow() {
    // Check session while animating
    Timer(const Duration(milliseconds: 2500), () {
      if (mounted) {
        final authState = ref.read(authControllerProvider).state;
        if (authState.isAuthenticated) {
          context.go(AppRouter.homePath);
        } else {
          context.go(AppRouter.loginPath);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const PremiumLogo(size: 100, hasGlow: true)
                .animate()
                .scale(
                  duration: 800.ms,
                  curve: Curves.easeOutBack,
                  begin: const Offset(0.5, 0.5),
                )
                .fadeIn(duration: 400.ms),

            const SizedBox(height: 24),

            Text(
              'FRINKELs',
              style: AppTypography.title.copyWith(
                fontSize: 32,
                letterSpacing: -1.0,
                fontWeight: FontWeight.w700,
              ),
            ).animate().fadeIn(delay: 300.ms, duration: 600.ms),

            const SizedBox(height: 12),

            Text(
                  'Find. Connect. Grow.',
                  style: AppTypography.title.copyWith(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    letterSpacing: 3.0,
                    fontWeight: FontWeight.w600,
                  ),
                )
                .animate()
                .fadeIn(delay: 600.ms, duration: 600.ms)
                .slideY(
                  begin: 0.2,
                  end: 0,
                  duration: 600.ms,
                  curve: Curves.easeOut,
                ),
          ],
        ),
      ),
    );
  }
}
