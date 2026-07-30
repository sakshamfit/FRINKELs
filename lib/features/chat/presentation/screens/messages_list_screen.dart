import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/controllers/auth_provider.dart';

class MessagesListScreen extends ConsumerWidget {
  const MessagesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final supabase = ref.read(supabaseProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundPrimary,
      appBar: AppBar(
        title: Text('Messages', style: AppTypography.section.copyWith(fontSize: 24)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(LucideIcons.square_pen), onPressed: () {}),
        ],
      ),
      body: FutureBuilder<List<User>>(
        future: _fetchRecentChats(supabase),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final users = snapshot.data ?? [];
          if (users.isEmpty) {
            return _buildEmptyState(isDark);
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: ListTile(
                    onTap: () => context.push('/chat', extra: user),
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundImage: user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
                      child: user.avatarUrl == null ? const Icon(LucideIcons.user) : null,
                    ),
                    title: Text(user.name ?? 'Anonymous', style: AppTypography.body.copyWith(fontWeight: FontWeight.w700)),
                    subtitle: Text(
                      'Tap to start chatting...', 
                      style: AppTypography.tiny.copyWith(color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Icon(LucideIcons.chevron_right, size: 16, color: AppColors.textSecondary.withValues(alpha: 0.5)),
                  ),
                ),
              ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: 0.1, end: 0);
            },
          );
        },
      ),
    );
  }

  Future<List<User>> _fetchRecentChats(dynamic supabase) async {
    // This should ideally join messages and profiles
    final response = await supabase.from('profiles').select().limit(5);
    final List<dynamic> data = response as List<dynamic>;
    return data.map((u) => User(
      id: u['id'],
      email: u['email'] ?? '',
      name: u['full_name'],
      avatarUrl: u['avatar_url'],
      isOnboarded: true,
      createdAt: DateTime.parse(u['created_at']),
    )).toList();
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.message_square, size: 48, color: AppColors.textSecondary.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text('No conversations yet', style: AppTypography.body.copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
