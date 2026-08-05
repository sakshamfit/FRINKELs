import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import '../../auth/presentation/controllers/auth_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/glass_text_field.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Form controllers
  final _usernameController = TextEditingController();
  final _professionController = TextEditingController();
  final _bioController = TextEditingController();
  final _locationController = TextEditingController();

  final List<String> _selectedSkills = [];
  final List<String> _selectedInterests = [];

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(duration: 400.ms, curve: Curves.easeOutCubic);
    } else {
      _completeOnboarding();
    }
  }

  Future<void> _completeOnboarding() async {
    debugPrint('ONBOARDING: Get Started tapped');
    
    final authController = ref.read(authControllerProvider);
    
    debugPrint('ONBOARDING: Starting onboarding completion');
    await authController.completeOnboarding({
      'username': _usernameController.text,
      'profession': _professionController.text,
      'bio': _bioController.text,
      'location': _locationController.text,
      'skills': _selectedSkills,
      'interests': _selectedInterests,
    });

    if (authController.state.errorMessage != null) {
      debugPrint('ONBOARDING: Error occurred: ${authController.state.errorMessage}');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authController.state.errorMessage!)),
        );
      }
      return;
    }

    debugPrint('ONBOARDING: Navigation requested to home');
    if (mounted) {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authState = ref.watch(authControllerProvider).state;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundPrimary,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  ...List.generate(
                    4,
                    (index) => Expanded(
                      child: Container(
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: index <= _currentPage
                              ? AppColors.accent
                              : (isDark ? Colors.white12 : Colors.black12),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) => setState(() => _currentPage = page),
                children: [
                  _buildIdentityStep(isDark),
                  _buildProfessionalStep(isDark),
                  _buildInterestsStep(isDark),
                  _buildFinalStep(isDark),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: FrinkelsButton.primary(
                width: double.infinity,
                text: _currentPage == 3 ? 'Get Started' : 'Continue',
                isLoading: authState.isLoading,
                onPressed: _nextPage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIdentityStep(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text('Choose your identity', style: AppTypography.title),
          const SizedBox(height: 12),
          Text(
            'This is how the professional world will see you.',
            style: AppTypography.body.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 48),
          Center(
            child: Stack(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark ? Colors.white12 : Colors.black12,
                  ),
                  child: const Icon(
                    LucideIcons.user,
                    size: 48,
                    color: AppColors.textSecondary,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.camera,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          GlassTextField(
            controller: _usernameController,
            labelText: 'Username',
            hintText: 'e.g. satyam_dev',
            prefixIcon: const Icon(LucideIcons.at_sign),
          ),
          const SizedBox(height: 24),
          GlassTextField(
            controller: _bioController,
            labelText: 'Bio',
            hintText: 'Tell us a bit about yourself...',
            prefixIcon: const Icon(LucideIcons.pencil),
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalStep(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text('Your Profession', style: AppTypography.title),
          const SizedBox(height: 12),
          Text(
            'Help us connect you with the right opportunities.',
            style: AppTypography.body.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 48),
          GlassTextField(
            controller: _professionController,
            labelText: 'Role',
            hintText: 'e.g. UI/UX Designer',
            prefixIcon: const Icon(LucideIcons.briefcase),
          ),
          const SizedBox(height: 24),
          GlassTextField(
            controller: _locationController,
            labelText: 'Location',
            hintText: 'e.g. Bangalore, India',
            prefixIcon: const Icon(LucideIcons.map_pin),
          ),
          const SizedBox(height: 32),
          Text('Top Skills', style: AppTypography.cardTitle),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildChoiceChip('Design'),
              _buildChoiceChip('Development'),
              _buildChoiceChip('Marketing'),
              _buildChoiceChip('Product'),
              _buildChoiceChip('Sales'),
              _buildChoiceChip('Writing'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInterestsStep(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text('What interests you?', style: AppTypography.title),
          const SizedBox(height: 12),
          Text(
            'Select at least 3 topics to personalize your feed.',
            style: AppTypography.body.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 48),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildInterestCard('Technology', LucideIcons.cpu),
              _buildInterestCard('Art', LucideIcons.palette),
              _buildInterestCard('Music', LucideIcons.music),
              _buildInterestCard('Business', LucideIcons.trending_up),
              _buildInterestCard('Sports', LucideIcons.trophy),
              _buildInterestCard('Science', LucideIcons.flask_conical),
              _buildInterestCard('Gaming', LucideIcons.gamepad_2),
              _buildInterestCard('Nature', LucideIcons.trees),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinalStep(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            LucideIcons.party_popper,
            size: 80,
            color: AppColors.accent,
          ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
          const SizedBox(height: 32),
          Text(
            'You\'re all set!',
            style: AppTypography.title,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Welcome to FRINKELs. Start building your professional network today.',
            style: AppTypography.body,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildChoiceChip(String label) {
    final isSelected = _selectedSkills.contains(label);
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (selected) {
            _selectedSkills.add(label);
          } else {
            _selectedSkills.remove(label);
          }
        });
      },
      backgroundColor: Colors.transparent,
      selectedColor: AppColors.accent.withValues(alpha: 0.2),
      labelStyle: AppTypography.tiny.copyWith(
        color: isSelected ? AppColors.accent : AppColors.textSecondary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected
              ? AppColors.accent
              : (Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.1)),
        ),
      ),
    );
  }

  Widget _buildInterestCard(String label, IconData icon) {
    final isSelected = _selectedInterests.contains(label);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedInterests.remove(label);
          } else {
            _selectedInterests.add(label);
          }
        });
      },
      child: Container(
        width: (MediaQuery.of(context).size.width - 88) / 2,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accent.withValues(alpha: 0.1)
              : (Theme.of(context).brightness == Brightness.dark
                    ? AppColors.cardDark
                    : AppColors.cardLight),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.accent
                : (Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.black.withValues(alpha: 0.1)),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 28,
              color: isSelected ? AppColors.accent : AppColors.textSecondary,
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: AppTypography.tiny.copyWith(
                color: isSelected ? AppColors.accent : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
