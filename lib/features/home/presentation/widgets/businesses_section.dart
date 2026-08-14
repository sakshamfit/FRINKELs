import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../presentation/controllers/businesses_provider.dart';
import '../widgets/business_card.dart';

class BusinessesSection extends ConsumerWidget {
  const BusinessesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final businessesAsync = ref.watch(businessesProvider);

    return businessesAsync.when(
      data: (businesses) {
        if (businesses.isEmpty) {
          return _buildEmptyState(isDark);
        }

        return SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: businesses.length,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemBuilder: (context, index) {
              final business = businesses[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: BusinessCard(
                  business: business,
                  onTap: () {
                    context.go('/business/${business.id}');
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
      height: 180,
      child: Center(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 3, // Show 3 placeholder cards while loading
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(right: 16),
            child: SizedBox(
              width: 180,
              child: GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
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
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.star, size: 14, color: Colors.amberAccent),
                              const SizedBox(width: 2),
                              Text(
                                '4.5',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Category',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white60,
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
      height: 180,
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
              'Failed to load businesses',
              style: AppTypography.body.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () {
                ref.read(businessesProvider.notifier).refreshBusinesses();
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
      height: 180,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              LucideIcons.store,
              size: 32,
              color: AppColors.textSecondaryDark,
            ),
            const SizedBox(height: 12),
            Text(
              'No businesses found',
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