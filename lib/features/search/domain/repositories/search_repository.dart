import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/models/search_result.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../home/domain/entities/post.dart';
import '../../../jobs/domain/entities/job.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<User>>> searchUsers(String query);
  Future<Either<Failure, List<Post>>> searchPosts(String query);
  Future<Either<Failure, List<Job>>> searchJobs(String query);
  Future<Either<Failure, List<User>>> searchProfessionals(String query);
  Future<Either<Failure, List<User>>> searchNearbyProfessionals({
    required String query,
    double? latitude,
    double? longitude,
    double radiusKm = 10,
  });
  Future<Either<Failure, List<SearchResult>>> getTrendingSearches();
  Future<Either<Failure, List<String>>> getRecentSearches(String userId);
  Future<Either<Failure, void>> saveSearch(String userId, String query);
  Future<Either<Failure, void>> clearSearchHistory(String userId);
}
