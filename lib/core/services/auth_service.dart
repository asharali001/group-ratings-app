import 'dart:developer';
import 'package:get/get.dart';

import '/core/__core.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find<AuthService>();

  final Rx<UserModel?> _currentUser = Rx<UserModel?>(null);
  final RxBool _isLoading = false.obs;
  final RxBool _isAuthenticated = false.obs;
  Stream<UserModel?>? _authStateChanges;

  UserModel? get currentUser => _currentUser.value;
  String? get currentUserId => _currentUser.value?.uid;
  bool get isLoading => _isLoading.value;
  bool get isAuthenticated => _isAuthenticated.value;
  Stream<UserModel?> get authStateChanges =>
      _authStateChanges ?? Stream.value(null);

  @override
  void onInit() {
    super.onInit();
    _initializeAuth();
  }

  void _initializeAuth() {
    // Set up the auth state changes stream
    _authStateChanges = AuthApi.authStateChanges;

    // Listen to auth state changes
    ever(_currentUser, (user) {
      _isAuthenticated.value = user != null;
    });

    // Get initial user
    _currentUser.value = AuthApi.getCurrentUser();
    _isAuthenticated.value = _currentUser.value != null;

    // Create user document for initial user if they exist
    if (_currentUser.value != null) {
      _createUserDocumentIfNeeded(_currentUser.value!);
    }

    // Listen to Firebase auth state changes
    _authStateChanges?.listen((user) async {
      _currentUser.value = user;

      // Create user document in Firestore if user exists but document doesn't
      if (user != null) {
        await _createUserDocumentIfNeeded(user);
      }
    });
  }

  /// Helper method to create user document if it doesn't exist
  Future<void> _createUserDocumentIfNeeded(UserModel user) async {
    try {
      final exists = await UserService.userDocumentExists(user.uid);
      if (!exists) {
        await UserService.createUserDocument(user);
      }
    } catch (e) {
      // Log error but don't throw
      log('Error creating user document: $e', name: 'AuthService');
    }
  }

  /// Sign in with email and password
  Future<UserModel?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading.value = true;
      final user = await AuthApi.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user document in Firestore if it doesn't exist
      await _createUserDocumentIfNeeded(user);

      _currentUser.value = user;
      return user;
    } catch (e) {
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  /// Sign up with email and password
  Future<UserModel?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      _isLoading.value = true;
      final user = await AuthApi.createUserWithEmailAndPassword(
        email: email,
        password: password,
        displayName: displayName,
      );

      // Create user document in Firestore
      await _createUserDocumentIfNeeded(user);

      _currentUser.value = user;
      return user;
    } catch (e) {
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  /// Sign in with Google
  Future<UserModel?> signInWithGoogle() async {
    try {
      _isLoading.value = true;
      final user = await AuthApi.signInWithGoogle();

      // Create user document in Firestore if it doesn't exist
      await _createUserDocumentIfNeeded(user);

      _currentUser.value = user;
      return user;
    } catch (e) {
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  /// Sign in with Apple
  Future<UserModel?> signInWithApple() async {
    try {
      _isLoading.value = true;
      final user = await AuthApi.signInWithApple();

      // Create user document in Firestore if it doesn't exist
      await _createUserDocumentIfNeeded(user);

      _currentUser.value = user;
      return user;
    } catch (e) {
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      _isLoading.value = true;
      await AuthApi.signOut();
      _currentUser.value = null;
      Get.offAllNamed(RouteNames.auth.signInPage);
      _isAuthenticated.value = false;
    } catch (e) {
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    try {
      _isLoading.value = true;
      await AuthApi.resetPassword(email);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  /// Update user profile
  Future<void> updateProfile({String? displayName, String? photoURL}) async {
    try {
      _isLoading.value = true;
      await AuthApi.updateProfile(displayName: displayName, photoURL: photoURL);

      // Update local user data
      if (_currentUser.value != null) {
        _currentUser.value = _currentUser.value!.copyWith(
          displayName: displayName,
          photoURL: photoURL,
        );

        // Update user document in Firestore
        final updates = <String, dynamic>{};
        if (displayName != null) updates['displayName'] = displayName;
        if (photoURL != null) updates['photoURL'] = photoURL;

        if (updates.isNotEmpty) {
          await UserService.updateUserDocument(
            _currentUser.value!.uid,
            updates,
          );
        }
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  /// Check if user is authenticated
  bool get isUserAuthenticated => _currentUser.value != null;

  /// Get user display name
  String get userDisplayName => _currentUser.value?.displayName ?? 'User';

  /// Get user email
  String get userEmail => _currentUser.value?.email ?? '';

  /// Get user photo URL
  String? get userPhotoURL => _currentUser.value?.photoURL;
}
