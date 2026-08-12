import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../domain/entities/profile.dart';

class ProfileCard extends StatelessWidget {
  final Profile profile;
  final VoidCallback? onTap;
  final bool showFollowButton;
  final bool showBadge;
  final String? badgeText;

  const ProfileCard({
    super.key,
    required this.profile,
    this.onTap,
    this.showFollowButton = false,
    this.showBadge = false,
    this.badgeText = 'New',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        blur: 20,
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: profile.avatarUrl != null
                      ? NetworkImage(profile.avatarUrl!)
                      : null,
                  child: profile.avatarUrl == null
                      ? Icon(
                          LucideIcons.user,
                          size: 20,
                          color: isDark ? Colors.white70 : Colors.grey[600],
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.name ?? 'Anonymous User',
                        style: AppTypography.body.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      if (profile.bio != null && profile.bio!.isNotEmpty)
                        Text(
                          profile.bio!,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white60 : Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                if (showFollowButton)
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Follow', style: TextStyle(fontSize: 12)),
                  ),
              ],
            ),
            if (showBadge && badgeText != null)
              Positioned(
                right: -4,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badgeText!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
