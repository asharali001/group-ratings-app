import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '/core/__core.dart';
import '/constants/__constants.dart';

class GroupController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final RxList<Group> userGroups = <Group>[].obs;
  final RxList<RatingItem> groupRatingItems = <RatingItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isCreatingGroup = false.obs;
  final RxBool isJoiningGroup = false.obs;
  final RxBool isUpdatingGroup = false.obs;
  final RxBool isUploadingImage = false.obs;

  final RxString errorMessage = ''.obs;
  final RxString successMessage = ''.obs;

  File? _selectedImage;

  @override
  void onInit() {
    super.onInit();
    loadUserGroups();
  }

  /// Load all groups where the user is a member
  void loadUserGroups() {
    final userId = _authService.currentUser?.uid;
    if (userId != null) {
      GroupService.getUserGroups(userId).listen((groups) {
        userGroups.value = groups;
      });
    }
  }

  void loadGroupRatingItems(String groupId) {
    final ratingService = Get.put(RatingService());
    ratingService.getGroupRatingItems(groupId).listen((ratings) {
      groupRatingItems.value = ratings;
    });
  }

  /// Create a new group
  Future<bool> createGroup({
    required String name,
    String? description,
    File? imageFile,
  }) async {
    try {
      isCreatingGroup.value = true;
      errorMessage.value = '';

      final userId = _authService.currentUser?.uid;
      if (userId == null) {
        errorMessage.value = 'User not authenticated';
        return false;
      }

      // Validate image if provided
      if (imageFile != null) {
        final validationError = validateImage(imageFile);
        if (validationError != null) {
          errorMessage.value = validationError;
          return false;
        }
      }

      // Show image upload progress if image is provided
      if (imageFile != null) {
        isUploadingImage.value = true;
      }

      final group = await GroupService.createGroup(
        name: name,
        description: description,
        imageFile: imageFile,
        user: _authService.currentUser!,
        onImageUploadProgress: (progress) {
          // You can use this progress value to show a progress bar
          // For now, we'll just show the loading state
        },
      );

      successMessage.value = 'Group "${group.name}" created successfully!';
      return true;
    } catch (e) {
      errorMessage.value = 'Failed to create group: ${e.toString()}';
      return false;
    } finally {
      isCreatingGroup.value = false;
      isUploadingImage.value = false;
    }
  }

  /// Join a group using a group code
  Future<bool> joinGroup(String groupCode) async {
    try {
      isJoiningGroup.value = true;
      errorMessage.value = '';

      final userId = _authService.currentUser?.uid;
      if (userId == null) {
        errorMessage.value = 'User not authenticated';
        return false;
      }

      final group = await GroupService.joinGroup(
        groupCode: groupCode,
        userId: userId,
      );

      if (group != null) {
        successMessage.value = 'Successfully joined "${group.name}"!';
        return true;
      } else {
        errorMessage.value = 'Group not found or invalid code';
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Failed to join group: ${e.toString()}';
      return false;
    } finally {
      isJoiningGroup.value = false;
    }
  }

  /// Update group details
  Future<bool> updateGroup({
    required String groupId,
    String? name,
    String? description,
    File? imageFile,
  }) async {
    try {
      isUpdatingGroup.value = true;
      errorMessage.value = '';

      await GroupService.updateGroup(
        groupId: groupId,
        name: name,
        description: description,
        imageFile: imageFile,
      );

      successMessage.value = 'Group updated successfully!';
      return true;
    } catch (e) {
      errorMessage.value = 'Failed to update group: ${e.toString()}';
      return false;
    } finally {
      isUpdatingGroup.value = false;
    }
  }

  /// Leave a group
  Future<bool> leaveGroup(String groupId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final userId = _authService.currentUser?.uid;
      if (userId == null) {
        errorMessage.value = 'User not authenticated';
        return false;
      }

      await GroupService.leaveGroup(groupId: groupId, userId: userId);

      successMessage.value = 'Left group successfully';
      return true;
    } catch (e) {
      errorMessage.value = 'Failed to leave group: ${e.toString()}';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Pick an image from gallery or camera
  Future<File?> pickImage({ImageSource source = ImageSource.gallery}) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      errorMessage.value = 'Failed to pick image: ${e.toString()}';
      return null;
    }
  }

  /// Validate image file
  String? validateImage(File? imageFile) {
    if (imageFile == null) return null;

    // Check file size (max 10MB)
    final fileSize = imageFile.lengthSync();
    if (fileSize > 10 * 1024 * 1024) {
      return 'Image size must be less than 10MB';
    }

    // Check file extension
    final extension = imageFile.path.split('.').last.toLowerCase();
    if (!['jpg', 'jpeg', 'png', 'gif'].contains(extension)) {
      return 'Please select a valid image file (JPG, PNG, or GIF)';
    }

    return null;
  }

  /// Clear selected image
  void clearSelectedImage() {
    _selectedImage = null;
    errorMessage.value = '';
  }

  /// Get selected image file
  File? get selectedImage => _selectedImage;

  /// Check if image is selected
  bool get hasSelectedImage => _selectedImage != null;

  /// Check and request camera permission
  Future<bool> _checkCameraPermission() async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      final result = await Permission.camera.request();
      return result.isGranted;
    }

    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }

    return false;
  }

  /// Check and request storage permission
  Future<bool> _checkStoragePermission() async {
    final status = await Permission.storage.status;
    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      final result = await Permission.storage.request();
      return result.isGranted;
    }

    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }

    return false;
  }

  /// Pick an image with source selection
  Future<File?> pickImageWithSource() async {
    try {
      final ImageSource? source = await _showImageSourceDialog();
      if (source != null) {
        // Check permissions based on source
        if (source == ImageSource.camera) {
          final hasPermission = await _checkCameraPermission();
          if (!hasPermission) {
            errorMessage.value = 'Camera permission is required to take photos';
            return null;
          }
        } else {
          final hasPermission = await _checkStoragePermission();
          if (!hasPermission) {
            errorMessage.value =
                'Storage permission is required to access photos';
            return null;
          }
        }

        return await pickImage(source: source);
      }
      return null;
    } catch (e) {
      errorMessage.value = 'Failed to pick image: ${e.toString()}';
      return null;
    }
  }

  /// Show image source selection dialog
  Future<ImageSource?> _showImageSourceDialog() async {
    return await Get.dialog<ImageSource>(
      AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () => Get.back(result: ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => Get.back(result: ImageSource.camera),
            ),
          ],
        ),
      ),
    );
  }

  /// Clear error message
  void clearError() {
    errorMessage.value = '';
  }

  /// Clear success message
  void clearSuccess() {
    successMessage.value = '';
  }

  /// Check if user is the creator of a group
  bool isGroupCreator(Group group) {
    final userId = _authService.currentUser?.uid;
    return group.members.firstWhereOrNull((e) => e.userId == userId)?.role ==
        GroupMemberRole.admin;
  }

  /// Check if user is a member of a group
  bool isGroupMember(Group group) {
    final userId = _authService.currentUser?.uid;
    return userId != null && group.members.any((e) => e.userId == userId);
  }

  void navigateToGroupRatings(Group group) {
    Get.toNamed(RouteNames.groups.ratingsPage, arguments: {'group': group});
  }
}
