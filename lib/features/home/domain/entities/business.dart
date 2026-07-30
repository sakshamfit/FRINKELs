import 'package:equatable/equatable.dart';

class Business extends Equatable {
  final String id;
  final String name;
  final String description;
  final String category;
  final String address;
  final String phone;
  final String website;
  final String imageUrl;
  final String coverImageUrl;
  final double rating;
  final int reviewCount;
  final bool isOpen;
  final bool isVerified;
  final List<String> categories;
  final DateTime createdAt;

  const Business({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.address,
    required this.phone,
    required this.website,
    required this.imageUrl,
    required this.coverImageUrl,
    required this.rating,
    required this.reviewCount,
    required this.isOpen,
    required this.isVerified,
    required this.categories,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        category,
        address,
        phone,
        website,
        imageUrl,
        coverImageUrl,
        rating,
        reviewCount,
        isOpen,
        isVerified,
        categories,
        createdAt,
      ];

  Business copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    String? address,
    String? phone,
    String? website,
    String? imageUrl,
    String? coverImageUrl,
    double? rating,
    int? reviewCount,
    bool? isOpen,
    bool? isVerified,
    List<String>? categories,
    DateTime? createdAt,
  }) {
    return Business(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      imageUrl: imageUrl ?? this.imageUrl,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isOpen: isOpen ?? this.isOpen,
      isVerified: isVerified ?? this.isVerified,
      categories: categories ?? this.categories,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String,
      website: json['website'] as String,
      imageUrl: json['image_url'] as String,
      coverImageUrl: json['cover_image_url'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['review_count'] as int,
      isOpen: json['is_open'] as bool,
      isVerified: json['is_verified'] as bool,
      categories: List<String>.from(json['categories'] ?? []),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'address': address,
      'phone': phone,
      'website': website,
      'image_url': imageUrl,
      'cover_image_url': coverImageUrl,
      'rating': rating,
      'review_count': reviewCount,
      'is_open': isOpen,
      'is_verified': isVerified,
      'categories': categories,
      'created_at': createdAt.toIso8601String(),
    };
  }
}