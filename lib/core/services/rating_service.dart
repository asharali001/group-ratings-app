import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:developer';
import 'dart:io';

import '../models/__models.dart';

class RatingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  CollectionReference<Map<String, dynamic>> get _ratingsCollection =>
      _firestore.collection('rating_items');

  Future<RatingItem?> createRatingItem({
    required String groupId,
    required String itemName,
    String? description,
    String? location,
    required int ratingScale,
    File? imageFile,
    required String createdBy,
  }) async {
    try {
      String? imageUrl;

      // Upload image if provided
      if (imageFile != null) {
        try {
          final imagePath =
              'ratings/$groupId/${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
          final ref = _storage.ref().child(imagePath);
          await ref.putFile(imageFile);
          imageUrl = await ref.getDownloadURL();
        } catch (e) {
          imageUrl = null;
        }
      }

      final ratingItem = RatingItem.create(
        groupId: groupId,
        name: itemName,
        description: description ?? '',
        location: location ?? '',
        ratingScale: ratingScale,
        imageUrl: imageUrl ?? '',
        createdBy: createdBy,
      );
      await _ratingsCollection.doc(ratingItem.id).set(ratingItem.toMap());
      return ratingItem;
    } catch (e) {
      log('Error creating rating: $e', name: 'RatingService');
      return null;
    }
  }

  Stream<List<RatingItem>> getGroupRatingItems(String groupId) {
    return _ratingsCollection
        .where('groupId', isEqualTo: groupId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => RatingItem.fromMap(doc.data()))
              .toList(),
        );
  }

  Future<RatingItem?> getRatingItem(String ratingId) async {
    try {
      final doc = await _ratingsCollection.doc(ratingId).get();
      if (doc.exists) {
        return RatingItem.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      log('Error getting rating: $e', name: 'RatingService');
      return null;
    }
  }

  Future<bool> updateRatingItem({
    required String ratingId,
    String? itemName,
    String? description,
    String? location,
    int? ratingScale,
    File? imageFile,
    bool removeImage = false,
  }) async {
    try {
      final updateData = <String, dynamic>{'updatedAt': Timestamp.now()};

      if (itemName != null) updateData['itemName'] = itemName;
      if (description != null) updateData['description'] = description;
      if (location != null) updateData['location'] = location;
      if (ratingScale != null) updateData['ratingScale'] = ratingScale;

      // Handle image update
      if (imageFile != null) {
        try {
          // Get the current rating to include groupId in the image path
          final currentRating = await getRatingItem(ratingId);
          final groupId = currentRating?.groupId ?? 'unknown';
          final imagePath =
              'ratings/$groupId/${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
          final ref = _storage.ref().child(imagePath);

          // Upload the file
          await ref.putFile(imageFile);

          // Get the download URL
          final imageUrl = await ref.getDownloadURL();
          updateData['imageUrl'] = imageUrl;

          log('Image updated successfully: $imageUrl', name: 'RatingService');
        } catch (e) {
          log('Error updating image: $e', name: 'RatingService');

          // Check for specific Firebase Storage errors
          if (e.toString().contains('permission-denied')) {
            log('Firebase Storage permission denied', name: 'RatingService');
          } else if (e.toString().contains('unauthenticated')) {
            log('User not authenticated for Firebase Storage', name: 'RatingService');
          } else if (e.toString().contains('storage/unauthorized')) {
            log('Firebase Storage unauthorized', name: 'RatingService');
          } else if (e.toString().contains('storage/quota-exceeded')) {
            log('Firebase Storage quota exceeded', name: 'RatingService');
          }

          // Continue without image if update fails
        }
      } else if (removeImage) {
        // Check if we need to remove the existing image
        final currentRating = await getRatingItem(ratingId);
        if (currentRating != null &&
            currentRating.imageUrl != null &&
            currentRating.imageUrl!.isNotEmpty) {
          // Set imageUrl to null to remove the image
          updateData['imageUrl'] = null;

          // Optionally delete the old image from storage
          try {
            await _storage.refFromURL(currentRating.imageUrl!).delete();
            log('Old image deleted successfully', name: 'RatingService');
          } catch (e) {
            log('Error deleting old image: $e', name: 'RatingService');
            // Continue with update even if image deletion fails
          }
        }
      }

      await _ratingsCollection.doc(ratingId).update(updateData);
      return true;
    } catch (e) {
      log('Error updating rating: $e', name: 'RatingService');
      return false;
    }
  }

  Future<bool> deleteRatingItem(String ratingId) async {
    try {
      // Get the rating first to check if it has an image
      final rating = await getRatingItem(ratingId);
      if (rating != null &&
          rating.imageUrl != null &&
          rating.imageUrl!.isNotEmpty) {
        // Delete the image from storage
        try {
          await _storage.refFromURL(rating.imageUrl!).delete();
        } catch (e) {
          log('Error deleting image: $e', name: 'RatingService');
          // Continue with rating deletion even if image deletion fails
        }
      }

      // Delete the rating document
      await _ratingsCollection.doc(ratingId).delete();
      return true;
    } catch (e) {
      log('Error deleting rating: $e', name: 'RatingService');
      return false;
    }
  }

  Stream<List<RatingItem>> getUserRatingItems(String userId) {
    return _ratingsCollection
        .where('ratedBy', arrayContains: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => RatingItem.fromMap(doc.data()))
              .toList(),
        );
  }

  Future<bool> addUserRating({
    required String ratingItemId,
    required String userId,
    required String userName,
    required double ratingValue,
  }) async {
    try {
      final userRating = UserRating.create(
        userId: userId,
        userName: userName,
        ratingValue: ratingValue,
      );

      await _ratingsCollection.doc(ratingItemId).update({
        'ratings': FieldValue.arrayUnion([userRating.toMap()]),
        'ratedBy': FieldValue.arrayUnion([userId]),
        'updatedAt': Timestamp.now(),
      });

      return true;
    } catch (e) {
      log('Error adding user rating: $e', name: 'RatingService');
      return false;
    }
  }

  /// Update an existing user rating
  Future<bool> updateUserRating({
    required String ratingItemId,
    required String userId,
    required double ratingValue,
  }) async {
    try {
      // Get the current rating item
      final ratingItem = await getRatingItem(ratingItemId);
      if (ratingItem == null) return false;

      // Find and update the existing rating
      final updatedRatings = ratingItem.ratings.map((rating) {
        if (rating.userId == userId) {
          return rating.copyWith(
            ratingValue: ratingValue,
            updatedAt: DateTime.now(),
          );
        }
        return rating;
      }).toList();

      await _ratingsCollection.doc(ratingItemId).update({
        'ratings': updatedRatings.map((r) => r.toMap()).toList(),
        'updatedAt': Timestamp.now(),
      });

      return true;
    } catch (e) {
      log('Error updating user rating: $e', name: 'RatingService');
      return false;
    }
  }

  /// Remove a user rating from a rating item
  Future<bool> removeUserRating({
    required String ratingItemId,
    required String userId,
  }) async {
    try {
      // Get the current rating item
      final ratingItem = await getRatingItem(ratingItemId);
      if (ratingItem == null) return false;

      // Remove the rating for the specific user
      final updatedRatings = ratingItem.ratings
          .where((rating) => rating.userId != userId)
          .toList();

      await _ratingsCollection.doc(ratingItemId).update({
        'ratings': updatedRatings.map((r) => r.toMap()).toList(),
        'ratedBy': FieldValue.arrayRemove([userId]),
        'updatedAt': Timestamp.now(),
      });

      return true;
    } catch (e) {
      log('Error removing user rating: $e', name: 'RatingService');
      return false;
    }
  }
}
