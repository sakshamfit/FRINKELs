import 'package:equatable/equatable.dart';

class Community extends Equatable {
  final String id;
  final String name;
  final String description;
  final String category;
  final int memberCount;
  final bool isVerified;
  final String? iconUrl;
  final String? bannerUrl;
  final DateTime createdAt;

  const Community({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.memberCount,
    required this.isVerified,
    this.iconUrl,
    this.bannerUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        category,
        memberCount,
        isVerified,
        iconUrl,
        bannerUrl,
        createdAt,
      ];

  Community copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    int? memberCount,
    bool? isVerified,
    String? iconUrl,
    String? bannerUrl,
    DateTime? createdAt,
  }) {
    return Community(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      memberCount: memberCount ?? this.memberCount,
      isVerified: isVerified ?? this.isVerified,
      iconUrl: iconUrl ?? this.iconUrl,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      memberCount: json['member_count'] as int,
      isVerified: json['is_verified'] as bool,
      iconUrl: json['icon_url'] as String?,
      bannerUrl: json['banner_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'member_count': memberCount,
      'is_verified': isVerified,
      'icon_url': iconUrl,
      'banner_url': bannerUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }
}