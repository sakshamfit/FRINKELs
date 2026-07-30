import 'package:dartz/dartz.dart';
import '../../../../core/failures/failure.dart';
import '../repositories/feed_repository.dart';

class LikePost {
  final FeedRepository repository;

  LikePost(this.repository);

  Future<Either<Failure, void>> call(String postId) =>
      repository.likePost(postId);
}
