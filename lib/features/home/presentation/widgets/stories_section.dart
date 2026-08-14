import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../controllers/stories_provider.dart';
import '../../../auth/presentation/controllers/auth_provider.dart';

class StoriesSection extends ConsumerStatefulWidget {
  const StoriesSection({super.key});

  @override
  ConsumerState<StoriesSection> createState() => _StoriesSectionState();
}

class _StoriesSectionState extends ConsumerState<StoriesSection> {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final storiesState = ref.watch(storiesProvider);

    if (storiesState.isLoading) {
      return _buildLoadingState(isDark);
    }

    if (storiesState.error != null) {
      return _buildErrorState(isDark, storiesState.error!);
    }

    final stories = storiesState.stories;
    if (stories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Stories',
                style: AppTypography.section.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimary,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  context.go('/create-story');
                },
                icon: const Icon(
                  LucideIcons.circle_plus,
                  size: 18,
                  color: AppColors.accent,
                ),
                label: Text(
                  'Add Story',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.accent,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: stories.length,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemBuilder: (context, index) {
              final story = stories[index];
              final isViewed = story.isViewed;
              final isOwnStory = story.userId ==
                  ref.read(authControllerProvider).state.user?.id;

              return GestureDetector(
                onTap: () {
                  context.go('/story/${story.id}');
                },
                child: Container(
                  width: 60,
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 58,
                            height: 58,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: isOwnStory
                                    ? [
                                        AppColors.primary,
                                        AppColors.secondary
                                      ]
                                    : [
                                        AppColors.primary.withValues(alpha: 0.3),
                                        AppColors.secondary.withValues(alpha: 0.3)
                                      ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: CircleAvatar(
                                radius: 26,
                                backgroundImage: story.userAvatarUrl != null
                                    ? NetworkImage(story.userAvatarUrl!)
                                    : null,
                                child: story.userAvatarUrl == null
                                    ? const Icon(LucideIcons.user, size: 24)
                                    : null,
                              ),
                            ),
                          ),
                          if (!isViewed && !isOwnStory)
                            Positioned(
                              bottom: 2,
                              right: 2,
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.accent,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        story.userName,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.05, end: 0);
  }

  Widget _buildLoadingState(bool isDark) {
    return const SizedBox(
      height: 120,
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorState(bool isDark, String error) {
    return SizedBox(
      height: 120,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.cloud_off, color: AppColors.error),
            Text(error, style: const TextStyle(fontSize: 12)),
            TextButton(
              onPressed: () => ref.read(storiesProvider.notifier).loadStories(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
