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
  final RxString selectedFilter = 'all'.obs; // all, highest, recent

  StreamSubscription<List<RatingItem>>? _ratingsSubscription;
  StreamSubscription<UserModel?>? _authStateSubscription;

  String? get currentUserId => _authService.currentUser?.uid;

  @override
  void onInit() {
    super.onInit();
    // Listen to auth state changes to reload data when user logs in
    _authStateSubscription = _authService.authStateChanges.listen((user) {
      if (user != null) {
        _loadUserRatings();
      } else {
        clearUserData();
      }
    });

    // Load initial data if user is already authenticated
    if (_authService.currentUserId != null) {
      _loadUserRatings();
    }
  }

  @override
  void onClose() {
    _authStateSubscription?.cancel();
    _ratingsSubscription?.cancel();
    super.onClose();
  }

  Future<void> _loadUserRatings() async {
    try {
      // Cancel existing subscription
      _ratingsSubscription?.cancel();

      isLoading.value = true;
      final userId = _authService.currentUser?.uid;
      if (userId == null) {
        isLoading.value = false;
        return;
      }

      _ratingsSubscription = _ratingService.getUserRatingItems(userId).listen((
        ratings,
      ) {
        allRatings.value = ratings;
        _applyFilters();
        isLoading.value = false;
      });
    } catch (e) {
      isLoading.value = false;
    }
  }

  /// Clear all user-specific data
  void clearUserData() {
    _authStateSubscription?.cancel();
    _ratingsSubscription?.cancel();
    _authStateSubscription = null;
    _ratingsSubscription = null;
    allRatings.clear();
    filteredRatings.clear();
    searchQuery.value = '';
    selectedFilter.value = 'all';
    isLoading.value = false;
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
    _applyFilters();
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void _applyFilters() {
    var results = allRatings.toList();

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
    switch (selectedFilter.value) {
      case 'highest':
        results.sort((a, b) {
          final aRating = _getUserRating(a);
          final bRating = _getUserRating(b);
          return (bRating ?? 0).compareTo(aRating ?? 0);
        });
        break;
      case 'recent':
        results.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      default:
        // Keep original order
        break;
    }

    filteredRatings.value = results;
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
    _applyFilters();
  }
}
