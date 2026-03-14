import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '/core/models/user_model.dart';
import '/core/models/group.dart';
import '/core/services/auth_service.dart';
import '/core/services/user_service.dart';
import '/core/services/group_service.dart';
import '/core/services/rating_service.dart';
import '/core/services/theme_service.dart';
import '/styles/colors.dart';
import '/ui_components/__ui_components.dart';

class ProfileController extends GetxController {
  final AuthService _authService = AuthService.to;
  final RxBool isLoading = false.obs;
  final RxInt groupsCount = 0.obs;
  final RxInt ratingsCount = 0.obs;
  final RxInt peersCount = 0.obs;
  final RxBool isDarkMode = false.obs;
  final RxBool canMirror = false.obs;
  final RxList<UserModel> allUsers = <UserModel>[].obs;
  final Rx<UserModel?> mirroredUser = Rx<UserModel?>(null);
  final RxString mirrorSearchQuery = ''.obs;
  final RxInt mirrorPage = 1.obs;
  static const int mirrorPageSize = 10;

  List<UserModel> get filteredMirrorUsers {
    final q = mirrorSearchQuery.value.toLowerCase();
    if (q.isEmpty) return allUsers;
    return allUsers.where((u) {
      return (u.displayName?.toLowerCase().contains(q) ?? false) ||
          (u.email?.toLowerCase().contains(q) ?? false);
    }).toList();
  }

  List<UserModel> get paginatedMirrorUsers {
    final all = filteredMirrorUsers;
    final end = (mirrorPage.value * mirrorPageSize).clamp(0, all.length);
    return all.sublist(0, end);
  }

  bool get hasMoreMirrorUsers =>
      paginatedMirrorUsers.length < filteredMirrorUsers.length;

  void loadMoreMirrorUsers() => mirrorPage.value++;

  void updateMirrorSearch(String query) {
    mirrorSearchQuery.value = query;
    mirrorPage.value = 1; // reset to first page on new search
  }

  StreamSubscription<int>? _groupsCountSubscription;
  StreamSubscription<List<Group>>? _groupsSubscription;
  StreamSubscription? _ratingsSubscription;
  StreamSubscription<UserModel?>? _authStateSubscription;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = ThemeService.appearenceMode == ThemeMode.dark.name;

    // Listen to auth state changes to reload data when user logs in
    _authStateSubscription = _authService.authStateChanges.listen((user) {
      if (user != null) {
        _bindGroupsCount();
        _bindRatingsCount();
        _bindPeersCount();
      } else {
        clearUserData();
      }
    });

    // Reload when mirrored user changes
    ever(_authService.mirroredUserIdObs, (_) {
      _bindGroupsCount();
      _bindRatingsCount();
      _bindPeersCount();
      if (_authService.isMirroring) {
        _loadMirroredUser();
      } else {
        mirroredUser.value = null;
      }
    });

    // Load initial data if user is already authenticated
    if (currentUser?.uid != null) {
      _bindGroupsCount();
      _bindRatingsCount();
      _bindPeersCount();
      _checkMirrorAccess();
    }
  }

  @override
  void onClose() {
    _authStateSubscription?.cancel();
    _groupsCountSubscription?.cancel();
    _groupsSubscription?.cancel();
    _ratingsSubscription?.cancel();
    super.onClose();
  }

  void _bindGroupsCount() {
    _groupsCountSubscription?.cancel();

    final uid = _authService.effectiveUserId;
    if (uid != null) {
      _groupsCountSubscription = GroupService.getUserGroups(uid)
          .map((groups) => groups.length)
          .listen((n) {
            groupsCount.value = n;
          });
    } else {
      groupsCount.value = 0;
    }
  }

  void _bindRatingsCount() {
    _ratingsSubscription?.cancel();

    final uid = _authService.effectiveUserId;
    if (uid != null) {
      final ratingService = Get.put(RatingService());
      _ratingsSubscription = ratingService.getUserRatingItems(uid).listen((
        ratings,
      ) {
        ratingsCount.value = ratings.length;
      });
    }
  }

  void _bindPeersCount() {
    _groupsSubscription?.cancel();

    final uid = _authService.effectiveUserId;
    if (uid != null) {
      _groupsSubscription = GroupService.getUserGroups(uid).listen((groups) {
        final uniqueMembers = <String>{};
        for (final group in groups) {
          uniqueMembers.addAll(group.memberIds);
        }
        uniqueMembers.remove(uid); // exclude the user themselves
        peersCount.value = uniqueMembers.length;
      });
    }
  }

  Future<void> _checkMirrorAccess() async {
    try {
      final email = currentUser?.email;
      if (email == null) return;
      final doc = await FirebaseFirestore.instance
          .collection('app_config')
          .doc('mirror_access')
          .get();
      if (doc.exists) {
        final allowed = List<String>.from(doc.data()?['allowedEmails'] ?? []);
        canMirror.value = allowed.contains(email);
      }
    } catch (_) {}
  }

  Future<void> _loadMirroredUser() async {
    final uid = _authService.mirroredUserId;
    if (uid == null) return;
    mirroredUser.value = await UserService.getUserDocument(uid);
  }

  Future<void> loadUsersForMirror() async {
    if (allUsers.isNotEmpty) return; // already cached
    isLoading.value = true;
    final fetched = await UserService.getAllUsers();
    fetched.removeWhere((u) => u.uid == currentUser?.uid);
    allUsers.value = fetched;
    isLoading.value = false;
  }

  void startMirroring(UserModel user) {
    _authService.setMirrorUser(
      user.uid,
      user.displayName ?? 'User',
      photoURL: user.photoURL,
    );
    mirroredUser.value = user;
  }

  void stopMirroring() {
    _authService.clearMirrorUser();
    mirroredUser.value = null;
  }

  /// Clear all user-specific data
  void clearUserData() {
    _authStateSubscription?.cancel();
    _groupsCountSubscription?.cancel();
    _groupsSubscription?.cancel();
    _ratingsSubscription?.cancel();
    _authStateSubscription = null;
    _groupsCountSubscription = null;
    _groupsSubscription = null;
    _ratingsSubscription = null;
    groupsCount.value = 0;
    ratingsCount.value = 0;
    peersCount.value = 0;
    isLoading.value = false;
  }

  UserModel? get currentUser => _authService.currentUser;

  /// Returns mirrored user when mirroring, otherwise the real logged-in user.
  UserModel? get effectiveUser =>
      _authService.isMirroring ? mirroredUser.value : currentUser;

  bool get isMirroring => _authService.isMirroring;

  String get memberSince {
    final user = effectiveUser;
    if (user?.createdAt == null) return 'Unknown';
    return DateFormat('MMM yyyy').format(user!.createdAt!);
  }

  void toggleTheme(bool value) {
    final mode = value ? ThemeMode.dark : ThemeMode.light;
    ThemeService.switchTheme(mode);
    isDarkMode.value = value;
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
