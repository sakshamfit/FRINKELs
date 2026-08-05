import 'package:equatable/equatable.dart';

/// Message content kind — must stay in sync with `public.message_type`
/// PostgreSQL enum (see supabase/migrations/20260804000100_enums.sql).
enum MessageType {
  text,
  image,
  video,
  voice,
  file,
  location,
  contact,
  sticker,
  gif;

  /// Convert a Postgres enum label (e.g. `'text'`) into a [MessageType].
  /// Falls back to [MessageType.text] if the label is unknown.
  static MessageType fromString(String? value) {
    if (value == null) return MessageType.text;
    for (final t in MessageType.values) {
      if (t.name == value) return t;
    }
    return MessageType.text;
  }
}

class Message extends Equatable {
  final String id;
  final String conversationId;
  final String senderId;
  final MessageType type;
  final String content;
  final List<String> imageUrls;
  final String? videoUrl;
  final String? fileUrl;
  final String? voiceUrl;
  final String? gifUrl;
  final int? duration; // in seconds
  final double? latitude;
  final double? longitude;
  final String? locationTitle;
  final Map<String, dynamic>? contactData; // JSON object
  final bool? isGif;
  final String? replyToMessageId;
  final String? forwardedFromMessageId;
  final DateTime? editedAt; // when message was last edited
  final String? editedBy; // user ID who edited the message
  final String? stickerPackId; // sticker pack identifier
  final String? stickerId; // sticker identifier
  final bool? pinned; // whether the message is pinned
  final String? pinnedBy; // user ID who pinned the message
  final DateTime? pinnedAt; // when the message was pinned
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final List<String> deletedBy; // list of user IDs who deleted it for themselves

  const Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.type,
    required this.content,
    this.imageUrls = const [],
    this.videoUrl,
    this.voiceUrl,
    this.fileUrl,
    this.gifUrl,
    this.duration,
    this.latitude,
    this.longitude,
    this.locationTitle,
    this.contactData,
    this.isGif,
    this.replyToMessageId,
    this.forwardedFromMessageId,
    this.editedAt,
    this.editedBy,
    this.stickerPackId,
    this.stickerId,
    this.pinned,
    this.pinnedBy,
    this.pinnedAt,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.deletedBy = const [],
  });

  factory Message.text({
    required String id,
    required String conversationId,
    required String senderId,
    required String content,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) {
    return Message(
      id: id,
      conversationId: conversationId,
      senderId: senderId,
      type: MessageType.text,
      content: content,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      conversationId: json['conversation_id'] as String,
      senderId: json['sender_id'] as String,
      type: MessageType.fromString(json['type'] as String?),
      content: json['content'] as String,
      imageUrls: List<String>.from(json['image_urls'] ?? []),
      videoUrl: json['video_url'] as String?,
      voiceUrl: json['voice_url'] as String?,
      fileUrl: json['file_url'] as String?,
      gifUrl: json['gif_url'] as String?,
      duration: json['duration'] as int?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      locationTitle: json['location_title'] as String?,
      contactData: json['contact_data'] != null ? Map<String, dynamic>.from(json['contact_data']) : null,
      isGif: json['is_gif'] as bool?,
      replyToMessageId: json['reply_to_message_id'] as String?,
      forwardedFromMessageId: json['forwarded_from_message_id'] as String?,
      editedAt: json['edited_at'] != null ? DateTime.parse(json['edited_at'] as String) : null,
      editedBy: json['edited_by'] as String?,
      stickerPackId: json['sticker_pack_id'] as String?,
      stickerId: json['sticker_id'] as String?,
      pinned: json['pinned'] as bool?,
      pinnedBy: json['pinned_by'] as String?,
      pinnedAt: json['pinned_at'] != null ? DateTime.parse(json['pinned_at'] as String) : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at'] as String) : null,
      deletedBy: List<String>.from(json['deleted_by'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'sender_id': senderId,
      'type': type.toString().split('.').last,
      'content': content,
      'image_urls': imageUrls,
      'video_url': videoUrl,
      'voice_url': voiceUrl,
      'file_url': fileUrl,
      'gif_url': gifUrl,
      'duration': duration,
      'latitude': latitude,
      'longitude': longitude,
      'location_title': locationTitle,
      'contact_data': contactData,
      'is_gif': isGif,
      'reply_to_message_id': replyToMessageId,
      'forwarded_from_message_id': forwardedFromMessageId,
      'edited_at': editedAt?.toIso8601String(),
      'edited_by': editedBy,
      'sticker_pack_id': stickerPackId,
      'sticker_id': stickerId,
      'pinned': pinned,
      'pinned_by': pinnedBy,
      'pinned_at': pinnedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'deleted_by': deletedBy,
    };
  }

  @override
  List<Object?> get props => [
        id,
        conversationId,
        senderId,
        type,
        content,
        imageUrls,
        videoUrl,
        voiceUrl,
        fileUrl,
        gifUrl,
        duration,
        latitude,
        longitude,
        locationTitle,
        contactData,
        isGif,
        replyToMessageId,
        forwardedFromMessageId,
        editedAt,
        editedBy,
        stickerPackId,
        stickerId,
        pinned,
        pinnedBy,
        pinnedAt,
        createdAt,
        updatedAt,
        deletedAt,
        deletedBy,
      ];
}
