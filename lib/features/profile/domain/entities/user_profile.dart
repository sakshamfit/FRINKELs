import '../../../auth/domain/entities/user.dart';
import 'profile.dart';

class UserProfile extends Profile {
  final String email;
  final String? profession;
  final bool emailVerified;
  final bool isOnboarded;
  final DateTime createdAt;
  final DateTime? lastSeen;
  final int followersCount;
  final int followingCount;
  final int postsCount;

  const UserProfile({
    required super.id,
    required this.email,
    super.name,
    super.username,
    super.bio,
    super.avatarUrl,
    super.coverUrl,
    this.profession,
    required this.emailVerified,
    required this.isOnboarded,
    required this.createdAt,
    this.lastSeen,
    this.followersCount = 0,
    this.followingCount = 0,
    this.postsCount = 0,
    super.interests = const [],
  });

  @override
  List<Object?> get props => [
        ...super.props,
        email,
        profession,
        emailVerified,
        isOnboarded,
        createdAt,
        lastSeen,
        followersCount,
        followingCount,
        postsCount,
      ];

  @override
  UserProfile copyWith({
    String? id,
    String? email,
    String? name,
    String? username,
    String? bio,
    String? avatarUrl,
    String? coverUrl,
    String? profession,
    bool? emailVerified,
    bool? isOnboarded,
    DateTime? createdAt,
    DateTime? lastSeen,
    List<String>? interests,
    int? followersCount,
    int? followingCount,
    int? postsCount,
  }) {
    return UserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      profession: profession ?? this.profession,
      emailVerified: emailVerified ?? this.emailVerified,
      isOnboarded: isOnboarded ?? this.isOnboarded,
      createdAt: createdAt ?? this.createdAt,
      lastSeen: lastSeen ?? this.lastSeen,
      interests: interests ?? this.interests,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      postsCount: postsCount ?? this.postsCount,
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'],
      username: json['username'],
      bio: json['bio'],
      avatarUrl: json['avatar_url'],
      coverUrl: json['cover_url'],
      profession: json['profession'],
      emailVerified: json['email_verified'] ?? false,
      isOnboarded: json['is_onboarded'] ?? false,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      lastSeen: json['last_seen'] != null ? DateTime.parse(json['last_seen']) : null,
      followersCount: json['followers_count'] ?? 0,
      followingCount: json['following_count'] ?? 0,
      postsCount: json['posts_count'] ?? 0,
      interests: List<String>.from(json['interests'] ?? []),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'email': email,
      'profession': profession,
      'email_verified': emailVerified,
      'is_onboarded': isOnboarded,
      'created_at': createdAt.toIso8601String(),
      'last_seen': lastSeen?.toIso8601String(),
      'followers_count': followersCount,
      'following_count': followingCount,
      'posts_count': postsCount,
    };
  }

  factory UserProfile.fromUser(User user) {
    return UserProfile(
      id: user.id,
      email: user.email,
      name: user.name,
      username: user.username,
      bio: user.bio,
      avatarUrl: user.avatarUrl,
      coverUrl: user.coverUrl,
      profession: user.profession,
      emailVerified: user.emailVerified,
      isOnboarded: user.isOnboarded,
      createdAt: user.createdAt,
      interests: user.interests,
    );
  }
}
