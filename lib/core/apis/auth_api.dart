import 'dart:convert';
import 'dart:developer';
import 'dart:math' hide log;

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../models/user_model.dart';

class AuthApi {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  /// Sign in with email and password
  static Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserModel.fromFirebaseUser(result.user!);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  /// Sign up with email and password
  static Future<UserModel> createUserWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name if provided
      if (displayName != null && displayName.isNotEmpty) {
        await result.user!.updateDisplayName(displayName);
      }

      return UserModel.fromFirebaseUser(result.user!);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  /// Sign in with Google
  static Future<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google sign in was cancelled');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      
      if (googleAuth.idToken == null) {
        throw Exception('Failed to get Google authentication token');
      }

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential result = await _auth.signInWithCredential(
        credential,
      );
      
      if (result.user == null) {
        throw Exception('Failed to sign in to Firebase');
      }

      return UserModel.fromFirebaseUser(result.user!);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  /// Sign in with Apple
  static Future<UserModel> signInWithApple() async {
    try {
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      final AuthorizationCredentialAppleID appleCredential =
          await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final OAuthProvider oAuthProvider = OAuthProvider('apple.com');
      final AuthCredential credential = oAuthProvider.credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
        rawNonce: rawNonce,
      );

      final UserCredential result = await _auth.signInWithCredential(
        credential,
      );

      // Apple only returns name on first sign in, so we might want to update it
      if (appleCredential.givenName != null) {
        final displayName = '${appleCredential.givenName} ${appleCredential.familyName}';
        await result.user!.updateDisplayName(displayName);
      }
      
      return UserModel.fromFirebaseUser(result.user!);
    } catch (e) {
      log('Apple Sign In Error: $e', name: 'AuthApi');
      throw _handleAuthError(e);
    }
  }

  /// Generate a random nonce string
  static String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in string format.
  static String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Sign out
  static Future<void> signOut() async {
    try {
      await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  /// Get current user
  static UserModel? getCurrentUser() {
    final user = _auth.currentUser;
    return user != null ? UserModel.fromFirebaseUser(user) : null;
  }

  /// Listen to auth state changes
  static Stream<UserModel?> get authStateChanges {
    return _auth.authStateChanges().map((user) {
      return user != null ? UserModel.fromFirebaseUser(user) : null;
    });
  }

  /// Reset password
  static Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  /// Update user profile
  static Future<void> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      await _auth.currentUser?.updateDisplayName(displayName);
      await _auth.currentUser?.updatePhotoURL(photoURL);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  /// Handle Firebase auth errors
  static String _handleAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          // Unified error for security to not reveal if email exists
          return 'Invalid email or password. Please try again.';
        case 'email-already-in-use':
          return 'An account already exists with this email address.';
        case 'weak-password':
          return 'The password provided is too weak. Please use a stronger password.';
        case 'invalid-email':
          return 'The email address provided is attempting to be invalid. Please check and try again.';
        case 'user-disabled':
          return 'This account has been disabled. Please contact support.';
        case 'too-many-requests':
          return 'Too many sign-in attempts. Please try again later for your security.';
        case 'operation-not-allowed':
          return 'This sign-in method is currently not enabled. Please contact support.';
        case 'network-request-failed':
          return 'Connection error. Please check your internet connection and try again.';
        default:
          return 'An unexpected authentication error occurred. Please try again.';
      }
    }
    return 'An unexpected error occurred. Please try again.';
  }
}
