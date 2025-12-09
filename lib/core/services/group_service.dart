import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

import '/core/__core.dart';
import '/constants/__constants.dart';

class GroupService {
  static final FirebaseFirestore _firestore = FirebaseService.firestore;

  static const String _groupsCollection = 'groups';

  static String _generateGroupCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        6,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  static Future<Group> createGroup({
    required String name,
    String? description,
    required GroupCategory category,
    required UserModel user,
  }) async {
    String groupCode;
    bool isUnique = false;

    do {
      groupCode = _generateGroupCode();
      final existingGroup = await _firestore
          .collection(_groupsCollection)
          .where('groupCode', isEqualTo: groupCode)
          .get();
      isUnique = existingGroup.docs.isEmpty;
    } while (!isUnique);

    final group = Group.create(
      groupCode: groupCode,
      name: name,
      description: description,
      category: category,
      user: user,
    );

    await _firestore
        .collection(_groupsCollection)
        .doc(group.id)
        .set(group.toMap());
    return group;
  }

  static Future<Group?> joinGroup({
    required String groupCode,
    required String userId,
    required String userName,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection(_groupsCollection)
          .where('groupCode', isEqualTo: groupCode)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return null;
      }

      final groupDoc = querySnapshot.docs.first;
      final group = Group.fromMap(groupDoc.data(), groupDoc.id);

      if (group.members.any((e) => e.userId == userId)) {
        return group;
      }

      final updatedMemberIds = List<String>.from(
        group.members.map((e) => e.userId),
      )..add(userId);

      final updatedMembers = List<GroupMember>.from(group.members.map((e) => e))
        ..add(
          GroupMember(
            userId: userId,
            name: userName,
            role: GroupMemberRole.member,
            joinedAt: DateTime.now(),
          ),
        );

      await _firestore.collection(_groupsCollection).doc(group.id).update({
        'memberIds': updatedMemberIds,
        'members': updatedMembers.map((e) => e.toMap()).toList(),
        'updatedAt': Timestamp.now(),
      });

      return group.copyWith(
        memberIds: updatedMemberIds,
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      rethrow;
    }
  }

  static Stream<List<Group>> getUserGroups(String userId) {
    return _firestore
        .collection(_groupsCollection)
        .where('memberIds', arrayContains: userId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            return Group.fromMap(doc.data(), doc.id);
          }).toList(),
        );
  }

  static Future<Group?> getGroup(String groupId) async {
    try {
      final doc = await _firestore
          .collection(_groupsCollection)
          .doc(groupId)
          .get();

      if (doc.exists) {
        return Group.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> updateGroup({
    required String groupId,
    String? name,
    String? description,
    GroupCategory? category,
  }) async {
    try {
      final updates = <String, dynamic>{'updatedAt': Timestamp.now()};

      if (name != null) updates['name'] = name;
      if (description != null) updates['description'] = description;
      if (category != null) updates['category'] = category.name;

      await _firestore
          .collection(_groupsCollection)
          .doc(groupId)
          .update(updates);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> leaveGroup({
    required String groupId,
    required String userId,
  }) async {
    try {
      final group = await getGroup(groupId);
      if (group == null) return;

      // Remove user from member list
      final updatedMemberIds = List<String>.from(
        group.members.map((e) => e.userId),
      )..remove(userId);
      if (updatedMemberIds.isEmpty) {
        await _firestore.collection(_groupsCollection).doc(groupId).delete();
      } else {
        await _firestore.collection(_groupsCollection).doc(groupId).update({
          'memberIds': updatedMemberIds,
          'updatedAt': Timestamp.now(),
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> groupCodeExists(String groupCode) async {
    final querySnapshot = await _firestore
        .collection(_groupsCollection)
        .where('groupCode', isEqualTo: groupCode)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }
}
