import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final String? imageUrl;
  final String? voiceUrl;
  final bool isRead;
  final DateTime createdAt;

  const Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    this.imageUrl,
    this.voiceUrl,
    this.isRead = false,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, senderId, receiverId, content, imageUrl, voiceUrl, isRead, createdAt];
}
