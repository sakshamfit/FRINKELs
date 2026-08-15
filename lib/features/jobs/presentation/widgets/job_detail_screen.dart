import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../jobs/domain/entities/job.dart';
import '../../../jobs/presentation/controllers/job_provider.dart';

class JobDetailScreen extends ConsumerWidget {
  final String jobId;

  const JobDetailScreen({
    super.key,
    required this.jobId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final jobAsync = ref.watch(jobProvider(jobId));

    return jobAsync.when(
      data: (job) => Scaffold(
        backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
        appBar: AppBar(
          title: Text(job.title),
          backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(LucideIcons.arrow_left),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GlassCard(
                child: Column(
                  children: [
                    ListTile(
                      leading: job.companyLogoUrl != null && job.companyLogoUrl!.isNotEmpty
                          ? Image.network(
                              job.companyLogoUrl!,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            )
                          : const Icon(
                              LucideIcons.briefcase,
                              size: 24,
                              color: AppColors.textSecondary,
                            ),
                      title: Text(
                        job.title,
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        job.companyName,
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(LucideIcons.map_pin),
                      title: const Text('Location'),
                      subtitle: Text(job.location),
                    ),
                    ListTile(
                      leading: const Icon(LucideIcons.dollar_sign),
                      title: const Text('Salary'),
                      subtitle: Text(job.salary),
                    ),
                    ListTile(
                      leading: const Icon(LucideIcons.clock),
                      title: const Text('Type'),
                      subtitle: Text(job.type),
                    ),
                    ListTile(
                      leading: const Icon(LucideIcons.clock),
                      title: const Text('Posted'),
                      subtitle: Text(
                        '${job.createdAt.day}/${job.createdAt.month}/${job.createdAt.year}',
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Job Description',
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        job.description,
                        style: AppTypography.body,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
          backgroundColor: AppColors.backgroundDark,
        ),
        body: Center(child: Text('Error: $error')),
      ),
    );
  }
}