import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/glass_card.dart';
import '../controllers/local_news_provider.dart';
import '../widgets/local_news_card.dart';

class LocalNewsSection extends ConsumerWidget {
  const LocalNewsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final localNewsAsync = ref.watch(localNewsProvider);

    return localNewsAsync.when(
      data: (localNews) {
        if (localNews.isEmpty) {
          return _buildEmptyState(isDark);
        }

        return SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: localNews.length,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemBuilder: (context, index) {
              final news = localNews[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: LocalNewsCard(
                  news: news,
                  onTap: () {
                    context.go('/news/${news.id}');
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
      height: 200,
      child: Center(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 3, // Show 3 placeholder cards while loading
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(right: 16),
            child: SizedBox(
              width: 200,
              child: GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          color: isDark
                              ? AppColors.cardDark.withValues(alpha: 0.2)
                              : AppColors.cardLight.withValues(alpha: 0.2),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Loading...',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                LucideIcons.map_pin,
                                size: 12,
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Local News • Nearby',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
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
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              LucideIcons.cloud_off,
              size: 32,
              color: AppColors.error,
            ),
            const SizedBox(height: 12),
            Text(
              'Failed to load local news',
              style: AppTypography.body.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () {
                ref.read(localNewsProvider.notifier).refreshLocalNews();
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
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              LucideIcons.newspaper,
              size: 32,
              color: AppColors.textSecondaryDark,
            ),
            const SizedBox(height: 12),
            Text(
              'No local news found',
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