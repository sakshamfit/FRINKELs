import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/glass_card.dart';
import '../controllers/jobs_provider.dart';
import '../widgets/job_card.dart';

class JobsSection extends ConsumerWidget {
  const JobsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final jobsAsync = ref.watch(jobsProvider);

    return jobsAsync.when(
      data: (jobs) {
        if (jobs.isEmpty) {
          return _buildEmptyState(isDark);
        }

        return SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: jobs.length,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemBuilder: (context, index) {
              final job = jobs[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: JobCard(
                  job: job,
                  onTap: () {
                    context.go('/job/${job.id}');
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
      height: 140,
      child: Center(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(right: 16),
            child: SizedBox(
              width: 120,
              child: GlassCard(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark
                            ? AppColors.cardDark.withValues(alpha: 0.2)
                            : AppColors.cardLight.withValues(alpha: 0.2),
                      ),
                      child: const Icon(
                        LucideIcons.briefcase,
                        size: 20,
                        color: Colors.white54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Loading...',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: Colors.white70,
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
      height: 140,
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
              'Failed to load jobs',
              style: AppTypography.body.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            TextButton.icon(
              onPressed: () {
                ref.read(jobsProvider.notifier).loadJobs();
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
      height: 140,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              LucideIcons.briefcase,
              size: 24,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 8),
            Text(
              'No jobs found',
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
