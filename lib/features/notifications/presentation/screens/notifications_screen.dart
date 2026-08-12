import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/glowing_loader.dart';
import '../../../../core/widgets/error_state.dart';
import '../../domain/entities/notification.dart' as notif;
import '../controllers/notification_provider.dart';
import '../widgets/notification_card.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  static const String routeName = '/notifications';
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isLoadingMore) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreNotifications();
    }
  }

  Future<void> _loadMoreNotifications() async {
    if (_isLoadingMore) return;

    setState(() => _isLoadingMore = true);
    final notificationsNotifier = ref.read(notificationsProvider.notifier);
    await notificationsNotifier.loadMore();
    setState(() => _isLoadingMore = false);
  }

  Future<void> _refreshNotifications() async {
    final notificationsNotifier = ref.read(notificationsProvider.notifier);
    await notificationsNotifier.refresh();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final notificationsState = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor:
            (isDark ? AppColors.backgroundDark : AppColors.backgroundPrimary)
                .withValues(alpha: 0.9),
        title: Text(
          'Notifications',
          style: AppTypography.section.copyWith(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.bell, size: 24),
            onPressed: () {
              // Mark all as read
              ref.read(notificationsProvider.notifier).markAllAsRead();
            },
            tooltip: 'Mark all as read',
          ),
          const SizedBox(width: 16),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.1),
          ),
        ),
      ),
      body: notificationsState.isLoading
          ? const Center(child: GlowingLoader())
          : notificationsState.error != null
          ? ErrorState(
              title: 'Something went wrong',
              message: notificationsState.error!,
              onRetry: _refreshNotifications,
            )
          : notificationsState.notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.bell_off,
                    size: 48,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.5)
                        : Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No notifications',
                    style: AppTypography.body.copyWith(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.7)
                          : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You will see notifications here when you receive notifications',
                    style: AppTypography.caption.copyWith(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.5)
                          : Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ).animate().fadeIn(duration: const Duration(milliseconds: 300)),
            )
          : RefreshIndicator(
              onRefresh: _refreshNotifications,
              color: isDark ? Colors.white : AppColors.accent,
              backgroundColor: isDark
                  ? AppColors.backgroundDark.withValues(alpha: 0.5)
                  : AppColors.backgroundPrimary.withValues(alpha: 0.5),
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount:
                    notificationsState.notifications.length +
                    (notificationsState.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == notificationsState.notifications.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: GlowingLoader(size: 20)),
                    );
                  }

                  final notification = notificationsState.notifications[index];
                  return NotificationCard(
                    notification: notification,
                    onTap: () => _onNotificationTap(notification),
                    onMarkAsRead: () => _markAsRead(notification.id),
                  ).animate().fadeIn(
                    duration: const Duration(milliseconds: 200),
                    delay: Duration(milliseconds: index * 30),
                  );
                },
              ),
            ),
    );
  }

  void _onNotificationTap(notif.Notification notification) {
    // Handle navigation based on notification type
    // For now, just mark as read
    _markAsRead(notification.id);
  }

  Future<void> _markAsRead(String notificationId) async {
    await ref.read(notificationsProvider.notifier).markAsRead(notificationId);
  }
}
