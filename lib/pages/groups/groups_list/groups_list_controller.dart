import 'dart:async';
import 'package:get/get.dart';

import '/core/__core.dart';
import '/constants/enums.dart';

class GroupsListController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final RxList<Group> userGroups = <Group>[].obs;
  final RxList<Group> filteredGroups = <Group>[].obs;
  final RxBool isLoading = false.obs;

  // Search and filter
  final RxString searchQuery = ''.obs;
  final RxString selectedFilter = 'All'.obs;

  StreamSubscription<List<Group>>? _groupsSubscription;
  StreamSubscription<UserModel?>? _authStateSubscription;

  @override
  void onInit() {
    super.onInit();
    // Listen to auth state changes to reload data when user logs in
    _authStateSubscription = _authService.authStateChanges.listen((user) {
      if (user != null) {
        loadUserGroups();
      } else {
        clearUserData();
      }
    });

    // Listen to search and filter changes
    ever(searchQuery, (_) => _applyFilters());
    ever(selectedFilter, (_) => _applyFilters());
    ever(userGroups, (_) => _applyFilters());

    // Load initial data if user is already authenticated
    if (_authService.currentUserId != null) {
      loadUserGroups();
    }
  }

  @override
  void onClose() {
    _authStateSubscription?.cancel();
    _groupsSubscription?.cancel();
    super.onClose();
  }

  void loadUserGroups() {
    // Cancel existing subscription
    _groupsSubscription?.cancel();

    final userId = _authService.currentUser?.uid;
    if (userId != null) {
      _groupsSubscription = GroupService.getUserGroups(userId).listen((groups) {
        userGroups.value = groups;
      });
    } else {
      userGroups.clear();
      filteredGroups.clear();
    }
  }

  /// Clear all user-specific data
  void clearUserData() {
    _groupsSubscription?.cancel();
    _groupsSubscription = null;
    userGroups.clear();
    filteredGroups.clear();
    searchQuery.value = '';
    selectedFilter.value = 'All';
    isLoading.value = false;
  }

  /// Apply search and filter
  void _applyFilters() {
    var results = userGroups.toList();
    final userId = _authService.currentUser?.uid;

    // Apply search
    if (searchQuery.value.isNotEmpty) {
      results = results.where((group) {
        final query = searchQuery.value.toLowerCase();
        return group.name.toLowerCase().contains(query) ||
            (group.description?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    // Apply filter
    switch (selectedFilter.value) {
      case 'My Groups':
        // Show all groups (same as All for now)
        break;
      case 'Admin':
        results = results.where((group) {
          return group.members
                  .firstWhereOrNull((m) => m.userId == userId)
                  ?.role ==
              GroupMemberRole.admin;
        }).toList();
        break;
      case 'Member':
        results = results.where((group) {
          return group.members
                  .firstWhereOrNull((m) => m.userId == userId)
                  ?.role ==
              GroupMemberRole.member;
        }).toList();
        break;
      default: // 'All'
        break;
    }

    filteredGroups.value = results;
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void updateFilter(String filter) {
    selectedFilter.value = filter;
  }

  Future<bool> leaveGroup(String groupId) async {
    try {
      isLoading.value = true;

      final userId = _authService.currentUser?.uid;
      if (userId == null) {
        return false;
      }

      await GroupService.leaveGroup(groupId: groupId, userId: userId);

      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  bool isGroupCreator(Group group) {
    final userId = _authService.currentUser?.uid;
    return group.members.firstWhereOrNull((e) => e.userId == userId)?.role ==
        GroupMemberRole.admin;
  }

  bool isGroupMember(Group group) {
    final userId = _authService.currentUser?.uid;
    return userId != null && group.members.any((e) => e.userId == userId);
  }

  void navigateToGroupRatings(Group group) {
    Get.toNamed(RouteNames.groups.ratingsPage, arguments: {'group': group});
  }
}
