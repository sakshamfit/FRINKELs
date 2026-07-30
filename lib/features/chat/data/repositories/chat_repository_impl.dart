import 'package:dartz/dartz.dart';
import '../../../../core/failures/failure.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl(this.remoteDataSource);

  @override
  Stream<List<Message>> getMessages(String otherUserId) {
    return remoteDataSource.getMessages(otherUserId);
  }

  @override
  Future<Either<Failure, void>> sendMessage(String receiverId, String content, {String? imageUrl, String? voiceUrl}) async {
    try {
      await remoteDataSource.sendMessage(receiverId, content, imageUrl: imageUrl, voiceUrl: voiceUrl);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String messageId) async {
    try {
      await remoteDataSource.markAsRead(messageId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
