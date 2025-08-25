import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '/core/__core.dart';

class RatingItemController extends GetxController {
  final RatingService _ratingService = RatingService();
  final AuthService _authService = Get.find<AuthService>();

  // Observable lists and variables
  final RxList<RatingItem> groupRatings = <RatingItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isCreatingRating = false.obs;
  final RxBool isUpdatingRating = false.obs;
  final RxBool isDeletingRating = false.obs;

  // Messages
  final RxString errorMessage = ''.obs;
  final RxString successMessage = ''.obs;

  // Current group context
  final RxString currentGroupId = ''.obs;
  final Rx<Group?> currentGroup = Rx<Group?>(null);

  /// Set the current group context and load its ratings
  void setGroupContext(Group group) {
    currentGroup.value = group;
    currentGroupId.value = group.id;
    loadGroupRatingItems(group.id);
  }

  /// Load all ratings for a specific group
  void loadGroupRatingItems(String groupId) {
    _ratingService.getGroupRatingItems(groupId).listen((ratings) {
      groupRatings.value = ratings;
    });
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
  }) async {
    try {
      final userId = _authService.currentUser?.uid;
      if (userId == null) {
        errorMessage.value = 'User not authenticated';
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
  }) async {
    try {
      final userId = _authService.currentUser?.uid;
      if (userId == null) {
        errorMessage.value = 'User not authenticated';
        return false;
      }

      final success = await _ratingService.updateUserRating(
        ratingItemId: ratingItemId,
        userId: userId,
        ratingValue: ratingValue,
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
}
