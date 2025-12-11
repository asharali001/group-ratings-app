import 'dart:async';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '/core/__core.dart';

class RatingItemController extends GetxController {
  final RatingService _ratingService = RatingService();
  final AuthService _authService = Get.find<AuthService>();

  // Observable lists and variables
  final RxList<RatingItem> groupRatings = <RatingItem>[].obs;
  final RxList<RatingItem> filteredRatings = <RatingItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isCreatingRating = false.obs;
  final RxBool isUpdatingRating = false.obs;
  final RxBool isDeletingRating = false.obs;

  // Search and filter
  final RxString searchQuery = ''.obs;
  final RxString selectedFilter = 'All'.obs;

  // Messages
  final RxString errorMessage = ''.obs;
  final RxString successMessage = ''.obs;

  // Current group context
  final RxString currentGroupId = ''.obs;
  final Rx<Group?> currentGroup = Rx<Group?>(null);

  StreamSubscription<List<RatingItem>>? _ratingsSubscription;
  StreamSubscription<UserModel?>? _authStateSubscription;

  @override
  void onInit() {
    super.onInit();
    // Listen to auth state changes
    _authStateSubscription = _authService.authStateChanges.listen((user) {
      if (user == null) {
        clearUserData();
      }
    });

    // Listen to search and filter changes
    ever(searchQuery, (_) => _applyFilters());
    ever(selectedFilter, (_) => _applyFilters());
    ever(groupRatings, (_) => _applyFilters());
  }

  @override
  void onClose() {
    _authStateSubscription?.cancel();
    _ratingsSubscription?.cancel();
    super.onClose();
  }

  /// Set the current group context and load its ratings
  void setGroupContext(Group group) {
    currentGroup.value = group;
    currentGroupId.value = group.id;
    loadGroupRatingItems(group.id);
  }

  /// Load all ratings for a specific group
  void loadGroupRatingItems(String groupId) {
    // Cancel existing subscription
    _ratingsSubscription?.cancel();

    _ratingsSubscription = _ratingService.getGroupRatingItems(groupId).listen((
      ratings,
    ) {
      groupRatings.value = ratings;
    });
  }

  /// Clear all user-specific data
  void clearUserData() {
    _authStateSubscription?.cancel();
    _ratingsSubscription?.cancel();
    _authStateSubscription = null;
    _ratingsSubscription = null;
    groupRatings.clear();
    filteredRatings.clear();
    currentGroupId.value = '';
    currentGroup.value = null;
    searchQuery.value = '';
    selectedFilter.value = 'All';
    errorMessage.value = '';
    successMessage.value = '';
    isLoading.value = false;
    isCreatingRating.value = false;
    isUpdatingRating.value = false;
    isDeletingRating.value = false;
    _ratingsExpanded.clear();
  }

  /// Apply search and filter
  void _applyFilters() {
    var results = groupRatings.toList();

    // Apply search
    if (searchQuery.value.isNotEmpty) {
      results = results.where((item) {
        final query = searchQuery.value.toLowerCase();
        return item.name.toLowerCase().contains(query) ||
            (item.description?.toLowerCase().contains(query) ?? false) ||
            (item.location?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    // Apply filter
    switch (selectedFilter.value) {
      case 'My Ratings':
        final currentUserId = _authService.currentUserId;
        results = results
            .where((item) => item.ratedBy.contains(currentUserId))
            .toList();
        break;
      case 'Highest Rated':
        results.sort((a, b) {
          final avgA = _calculateAverage(a.ratings);
          final avgB = _calculateAverage(b.ratings);
          return avgB.compareTo(avgA);
        });
        break;
      case 'Newest':
        results.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      default: // 'All'
        break;
    }

    filteredRatings.value = results;
  }

  double _calculateAverage(List<UserRating> ratings) {
    if (ratings.isEmpty) return 0.0;
    final sum = ratings.fold<double>(0.0, (sum, r) => sum + r.ratingValue);
    return sum / ratings.length;
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void updateFilter(String filter) {
    selectedFilter.value = filter;
  }

  Future<String> getUserDisplayName(String uid) async {
    return await UserService.getUserDisplayName(uid);
  }

  Future<bool> createRatingItem({
    required String groupId,
    required String itemName,
    String? description,
    String? location,
    required int ratingScale,
    File? imageFile,
    double? initialRating,
    String? initialComment,
  }) async {
    try {
      isCreatingRating.value = true;
      errorMessage.value = '';

      final userId = _authService.currentUser?.uid;
      if (userId == null) {
        errorMessage.value = 'User not authenticated';
        return false;
      }
      final rating = await _ratingService.createRatingItem(
        groupId: groupId,
        itemName: itemName,
        description: description,
        location: location,
        ratingScale: ratingScale,
        imageFile: imageFile,
        createdBy: userId,
        initialRating: initialRating,
        initialComment: initialComment,
      );

      if (rating != null) {
        successMessage.value = 'Rating added successfully!';
        return true;
      } else {
        errorMessage.value = 'Failed to create rating';
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Failed to create rating: ${e.toString()}';
      return false;
    } finally {
      isCreatingRating.value = false;
    }
  }

  Future<bool> updateRatingItem({
    required String ratingId,
    String? itemName,
    String? description,
    String? location,
    int? ratingScale,
    File? imageFile,
    bool removeImage = false,
  }) async {
    try {
      isUpdatingRating.value = true;
      errorMessage.value = '';

      final success = await _ratingService.updateRatingItem(
        ratingId: ratingId,
        itemName: itemName,
        description: description,
        location: location,
        ratingScale: ratingScale,
        imageFile: imageFile,
        removeImage: removeImage,
      );

      if (success) {
        successMessage.value = 'Rating updated successfully!';
        return true;
      } else {
        errorMessage.value = 'Failed to update rating';
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Failed to update rating: ${e.toString()}';
      return false;
    } finally {
      isUpdatingRating.value = false;
    }
  }

  Future<bool> deleteRatingItem(String ratingId) async {
    try {
      isDeletingRating.value = true;
      errorMessage.value = '';

      final success = await _ratingService.deleteRatingItem(ratingId);

      if (success) {
        successMessage.value = 'Rating deleted successfully!';
        return true;
      } else {
        errorMessage.value = 'Failed to delete rating';
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Failed to delete rating: ${e.toString()}';
      return false;
    } finally {
      isDeletingRating.value = false;
    }
  }

  Future<File?> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();

      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        final file = File(image.path);
        return file;
      } else {
        return null;
      }
    } catch (e) {
      errorMessage.value = 'Failed to pick image: ${e.toString()}';
      return null;
    }
  }

  /// Check if user can edit/delete a rating
  bool canEditRating(RatingItem rating) {
    final userId = _authService.currentUser?.uid;
    return userId == rating.createdBy;
  }

  /// Check if user can create ratings in the current group
  bool canCreateRating() {
    final userId = _authService.currentUser?.uid;
    final group = currentGroup.value;
    return userId != null && group != null && group.memberIds.contains(userId);
  }

  /// Clear error message
  void clearError() {
    errorMessage.value = '';
  }

  /// Clear success message
  void clearSuccess() {
    successMessage.value = '';
  }

  /// Get rating by ID
  RatingItem? getRatingById(String ratingId) {
    try {
      return groupRatings.firstWhere((rating) => rating.id == ratingId);
    } catch (e) {
      return null;
    }
  }

  /// Get ratings created by current user
  List<RatingItem> getCurrentUserRatings() {
    final userId = _authService.currentUser?.uid;
    if (userId == null) return [];

    return groupRatings.where((rating) => rating.createdBy == userId).toList();
  }

  /// Get ratings created by other users
  List<RatingItem> getOtherUsersRatings() {
    final userId = _authService.currentUser?.uid;
    if (userId == null) return [];

    return groupRatings.where((rating) => rating.createdBy != userId).toList();
  }

  /// Add a user rating to a rating item
  Future<bool> addUserRating({
    required String ratingItemId,
    required double ratingValue,
    String? comment,
  }) async {
    try {
      final userId = _authService.currentUser?.uid;
      if (userId == null) {
        errorMessage.value = 'User not authenticated';
        return false;
      }

      // Get the rating item to access ratingScale
      final ratingItem = getRatingById(ratingItemId);
      if (ratingItem == null) {
        errorMessage.value = 'Rating item not found';
        return false;
      }

      // Get current user's display name
      final currentUser = _authService.currentUser;
      final userName =
          currentUser?.displayName ?? currentUser?.email ?? 'Anonymous';

      final success = await _ratingService.addUserRating(
        ratingItemId: ratingItemId,
        userId: userId,
        userName: userName,
        ratingValue: ratingValue,
        ratingScale: ratingItem.ratingScale,
        comment: comment,
      );

      if (success) {
        successMessage.value = 'Rating added successfully!';
        return true;
      } else {
        errorMessage.value = 'Failed to add rating';
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Failed to add rating: ${e.toString()}';
      return false;
    }
  }

  /// Update an existing user rating
  Future<bool> updateUserRating({
    required String ratingItemId,
    required double ratingValue,
    String? comment,
  }) async {
    try {
      final userId = _authService.currentUser?.uid;
      if (userId == null) {
        errorMessage.value = 'User not authenticated';
        return false;
      }

      // Get the rating item to access ratingScale
      final ratingItem = getRatingById(ratingItemId);
      if (ratingItem == null) {
        errorMessage.value = 'Rating item not found';
        return false;
      }

      final success = await _ratingService.updateUserRating(
        ratingItemId: ratingItemId,
        userId: userId,
        ratingValue: ratingValue,
        ratingScale: ratingItem.ratingScale,
        comment: comment,
      );

      if (success) {
        successMessage.value = 'Rating updated successfully!';
        return true;
      } else {
        errorMessage.value = 'Failed to update rating';
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Failed to update rating: ${e.toString()}';
      return false;
    }
  }

  /// Remove a user rating from a rating item
  Future<bool> removeUserRating({required String ratingItemId}) async {
    try {
      final userId = _authService.currentUser?.uid;
      if (userId == null) {
        errorMessage.value = 'User not authenticated';
        return false;
      }

      final success = await _ratingService.removeUserRating(
        ratingItemId: ratingItemId,
        userId: userId,
      );

      if (success) {
        successMessage.value = 'Rating removed successfully!';
        return true;
      } else {
        errorMessage.value = 'Failed to remove rating';
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Failed to remove rating: ${e.toString()}';
      return false;
    }
  }

  /// Get the current user's rating for a specific rating item
  UserRating? getCurrentUserRating(String ratingItemId) {
    final userId = _authService.currentUser?.uid;
    if (userId == null) return null;

    final ratingItem = getRatingById(ratingItemId);
    if (ratingItem == null) return null;

    try {
      return ratingItem.ratings.firstWhere((rating) => rating.userId == userId);
    } catch (e) {
      return null;
    }
  }

  /// Check if the current user has rated a specific rating item
  bool hasUserRated(String ratingItemId) {
    return getCurrentUserRating(ratingItemId) != null;
  }

  // Rating expansion state management
  final Map<String, bool> _ratingsExpanded = {};

  /// Check if ratings are expanded for a specific rating item
  bool isRatingsExpanded(String ratingItemId) {
    return _ratingsExpanded[ratingItemId] ?? false;
  }

  /// Toggle ratings expansion for a specific rating item
  void toggleRatingsExpansion(String ratingItemId) {
    _ratingsExpanded[ratingItemId] = !isRatingsExpanded(ratingItemId);
    update();
  }

  /// Get visible ratings for a specific rating item (with pagination)
  List<UserRating> getVisibleRatings(String ratingItemId) {
    final ratingItem = getRatingById(ratingItemId);
    if (ratingItem == null) return [];

    final isExpanded = isRatingsExpanded(ratingItemId);

    if (isExpanded) {
      // Show all ratings when expanded
      return ratingItem.ratings;
    } else {
      // Show only first 2 ratings when collapsed
      return ratingItem.ratings.take(2).toList();
    }
  }
}
