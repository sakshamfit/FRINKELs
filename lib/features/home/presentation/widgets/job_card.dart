import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../jobs/domain/entities/job.dart';

class JobCard extends StatelessWidget {
  final Job job;
  final VoidCallback onTap;

  const JobCard({super.key, required this.job, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final salaryText = '\$${job.salary.split('-').first.trim()}';

    return GestureDetector(
      onTap: onTap,
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
              child:
                  job.companyLogoUrl != null && job.companyLogoUrl!.isNotEmpty
                  ? ClipOval(
                      child: Image.network(
                        job.companyLogoUrl!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              LucideIcons.briefcase,
                              size: 24,
                              color: Colors.white54,
                            ),
                      ),
                    )
                  : const Icon(
                      LucideIcons.briefcase,
                      size: 24,
                      color: Colors.white54,
                    ),
            ),
            const SizedBox(height: 8),
            Text(
              job.title.length > 12
                  ? '${job.title.substring(0, 12)}...'
                  : job.title,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              job.companyName.length > 10
                  ? '${job.companyName.substring(0, 10)}...'
                  : job.companyName,
              style: TextStyle(
                fontSize: 8,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              salaryText,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
