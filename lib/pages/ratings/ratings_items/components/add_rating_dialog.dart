import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '/core/__core.dart';
import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';

import '../rating_items_controller.dart';

class AddRatingDialog extends StatefulWidget {
  final String groupId;
  final VoidCallback onRatingCreated;

  const AddRatingDialog({
    super.key,
    required this.groupId,
    required this.onRatingCreated,
  });

  @override
  State<AddRatingDialog> createState() => _AddRatingDialogState();
}

class _AddRatingDialogState extends State<AddRatingDialog> {
  final _formKey = GlobalKey<FormState>();
  final _itemNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  int _ratingScale = 5;
  File? _selectedImage;
  bool _isUploadingImage = false;

  final RatingItemController _ratingController =
      Get.find<RatingItemController>();

  @override
  void dispose() {
    _itemNameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();

    // Clear any selected image
    _selectedImage = null;

    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final image = await _ratingController.pickImage();
      if (image != null) {
        // Validate image file
        if (await _validateImage(image)) {
          setState(() {
            _selectedImage = image;
          });
          print('Image selected successfully: ${image.path}');
        } else {
          Get.snackbar(
            'Invalid Image',
            'Please select a valid image file (JPEG, PNG) under 10MB',
            backgroundColor: AppColors.orange,
            colorText: AppColors.white,
            snackPosition: SnackPosition.BOTTOM,
            borderRadius: AppBorderRadius.md,
            margin: const EdgeInsets.all(AppSpacing.md),
          );
        }
      } else {
        print('No image selected');
      }
    } catch (e) {
      print('Error in _pickImage: $e');
      Get.snackbar(
        'Error',
        'Failed to pick image: ${e.toString()}',
        backgroundColor: AppColors.red,
        colorText: AppColors.white,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: AppBorderRadius.md,
        margin: const EdgeInsets.all(AppSpacing.md),
      );
    }
  }

  Future<bool> _validateImage(File imageFile) async {
    try {
      // Check if file exists
      if (!await imageFile.exists()) {
        print('Image file does not exist');
        return false;
      }

      // Check file size (max 10MB)
      final fileSize = await imageFile.length();
      if (fileSize > 10 * 1024 * 1024) {
        print('Image file too large: $fileSize bytes');
        return false;
      }

      // Check file extension
      final extension = imageFile.path.split('.').last.toLowerCase();
      if (!['jpg', 'jpeg', 'png'].contains(extension)) {
        print('Invalid image format: $extension');
        return false;
      }

      return true;
    } catch (e) {
      print('Error validating image: $e');
      return false;
    }
  }

  Future<void> _submitRating() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isUploadingImage = true;
    });

    try {
      final success = await _ratingController.createRatingItem(
        groupId: widget.groupId,
        itemName: _itemNameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        location: _locationController.text.trim().isEmpty
            ? null
            : _locationController.text.trim(),
        ratingScale: _ratingScale,
        imageFile: _selectedImage,
      );

      if (success) {
        widget.onRatingCreated();
        Navigator.of(context).pop();
      } else {
        Get.snackbar(
          'Error',
          _ratingController.errorMessage.value,
          backgroundColor: AppColors.red,
          colorText: AppColors.white,
          snackPosition: SnackPosition.BOTTOM,
          borderRadius: AppBorderRadius.md,
          margin: const EdgeInsets.all(AppSpacing.md),
        );
      }
    } catch (e) {
      print('Error in _submitRating: $e');
      Get.snackbar(
        'Error',
        'Failed to create rating: ${e.toString()}',
        backgroundColor: AppColors.red,
        colorText: AppColors.white,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: AppBorderRadius.md,
        margin: const EdgeInsets.all(AppSpacing.md),
      );
    } finally {
      setState(() {
        _isUploadingImage = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(AppSpacing.sm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
      ),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    context.colors.primary.withValues(alpha: 0.3),
                    context.colors.primary.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppBorderRadius.lg),
                  topRight: Radius.circular(AppBorderRadius.lg),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: context.colors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.star,
                      size: 24,
                      color: context.colors.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add New Rating',
                          style: AppTypography.titleLarge.copyWith(
                            color: context.colors.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Share your experience with the group',
                          style: AppTypography.bodyMedium.copyWith(
                            color: context.colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Form Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Section
                      _buildImageSection(),

                      const SizedBox(height: AppSpacing.lg),

                      // Item Name Field
                      _buildFormField(
                        label: 'Item Name',
                        hint: 'What are you rating?',
                        controller: _itemNameController,
                        icon: Icons.label,
                        isRequired: true,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Item name is required';
                          }
                          if (value.trim().length < 2) {
                            return 'Item name must be at least 2 characters';
                          }
                          if (value.trim().length > 100) {
                            return 'Item name must be less than 100 characters';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      // Rating Scale Selection
                      Text(
                        'Rating Scale',
                        style: AppTypography.titleMedium.copyWith(
                          color: context.colors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          Expanded(child: _buildScaleButton(5, '10 Stars')),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(child: _buildScaleButton(100, '100 Points')),
                        ],
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      // Description Field
                      _buildFormField(
                        label: 'Description',
                        hint: 'Tell us more about your experience (optional)',
                        controller: _descriptionController,
                        icon: Icons.description,
                        isRequired: false,
                        maxLines: 3,
                        validator: (value) {
                          if (value != null &&
                              value.trim().isNotEmpty &&
                              value.trim().length > 500) {
                            return 'Description must be less than 500 characters';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      // Location Field
                      _buildFormField(
                        label: 'Location',
                        hint: 'Where is this item located? (optional)',
                        controller: _locationController,
                        icon: Icons.location_on,
                        isRequired: false,
                        validator: (value) {
                          if (value != null &&
                              value.trim().isNotEmpty &&
                              value.trim().length > 100) {
                            return 'Location must be less than 100 characters';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: AppSpacing.xl),
                      SizedBox(
                        width: double.infinity,
                        child: Obx(
                          () => CustomButton(
                            onPressed:
                                (_ratingController.isCreatingRating.value ||
                                    _isUploadingImage)
                                ? null
                                : _submitRating,
                            text: _isUploadingImage
                                ? 'Uploading...'
                                : 'Add Rating',
                            isLoading:
                                _ratingController.isCreatingRating.value ||
                                _isUploadingImage,
                            backgroundColor: context.colors.primary,
                            textColor: context.colors.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    required bool isRequired,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: AppTypography.titleMedium.copyWith(
                color: context.colors.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (isRequired) ...[
              const SizedBox(width: AppSpacing.xs),
              Text(
                '*',
                style: AppTypography.titleMedium.copyWith(
                  color: context.colors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.bodyMedium.copyWith(
              color: context.colors.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            prefixIcon: Icon(
              icon,
              color: context.colors.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              borderSide: BorderSide(
                color: context.colors.outline.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              borderSide: BorderSide(
                color: context.colors.outline.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              borderSide: BorderSide(color: context.colors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              borderSide: BorderSide(color: context.colors.error, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              borderSide: BorderSide(color: context.colors.error, width: 2),
            ),
            filled: true,
            fillColor: context.colors.surfaceContainerHighest.withValues(
              alpha: 0.3,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
          ),
          style: AppTypography.bodyLarge.copyWith(
            color: context.colors.onSurface,
          ),
          textInputAction: maxLines == 1
              ? TextInputAction.next
              : TextInputAction.done,
          onFieldSubmitted: maxLines == 1
              ? (_) => FocusScope.of(context).nextFocus()
              : null,
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildScaleButton(int scale, String label) {
    final isSelected = _ratingScale == scale;
    return GestureDetector(
      onTap: () {
        setState(() {
          _ratingScale = scale;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? context.colors.primary
              : context.colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          border: Border.all(
            color: isSelected ? context.colors.primary : context.colors.outline,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.bodyMedium.copyWith(
            color: isSelected
                ? context.colors.onPrimary
                : context.colors.onSurface,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(
          color: context.colors.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Item Photo',
            style: AppTypography.titleMedium.copyWith(
              color: context.colors.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Add a photo to make your rating more helpful (optional)',
            style: AppTypography.bodySmall.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          GestureDetector(
            onTap: _isUploadingImage ? null : _pickImage,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: _selectedImage != null
                    ? AppColors.transparent
                    : context.colors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                border: Border.all(
                  color: _selectedImage != null
                      ? context.colors.primary.withValues(alpha: 0.3)
                      : context.colors.outline.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: _selectedImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                      child: Stack(
                        children: [
                          Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                            width: 120,
                            height: 120,
                          ),
                          Positioned(
                            top: AppSpacing.sm,
                            right: AppSpacing.sm,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedImage = null;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(AppSpacing.xs),
                                decoration: BoxDecoration(
                                  color: context.colors.error,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.close,
                                  size: 16,
                                  color: context.colors.onPrimary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: context.colors.primary.withValues(
                              alpha: 0.1,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.add_a_photo_rounded,
                            size: 24,
                            color: context.colors.primary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        if (_isUploadingImage)
                          CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              context.colors.primary,
                            ),
                          )
                        else
                          Text(
                            'Add Photo',
                            style: AppTypography.bodyMedium.copyWith(
                              color: context.colors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
