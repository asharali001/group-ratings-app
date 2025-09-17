import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '/core/__core.dart';
import '/ui_components/__ui_components.dart';

import '../ratings_items/rating_items_controller.dart';

class EditRatingController extends GetxController {
  final RxBool isUpdatingImage = false.obs;

  final formKey = GlobalKey<FormState>();

  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  final RxInt ratingScale = 5.obs;
  final Rx<File?> selectedImage = Rx<File?>(null);
  final RxBool keepExistingImage = true.obs;

  final RatingItemController _ratingController =
      Get.find<RatingItemController>();

  static const List<int> availableRatingScales = [5, 10, 20, 50, 100];

  @override
  void onClose() {
    itemNameController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    super.onClose();
  }

  void initializeForm(RatingItem rating) {
    itemNameController.text = rating.name;
    descriptionController.text = rating.description ?? '';
    locationController.text = rating.location ?? '';
    ratingScale.value = rating.ratingScale;
    selectedImage.value = null;
    keepExistingImage.value = true;
  }

  Future<void> pickImage() async {
    try {
      final image = await _ratingController.pickImage();
      if (image != null && await _validateImage(image)) {
        selectedImage.value = image;
        keepExistingImage.value = false;
      }
    } catch (e) {
      showCustomSnackBar(
        message: 'Failed to pick image: ${e.toString()}',
        isError: true,
      );
    }
  }

  Future<bool> _validateImage(File imageFile) async {
    try {
      if (!await imageFile.exists()) {
        showCustomSnackBar(message: 'Image file does not exist', isError: true);
        return false;
      }

      // Check file size (max 10MB)
      final fileSize = await imageFile.length();
      if (fileSize > 10 * 1024 * 1024) {
        showCustomSnackBar(
          message: 'Image file too large: $fileSize bytes',
          isError: true,
        );
        return false;
      }

      final extension = imageFile.path.split('.').last.toLowerCase();
      if (!['jpg', 'jpeg', 'png'].contains(extension)) {
        showCustomSnackBar(
          message: 'Invalid image format: $extension',
          isError: true,
        );
        return false;
      }

      return true;
    } catch (e) {
      showCustomSnackBar(message: 'Error validating image: $e', isError: true);
      return false;
    }
  }

  void removeImage() {
    selectedImage.value = null;
    keepExistingImage.value = false;
  }

  void setRatingScale(int scale) {
    ratingScale.value = scale;
  }

  Future<bool> updateRating(RatingItem rating) async {
    if (!formKey.currentState!.validate()) return false;

    isUpdatingImage.value = true;

    try {
      final success = await _ratingController.updateRatingItem(
        ratingId: rating.id,
        itemName: itemNameController.text.trim(),
        description: descriptionController.text.trim().isEmpty
            ? null
            : descriptionController.text.trim(),
        location: locationController.text.trim().isEmpty
            ? null
            : locationController.text.trim(),
        ratingScale: ratingScale.value,
        imageFile: keepExistingImage.value ? null : selectedImage.value,
        removeImage: !keepExistingImage.value && selectedImage.value == null,
      );

      if (success) {
        showCustomSnackBar(
          message: 'Rating updated successfully!',
          isSuccess: true,
        );
        return true;
      } else {
        showCustomSnackBar(
          message: _ratingController.errorMessage.value,
          isError: true,
        );
        return false;
      }
    } catch (e) {
      showCustomSnackBar(
        message: 'Failed to update rating: ${e.toString()}',
        isError: true,
      );
      return false;
    } finally {
      isUpdatingImage.value = false;
    }
  }
}
