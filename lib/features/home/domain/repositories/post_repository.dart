import 'package:dartz/dartz.dart';
import '../../../../core/failures/failure.dart';
import '../entities/post.dart';

abstract class PostRepository {
  Future<Either<Failure, List<Post>>> getFeed({int limit = 20, int offset = 0});
  Future<Either<Failure, Post>> createPost(String content, List<String> imageUrls);
  Future<Either<Failure, void>> likePost(String postId);
  Future<Either<Failure, void>> unlikePost(String postId);
  Future<Either<Failure, void>> bookmarkPost(String postId);
}
