import 'package:dartz/dartz.dart';
import '../../../../core/failures/failure.dart';
import '../entities/post.dart';
import '../repositories/feed_repository.dart';

class CreatePost {
  final FeedRepository repository;

  CreatePost(this.repository);

  Future<Either<Failure, Post>> call(
    String content, {
    List<String>? imageUrls,
    PostType type = PostType.text,
  }) => repository.createPost(content, imageUrls: imageUrls, type: type);
}
