import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import 'firebase_service.dart';

class UserService {
  static final FirebaseFirestore _firestore = FirebaseService.firestore;
  static const String _usersCollection = 'users';

  /// Create a new user document in Firestore
  static Future<void> createUserDocument(UserModel user) async {
    try {
      final userData = user.toMap();
      userData['createdAt'] = Timestamp.now();
      userData['updatedAt'] = Timestamp.now();

      await _firestore.collection(_usersCollection).doc(user.uid).set(userData);
    } catch (e) {
      // Log error but don't throw - we don't want to fail auth if Firestore fails
      print('Error creating user document: $e');
    }
  }

  /// Update user document in Firestore
  static Future<void> updateUserDocument(
    String uid,
    Map<String, dynamic> updates,
  ) async {
    try {
      updates['updatedAt'] = Timestamp.now();

      await _firestore.collection(_usersCollection).doc(uid).update(updates);
    } catch (e) {
      print('Error updating user document: $e');
      rethrow;
    }
  }

  /// Get user document from Firestore
  static Future<UserModel?> getUserDocument(String uid) async {
    try {
      final doc = await _firestore.collection(_usersCollection).doc(uid).get();

      if (doc.exists) {
        return UserModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      print('Error getting user document: $e');
      return null;
    }
  }

  static Future<String> getUserDisplayName(String uid) async {
    final user = await getUserDocument(uid);
    return user?.displayName ?? '';
  }

  /// Check if user document exists
  static Future<bool> userDocumentExists(String uid) async {
    try {
      final doc = await _firestore.collection(_usersCollection).doc(uid).get();

      return doc.exists;
    } catch (e) {
      print('Error checking user document: $e');
      return false;
    }
  }

  /// Delete user document from Firestore
  static Future<void> deleteUserDocument(String uid) async {
    try {
      await _firestore.collection(_usersCollection).doc(uid).delete();
    } catch (e) {
      print('Error deleting user document: $e');
      rethrow;
    }
  }
}
