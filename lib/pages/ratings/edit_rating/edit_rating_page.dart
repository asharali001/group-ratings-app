import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/__core.dart';
import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';

import 'edit_rating_controller.dart';

class EditRatingPage extends GetView<EditRatingController> {
  final RatingItem rating;

  const EditRatingPage({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    // Initialize form when page is built
    controller.initializeForm(rating);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Rating'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.text,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              _buildHeaderSection(),

              const SizedBox(height: AppSpacing.lg),

              // Image Section
              _buildImageSection(),

              const SizedBox(height: AppSpacing.lg),

              // Form Section
              _buildFormSection(),

              const SizedBox(height: AppSpacing.lg),

              // Submit Button
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Edit Rating',
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.text,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Update your rating for "${rating.name}"',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.textLight),
        ),
      ],
    );
  }

  Widget _buildFormSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Item Name Field
        CustomFormField(
          label: 'Item Name',
          hint: 'What are you rating?',
          controller: controller.itemNameController,
          icon: Icons.label_rounded,
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

        const SizedBox(height: AppSpacing.md),

        // Rating Scale Selection
        CustomDropdown<int>(
          items: EditRatingController.availableRatingScales,
          value: controller.ratingScale.value,
          onChanged: (value) {
            if (value != null) {
              controller.setRatingScale(value);
            }
          },
          label: 'Rating Scale',
          hintText: 'Select rating scale',
          isRequired: true,
          itemBuilder: (context, item, isSelected) => Row(
            children: [
              Icon(
                Icons.circle_rounded,
                color: isSelected ? AppColors.primary : AppColors.textLight,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                '$item Points',
                style: AppTypography.bodyMedium.copyWith(
                  color: isSelected ? AppColors.primary : AppColors.text,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
          displayBuilder: (value) => Row(
            children: [
              const Icon(
                Icons.circle_rounded,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                '$value Points',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.text,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          emptyIcon: Icons.star_rounded,
        ),

        const SizedBox(height: AppSpacing.md),

        // Description Field
        CustomFormField(
          label: 'Description',
          hint: 'Tell us more about your experience (optional)',
          controller: controller.descriptionController,
          icon: Icons.description_rounded,
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

        const SizedBox(height: AppSpacing.md),

        // Location Field
        CustomFormField(
          label: 'Location',
          hint: 'Where is this item located? (optional)',
          controller: controller.locationController,
          icon: Icons.location_on_rounded,
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
      ],
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Item Photo',
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.text,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Update the photo for your rating (optional)',
          style: AppTypography.bodySmall.copyWith(color: AppColors.textLight),
        ),
        const SizedBox(height: AppSpacing.md),

        // Modern image picker
        Obx(
          () => GestureDetector(
            onTap: controller.isUpdatingImage.value
                ? null
                : controller.pickImage,
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color:
                    controller.selectedImage.value != null ||
                        (rating.imageUrl != null &&
                            rating.imageUrl!.isNotEmpty &&
                            controller.keepExistingImage.value)
                    ? AppColors.transparent
                    : AppColors.surfaceVariant.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                border: Border.all(
                  color:
                      controller.selectedImage.value != null ||
                          (rating.imageUrl != null &&
                              rating.imageUrl!.isNotEmpty &&
                              controller.keepExistingImage.value)
                      ? AppColors.primary.withValues(alpha: 0.2)
                      : AppColors.outline.withValues(alpha: 0.3),
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: controller.selectedImage.value != null
                  ? Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            AppBorderRadius.lg,
                          ),
                          child: Image.file(
                            controller.selectedImage.value!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                        // Modern overlay with actions
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                AppBorderRadius.lg,
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColors.black.withValues(alpha: 0.3),
                                  AppColors.transparent,
                                  AppColors.transparent,
                                  AppColors.black.withValues(alpha: 0.3),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Remove button - top right
                        Positioned(
                          top: AppSpacing.sm,
                          right: AppSpacing.sm,
                          child: GestureDetector(
                            onTap: controller.removeImage,
                            child: Container(
                              padding: const EdgeInsets.all(AppSpacing.sm),
                              decoration: BoxDecoration(
                                color: AppColors.black.withValues(alpha: 0.6),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.black.withValues(
                                      alpha: 0.2,
                                    ),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                size: 18,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                        // Change photo button - bottom center
                        Positioned(
                          bottom: AppSpacing.sm,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: GestureDetector(
                              onTap: controller.isUpdatingImage.value
                                  ? null
                                  : controller.pickImage,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                  vertical: AppSpacing.sm,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.black.withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(
                                    AppBorderRadius.md,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.black.withValues(
                                        alpha: 0.2,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.edit_rounded,
                                      size: 16,
                                      color: AppColors.white,
                                    ),
                                    const SizedBox(width: AppSpacing.xs),
                                    Text(
                                      'Change Photo',
                                      style: AppTypography.bodySmall.copyWith(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : (rating.imageUrl != null &&
                        rating.imageUrl!.isNotEmpty &&
                        controller.keepExistingImage.value)
                  ? Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            AppBorderRadius.lg,
                          ),
                          child: Image.network(
                            rating.imageUrl!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceVariant,
                                  borderRadius: BorderRadius.circular(
                                    AppBorderRadius.lg,
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.image_rounded,
                                    color: AppColors.primary,
                                    size: 48,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        // Modern overlay with actions
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                AppBorderRadius.lg,
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColors.black.withValues(alpha: 0.3),
                                  AppColors.transparent,
                                  AppColors.transparent,
                                  AppColors.black.withValues(alpha: 0.3),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Remove button - top right
                        Positioned(
                          top: AppSpacing.sm,
                          right: AppSpacing.sm,
                          child: GestureDetector(
                            onTap: controller.removeImage,
                            child: Container(
                              padding: const EdgeInsets.all(AppSpacing.sm),
                              decoration: BoxDecoration(
                                color: AppColors.black.withValues(alpha: 0.6),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.black.withValues(
                                      alpha: 0.2,
                                    ),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.delete_rounded,
                                size: 18,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                        // Change photo button - bottom center
                        Positioned(
                          bottom: AppSpacing.sm,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: GestureDetector(
                              onTap: controller.isUpdatingImage.value
                                  ? null
                                  : controller.pickImage,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                  vertical: AppSpacing.sm,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.black.withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(
                                    AppBorderRadius.md,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.black.withValues(
                                        alpha: 0.2,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.edit_rounded,
                                      size: 16,
                                      color: AppColors.white,
                                    ),
                                    const SizedBox(width: AppSpacing.xs),
                                    Text(
                                      'Change Photo',
                                      style: AppTypography.bodySmall.copyWith(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add_photo_alternate_rounded,
                            size: 32,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        if (controller.isUpdatingImage.value)
                          Column(
                            children: [
                              const CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                'Uploading...',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                        else
                          Column(
                            children: [
                              Text(
                                'Tap to add photo',
                                style: AppTypography.titleMedium.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                'JPEG, PNG up to 10MB',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.textLight,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Obx(
      () => CustomButton(
        width: double.infinity,
        onPressed: controller.isUpdatingImage.value
            ? null
            : () async {
                final success = await controller.updateRating(rating);
                if (success) {
                  Get.back();
                }
              },
        text: controller.isUpdatingImage.value
            ? 'Uploading...'
            : 'Update Rating',
        isLoading: controller.isUpdatingImage.value,
        backgroundColor: AppColors.primary,
        textColor: AppColors.white,
      ),
    );
  }
}
