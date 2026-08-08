import 'package:equatable/equatable.dart';

/// Represents a local news article
class LocalNews extends Equatable {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final String? source;
  final String? author;
  final DateTime publishedAt;
  final String? category;
  final String? location;
  final bool isTrending;

  const LocalNews({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    this.source,
    this.author,
    required this.publishedAt,
    this.category,
    this.location,
    this.isTrending = false,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        imageUrl,
        source,
        author,
        publishedAt,
        category,
        location,
        isTrending,
      ];

  LocalNews copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    String? source,
    String? author,
    DateTime? publishedAt,
    String? category,
    String? location,
    bool? isTrending,
  }) {
    return LocalNews(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      source: source ?? this.source,
      author: author ?? this.author,
      publishedAt: publishedAt ?? this.publishedAt,
      category: category ?? this.category,
      location: location ?? this.location,
      isTrending: isTrending ?? this.isTrending,
    );
  }

  factory LocalNews.fromJson(Map<String, dynamic> json) {
    return LocalNews(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['image_url'] as String?,
      source: json['source'] as String?,
      author: json['author'] as String?,
      publishedAt: DateTime.parse(json['published_at'] as String),
      category: json['category'] as String?,
      location: json['location'] as String?,
      isTrending: json['is_trending'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'source': source,
      'author': author,
      'published_at': publishedAt.toIso8601String(),
      'category': category,
      'location': location,
      'is_trending': isTrending,
    };
  }
}