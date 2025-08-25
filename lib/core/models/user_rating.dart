import 'package:cloud_firestore/cloud_firestore.dart';

class UserRating {
  final String userId;
  final String userName;
  final double ratingValue;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserRating({
    required this.userId,
    required this.userName,
    required this.ratingValue,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserRating.create({
    required String userId,
    required String userName,
    required double ratingValue,
  }) {
    final now = DateTime.now();
    return UserRating(
      userId: userId,
      userName: userName,
      ratingValue: ratingValue,
      createdAt: now,
      updatedAt: now,
    );
  }

  factory UserRating.fromMap(Map<String, dynamic> map) {
    return UserRating(
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      ratingValue: (map['ratingValue'] ?? 0.0).toDouble(),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'ratingValue': ratingValue,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  UserRating copyWith({
    String? userId,
    String? userName,
    double? ratingValue,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserRating(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      ratingValue: ratingValue ?? this.ratingValue,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
