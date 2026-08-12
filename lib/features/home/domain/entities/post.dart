import 'package:equatable/equatable.dart';

enum PostType { text, image, video, job, event }

class Post extends Equatable {
  final String id;
  final String authorId;
  final String authorName;
  final String? authorAvatarUrl;
  final String? authorProfession;
  final String content;
  final List<String> imageUrls;
  final String? videoUrl;
  final PostType type;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;
  final bool isBookmarked;
  final DateTime createdAt;

  const Post({
    required this.id,
    required this.authorId,
    required this.authorName,
    this.authorAvatarUrl,
    this.authorProfession,
    required this.content,
    this.imageUrls = const [],
    this.videoUrl,
    this.type = PostType.text,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.isLiked = false,
    this.isBookmarked = false,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    authorId,
    authorName,
    authorAvatarUrl,
    authorProfession,
    content,
    imageUrls,
    videoUrl,
    type,
    likesCount,
    commentsCount,
    isLiked,
    isBookmarked,
    createdAt,
  ];
}
