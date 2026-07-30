import 'package:dartz/dartz.dart';
import '../../../../core/failures/failure.dart';
import '../entities/message.dart';

abstract class ChatRepository {
  Stream<List<Message>> getMessages(String otherUserId);
  Future<Either<Failure, void>> sendMessage(String receiverId, String content, {String? imageUrl, String? voiceUrl});
  Future<Either<Failure, void>> markAsRead(String messageId);
}
