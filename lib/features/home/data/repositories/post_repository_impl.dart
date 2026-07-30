import 'package:dartz/dartz.dart';
import '../../../../core/failures/failure.dart';
import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/home_remote_data_source.dart';

class PostRepositoryImpl implements PostRepository {
  final HomeRemoteDataSource remoteDataSource;

  PostRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Post>>> getFeed({int limit = 20, int offset = 0}) async {
    try {
      final posts = await remoteDataSource.getFeed(limit: limit, offset: offset);
      return Right(posts);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Post>> createPost(String content, List<String> imageUrls) async {
    try {
      final post = await remoteDataSource.createPost(content, imageUrls);
      return Right(post);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> likePost(String postId) async {
    try {
      await remoteDataSource.likePost(postId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> unlikePost(String postId) async {
    try {
      await remoteDataSource.unlikePost(postId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> bookmarkPost(String postId) async {
    try {
      await remoteDataSource.bookmarkPost(postId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
