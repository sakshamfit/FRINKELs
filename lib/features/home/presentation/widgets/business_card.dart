import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../domain/entities/business.dart';

class BusinessCard extends StatelessWidget {
  final Business business;
  final VoidCallback onTap;

  const BusinessCard({
    super.key,
    required this.business,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        width: 180,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Business Image (Cover Image)
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: business.coverImageUrl.isNotEmpty
                        ? Image.network(
                            business.coverImageUrl,
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
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: isDark
                                  ? AppColors.cardDark.withValues(alpha: 0.2)
                                  : AppColors.cardPrimary.withValues(alpha: 0.2),
                              child: const Icon(
                                LucideIcons.image,
                                size: 32,
                                color: Colors.white54,
                              ),
                            ),
                          ),
                        : Container(
                            color: isDark
                                ? AppColors.cardDark.withValues(alpha: 0.2)
                                : AppColors.cardPrimary.withValues(alpha: 0.2),
                            child: const Icon(
                              LucideIcons.image,
                              size: 32,
                              color: Colors.white54,
                            ),
                          ),
                  ),
                  // Verified badge
                  if (business.isVerified)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.verified,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          LucideIcons.check_circle,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  // Open/Closed indicator
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: business.isOpen
                            ? AppColors.success.withValues(alpha: 0.2)
                            : AppColors.error.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        business.isOpen ? 'Open' : 'Closed',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: business.isOpen
                              ? AppColors.success
                              : AppColors.error,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Business Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Business Name
                  Text(
                    business.name,
                    style: AppTypography.body.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Rating and Category
                  Row(
                    children: [
                      Icon(
                        LucideIcons.star,
                        size: 14,
                        color: Colors.amberAccent,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        business.rating.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        business.category,
                        style: TextStyle(
                          fontSize: 10,
                          color: isDark ? Colors.white60 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Follow Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isDark
                              ? AppColors.borderDark
                              : AppColors.borderPrimary,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            LucideIcons.user_plus,
                            size: 14,
                            color: AppColors.accent,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Follow',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.accent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}