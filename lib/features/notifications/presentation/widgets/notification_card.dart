import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../domain/entities/notification.dart' as notif;

class NotificationCard extends ConsumerWidget {
  final notif.Notification notification;
  final VoidCallback? onTap;
  final VoidCallback? onMarkAsRead;

  const NotificationCard({
    super.key,
    required this.notification,
    this.onTap,
    this.onMarkAsRead,
  });

  String _getNotificationTitle() {
    switch (notification.type) {
      case notif.NotificationType.like:
        return '${notification.senderName} liked your post';
      case notif.NotificationType.comment:
        return '${notification.senderName} commented on your post';
      case notif.NotificationType.mention:
        return '${notification.senderName} mentioned you';
      case notif.NotificationType.mentionInComment:
        return '${notification.senderName} mentioned you in a comment';
      case notif.NotificationType.postMention:
        return '${notification.senderName} mentioned your post';
      case notif.NotificationType.follow:
        return '${notification.senderName} started following you';
      case notif.NotificationType.jobApplication:
        return '${notification.senderName} applied for your job';
      case notif.NotificationType.jobAccepted:
        return 'Your job application was accepted';
      case notif.NotificationType.jobRejected:
        return 'Your job application was rejected';
      case notif.NotificationType.eventInvite:
        return '${notification.senderName} invited you to an event';
      case notif.NotificationType.eventReminder:
        return 'Reminder: You have an event coming up';
      case notif.NotificationType.system:
        return 'System notification';
    }
  }

  String _getNotificationSubtitle() {
    // Format time ago
    final difference = DateTime.now().difference(notification.createdAt);
    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'just now';
    }
  }

  IconData _getNotificationIcon() {
    switch (notification.type) {
      case notif.NotificationType.like:
        return Icons.favorite;
      case notif.NotificationType.comment:
        return Icons.comment;
      case notif.NotificationType.mention:
      case notif.NotificationType.mentionInComment:
      case notif.NotificationType.postMention:
        return Icons.email; // Using email as a substitute for @ mention
      case notif.NotificationType.follow:
        return Icons.person_add;
      case notif.NotificationType.jobApplication:
      case notif.NotificationType.jobAccepted:
      case notif.NotificationType.jobRejected:
        return Icons.work;
      case notif.NotificationType.eventInvite:
        return Icons.calendar_today;
      case notif.NotificationType.eventReminder:
        return Icons.notifications_active;
      case notif.NotificationType.system:
        return Icons.settings;
    }
  }

  Color _getIconColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (notification.type) {
      case notif.NotificationType.like:
        return isDark ? Colors.pinkAccent : Colors.pink;
      case notif.NotificationType.comment:
        return isDark ? Colors.orangeAccent : Colors.orange;
      case notif.NotificationType.mention:
      case notif.NotificationType.mentionInComment:
      case notif.NotificationType.postMention:
        return isDark ? Colors.blueAccent : Colors.blue;
      case notif.NotificationType.follow:
        return isDark ? Colors.greenAccent : Colors.green;
      case notif.NotificationType.jobApplication:
      case notif.NotificationType.jobAccepted:
      case notif.NotificationType.jobRejected:
        return isDark ? Colors.purpleAccent : Colors.purple;
      case notif.NotificationType.eventInvite:
      case notif.NotificationType.eventReminder:
        return isDark ? Colors.orangeAccent : Colors.orange;
      case notif.NotificationType.system:
        return isDark ? Colors.redAccent : Colors.red;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isRead = notification.isRead;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: GlassCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getIconColor(context).withValues(alpha: 0.1),
                ),
                child: Icon(
                  _getNotificationIcon(),
                  size: 24,
                  color: _getIconColor(context),
                ),
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getNotificationTitle(),
                      style: AppTypography.body.copyWith(
                        fontWeight: isRead ? FontWeight.normal : FontWeight.w600,
                        color: isDark
                            ? Colors.white.withValues(alpha: isRead ? 0.7 : 0.9)
                            : Colors.black.withValues(alpha: isRead ? 0.7 : 0.9),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getNotificationSubtitle(),
                      style: AppTypography.caption.copyWith(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.5)
                            : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              // Mark as read button (if not already read)
              if (!isRead)
                Positioned(
                  right: 0,
                  top: 0,
                  child: IconButton(
                    icon: const Icon(Icons.check, size: 16),
                    color: isDark ? Colors.white.withValues(alpha: 0.5) : Colors.grey[400],
                    onPressed: onMarkAsRead,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}