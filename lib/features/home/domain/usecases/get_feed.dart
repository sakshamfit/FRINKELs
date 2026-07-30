import 'package:dartz/dartz.dart';
import '../../../../core/failures/failure.dart';
import '../entities/post.dart';
import '../repositories/feed_repository.dart';

class GetFeed {
  final FeedRepository repository;

  GetFeed(this.repository);

  Future<Either<Failure, List<Post>>> call({int limit = 20, int offset = 0}) =>
      repository.getFeed(limit: limit, offset: offset);
}
