import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../domain/entities/community.dart';

class CommunityCard extends StatelessWidget {
  final Community community;
  final VoidCallback onTap;

  const CommunityCard({
    super.key,
    required this.community,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
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
                child:
                    community.iconUrl != null && community.iconUrl!.isNotEmpty
                    ? ClipOval(
                        child: Image.network(
                          community.iconUrl!,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                LucideIcons.users,
                                size: 24,
                                color: Colors.white54,
                              ),
                        ),
                      )
                    : const Icon(
                        LucideIcons.users,
                        size: 24,
                        color: Colors.white54,
                      ),
              ),
              const SizedBox(height: 8),
              Text(
                community.name.length > 10
                    ? '${community.name.substring(0, 10)}...'
                    : community.name,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                '${community.memberCount}',
                style: TextStyle(
                  fontSize: 10,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
