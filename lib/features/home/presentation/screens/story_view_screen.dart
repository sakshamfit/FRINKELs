import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../home/domain/entities/story.dart';
import '../../../home/presentation/controllers/stories_provider.dart';

class StoryViewScreen extends ConsumerWidget {
  final String storyId;

  const StoryViewScreen({
    super.key,
    required this.storyId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final storiesAsync = ref.watch(storiesProvider);

    return storiesAsync.when(
      data: (stories) {
        final story = stories.firstWhere((s) => s.id == storyId, orElse: () => stories.first);
        return Scaffold(
          backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
          appBar: AppBar(
            title: const Text('Story'),
            backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(LucideIcons.arrow_left),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: Center(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GlassCard(
                    child: Column(
                      children: [
                        Container(
                          width: 300,
                          height: 500,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(story.mediaUrl),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          story.userName,
                          style: AppTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${story.createdAt.day}/${story.createdAt.month}/${story.createdAt.year}',
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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