import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../auth/presentation/controllers/auth_provider.dart';
import '../controllers/profile_provider.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/profile.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final String? userId;
  const ProfileScreen({super.key, this.userId});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late final String _userId;
  bool _isOwnProfile = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() {
    final currentUser = ref.read(authControllerProvider).state.user;
    final userId = widget.userId;

    _userId = userId ?? currentUser?.id ?? '';
    _isOwnProfile = userId == null || userId == currentUser?.id;
  }

  void _followUser() {
    ref.read(followProvider(_userId).notifier).followUser();
  }

  void _unfollowUser() {
    ref.read(followProvider(_userId).notifier).unfollowUser();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userProfileAsync = ref.watch(userProfileProvider(_userId));
    final followAsync = ref.watch(followProvider(_userId));
    final followersAsync = ref.watch(followersProvider(_userId));
    final followingAsync = ref.watch(followingProvider(_userId));

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundPrimary,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(isDark),
          _buildProfileHeader(userProfileAsync, followAsync, isDark),
          _buildStatsSection(followersAsync, followingAsync, isDark),
          _buildBioSection(userProfileAsync, isDark),
          _buildFollowButton(followAsync, isDark),
          _buildTabs(),
          _buildProfileContent(userProfileAsync, isDark),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar(bool isDark) {
    return SliverAppBar(
      expandedHeight: 280,
      backgroundColor: Colors.transparent,
      elevation: 0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(color: isDark ? Colors.grey[900] : Colors.grey[200]),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.6),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        if (_isOwnProfile)
          IconButton(
            icon: Icon(
              LucideIcons.settings,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: () {
              // Navigate to edit profile
            },
          ),
      ],
    );
  }

  Widget _buildProfileHeader(
    AsyncValue<UserProfile?> userProfileAsync,
    AsyncValue<bool> followAsync,
    bool isDark,
  ) {
    return SliverToBoxAdapter(
      child: userProfileAsync.when(
        data: (userProfile) => userProfile != null
            ? _buildProfileHeaderContent(userProfile, followAsync, isDark)
            : const Center(child: Text('Profile not found')),
        loading: () => const _ProfileHeaderSkeleton(),
        error: (error, stack) => _ProfileHeaderError(error: error),
      ),
    );
  }

  Widget _buildProfileHeaderContent(
    UserProfile userProfile,
    AsyncValue<bool> followAsync,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: userProfile.avatarUrl != null
                ? NetworkImage(userProfile.avatarUrl!)
                : null,
            child: userProfile.avatarUrl == null
                ? Icon(
                    LucideIcons.user,
                    size: 48,
                    color: isDark ? Colors.white70 : Colors.grey[600],
                  )
                : null,
          ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                userProfile.name ?? 'Anonymous User',
                style: AppTypography.section.copyWith(
                  fontSize: 24.0,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              if (userProfile.emailVerified)
                const Icon(
                  LucideIcons.circle_check,
                  color: AppColors.accent,
                  size: 20,
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            userProfile.profession ?? 'Professional',
            style: AppTypography.body.copyWith(
              fontSize: 16,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          if (!_isOwnProfile)
            followAsync.when(
              data: (isFollowing) => _FollowButton(
                isFollowing: isFollowing,
                onFollow: _followUser,
                onUnfollow: _unfollowUser,
                isDark: isDark,
              ),
              loading: () => const SizedBox(
                width: 120,
                height: 36,
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              ),
              error: (error, stack) =>
                  _FollowButtonError(error: error, isDark: isDark),
            ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(
    AsyncValue<List<Profile>> followersAsync,
    AsyncValue<List<Profile>> followingAsync,
    bool isDark,
  ) {
    return SliverToBoxAdapter(
      child: followersAsync.when(
        data: (followers) => followingAsync.when(
          data: (following) =>
              _buildStatsContent(followers.length, following.length, isDark),
          loading: () => const _StatsSkeleton(),
          error: (error, stack) => _StatsError(error: error),
        ),
        loading: () => const _StatsSkeleton(),
        error: (error, stack) => _StatsError(error: error),
      ),
    );
  }

  Widget _buildStatsContent(
    int followersCount,
    int followingCount,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: GlassCard(
        blur: 20,
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _StatItem(
              label: 'Followers',
              value: followersCount.toString(),
              icon: LucideIcons.users,
              isDark: isDark,
            ),
            _StatItem(
              label: 'Following',
              value: followingCount.toString(),
              icon: LucideIcons.user_plus,
              isDark: isDark,
            ),
            _StatItem(
              label: 'Posts',
              value: '0',
              icon: LucideIcons.folder,
              isDark: isDark,
            ),
          ],
        ),
      ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
    );
  }

  Widget _buildBioSection(
    AsyncValue<UserProfile?> userProfileAsync,
    bool isDark,
  ) {
    return userProfileAsync.when(
      data: (userProfile) => _buildBioContent(userProfile?.bio, isDark),
      loading: () => const SliverToBoxAdapter(child: _BioSkeleton()),
      error: (error, stack) => SliverToBoxAdapter(child: _BioError(error: error)),
    );
  }

  Widget _buildBioContent(String? bio, bool isDark) {
    if (bio == null || bio.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox(height: 24));
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About',
              style: AppTypography.cardTitle.copyWith(
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              bio,
              style: AppTypography.body.copyWith(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),
    );
  }

  Widget _buildFollowButton(AsyncValue<bool> followAsync, bool isDark) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: _isOwnProfile
            ? const SizedBox.shrink()
            : followAsync.when(
                data: (isFollowing) => FrinkelsButton.primary(
                  text: isFollowing ? 'Unfollow' : 'Follow',
                  width: double.infinity,
                  onPressed: isFollowing ? _unfollowUser : _followUser,
                ),
                loading: () => const SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                error: (error, stack) =>
                    _FollowButtonError(error: error, isDark: isDark),
              ),
      ),
    );
  }

  Widget _buildTabs() {
    return SliverToBoxAdapter(
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            _ProfileTab(label: 'Posts', isActive: true),
            SizedBox(width: 32),
            _ProfileTab(label: 'Following'),
            SizedBox(width: 32),
            _ProfileTab(label: 'Followers'),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent(
    AsyncValue<UserProfile?> userProfileAsync,
    bool isDark,
  ) {
    return SliverFillRemaining(
      child: userProfileAsync.when(
        data: (userProfile) => userProfile != null 
            ? _buildProfileContentContent(userProfile, isDark)
            : const SizedBox.shrink(),
        loading: () => const _ProfileContentSkeleton(),
        error: (error, stack) => _ProfileContentError(error: error),
      ),
    );
  }

  Widget _buildProfileContentContent(UserProfile userProfile, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Activity',
            style: AppTypography.section.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'No posts yet',
              style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeaderSkeleton extends StatelessWidget {
  const _ProfileHeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(radius: 50),
          SizedBox(height: 16),
          Text('Loading...'),
        ],
      ),
    );
  }
}

class _ProfileHeaderError extends StatelessWidget {
  final Object error;
  const _ProfileHeaderError({required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(LucideIcons.triangle_alert, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          const Text(
            'Error loading profile',
            style: TextStyle(color: Colors.red, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: TextStyle(color: Colors.red[300], fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _FollowButton extends StatelessWidget {
  final bool isFollowing;
  final VoidCallback onFollow;
  final VoidCallback onUnfollow;
  final bool isDark;

  const _FollowButton({
    required this.isFollowing,
    required this.onFollow,
    required this.onUnfollow,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return FrinkelsButton(
      text: isFollowing ? 'Unfollow' : 'Follow',
      variant: isFollowing ? ButtonVariant.outline : ButtonVariant.filled,
      onPressed: isFollowing ? onUnfollow : onFollow,
      width: 120,
      height: 36,
    );
  }
}

class _FollowButtonError extends StatelessWidget {
  final Object error;
  final bool isDark;

  const _FollowButtonError({required this.error, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return const FrinkelsButton(
      text: 'Error',
      onPressed: null,
      width: 120,
      height: 36,
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isDark;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isDark ? Colors.white70 : Colors.grey[600],
            size: 20,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white54 : Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

class _StatsSkeleton extends StatelessWidget {
  const _StatsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          3,
          (_) => Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

class _StatsError extends StatelessWidget {
  final Object error;
  const _StatsError({required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(LucideIcons.triangle_alert, color: Colors.red, size: 36),
          const SizedBox(height: 8),
          const Text(
            'Error loading stats',
            style: TextStyle(color: Colors.red, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _BioSkeleton extends StatelessWidget {
  const _BioSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(height: 12),
          Text('Loading...'),
        ],
      ),
    );
  }
}

class _BioError extends StatelessWidget {
  final Object error;
  const _BioError({required this.error});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 12),
          const Text(
            'Error loading bio',
            style: TextStyle(color: Colors.red, fontSize: 14),
          ),
        ],
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            fontSize: 16,
            color: isActive ? Colors.blue : Colors.grey[600],
          ),
        ),
        if (isActive)
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 24,
            height: 2,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
      ],
    );
  }
}

class _ProfileContentSkeleton extends StatelessWidget {
  const _ProfileContentSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Loading...'),
    );
  }
}

class _ProfileContentError extends StatelessWidget {
  final Object error;
  const _ProfileContentError({required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(LucideIcons.triangle_alert, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          const Text(
            'Error loading content',
            style: TextStyle(color: Colors.red, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: TextStyle(color: Colors.red[300], fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
