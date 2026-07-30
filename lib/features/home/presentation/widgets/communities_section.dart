import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../presentation/controllers/communities_provider.dart';
import '../widgets/community_card.dart';

class CommunitiesSection extends ConsumerWidget {
  const CommunitiesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final communitiesAsync = ref.watch(communitiesProvider);

    return communitiesAsync.when(
      data: (communities) {
        if (communities.isEmpty) {
          return _buildEmptyState(isDark);
        }

        return SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: communities.length,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemBuilder: (context, index) {
              final community = communities[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: CommunityCard(
                  community: community,
                  onTap: () {
                    // TODO: Navigate to community screen
                    // context.go('/community/${community.id}');
                  },
                ),
              );
            },
          ),
        ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.05, end: 0);
      },
      loading: () => _buildLoadingState(isDark),
      error: (error, stackTrace) => _buildErrorState(isDark, error.toString(), ref),
    );
  }

  Widget _buildLoadingState(bool isDark) {
    return SizedBox(
      height: 120,
      child: Center(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 3, // Show 3 placeholder cards while loading
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(right: 16),
            child: SizedBox(
              width: 80,
              child: GlassCard(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark
                            ? AppColors.cardDark.withValues(alpha: 0.2)
                            : AppColors.cardLight.withValues(alpha: 0.2),
                      ),
                      child: const Icon(
                        LucideIcons.users,
                        size: 24,
                        color: Colors.white54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Loading...',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '0',
                      style: TextStyle(
                        fontSize: 10,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(bool isDark, String error, WidgetRef ref) {
    return SizedBox(
      height: 120,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              LucideIcons.cloud_off,
              size: 24,
              color: AppColors.error,
            ),
            const SizedBox(height: 8),
            Text(
              'Failed to load communities',
              style: AppTypography.body.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            TextButton.icon(
              onPressed: () {
                ref.read(communitiesProvider.notifier).refreshCommunities();
              },
              icon: const Icon(LucideIcons.refresh_cw, size: 16),
              label: Text(
                'Retry',
                style: AppTypography.caption.copyWith(color: AppColors.accent),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return SizedBox(
      height: 120,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              LucideIcons.users,
              size: 24,
              color: AppColors.textSecondaryDark,
            ),
            const SizedBox(height: 8),
            Text(
              'No communities found',
              style: AppTypography.body.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}