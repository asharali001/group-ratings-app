import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '/core/models/user_model.dart';
import '/core/services/auth_service.dart';
import '/core/services/user_service.dart';
import '/core/services/group_service.dart';
import '/styles/colors.dart';

class ProfileController extends GetxController {
  final AuthService _authService = AuthService.to;
  final RxBool isLoading = false.obs;
  final RxInt groupsCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _bindGroupsCount();
  }

  void _bindGroupsCount() {
    if (currentUser?.uid != null) {
      groupsCount.bindStream(
        GroupService.getUserGroups(currentUser!.uid).map((groups) => groups.length),
      );
    }
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
      Get.snackbar('Success', 'Profile updated successfully',
          backgroundColor: AppColors.success.withValues(alpha: 0.1),
          colorText: AppColors.success);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile: $e',
          backgroundColor: AppColors.error.withValues(alpha: 0.1),
          colorText: AppColors.error);
    } finally {
      isLoading.value = false;
    }
  }

  // Use the exact same flow as SettingsPage but managed in controller
  Future<void> handleDeleteAccount(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppColors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      // Second confirmation for safety
      final doubleConfirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Final Confirmation'),
          content: const Text(
            'Please confirm once more. This will immediately delete your account and data.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.white,
                backgroundColor: AppColors.red,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('PERMANENTLY DELETE'),
            ),
          ],
        ),
      );

      if (doubleConfirmed == true) {
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
                  content: Text('For security, please sign out and sign in again to delete your account.'),
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: $e')),
            );
          }
        } finally {
          isLoading.value = false;
        }
      }
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }
}
