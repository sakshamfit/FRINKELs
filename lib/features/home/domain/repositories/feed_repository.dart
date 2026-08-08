import 'package:dartz/dartz.dart';
import '../../../../core/failures/failure.dart';
import '../entities/post.dart';
import '../entities/story.dart';
import '../entities/business.dart';
import '../entities/community.dart';
import '../../../jobs/domain/entities/job.dart';
import '../../../auth/domain/entities/user.dart';
import '../entities/local_news.dart';

abstract class FeedRepository {
  Future<Either<Failure, List<Post>>> getFeed({int limit = 20, int offset = 0});
  Stream<Either<Failure, List<Post>>> getFeedStream({int limit = 20});
  Future<Either<Failure, List<User>>> getNearbyProfessionals();
  Future<Either<Failure, List<Story>>> getStories({String? userId});
  Future<Either<Failure, List<Business>>> getBusinesses({String? category, double? minRating});
  Future<Either<Failure, List<Community>>> getCommunities({String? category, int? minMemberCount});
  Future<Either<Failure, List<Job>>> getJobs({String? category, double? minSalary});
  Future<Either<Failure, List<LocalNews>>> getLocalNews({String? category, String? location});
  Future<Either<Failure, void>> likePost(String postId);
  Future<Either<Failure, void>> bookmarkPost(String postId);
  Future<Either<Failure, Post>> createPost(String content, {List<String>? imageUrls, PostType type = PostType.text});
  Future<Either<Failure, Story>> createStory(String mediaUrl, {String? caption, StoryType type = StoryType.image});
  Future<Either<Failure, void>> viewStory(String storyId);
}
