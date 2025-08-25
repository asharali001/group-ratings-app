import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '/core/__core.dart';

class GroupService {
  static final FirebaseFirestore _firestore = FirebaseService.firestore;
  static final FirebaseStorage _storage = FirebaseService.storage;

  static const String _groupsCollection = 'groups';

  /// Compress image before upload
  static Future<File?> _compressImage(File imageFile) async {
    try {
      final Uint8List? compressedBytes =
          await FlutterImageCompress.compressWithFile(
            imageFile.absolute.path,
            minWidth: 1024,
            minHeight: 1024,
            quality: 80,
          );

      if (compressedBytes != null) {
        final compressedFile = File(
          '${imageFile.parent.path}/compressed_${imageFile.uri.pathSegments.last}',
        );
        await compressedFile.writeAsBytes(compressedBytes);
        return compressedFile;
      }
      return imageFile; // Return original if compression fails
    } catch (e) {
      print('Image compression failed: $e');
      return imageFile; // Return original if compression fails
    }
  }

  /// Upload image to Firebase Storage with progress tracking
  static Future<String> _uploadImage(
    File imageFile,
    String groupCode, {
    Function(double)? onProgress,
  }) async {
    try {
      // Validate file exists
      if (!await imageFile.exists()) {
        throw Exception('Image file does not exist');
      }

      // Compress image first
      final File? compressedImage = await _compressImage(imageFile);
      final File imageToUpload = compressedImage ?? imageFile;

      final ref = _storage.ref().child('group_images/$groupCode.jpg');

      // Upload with metadata
      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {
          'uploadedAt': DateTime.now().toIso8601String(),
          'originalSize': imageFile.lengthSync().toString(),
          'compressedSize': imageToUpload.lengthSync().toString(),
        },
      );

      final uploadTask = ref.putFile(imageToUpload, metadata);

      // Listen to upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        onProgress?.call(progress);
      });

      // Wait for upload to complete
      final snapshot = await uploadTask;

      // Get download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'storage/unauthorized':
          throw Exception('You are not authorized to upload images');
        case 'storage/quota-exceeded':
          throw Exception('Storage quota exceeded. Please try again later.');
        case 'storage/retry-limit-exceeded':
          throw Exception(
            'Upload failed. Please check your internet connection and try again.',
          );
        default:
          throw Exception('Failed to upload image: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  /// Generate a unique 6-character group code
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

  /// Create a new group with a unique code
  static Future<Group> createGroup({
    required String name,
    String? description,
    File? imageFile,
    required UserModel user,
    Function(double)? onImageUploadProgress,
  }) async {
    // Generate a unique group code
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

    // Upload image if provided
    String? imageUrl;
    if (imageFile != null) {
      imageUrl = await _uploadImage(
        imageFile,
        groupCode,
        onProgress: onImageUploadProgress,
      );
    }

    // Create the group
    final group = Group.create(
      groupCode: groupCode,
      name: name,
      description: description,
      imageUrl: imageUrl,
      user: user,
    );

    // Save to Firestore
    await _firestore
        .collection(_groupsCollection)
        .doc(group.id)
        .set(group.toMap());
    return group;
  }

  /// Join a group using a group code
  static Future<Group?> joinGroup({
    required String groupCode,
    required String userId,
  }) async {
    try {
      // Find the group by code
      final querySnapshot = await _firestore
          .collection(_groupsCollection)
          .where('groupCode', isEqualTo: groupCode)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return null; // Group not found
      }

      final groupDoc = querySnapshot.docs.first;
      final group = Group.fromMap(groupDoc.data(), groupDoc.id);

      // Check if user is already a member
      if (group.members.any((e) => e.userId == userId)) {
        return group; // User is already a member
      }

      // Add user to the group
      final updatedMemberIds = List<String>.from(
        group.members.map((e) => e.userId),
      )..add(userId);

      await _firestore.collection(_groupsCollection).doc(group.id).update({
        'memberIds': updatedMemberIds,
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

  /// Get all groups where the user is a member
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

  /// Get a specific group by ID
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

  /// Delete image from Firebase Storage
  static Future<void> _deleteImage(String groupCode) async {
    try {
      final ref = _storage.ref().child('group_images/$groupCode.jpg');
      await ref.delete();
    } catch (e) {
      // Ignore errors when deleting images (they might not exist)
      print('Failed to delete image: $e');
    }
  }

  /// Update group details (name, description, image)
  static Future<void> updateGroup({
    required String groupId,
    String? name,
    String? description,
    File? imageFile,
    Function(double)? onImageUploadProgress,
  }) async {
    try {
      final updates = <String, dynamic>{'updatedAt': Timestamp.now()};

      if (name != null) updates['name'] = name;
      if (description != null) updates['description'] = description;

      // Upload new image if provided
      if (imageFile != null) {
        final group = await getGroup(groupId);
        if (group != null) {
          // Delete old image first
          await _deleteImage(group.groupCode);

          // Upload new image
          final imageUrl = await _uploadImage(
            imageFile,
            group.groupCode,
            onProgress: onImageUploadProgress,
          );
          updates['imageUrl'] = imageUrl;
        }
      }

      await _firestore
          .collection(_groupsCollection)
          .doc(groupId)
          .update(updates);
    } catch (e) {
      rethrow;
    }
  }

  /// Leave a group
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

      // If no members left, delete the group and its image
      if (updatedMemberIds.isEmpty) {
        // Delete the group image first
        await _deleteImage(group.groupCode);

        // Delete the group document
        await _firestore.collection(_groupsCollection).doc(groupId).delete();
      } else {
        // Update the group
        await _firestore.collection(_groupsCollection).doc(groupId).update({
          'memberIds': updatedMemberIds,
          'updatedAt': Timestamp.now(),
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Check if a group code exists
  static Future<bool> groupCodeExists(String groupCode) async {
    final querySnapshot = await _firestore
        .collection(_groupsCollection)
        .where('groupCode', isEqualTo: groupCode)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }
}
