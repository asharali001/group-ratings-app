import 'package:cloud_firestore/cloud_firestore.dart';

class UserRating {
  final String userId;
  final String userName;
  final double ratingValue;
  final double normalizedValue; // 0.0 - 1.0 for cross-scale comparison
  final String? comment;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserRating({
    required this.userId,
    required this.userName,
    required this.ratingValue,
    required this.normalizedValue,
    this.comment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserRating.create({
    required String userId,
    required String userName,
    required double ratingValue,
    required int ratingScale,
    String? comment,
  }) {
    final now = DateTime.now();
    return UserRating(
      userId: userId,
      userName: userName,
      ratingValue: ratingValue,
      normalizedValue: ratingValue / ratingScale, // Calculate percentage
      comment: comment,
      createdAt: now,
      updatedAt: now,
    );
  }

  factory UserRating.fromMap(Map<String, dynamic> map) {
    return UserRating(
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      ratingValue: (map['ratingValue'] ?? 0.0).toDouble(),
      normalizedValue: (map['normalizedValue'] ?? 0.0).toDouble(),
      comment: map['comment'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'ratingValue': ratingValue,
      'normalizedValue': normalizedValue,
      'comment': comment,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  UserRating copyWith({
    String? userId,
    String? userName,
    double? ratingValue,
    double? normalizedValue,
    String? comment,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserRating(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      ratingValue: ratingValue ?? this.ratingValue,
      normalizedValue: normalizedValue ?? this.normalizedValue,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
