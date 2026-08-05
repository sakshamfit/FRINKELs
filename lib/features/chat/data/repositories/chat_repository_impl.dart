import 'package:dartz/dartz.dart';
import '../../../../core/failures/failure.dart';
import '../../domain/entities/message.dart';
import '../datasources/chat_remote_data_source.dart';
import '../../domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl(this.remoteDataSource);

  @override
  Stream<List<Message>> getMessages(String otherUserId, {int limit = 50, String? beforeMessageId}) {
    return remoteDataSource.getMessages(otherUserId, limit: limit, beforeMessageId: beforeMessageId);
  }

  @override
  Stream<List<Message>> getMessagesAfter(String otherUserId, {int limit = 50, String? afterMessageId}) {
    return remoteDataSource.getMessagesAfter(otherUserId, limit: limit, afterMessageId: afterMessageId);
  }

  @override
  Future<Either<Failure, void>> sendMessage(String receiverId, String content,
      {String? imageUrl, String? videoUrl, String? voiceUrl, String? fileUrl, String? stickerPackId, String? stickerId}) async {
    try {
      await remoteDataSource.sendMessage(receiverId, content,
          imageUrl: imageUrl, videoUrl: videoUrl, voiceUrl: voiceUrl, fileUrl: fileUrl, stickerPackId: stickerPackId, stickerId: stickerId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAsDelivered(String messageId) async {
    try {
      await remoteDataSource.markAsDelivered(messageId);
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

  // Typing indicators
  @override
  Stream<List<String>> getTypingIndicators(String conversationId) {
    return remoteDataSource.getTypingIndicators(conversationId);
  }

  @override
  Future<Either<Failure, void>> sendTypingIndicator(String conversationId, bool isTyping) async {
    try {
      await remoteDataSource.sendTypingIndicator(conversationId, isTyping);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // Presence
  @override
  Stream<String?> getPresence(String userId) {
    return remoteDataSource.getPresence(userId);
  }

  // Reactions
  @override
  Future<Either<Failure, void>> reactToMessage(String messageId, String emoji) async {
    try {
      await remoteDataSource.reactToMessage(messageId, emoji);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeReaction(String messageId, String emoji) async {
    try {
      await remoteDataSource.removeReaction(messageId, emoji);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // Message editing
  @override
  Future<Either<Failure, void>> editMessage(String messageId, String newContent) async {
    try {
      await remoteDataSource.editMessage(messageId, newContent);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // Message deletion
  @override
  Future<Either<Failure, void>> deleteMessage(String messageId, bool forEveryone) async {
    try {
      await remoteDataSource.deleteMessage(messageId, forEveryone);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // Message pinning
  @override
  Future<Either<Failure, void>> pinMessage(String messageId, bool pin) async {
    try {
      await remoteDataSource.pinMessage(messageId, pin);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // Reactions
  @override
  Stream<List<Map<String, dynamic>>> getReactions(String messageId) {
    return remoteDataSource.getReactions(messageId);
  }

  @override
  Stream<List<Map<String, dynamic>>> getReactionsForConversation(String conversationId) {
    return remoteDataSource.getReactionsForConversation(conversationId);
  }
}