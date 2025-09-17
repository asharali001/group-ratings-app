import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/styles/__styles.dart';

import '../add_rating_controller.dart';

class ImageSection extends GetView<AddRatingController> {
  const ImageSection({super.key});

  @override
  Widget build(BuildContext context) {
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
          'Add a photo to make your rating more helpful (optional)',
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
                color: controller.selectedImage.value != null
                    ? AppColors.transparent
                    : AppColors.surfaceVariant.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                border: Border.all(
                  color: controller.selectedImage.value != null
                      ? AppColors.primary.withValues(alpha: 0.2)
                      : AppColors.outline.withValues(alpha: 0.3),
                  width: 2,
                  style: controller.selectedImage.value != null
                      ? BorderStyle.solid
                      : BorderStyle.solid,
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
                            onTap: () {
                              controller.removeImage();
                            },
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
}
