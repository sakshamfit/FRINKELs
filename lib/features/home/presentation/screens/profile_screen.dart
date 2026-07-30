import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_padding.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../auth/presentation/controllers/auth_provider.dart';
import '../../../auth/domain/entities/user.dart';
import '../controllers/home_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final String? userId;
  const ProfileScreen({super.key, this.userId});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // If widget.userId is null, we show the current user's profile
    final currentUser = ref.watch(authControllerProvider).state.user;
    
    if (widget.userId == null && currentUser != null) {
      return _buildProfileView(context, isDark, currentUser, isMe: true);
    }

    // Otherwise, fetch profile by ID
    // For now, if it's the current user's ID, just show current user
    if (widget.userId == currentUser?.id) {
       return _buildProfileView(context, isDark, currentUser!, isMe: true);
    }

    // In a real app, we would use a FutureProvider to fetch the profile
    // final profileAsync = ref.watch(profileProvider(widget.userId!));
    // return profileAsync.when(...);
    
    return const Scaffold(body: Center(child: Text('Loading profile...')));
  }

  Widget _buildProfileView(BuildContext context, bool isDark, User user, {required bool isMe}) {
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundPrimary,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildCover(context, user),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildHeader(isDark, user, isMe),
                const SizedBox(height: 32),
                _buildStats(isDark, user),
                const SizedBox(height: 48),
                _buildBio(isDark, user),
                const SizedBox(height: 48),
                _buildSkills(isDark, user),
                const SizedBox(height: 48),
                _buildTabs(isDark),
              ],
            ),
          ),
          _buildGalleryGrid(isDark),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }

  Widget _buildCover(BuildContext context, User user) {
    return SliverAppBar(
      expandedHeight: 280,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            user.coverUrl != null 
              ? Image.network(user.coverUrl!, fit: BoxFit.cover)
              : Container(color: AppColors.cardDark),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ],
        ),
      ),
      pinned: true,
      actions: [
        IconButton(
          icon: const Icon(LucideIcons.settings, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildHeader(bool isDark, User user, bool isMe) {
    return Transform.translate(
      offset: const Offset(0, -60),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: isDark ? Colors.black : Colors.white, width: 4),
              boxShadow: AppShadows.premium,
              image: user.avatarUrl != null 
                ? DecorationImage(image: NetworkImage(user.avatarUrl!), fit: BoxFit.cover)
                : null,
            ),
            child: user.avatarUrl == null 
              ? const Icon(LucideIcons.user, size: 48) 
              : null,
          ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                user.name ?? 'Professional', 
                style: AppTypography.section.copyWith(fontSize: 32)
              ),
              const SizedBox(width: 8),
              if (user.emailVerified)
                const Icon(LucideIcons.check_circle_2, color: AppColors.accent, size: 24),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            user.profession ?? 'Lead Design Architect',
            style: AppTypography.body.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: FrinkelsButton.primary(
              text: isMe ? 'Edit Profile' : 'Connect',
              width: double.infinity,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(bool isDark, User user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: GlassCard(
        blur: 20,
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatItem('Connections', '2.4k'),
            _buildStatItem('Projects', '48'),
            _buildStatItem('Rating', '4.9'),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: AppTypography.cardTitle.copyWith(fontSize: 22, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text(label, style: AppTypography.tiny),
      ],
    );
  }

  Widget _buildBio(bool isDark, User user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('About', style: AppTypography.cardTitle),
          const SizedBox(height: 16),
          Text(
            user.bio ?? 'Building the future of professional networking at FRINKELs. Passionate about minimal design and clean code.',
            style: AppTypography.body.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkills(bool isDark, User user) {
    final skills = user.skills.isNotEmpty ? user.skills : ['UI Design', 'Flutter', 'Firebase', 'Supabase', 'Architecture'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Skills', style: AppTypography.cardTitle),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skills.map((skill) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : AppColors.cardLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isDark ? Colors.white10 : Colors.black10),
              ),
              child: Text(skill, style: AppTypography.tiny),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(bool isDark) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          _ProfileTab(label: 'Portfolio', isActive: true),
          _ProfileTab(label: 'Experience'),
          _ProfileTab(label: 'Social'),
        ],
      ),
    );
  }

  Widget _buildGalleryGrid(bool isDark) {
    return SliverPadding(
      padding: const EdgeInsets.all(24),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.0,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return GlassCard(
              padding: EdgeInsets.zero,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  image: DecorationImage(
                    image: NetworkImage('https://picsum.photos/400/400?random=$index'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
          childCount: 8,
        ),
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  final String label;
  final bool isActive;

  const _ProfileTab({required this.label, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 32),
      child: Column(
        children: [
          Text(
            label,
            style: AppTypography.body.copyWith(
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              color: isActive ? AppColors.accent : AppColors.textSecondary,
              fontSize: 15,
            ),
          ),
          if (isActive)
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 24,
              height: 2,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(2),
              ),
            ).animate().scale(duration: 200.ms),
        ],
      ),
    );
  }
}
