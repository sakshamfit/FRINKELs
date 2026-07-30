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
import '../../../../core/widgets/premium_logo.dart';
import '../controllers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundPrimary,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const PremiumLogo(size: 72, hasGlow: true)
                    .animate()
                    .scale(duration: 500.ms, curve: Curves.easeOutBack),
                
                const SizedBox(height: 48),
                
                Text(
                  'Welcome back',
                  style: AppTypography.title.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
                
                const SizedBox(height: 48),
                
                _LoginForm(
                  formKey: _formKey,
                  emailController: _emailController,
                  passwordController: _passwordController,
                ),
                
                const SizedBox(height: 32),
                
                TextButton(
                  onPressed: () => context.go('${AppRouter.authPath}/signup'),
                  child: Text(
                    "Don't have an account? Sign up",
                    style: AppTypography.caption.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ).animate().fadeIn(delay: 1000.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends ConsumerWidget {
  const _LoginForm({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider).state;
    final authController = ref.read(authControllerProvider);

    return Form(
      key: formKey,
      child: Column(
        children: [
          GlassTextField(
            controller: emailController,
            labelText: 'Email',
            hintText: 'name@work.com',
            prefixIcon: const Icon(LucideIcons.mail),
            keyboardType: TextInputType.emailAddress,
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0),
          
          const SizedBox(height: 16),
          
          GlassTextField(
            controller: passwordController,
            labelText: 'Password',
            hintText: '••••••••',
            isPassword: true,
            prefixIcon: const Icon(LucideIcons.lock),
          ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1, end: 0),
          
          const SizedBox(height: 12),
          
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => context.go('${AppRouter.authPath}/reset-password'),
              child: Text(
                'Forgot password?',
                style: AppTypography.tiny.copyWith(color: AppColors.textSecondary),
              ),
            ),
          ).animate().fadeIn(delay: 600.ms),
          
          const SizedBox(height: 32),
          
          FrinkelsButton.primary(
            width: double.infinity,
            text: 'Sign In',
            isLoading: authState.isLoading,
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                authController.signIn(
                  emailController.text,
                  passwordController.text,
                );
              }
            },
          ).animate().fadeIn(delay: 700.ms),
          
          const SizedBox(height: 16),
          
          FrinkelsButton.outline(
            width: double.infinity,
            text: 'Continue with Google',
            icon: const Icon(LucideIcons.globe),
            onPressed: () => authController.signInWithGoogle(),
          ).animate().fadeIn(delay: 800.ms),
        ],
      ),
    );
  }
}
