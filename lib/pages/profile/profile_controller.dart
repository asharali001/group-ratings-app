import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '/core/models/user_model.dart';
import '/core/services/auth_service.dart';
import '/core/services/user_service.dart';
import '/core/services/group_service.dart';
import '/styles/colors.dart';
import '/ui_components/__ui_components.dart';

class ProfileController extends GetxController {
  final AuthService _authService = AuthService.to;
  final RxBool isLoading = false.obs;
  final RxInt groupsCount = 0.obs;

  StreamSubscription<int>? _groupsCountSubscription;
  StreamSubscription<UserModel?>? _authStateSubscription;

  @override
  void onInit() {
    super.onInit();
    // Listen to auth state changes to reload data when user logs in
    _authStateSubscription = _authService.authStateChanges.listen((user) {
      if (user != null) {
        _bindGroupsCount();
      } else {
        clearUserData();
      }
    });

    // Load initial data if user is already authenticated
    if (currentUser?.uid != null) {
      _bindGroupsCount();
    }
  }

  @override
  void onClose() {
    _authStateSubscription?.cancel();
    _groupsCountSubscription?.cancel();
    super.onClose();
  }

  void _bindGroupsCount() {
    _groupsCountSubscription?.cancel();

    if (currentUser?.uid != null) {
      _groupsCountSubscription = GroupService.getUserGroups(currentUser!.uid)
          .map((groups) => groups.length)
          .listen((count) {
            groupsCount.value = count;
          });
    } else {
      groupsCount.value = 0;
    }
  }

  /// Clear all user-specific data
  void clearUserData() {
    _authStateSubscription?.cancel();
    _groupsCountSubscription?.cancel();
    _authStateSubscription = null;
    _groupsCountSubscription = null;
    groupsCount.value = 0;
    isLoading.value = false;
  }

  UserModel? get currentUser => _authService.currentUser;

  String get memberSince {
    if (currentUser?.createdAt == null) return 'Unknown';
    return DateFormat('MMM yyyy').format(currentUser!.createdAt!);
  }

  Future<void> updateDisplayName(String newName) async {
    if (newName.trim().isEmpty) return;

    try {
      isLoading.value = true;
      await _authService.updateProfile(displayName: newName.trim());
      Get.back(); // Close dialog
      Get.snackbar(
        'Success',
        'Profile updated successfully',
        backgroundColor: AppColors.success.withValues(alpha: 0.1),
        colorText: AppColors.success,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile: $e',
        backgroundColor: AppColors.error.withValues(alpha: 0.1),
        colorText: AppColors.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Use the exact same flow as SettingsPage but managed in controller
  void handleDeleteAccount(BuildContext context) {
    AppDialog.show(
      context,
      title: 'Delete Account',
      description:
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently lost.',
      primaryActionText: 'Delete',
      isDestructive: true,
      onPrimaryAction: () => _showFinalDeleteConfirmation(context),
      secondaryActionText: 'Cancel',
    );
  }

  void _showFinalDeleteConfirmation(BuildContext context) {
    AppDialog.show(
      context,
      title: 'Final Confirmation',
      description:
          'Please confirm once more. This will immediately delete your account and data.',
      primaryActionText: 'PERMANENTLY DELETE',
      isDestructive: true,
      onPrimaryAction: () => _performAccountDeletion(context),
      secondaryActionText: 'Cancel',
    );
  }

  Future<void> _performAccountDeletion(BuildContext context) async {
    isLoading.value = true;
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // 1. Delete Firestore data first
        await UserService.deleteUserDocument(user.uid);
        // 2. Delete Auth account
        await user.delete();
        // 3. Sign out locally
        await _authService.signOut();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account deleted successfully')),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'For security, please sign out and sign in again to delete your account.',
              ),
              duration: Duration(seconds: 4),
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting account: ${e.message}')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }
}
