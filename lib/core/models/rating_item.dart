import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'user_rating.dart';

class RatingItem {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final String? location;
  final int ratingScale;
  final List<String> ratedBy;
  final List<UserRating> ratings;
  final String groupId;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const RatingItem({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    this.location,
    required this.ratingScale,
    required this.ratedBy,
    required this.ratings,
    required this.groupId,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RatingItem.create({
    required String groupId,
    required String name,
    String? description,
    String? imageUrl,
    String? location,
    required int ratingScale,
    required String createdBy,
  }) {
    return RatingItem(
      id: const Uuid().v4(),
      name: name,
      description: description ?? '',
      imageUrl: imageUrl ?? '',
      location: location ?? '',
      ratingScale: ratingScale,
      ratedBy: [],
      ratings: [],
      groupId: groupId,
      createdBy: createdBy,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  RatingItem copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? location,
    int? ratingScale,
    List<String>? ratedBy,
    List<UserRating>? ratings,
    String? groupId,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RatingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      location: location ?? this.location,
      ratingScale: ratingScale ?? this.ratingScale,
      ratedBy: ratedBy ?? this.ratedBy,
      ratings: ratings ?? this.ratings,
      groupId: groupId ?? this.groupId,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory RatingItem.fromMap(Map<String, dynamic> map) {
    return RatingItem(
      id: map['id'],
      name: map['name'],
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      location: map['location'] ?? '',
      ratingScale: map['ratingScale'],
      ratedBy: List<String>.from(map['ratedBy'] ?? []),
      ratings: List<UserRating>.from(
        (map['ratings'] ?? []).map((e) => UserRating.fromMap(e)),
      ),
      groupId: map['groupId'],
      createdBy: map['createdBy'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description ?? '',
      'imageUrl': imageUrl ?? '',
      'location': location ?? '',
      'ratingScale': ratingScale,
      'ratedBy': ratedBy,
      'ratings': ratings,
      'groupId': groupId,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  @override
  String toString() {
    return 'RatingItem(id: $id, name: $name, description: $description, imageUrl: $imageUrl, location: $location, ratingScale: $ratingScale, ratedBy: $ratedBy, ratings: $ratings, groupId: $groupId, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RatingItem &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.imageUrl == imageUrl &&
        other.location == location &&
        other.ratingScale == ratingScale &&
        other.ratedBy == ratedBy &&
        other.ratings == ratings &&
        other.groupId == groupId &&
        other.createdBy == createdBy &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        imageUrl.hashCode ^
        location.hashCode ^
        ratingScale.hashCode ^
        ratedBy.hashCode ^
        ratings.hashCode ^
        groupId.hashCode ^
        createdBy.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
