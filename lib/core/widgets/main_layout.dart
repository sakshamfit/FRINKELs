import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';

class MainLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainLayout({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true, // Allow body to flow behind glass bottom bar
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundPrimary,
      body: navigationShell,
      bottomNavigationBar: _PremiumBottomBar(navigationShell: navigationShell),
    );
  }
}

class _PremiumBottomBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const _PremiumBottomBar({required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      height: 72,
      decoration: BoxDecoration(
        color: (isDark ? AppColors.cardDark : Colors.white).withValues(
          alpha: 0.9,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: isDark ? AppShadows.premiumDark : AppShadows.premium,
        border: isDark
            ? AppShadows.glassInsetBorderDark
            : AppShadows.glassInsetBorder,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: LucideIcons.house,
            isActive: navigationShell.currentIndex == 0,
            onTap: () => navigationShell.goBranch(0),
          ),
          _NavItem(
            icon: LucideIcons.search,
            isActive: navigationShell.currentIndex == 1,
            onTap: () => navigationShell.goBranch(1),
          ),
          _buildPostButton(context),
          _NavItem(
            icon: LucideIcons.message_square,
            isActive: navigationShell.currentIndex == 3,
            onTap: () => navigationShell.goBranch(3),
          ),
          _NavItem(
            icon: LucideIcons.user,
            isActive: navigationShell.currentIndex == 4,
            onTap: () => navigationShell.goBranch(4),
          ),
        ],
      ),
    ).animate().slideY(
      begin: 1.0,
      end: 0,
      duration: 400.ms,
      curve: Curves.easeOutCubic,
    );
  }

  Widget _buildPostButton(BuildContext context) {
    return GestureDetector(
      onTap: () => navigationShell.goBranch(2),
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(LucideIcons.plus, color: Colors.white, size: 28),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = AppColors.accent;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inactiveColor = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondary;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isActive ? activeColor : inactiveColor, size: 24)
                .animate(target: isActive ? 1 : 0)
                .scale(
                  duration: 200.ms,
                  begin: const Offset(1, 1),
                  end: const Offset(1.15, 1.15),
                ),
            if (isActive)
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: activeColor,
                  shape: BoxShape.circle,
                ),
              ).animate().scale(duration: 200.ms),
          ],
        ),
      ),
    );
  }
}
