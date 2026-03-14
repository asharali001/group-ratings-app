import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';

import 'add_rating_controller.dart';
import 'components/__components.dart';

class AddRatingPage extends GetView<AddRatingController> {
  final String groupId;
  final String groupName;

  const AddRatingPage({
    super.key,
    required this.groupId,
    required this.groupName,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Centered hero header
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryTint,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.star_rounded,
                        color: colorScheme.primary,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Add Rating',
                      style: AppTypography.headlineMedium.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Add an item to $groupName',
                      style: AppTypography.bodyMedium.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              // Overline: ITEM DETAILS
              Text(
                'ITEM DETAILS',
                style: AppTypography.labelSmall.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const ImageSection(),
              const SizedBox(height: AppSpacing.md),
              const FormSection(),
              const SizedBox(height: AppSpacing.lg),
              Obx(
                () => AppButton(
                  isFullWidth: true,
                  onPressed: controller.isUpdatingImage.value
                      ? null
                      : () async {
                          final success = await controller.submitRating(
                            groupId,
                          );
                          if (success) {
                            Get.back();
                          }
                        },
                  text: controller.isUpdatingImage.value
                      ? 'Uploading...'
                      : 'Add Rating',
                  isLoading: controller.isUpdatingImage.value,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
