import 'package:cloud_firestore/cloud_firestore.dart';

import '/constants/enums.dart';

class GroupMember {
  final String userId;
  final String name;
  final GroupMemberRole role;
  final DateTime joinedAt;

  const GroupMember({
    required this.userId,
    required this.name,
    required this.role,
    required this.joinedAt,
  });

  factory GroupMember.fromMap(Map<String, dynamic> map) {
    return GroupMember(
      userId: map['userId'],
      name: map['name'],
      role: GroupMemberRole.values.firstWhere((e) => e.value == map['role']),
      joinedAt: (map['joinedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'role': role.value,
      'joinedAt': joinedAt,
    };
  }

  GroupMember copyWith({
    String? userId,
    String? name,
    GroupMemberRole? role,
    DateTime? joinedAt,
  }) {
    return GroupMember(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      role: role ?? this.role,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}
