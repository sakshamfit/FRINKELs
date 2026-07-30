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

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
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
                const PremiumLogo(size: 60, hasGlow: false)
                    .animate()
                    .scale(duration: 400.ms),
                
                const SizedBox(height: 32),
                
                Text(
                  'Create account',
                  style: AppTypography.title.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    fontSize: 32,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 100.ms),
                
                const SizedBox(height: 48),
                
                _SignupForm(
                  formKey: _formKey,
                  nameController: _nameController,
                  emailController: _emailController,
                  passwordController: _passwordController,
                ),
                
                const SizedBox(height: 32),
                
                TextButton(
                  onPressed: () => context.go('${AppRouter.authPath}/login'),
                  child: Text(
                    "Already have an account? Sign in",
                    style: AppTypography.caption.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ).animate().fadeIn(delay: 800.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SignupForm extends ConsumerWidget {
  const _SignupForm({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
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
            controller: nameController,
            labelText: 'Full Name',
            hintText: 'John Doe',
            prefixIcon: const Icon(LucideIcons.user),
          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),
          
          const SizedBox(height: 16),
          
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
          
          const SizedBox(height: 32),
          
          FrinkelsButton.primary(
            width: double.infinity,
            text: 'Create Account',
            isLoading: authState.isLoading,
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                authController.signUp(
                  emailController.text,
                  passwordController.text,
                  nameController.text,
                );
              }
            },
          ).animate().fadeIn(delay: 600.ms),
        ],
      ),
    );
  }
}
