import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../domain/entities/post.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: GlassCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: post.authorAvatarUrl != null
                        ? NetworkImage(post.authorAvatarUrl!)
                        : null,
                    child: post.authorAvatarUrl == null
                        ? const Icon(LucideIcons.user, size: 20)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.authorName,
                        style: AppTypography.body.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '2 hours ago',
                        style: AppTypography.tiny,
                      ), // Replace with timeago
                    ],
                  ),
                  const Spacer(),
                  const Icon(LucideIcons.ellipsis, size: 20),
                ],
              ),
            ),
            if (post.imageUrls.isNotEmpty)
              AspectRatio(
                aspectRatio: 16 / 10,
                child: Container(
                  width: double.infinity,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.black.withValues(alpha: 0.05),
                  child: Image.network(post.imageUrls.first, fit: BoxFit.cover),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (post.content.isNotEmpty) ...[
                    Text(
                      post.content,
                      style: AppTypography.body.copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                  ],
                  Row(
                    children: [
                      Icon(
                        post.isLiked ? LucideIcons.heart : LucideIcons.heart,
                        size: 24,
                        color: post.isLiked ? AppColors.error : null,
                      ),
                      const SizedBox(width: 20),
                      const Icon(LucideIcons.message_circle, size: 24),
                      const SizedBox(width: 20),
                      const Icon(LucideIcons.send, size: 24),
                      const Spacer(),
                      Icon(
                        post.isBookmarked
                            ? LucideIcons.bookmark
                            : LucideIcons.bookmark,
                        size: 24,
                        color: post.isBookmarked ? AppColors.accent : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${post.likesCount} likes',
                    style: AppTypography.body.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
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
