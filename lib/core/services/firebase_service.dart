import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import '../../firebase_options.dart';

class FirebaseService {
  static FirebaseAuth get auth => FirebaseAuth.instance;
  static FirebaseFirestore get firestore => FirebaseFirestore.instance;
  static FirebaseStorage get storage => FirebaseStorage.instance;

  /// Initialize Firebase for the app
  static Future<void> initialize() async {
    try {
      // Check if Firebase is already initialized (e.g., from AppDelegate on iOS)
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        if (kDebugMode) {
          debugPrint('Firebase initialized successfully');
        }
      } else {
        if (kDebugMode) {
          debugPrint('Firebase already initialized');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error initializing Firebase: $e');
      }
      // Don't rethrow - allow app to continue even if Firebase init fails
      // The app will handle missing Firebase gracefully
    }
  }

  /// Get current user
  static User? get currentUser => auth.currentUser;

  /// Get user authentication state stream
  static Stream<User?> get authStateChanges => auth.authStateChanges();

  /// Sign out current user
  static Future<void> signOut() async {
    await auth.signOut();
  }
}
