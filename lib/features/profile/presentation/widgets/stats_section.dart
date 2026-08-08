import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../../core/widgets/glass_card.dart';

class StatsSection extends StatelessWidget {
  final int followersCount;
  final int followingCount;
  final int postsCount;
  final bool showVertical;

  const StatsSection({
    super.key,
    required this.followersCount,
    required this.followingCount,
    required this.postsCount,
    this.showVertical = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (showVertical) {
      return _buildVerticalStats(isDark);
    } else {
      return _buildHorizontalStats(isDark);
    }
  }

  Widget _buildHorizontalStats(bool isDark) {
    return GlassCard(
      blur: 20,
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          statColumn(
            label: 'Followers',
            value: followersCount.toString(),
            icon: LucideIcons.user,
            isDark: isDark,
          ),
          statColumn(
            label: 'Following',
            value: followingCount.toString(),
            icon: LucideIcons.user_plus,
            isDark: isDark,
          ),
          statColumn(
            label: 'Posts',
            value: postsCount.toString(),
            icon: LucideIcons.folder,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalStats(bool isDark) {
    return GlassCard(
      blur: 20,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          statRow(
            label: 'Followers',
            value: followersCount.toString(),
            icon: LucideIcons.user,
            isDark: isDark,
          ),
          const SizedBox(height: 12),
          statRow(
            label: 'Following',
            value: followingCount.toString(),
            icon: LucideIcons.user_plus,
            isDark: isDark,
          ),
          const SizedBox(height: 12),
          statRow(
            label: 'Posts',
            value: postsCount.toString(),
            icon: LucideIcons.folder,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget statColumn({
    required String label,
    required String value,
    required IconData icon,
    required bool isDark,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isDark ? Colors.white70 : Colors.grey[600],
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white54 : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget statRow({
    required String label,
    required String value,
    required IconData icon,
    required bool isDark,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isDark ? Colors.white70 : Colors.grey[600],
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white54 : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
