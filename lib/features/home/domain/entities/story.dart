import 'package:equatable/equatable.dart';

enum StoryType { image, video }

class Story extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatarUrl;
  final String mediaUrl; // URL to the image or video
  final StoryType type;
  final DateTime createdAt;
  final DateTime expiresAt; // Stories typically expire after 24 hours
  final bool isViewed; // Whether the current user has viewed this story

  const Story({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    required this.mediaUrl,
    required this.type,
    required this.createdAt,
    required this.expiresAt,
    this.isViewed = false,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        userName,
        userAvatarUrl,
        mediaUrl,
        type,
        createdAt,
        expiresAt,
        isViewed,
      ];

  Story copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userAvatarUrl,
    String? mediaUrl,
    StoryType? type,
    DateTime? createdAt,
    DateTime? expiresAt,
    bool? isViewed,
  }) {
    return Story(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatarUrl: userAvatarUrl ?? this.userAvatarUrl,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      isViewed: isViewed ?? this.isViewed,
    );
  }
}