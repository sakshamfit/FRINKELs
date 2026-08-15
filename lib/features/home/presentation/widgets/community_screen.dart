import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../home/domain/entities/community.dart';
import '../../../home/presentation/controllers/communities_provider.dart';

class CommunityScreen extends ConsumerWidget {
  final String communityId;

  const CommunityScreen({
    super.key,
    required this.communityId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final communitiesAsync = ref.watch(communitiesProvider);

    return communitiesAsync.when(
      data: (communitiesList) {
        final community = communitiesList.firstWhere(
          (c) => c.id == communityId,
          orElse: () => communitiesList.first,
        );

        return Scaffold(
          backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
          appBar: AppBar(
            title: Text(community.name),
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
                // Community Icon
                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? AppColors.cardDark.withValues(alpha: 0.2)
                          : AppColors.cardLight.withValues(alpha: 0.2),
                    ),
                    child: community.iconUrl != null && community.iconUrl!.isNotEmpty
                        ? ClipOval(
                            child: Image.network(
                              community.iconUrl!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(
                            LucideIcons.users,
                            size: 48,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                  ),
                ),
                const SizedBox(height: 24),
                // Community Name
                Text(
                  community.name,
                  style: AppTypography.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Member Count
                Text(
                  '${community.memberCount} members',
                  style: AppTypography.bodyMedium.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                // Description
                Text(
                  'About this community',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                GlassCard(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      community.description.isNotEmpty
                          ? community.description
                          : 'No description available.',
                      style: AppTypography.body.copyWith(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Category chip
                if (community.category.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      community.category,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                // Tags
                if (community.tags.isNotEmpty) ...[
                  Text(
                    'Tags',
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: community.tags.map((tag) => Chip(
                          label: Text(tag),
                          backgroundColor: AppColors.secondary.withValues(alpha: 0.1),
                          labelStyle: TextStyle(color: AppColors.secondary),
                        )).toList(),
                  ),
                ],
              ],
            ),
          ),
        );
      },
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