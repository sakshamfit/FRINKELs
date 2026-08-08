import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/models/search_result.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../home/domain/entities/post.dart';
import '../../../jobs/domain/entities/job.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_remote_data_source.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;

  SearchRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<User>>> searchUsers(String query) async {
    try {
      final result = await remoteDataSource.searchUsers(query);
      return Right(result);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Post>>> searchPosts(String query) async {
    try {
      final result = await remoteDataSource.searchPosts(query);
      return Right(result);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Job>>> searchJobs(String query) async {
    try {
      final result = await remoteDataSource.searchJobs(query);
      return Right(result);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<User>>> searchProfessionals(String query) async {
    try {
      final result = await remoteDataSource.searchProfessionals(query);
      return Right(result);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<User>>> searchNearbyProfessionals({
    required String query,
    double? latitude,
    double? longitude,
    double radiusKm = 10,
  }) async {
    try {
      final result = await remoteDataSource.searchNearbyProfessionals(
        query: query,
        latitude: latitude,
        longitude: longitude,
        radiusKm: radiusKm,
      );
      return Right(result);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<SearchResult>>> getTrendingSearches() async {
    try {
      final result = await remoteDataSource.getTrendingSearches();
      return Right(result);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<String>>> getRecentSearches(String userId) async {
    try {
      final result = await remoteDataSource.getRecentSearches(userId);
      return Right(result);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> saveSearch(String userId, String query) async {
    try {
      await remoteDataSource.saveSearch(userId, query);
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> clearSearchHistory(String userId) async {
    try {
      await remoteDataSource.clearSearchHistory(userId);
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }
}
