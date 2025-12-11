import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '/core/__core.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  // Form controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final displayNameController = TextEditingController();

  // Observable variables
  final RxBool _isSignUp = false.obs;
  final RxBool _isPasswordVisible = false.obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  // Getters
  bool get isSignUp => _isSignUp.value;
  bool get isPasswordVisible => _isPasswordVisible.value;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  bool get isAuthenticated => _authService.isAuthenticated;

  @override
  void onInit() {
    super.onInit();
    _authService.authStateChanges.listen((user) {
      if (user != null) {
        _clearForm();
        _clearError();
      }
    });
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    displayNameController.dispose();
    super.onClose();
  }

  /// Set sign up mode (used by signup page)
  void setSignUpMode() {
    _isSignUp.value = true;
    _clearForm();
    _clearError();
  }

  /// Set sign in mode (used by signin page)
  void setSignInMode() {
    _isSignUp.value = false;
    _clearForm();
    _clearError();
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    _isPasswordVisible.value = !_isPasswordVisible.value;
  }

  /// Clear form fields
  void _clearForm() {
    emailController.clear();
    passwordController.clear();
    displayNameController.clear();
  }

  /// Clear error message
  void _clearError() {
    _errorMessage.value = '';
  }

  /// Validate form inputs
  bool _validateForm() {
    if (emailController.text.trim().isEmpty) {
      _errorMessage.value = 'Please enter your email';
      return false;
    }

    if (!GetUtils.isEmail(emailController.text.trim())) {
      _errorMessage.value = 'Please enter a valid email';
      return false;
    }

    if (passwordController.text.isEmpty) {
      _errorMessage.value = 'Please enter your password';
      return false;
    }

    if (isSignUp && passwordController.text.length < 6) {
      _errorMessage.value = 'Password must be at least 6 characters';
      return false;
    }

    if (isSignUp && displayNameController.text.trim().isEmpty) {
      _errorMessage.value = 'Please enter your display name';
      return false;
    }

    return true;
  }

  /// Sign in with email and password
  Future<void> signInWithEmailAndPassword() async {
    if (!_validateForm()) return;

    try {
      _isLoading.value = true;
      _clearError();

      await _authService.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      Get.offAllNamed(RouteNames.mainApp.mainLayout);
    } catch (e) {
      debugPrint('Auth Error: $e');
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  /// Sign up with email and password
  Future<void> signUpWithEmailAndPassword() async {
    if (!_validateForm()) return;

    try {
      _isLoading.value = true;
      _clearError();

      await _authService.signUpWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
        displayName: displayNameController.text.trim(),
      );

      Get.offAllNamed(RouteNames.mainApp.mainLayout);
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  /// Sign in with Apple
  Future<void> signInWithApple() async {
    try {
      _isLoading.value = true;
      _clearError();

      await _authService.signInWithApple();
      Get.offAllNamed(RouteNames.mainApp.mainLayout);
    } catch (e) {
      // Don't show error if user cancelled
      if (e.toString().contains('canceled') ||
          e.toString().contains('cancelled')) {
        return;
      }
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  /// Sign in with Google
  Future<void> signInWithGoogle() async {
    try {
      _isLoading.value = true;
      _clearError();

      await _authService.signInWithGoogle();
      Get.offAllNamed(RouteNames.mainApp.mainLayout);
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  /// Reset password
  Future<void> resetPassword() async {
    if (emailController.text.trim().isEmpty) {
      _errorMessage.value = 'Please enter your email';
      return;
    }

    if (!GetUtils.isEmail(emailController.text.trim())) {
      _errorMessage.value = 'Please enter a valid email';
      return;
    }

    try {
      _isLoading.value = true;
      _clearError();

      await _authService.resetPassword(emailController.text.trim());
      Get.snackbar(
        'Success',
        'Password reset email sent. Please check your inbox.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _authService.signOut();
      Get.offAllNamed('/signin');
    } catch (e) {
      _errorMessage.value = e.toString();
    }
  }
}
