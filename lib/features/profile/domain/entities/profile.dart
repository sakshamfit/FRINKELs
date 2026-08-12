import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String id;
  final String? name;
  final String? username;
  final String? bio;
  final String? avatarUrl;
  final String? coverUrl;
  final List<String> interests;

  const Profile({
    required this.id,
    this.name,
    this.username,
    this.bio,
    this.avatarUrl,
    this.coverUrl,
    this.interests = const [],
  });

  @override
  List<Object?> get props => [
    id,
    name,
    username,
    bio,
    avatarUrl,
    coverUrl,
    interests,
  ];

  Profile copyWith({
    String? id,
    String? name,
    String? username,
    String? bio,
    String? avatarUrl,
    String? coverUrl,
    List<String>? interests,
  }) {
    return Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      interests: interests ?? this.interests,
    );
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] ?? '',
      name: json['name'],
      username: json['username'],
      bio: json['bio'],
      avatarUrl: json['avatar_url'],
      coverUrl: json['cover_url'],
      interests: List<String>.from(json['interests'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'bio': bio,
      'avatar_url': avatarUrl,
      'cover_url': coverUrl,
      'interests': interests,
    };
  }
}
