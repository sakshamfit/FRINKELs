import 'package:dartz/dartz.dart';
import '../../../../core/failures/failure.dart';
import '../repositories/feed_repository.dart';

class BookmarkPost {
  final FeedRepository repository;

  BookmarkPost(this.repository);

  Future<Either<Failure, void>> call(String postId) =>
      repository.bookmarkPost(postId);
}
