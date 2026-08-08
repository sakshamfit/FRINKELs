import 'package:equatable/equatable.dart';

class Documentation extends Equatable {
  final String id;
  final String title;
  final String content;
  final String category;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPublished;

  const Documentation({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
    required this.isPublished,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        category,
        tags,
        createdAt,
        updatedAt,
        isPublished,
      ];

  Documentation copyWith({
    String? id,
    String? title,
    String? content,
    String? category,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPublished,
  }) {
    return Documentation(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPublished: isPublished ?? this.isPublished,
    );
  }
}