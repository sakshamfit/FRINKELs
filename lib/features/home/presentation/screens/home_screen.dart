import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_padding.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/glass_text_field.dart';
import '../../../auth/presentation/controllers/auth_provider.dart';
import '../controllers/home_provider.dart';
import '../widgets/post_card.dart';
import '../widgets/businesses_section.dart';
import '../widgets/communities_section.dart';
import '../widgets/stories_section.dart';
import '../../domain/entities/post.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(authControllerProvider).state.user;
    final feedState = ref.watch(feedProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundPrimary,
      body: RefreshIndicator(
        onRefresh: () => ref.read(feedProvider.notifier).getFeed(),
        color: AppColors.accent,
        backgroundColor: isDark ? AppColors.cardDark : Colors.white,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildAppBar(isDark, user),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    _buildGreeting(isDark, user?.name),
                    const SizedBox(height: 32),
                    _buildQuickActions(isDark),
                    const SizedBox(height: 48),
                    _buildSectionHeader('Stories', isDark),
                    const SizedBox(height: 16),
                    _buildStories(),
                    const SizedBox(height: 48),
                    _buildSectionHeader('Businesses', isDark),
                    const SizedBox(height: 16),
                    const BusinessesSection(),
                    const SizedBox(height: 24), // Added space before Communities
                    _buildSectionHeader('Communities', isDark),
                    const SizedBox(height: 16),
                    const CommunitiesSection(),
                    const SizedBox(height: 48),
                    _buildSectionHeader('Nearby Professionals', isDark),
                    const SizedBox(height: 16),
                    _buildNearbyProfessionals(isDark),
                    const SizedBox(height: 48),
                    _buildSectionHeader('Your Feed', isDark),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            _buildFeed(feedState),
            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(bool isDark, dynamic user) {
    return SliverAppBar(
      floating: true,
      pinned: false,
      backgroundColor: (isDark ? AppColors.backgroundDark : AppColors.backgroundPrimary).withValues(alpha: 0.8),
      elevation: 0,
      centerTitle: false,
      title: GlassTextField(
        controller: _searchController,
        labelText: '',
        hintText: 'Search people, skills, jobs...',
        prefixIcon: const Icon(LucideIcons.search),
      ),
      actions: [
        IconButton(
          icon: const Icon(LucideIcons.bell_ring, size: 22),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildGreeting(bool isDark, String? name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good morning,',
          style: AppTypography.section.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ),
        ),
        Text(
          name?.split(' ').first ?? 'Professional',
          style: AppTypography.title.copyWith(fontSize: 32),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.05, end: 0);
  }

  Widget _buildQuickActions(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _buildActionCard(
            'Hire Pro',
            LucideIcons.user_plus,
            AppColors.accent,
            isDark,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildActionCard(
            'Find Work',
            LucideIcons.briefcase,
            AppColors.success,
            isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(String label, IconData icon, Color color, bool isDark) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(label, style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title, 
          style: AppTypography.section.copyWith(fontSize: 20, fontWeight: FontWeight.w700)
        ),
        Text(
          'See all', 
          style: AppTypography.caption.copyWith(color: AppColors.accent, fontWeight: FontWeight.w600)
        ),
      ],
    );
  }

  Widget _buildStories() {
    return StoriesSection();
  }

  Widget _buildNearbyProfessionals(bool isDark) {
    final nearbyAsync = ref.watch(nearbyProfessionalsProvider);
    
    return SizedBox(
      height: 180,
      child: nearbyAsync.when(
        data: (users) => ListView.builder(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          itemCount: users.length,
          itemBuilder: (context, index) {
            final pro = users[index];
            return Container(
              width: 160,
              margin: const EdgeInsets.only(right: 16),
              child: GlassCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundImage: pro.avatarUrl != null ? NetworkImage(pro.avatarUrl!) : null,
                      child: pro.avatarUrl == null ? const Icon(LucideIcons.user) : null,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      pro.name ?? 'Pro', 
                      style: AppTypography.body.copyWith(fontSize: 14, fontWeight: FontWeight.w700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(pro.profession ?? 'Specialist', style: AppTypography.tiny),
                  ],
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error loading pros')),
      ),
    );
  }

  Widget _buildFeed(AsyncValue<List<Post>> feedState) {
    return feedState.when(
      data: (posts) => SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => PostCard(post: posts[index]),
          childCount: posts.length,
        ),
      ),
      loading: () => const SliverToBoxAdapter(
        child: Center(child: Padding(
          padding: EdgeInsets.all(48.0),
          child: CircularProgressIndicator(),
        )),
      ),
      error: (e, _) => SliverToBoxAdapter(
        child: Center(child: Text('Failed to load feed')),
      ),
    );
  }
}
