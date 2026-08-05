import 'package:dartz/dartz.dart';
import '../../../../core/failures/failure.dart';
import '../entities/message.dart';

abstract class ChatRepository {
  Stream<List<Message>> getMessages(String otherUserId, {int limit = 50, String? beforeMessageId});
  Stream<List<Message>> getMessagesAfter(String otherUserId, {int limit = 50, String? afterMessageId});
  Future<Either<Failure, void>> sendMessage(String receiverId, String content,
      {String? imageUrl, String? videoUrl, String? voiceUrl, String? fileUrl, String? stickerPackId, String? stickerId});
  Future<Either<Failure, void>> markAsDelivered(String messageId);
  Future<Either<Failure, void>> markAsRead(String messageId);

  // Typing indicators
  Stream<List<String>> getTypingIndicators(String conversationId);
  Future<Either<Failure, void>> sendTypingIndicator(String conversationId, bool isTyping);

  // Presence
  Stream<String?> getPresence(String userId);

  // Reactions
  Future<Either<Failure, void>> reactToMessage(String messageId, String emoji);
  Future<Either<Failure, void>> removeReaction(String messageId, String emoji);
  Stream<List<Map<String, dynamic>>> getReactions(String messageId);
  Stream<List<Map<String, dynamic>>> getReactionsForConversation(String conversationId);

  // Message editing
  Future<Either<Failure, void>> editMessage(String messageId, String newContent);

  // Message deletion
  Future<Either<Failure, void>> deleteMessage(String messageId, bool forEveryone);

  // Message pinning
  Future<Either<Failure, void>> pinMessage(String messageId, bool pin);
}