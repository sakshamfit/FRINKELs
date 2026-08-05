import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/glass_text_field.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../home/domain/entities/post.dart';
import '../../../jobs/domain/entities/job.dart';
import '../controllers/search_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    if (query.trim().isEmpty) {
      ref.read(searchProvider.notifier).search('');
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 300), () {
      ref.read(searchProvider.notifier).search(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final searchState = ref.watch(searchProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundPrimary,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: GlassTextField(
                controller: _searchController,
                labelText: '',
                hintText: 'Search people, jobs, posts...',
                prefixIcon: const Icon(LucideIcons.search),
                onChanged: _onSearchChanged,
              ),
            ),
            Expanded(
              child: searchState.when(
                data: (result) {
                  if (result.users.isEmpty && result.posts.isEmpty && result.jobs.isEmpty) {
                    return _buildEmptyState(isDark);
                  }
                  return _buildResultsList(result, isDark);
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.search, size: 48, color: AppColors.textSecondary.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text('Search FRINKELs', style: AppTypography.body.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          Text('Try searching for people, jobs, or posts', style: AppTypography.caption),
        ],
      ),
    );
  }

  Widget _buildResultsList(SearchResult result, bool isDark) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: [
        if (result.users.isNotEmpty) ...[
          _buildCategoryHeader('People'),
          ...result.users.map((u) => _buildUserTile(u, isDark)),
          const SizedBox(height: 24),
        ],
        if (result.jobs.isNotEmpty) ...[
          _buildCategoryHeader('Jobs'),
          ...result.jobs.map((j) => _buildJobTile(j, isDark)),
          const SizedBox(height: 24),
        ],
        if (result.posts.isNotEmpty) ...[
          _buildCategoryHeader('Posts'),
          ...result.posts.map((p) => _buildPostTile(p, isDark)),
          const SizedBox(height: 24),
        ],
      ],
    );
  }

  Widget _buildCategoryHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 24),
      child: Text(title, style: AppTypography.cardTitle.copyWith(fontSize: 18)),
    );
  }

  Widget _buildUserTile(User user, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
              radius: 24,
              child: user.avatarUrl == null ? const Icon(LucideIcons.user) : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name ?? 'User', style: AppTypography.body.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(user.profession ?? 'Professional', style: AppTypography.tiny),
                  if (user.location != null && user.location!.isNotEmpty)
                    Text(user.location!, style: AppTypography.caption),
                ],
              ),
            ),
            const Icon(LucideIcons.chevron_right, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildJobTile(Job job, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: AppColors.accent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
              child: const Icon(LucideIcons.briefcase, color: AppColors.accent, size: 18),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(job.title, style: AppTypography.body.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text('${job.companyName} • ${job.location}', style: AppTypography.tiny),
                ],
              ),
            ),
            Text(job.salary, style: AppTypography.tiny.copyWith(fontWeight: FontWeight.w700, color: AppColors.success)),
          ],
        ),
      ),
    );
  }

  Widget _buildPostTile(Post post, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: post.authorAvatarUrl != null ? NetworkImage(post.authorAvatarUrl!) : null,
                  child: post.authorAvatarUrl == null ? const Icon(LucideIcons.user, size: 16) : null,
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.authorName, style: AppTypography.tiny.copyWith(fontWeight: FontWeight.w700)),
                    Text('${DateTime.now().difference(post.createdAt).inDays}d ago', style: AppTypography.caption),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              post.content,
              style: AppTypography.body,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
