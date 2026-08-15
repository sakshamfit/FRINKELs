import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/glass_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../controllers/auth_provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            LucideIcons.arrow_left,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => context.go('${AppRouter.authPath}/login'),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  LucideIcons.key,
                  size: 64,
                  color: AppColors.accent,
                ).animate().scale(duration: 400.ms),

                const SizedBox(height: 32),

                Text(
                  'Reset password',
                  style: AppTypography.title.copyWith(fontSize: 32),
                ).animate().fadeIn(delay: 100.ms),

                const SizedBox(height: 12),

                Text(
                  'Enter your email to receive a reset link',
                  style: AppTypography.body.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 200.ms),

                const SizedBox(height: 48),

                Form(
                  key: _formKey,
                  child: GlassTextField(
                    controller: _emailController,
                    labelText: 'Email',
                    hintText: 'name@company.com',
                    prefixIcon: const Icon(LucideIcons.mail, size: 20),
                  ).animate().fadeIn(delay: 300.ms),
                ),

                const SizedBox(height: 32),

                Consumer(
                  builder: (context, ref, child) {
                    final authState = ref.watch(authControllerProvider).state;
                    return SizedBox(
                      width: double.infinity,
                      child: FrinkelsButton.primary(
                        text: 'Send Link',
                        isLoading: authState.isLoading,
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            ref
                                .read(authControllerProvider)
                                .resetPassword(_emailController.text);
                          }
                        },
                      ),
                    );
                  },
                ).animate().fadeIn(delay: 400.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
