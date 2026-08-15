import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../home/domain/entities/local_news.dart';
import '../../../home/presentation/controllers/local_news_provider.dart';

class NewsDetailScreen extends ConsumerWidget {
  final String newsId;

  const NewsDetailScreen({
    super.key,
    required this.newsId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final newsAsync = ref.watch(localNewsProvider);

    return newsAsync.when(
      data: (localNewsList) {
        final news = localNewsList.firstWhere(
          (n) => n.id == newsId,
          orElse: () => localNewsList.first,
        );

        return Scaffold(
          backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
          appBar: AppBar(
            title: Text(news.title),
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
                // News Image
                if (news.imageUrl != null && news.imageUrl!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      news.imageUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                    ),
                  ),
                const SizedBox(height: 16),
                // Trending badge
                if (news.isTrending)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Trending',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                // News Title
                Text(
                  news.title,
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                // Source and Time
                Row(
                  children: [
                    Icon(
                      LucideIcons.map_pin,
                      size: 16,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${news.source ?? 'Local News'} • ${news.location ?? 'Nearby'}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Time ago
                Text(
                  '${news.publishedAt.day}/${news.publishedAt.month}/${news.publishedAt.year}',
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                // Description
                Text(
                  news.description,
                  style: AppTypography.body.copyWith(
                    fontSize: 14,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
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