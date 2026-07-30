import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? username;
  final String? profession;
  final List<String> skills;
  final List<String> interests;
  final String? bio;
  final String? location;
  final String? availability;
  final String? avatarUrl;
  final String? coverUrl;
  final bool emailVerified;
  final bool isOnboarded;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.email,
    this.name,
    this.username,
    this.profession,
    this.skills = const [],
    this.interests = const [],
    this.bio,
    this.location,
    this.availability,
    this.avatarUrl,
    this.coverUrl,
    this.emailVerified = false,
    this.isOnboarded = false,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    username,
    profession,
    skills,
    interests,
    bio,
    location,
    availability,
    avatarUrl,
    coverUrl,
    emailVerified,
    isOnboarded,
    createdAt,
  ];

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? username,
    String? profession,
    List<String>? skills,
    List<String>? interests,
    String? bio,
    String? location,
    String? availability,
    String? avatarUrl,
    String? coverUrl,
    bool? emailVerified,
    bool? isOnboarded,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      username: username ?? this.username,
      profession: profession ?? this.profession,
      skills: skills ?? this.skills,
      interests: interests ?? this.interests,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      availability: availability ?? this.availability,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      emailVerified: emailVerified ?? this.emailVerified,
      isOnboarded: isOnboarded ?? this.isOnboarded,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
