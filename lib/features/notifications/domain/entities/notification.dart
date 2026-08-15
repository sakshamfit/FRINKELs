import 'package:equatable/equatable.dart';

/// Notification event category — must stay in sync with
/// `public.notification_type` PostgreSQL enum (snake_case labels).
enum NotificationType {
  like,
  comment,
  mention,
  follow,
  mentionInComment,
  postMention,
  jobApplication,
  jobAccepted,
  jobRejected,
  eventInvite,
  eventReminder,
  system;

  /// Postgres stores enum labels in snake_case. Convert from
  /// `like` -> `NotificationType.like`, `mention_in_comment` ->
  /// [NotificationType.mentionInComment], etc.
  String get dbValue {
    switch (this) {
      case NotificationType.mentionInComment:
        return 'mention_in_comment';
      case NotificationType.postMention:
        return 'post_mention';
      case NotificationType.jobApplication:
        return 'job_application';
      case NotificationType.jobAccepted:
        return 'job_accepted';
      case NotificationType.jobRejected:
        return 'job_rejected';
      case NotificationType.eventInvite:
        return 'event_invite';
      case NotificationType.eventReminder:
        return 'event_reminder';
      default:
        return name;
    }
  }

  /// Inverse of [dbValue]. Falls back to [NotificationType.system].
  static NotificationType fromDbValue(String? value) {
    switch (value) {
      case 'like':
        return NotificationType.like;
      case 'comment':
        return NotificationType.comment;
      case 'mention':
        return NotificationType.mention;
      case 'follow':
        return NotificationType.follow;
      case 'mention_in_comment':
        return NotificationType.mentionInComment;
      case 'post_mention':
        return NotificationType.postMention;
      case 'job_application':
        return NotificationType.jobApplication;
      case 'job_accepted':
        return NotificationType.jobAccepted;
      case 'job_rejected':
        return NotificationType.jobRejected;
      case 'event_invite':
        return NotificationType.eventInvite;
      case 'event_reminder':
        return NotificationType.eventReminder;
      case 'system':
        return NotificationType.system;
      default:
        return NotificationType.system;
    }
  }
}

class Notification extends Equatable {
  final String id;
  final String recipientId;
  final String senderId;
  final String? senderName;
  final String? senderAvatarUrl;
  final NotificationType type;
  final String? entityId; // e.g., postId, commentId, etc.
  final String? entityType; // e.g., 'post', 'comment', 'job'
  final bool isRead;
  final DateTime createdAt;

  const Notification({
    required this.id,
    required this.recipientId,
    required this.senderId,
    this.senderName,
    this.senderAvatarUrl,
    required this.type,
    this.entityId,
    this.entityType,
    this.isRead = false,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    recipientId,
    senderId,
    senderName,
    senderAvatarUrl,
    type,
    entityId,
    entityType,
    isRead,
    createdAt,
  ];

  Notification copyWith({
    String? id,
    String? recipientId,
    String? senderId,
    String? senderName,
    String? senderAvatarUrl,
    NotificationType? type,
    String? entityId,
    String? entityType,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return Notification(
      id: id ?? this.id,
      recipientId: recipientId ?? this.recipientId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderAvatarUrl: senderAvatarUrl ?? this.senderAvatarUrl,
      type: type ?? this.type,
      entityId: entityId ?? this.entityId,
      entityType: entityType ?? this.entityType,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
