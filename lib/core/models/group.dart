import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '/core/__core.dart';
import '/constants/__constants.dart';

class Group {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final String groupCode;
  final int ratingItemsCount;
  final GroupCategory category;
  final List<String> memberIds;
  final List<GroupMember> members;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Group({
    required this.id,
    required this.groupCode,
    required this.name,
    this.description,
    this.imageUrl,
    required this.ratingItemsCount,
    required this.category,
    required this.memberIds,
    required this.members,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Group.create({
    required String groupCode,
    required String name,
    String? description,
    String? imageUrl,
    required GroupCategory category,
    required UserModel user,
  }) {
    final now = DateTime.now();
    return Group(
      id: const Uuid().v4(),
      groupCode: groupCode,
      name: name,
      description: description,
      imageUrl: imageUrl,
      ratingItemsCount: 0,
      category: category,
      memberIds: [user.uid],
      members: [
        GroupMember(
          userId: user.uid,
          name: user.displayName ?? '',
          role: GroupMemberRole.admin,
          joinedAt: now,
        ),
      ],
      createdAt: now,
      updatedAt: now,
    );
  }

  factory Group.fromMap(Map<String, dynamic> map, String id) {
    return Group(
      id: id,
      groupCode: map['groupCode'] ?? '',
      name: map['name'] ?? '',
      description: map['description'],
      imageUrl: map['imageUrl'],
      ratingItemsCount: map['ratingItemsCount'] ?? 0,
      category: GroupCategory.values.firstWhere(
        (e) => e.name == map['category'],
        orElse: () => GroupCategory.other,
      ),
      memberIds: List<String>.from(map['memberIds'] ?? []),
      members: List<GroupMember>.from(
        (map['members'] ?? []).map((e) => GroupMember.fromMap(e)),
      ),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'groupCode': groupCode,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'ratingItemsCount': ratingItemsCount,
      'category': category.name,
      'memberIds': memberIds,
      'members': members.map((e) => e.toMap()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  Group copyWith({
    String? id,
    String? groupCode,
    String? name,
    String? description,
    String? imageUrl,
    int? ratingItemsCount,
    GroupCategory? category,
    List<String>? memberIds,
    List<GroupMember>? members,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Group(
      id: id ?? this.id,
      groupCode: groupCode ?? this.groupCode,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      ratingItemsCount: ratingItemsCount ?? this.ratingItemsCount,
      category: category ?? this.category,
      memberIds: memberIds ?? this.memberIds,
      members: members ?? this.members,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
