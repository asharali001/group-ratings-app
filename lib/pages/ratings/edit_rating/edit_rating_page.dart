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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              _buildHeaderSection(context),

              const SizedBox(height: AppSpacing.lg),

              // Image Section
              _buildImageSection(context),

              const SizedBox(height: AppSpacing.lg),

              // Form Section
              _buildFormSection(context),

              const SizedBox(height: AppSpacing.lg),

              // Submit Button
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Edit Rating',
          style: AppTypography.titleLarge.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Update your rating for "${rating.name}"',
          style: AppTypography.bodyMedium.copyWith(color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildFormSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Item Name Field
        AppTextField(
          label: 'Item Name',
          controller: controller.itemNameController,
          prefixIcon: Icons.label_rounded,
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
        AppDropdown<int>(
          label: 'Rating Scale',
          value: controller.ratingScale.value,
          onChanged: (value) {
            if (value != null) {
              controller.setRatingScale(value);
            }
          },
          prefixIcon: Icons.star_outline_rounded,
          items: EditRatingController.availableRatingScales.map((scale) {
            return DropdownMenuItem<int>(
              value: scale,
              child: Text('$scale Points'),
            );
          }).toList(),
          validator: (value) => value == null ? 'Selection required' : null,
        ),

        const SizedBox(height: AppSpacing.md),

        // Description Field
        AppTextField(
          label: 'Description',
          hintText: 'Tell us more about your experience (optional)',
          controller: controller.descriptionController,
          prefixIcon: Icons.description_rounded,
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
        AppTextField(
          label: 'Location',
          hintText: 'Where is this item located? (optional)',
          controller: controller.locationController,
          prefixIcon: Icons.location_on_rounded,
          textInputAction: TextInputAction.next,
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

  Widget _buildImageSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Item Photo',
          style: AppTypography.titleMedium.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Update the photo for your rating (optional)',
          style: AppTypography.bodySmall.copyWith(color: colorScheme.onSurfaceVariant),
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
                    ? Colors.transparent
                    : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: AppBorderRadius.lgRadius,
                border: Border.all(
                  color:
                      controller.selectedImage.value != null ||
                          (rating.imageUrl != null &&
                              rating.imageUrl!.isNotEmpty &&
                              controller.keepExistingImage.value)
                      ? colorScheme.primary.withValues(alpha: 0.2)
                      : colorScheme.outline.withValues(alpha: 0.3),
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: controller.selectedImage.value != null
                  ? Stack(
                      children: [
                        ClipRRect(
                          borderRadius: AppBorderRadius.lgRadius,
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
                              borderRadius: AppBorderRadius.lgRadius,
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withValues(alpha: 0.3),
                                  Colors.transparent,
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.3),
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
                                color: Colors.black.withValues(alpha: 0.6),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(
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
                                color: Colors.white,
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
                                  color: Colors.black.withValues(alpha: 0.6),
                                  borderRadius: AppBorderRadius.mdRadius,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
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
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: AppSpacing.xs),
                                    Text(
                                      'Change Photo',
                                      style: AppTypography.bodySmall.copyWith(
                                        color: Colors.white,
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
                          borderRadius: AppBorderRadius.lgRadius,
                          child: Image.network(
                            rating.imageUrl!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: colorScheme.surfaceContainerHighest,
                                  borderRadius: AppBorderRadius.lgRadius,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.image_rounded,
                                    color: colorScheme.primary,
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
                              borderRadius: AppBorderRadius.lgRadius,
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withValues(alpha: 0.3),
                                  Colors.transparent,
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.3),
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
                                color: Colors.black.withValues(alpha: 0.6),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(
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
                                color: Colors.white,
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
                                  color: Colors.black.withValues(alpha: 0.6),
                                  borderRadius: AppBorderRadius.mdRadius,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
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
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: AppSpacing.xs),
                                    Text(
                                      'Change Photo',
                                      style: AppTypography.bodySmall.copyWith(
                                        color: Colors.white,
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
                            color: colorScheme.primaryContainer.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.add_photo_alternate_rounded,
                            size: 32,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        if (controller.isUpdatingImage.value)
                          Column(
                            children: [
                              CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                'Uploading...',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: colorScheme.primary,
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
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                'JPEG, PNG up to 10MB',
                                style: AppTypography.bodySmall.copyWith(
                                  color: colorScheme.onSurfaceVariant,
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
      () => AppButton(
        isFullWidth: true,
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
      ),
    );
  }
}
