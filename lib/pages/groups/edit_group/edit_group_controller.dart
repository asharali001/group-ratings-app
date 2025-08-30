import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '/core/__core.dart';
import '/styles/__styles.dart';

class EditGroupController extends GetxController {
  final RxBool isUpdatingGroup = false.obs;
  final RxBool isUploadingImage = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString successMessage = ''.obs;

  File? _selectedImage;

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
      isUploadingImage.value = false;
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
        _selectedImage = File(image.path);
        return _selectedImage;
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
    return await Get.bottomSheet<ImageSource>(
      Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppBorderRadius.xl),
            topRight: Radius.circular(AppBorderRadius.xl),
          ),
          boxShadow: AppShadows.level4Shadow,
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: AppSpacing.sm),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.outline,
                  borderRadius: BorderRadius.circular(AppBorderRadius.xs),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  'Choose Image Source',
                  style: AppTypography.headlineSmall.copyWith(
                    color: AppColors.text,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // Options
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  children: [
                    // Gallery option
                    _buildImageSourceOption(
                      icon: Icons.photo_library_rounded,
                      title: 'Photo Gallery',
                      subtitle: 'Select from your device gallery',
                      color: AppColors.purple,
                      onTap: () => Get.back(result: ImageSource.gallery),
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // Camera option
                    _buildImageSourceOption(
                      icon: Icons.camera_alt_rounded,
                      title: 'Camera',
                      subtitle: 'Take a new photo',
                      color: AppColors.blue,
                      onTap: () => Get.back(result: ImageSource.camera),
                    ),
                  ],
                ),
              ),

              // Cancel button
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Get.back(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.md,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.textLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  /// Build individual image source option
  Widget _buildImageSourceOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(AppBorderRadius.lg),
            border: Border.all(color: AppColors.outline, width: 1),
          ),
          child: Row(
            children: [
              // Icon container
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                ),
                child: Icon(icon, color: color, size: 28),
              ),

              const SizedBox(width: AppSpacing.lg),

              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.titleLarge.copyWith(
                        color: AppColors.text,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      subtitle,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow icon
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.textLight,
                size: 20,
              ),
            ],
          ),
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
}
