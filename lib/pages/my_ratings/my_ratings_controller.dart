import 'dart:async';
import 'package:get/get.dart';

import '/core/__core.dart';

class MyRatingsController extends GetxController {
  final RatingService _ratingService = RatingService();
  final AuthService _authService = Get.find<AuthService>();

  final RxList<RatingItem> allRatings = <RatingItem>[].obs;
  final RxList<RatingItem> filteredRatings = <RatingItem>[].obs;
  final RxBool isLoading = true.obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedFilter = 'all'.obs; // all, rated, pending
  final RxString selectedSort = 'recent'.obs; // highest, lowest, recent, oldest

  StreamSubscription<List<Group>>? _groupsSubscription;
  final Map<String, StreamSubscription<List<RatingItem>>> _ratingSubscriptions =
      {};
  StreamSubscription<UserModel?>? _authStateSubscription;
  final Map<String, RatingItem> _allItemsMap = <String, RatingItem>{};

  String? get currentUserId => _authService.currentUser?.uid;

  @override
  void onInit() {
    super.onInit();
    // Listen to auth state changes to reload data when user logs in
    _authStateSubscription = _authService.authStateChanges.listen((user) {
      if (user != null) {
        _loadAllRatingItems();
      } else {
        clearUserData();
      }
    });

    // Load initial data if user is already authenticated
    if (_authService.currentUserId != null) {
      _loadAllRatingItems();
    }
  }

  @override
  void onClose() {
    _authStateSubscription?.cancel();
    _groupsSubscription?.cancel();
    _cancelAllRatingSubscriptions();
    super.onClose();
  }

  void _cancelAllRatingSubscriptions() {
    for (final subscription in _ratingSubscriptions.values) {
      subscription.cancel();
    }
    _ratingSubscriptions.clear();
  }

  Future<void> _loadAllRatingItems() async {
    try {
      // Cancel existing subscriptions
      _groupsSubscription?.cancel();
      _cancelAllRatingSubscriptions();

      isLoading.value = true;
      final userId = _authService.currentUser?.uid;
      if (userId == null) {
        isLoading.value = false;
        return;
      }

      // Subscribe to user groups
      _groupsSubscription = GroupService.getUserGroups(userId).listen((groups) {
        _handleGroupsUpdate(groups);
      });
    } catch (e) {
      isLoading.value = false;
    }
  }

  void _handleGroupsUpdate(List<Group> groups) async {
    // Cancel old subscriptions for groups that no longer exist
    final currentGroupIds = groups.map((g) => g.id).toSet();
    final subscriptionsToRemove = <String>[];
    for (final groupId in _ratingSubscriptions.keys) {
      if (!currentGroupIds.contains(groupId)) {
        _ratingSubscriptions[groupId]?.cancel();
        subscriptionsToRemove.add(groupId);
        // Remove items from this group
        _allItemsMap.removeWhere((id, item) => item.groupId == groupId);
      }
    }
    for (final groupId in subscriptionsToRemove) {
      _ratingSubscriptions.remove(groupId);
    }

    if (groups.isEmpty) {
      _allItemsMap.clear();
      allRatings.clear();
      _applyFilters();
      isLoading.value = false;
      return;
    }

    // Set up subscriptions for new groups and collect initial data
    int completedGroups = 0;
    final totalGroups = groups.length;

    for (final group in groups) {
      if (!_ratingSubscriptions.containsKey(group.id)) {
        _ratingSubscriptions[group.id] = _ratingService
            .getGroupRatingItems(group.id)
            .listen((items) {
          // Update items for this group
          for (final item in items) {
            _allItemsMap[item.id] = item;
          }
          
          // Remove items that no longer exist in this group
          final groupItemIds = items.map((i) => i.id).toSet();
          _allItemsMap.removeWhere((id, item) => 
            item.groupId == group.id && !groupItemIds.contains(id)
          );

          allRatings.value = _allItemsMap.values.toList();
          _applyFilters();
          isLoading.value = false;
        });
      }

      // Also fetch initial data
      try {
        final items = await _ratingService.getGroupRatingItems(group.id).first;
        for (final item in items) {
          _allItemsMap[item.id] = item;
        }
        completedGroups++;
        
        if (completedGroups == totalGroups) {
          allRatings.value = _allItemsMap.values.toList();
          _applyFilters();
          isLoading.value = false;
        }
      } catch (e) {
        completedGroups++;
        if (completedGroups == totalGroups) {
          allRatings.value = _allItemsMap.values.toList();
          _applyFilters();
          isLoading.value = false;
        }
      }
    }
  }

  /// Clear all user-specific data
  void clearUserData() {
    _authStateSubscription?.cancel();
    _groupsSubscription?.cancel();
    _cancelAllRatingSubscriptions();
    _authStateSubscription = null;
    _groupsSubscription = null;
    _allItemsMap.clear();
    allRatings.clear();
    filteredRatings.clear();
    searchQuery.value = '';
    selectedFilter.value = 'all';
    selectedSort.value = 'recent';
    isLoading.value = false;
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
    _applyFilters();
  }

  void setSort(String sort) {
    selectedSort.value = sort;
    _applyFilters();
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void _applyFilters() {
    var results = allRatings.toList();

    // Apply filter: all, rated, or pending
    switch (selectedFilter.value) {
      case 'rated':
        results = results.where((item) => _hasUserRated(item)).toList();
        break;
      case 'pending':
        results = results.where((item) => !_hasUserRated(item)).toList();
        break;
      case 'all':
      default:
        // Show all items
        break;
    }

    // Apply search
    if (searchQuery.value.isNotEmpty) {
      results = results.where((item) {
        return item.name.toLowerCase().contains(
              searchQuery.value.toLowerCase(),
            ) ||
            (item.description?.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ) ??
                false);
      }).toList();
    }

    // Apply sorting
    switch (selectedSort.value) {
      case 'highest':
        results.sort((a, b) {
          final aRating = _getUserRating(a);
          final bRating = _getUserRating(b);
          return (bRating ?? 0).compareTo(aRating ?? 0);
        });
        break;
      case 'lowest':
        results.sort((a, b) {
          final aRating = _getUserRating(a);
          final bRating = _getUserRating(b);
          return (aRating ?? 0).compareTo(bRating ?? 0);
        });
        break;
      case 'recent':
        results.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'oldest':
        results.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      default:
        // Keep original order
        break;
    }

    filteredRatings.value = results;
  }

  bool _hasUserRated(RatingItem item) {
    final userId = _authService.currentUser?.uid;
    if (userId == null) return false;
    return item.ratedBy.contains(userId);
  }

  double? _getUserRating(RatingItem item) {
    final userId = _authService.currentUser?.uid;
    if (userId == null) return null;

    final userRating = item.ratings.firstWhereOrNull((r) => r.userId == userId);
    return userRating?.ratingValue;
  }

  void clearFilters() {
    searchQuery.value = '';
    selectedFilter.value = 'all';
    selectedSort.value = 'recent';
    _applyFilters();
  }
}
