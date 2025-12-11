import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';

import '../add_rating_controller.dart';

class FormSection extends GetView<AddRatingController> {
  const FormSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
        Obx(() {
          return AppDropdown<int>(
            label: 'Rating Scale',
            value: controller.ratingScale.value,
            onChanged: (value) {
              if (value != null) {
                controller.setRatingScale(value);
              }
            },
            prefixIcon: Icons.star_outline_rounded,
            items: AddRatingController.availableRatingScales.map((scale) {
              return DropdownMenuItem<int>(
                value: scale,
                child: Text('$scale Points'),
              );
            }).toList(),
            validator: (value) => value == null ? 'Selection required' : null,
          );
        }),

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

        const SizedBox(height: AppSpacing.xl),

        // Instant Rating Section
        Text(
          'Your Rating (Optional)',
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Rate this item now to save time',
          style: AppTypography.bodySmall.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Rating Slider
        Obx(() {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Rating',
                    style: AppTypography.bodyMedium.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: AppBorderRadius.smRadius,
                    ),
                    child: Text(
                      controller.initialRating.value > 0
                          ? '${controller.initialRating.value.toStringAsFixed(1)}/${controller.ratingScale.value}'
                          : 'Not rated',
                      style: AppTypography.titleMedium.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              AppSlider(
                value: controller.initialRating.value,
                min: 0,
                max: controller.ratingScale.value.toDouble(),
                divisions: controller.ratingScale.value, // One tick per point
                onChanged: (value) {
                  controller.initialRating.value = value;
                },
              ),
            ],
          );
        }),

        const SizedBox(height: AppSpacing.md),

        // Comment Field
        AppTextField(
          label: 'Your Review (Optional)',
          hintText: 'Share your thoughts about this item...',
          controller: controller.commentController,
          prefixIcon: Icons.comment_rounded,
          maxLines: 3,
          validator: (value) {
            if (value != null &&
                value.trim().isNotEmpty &&
                value.trim().length > 500) {
              return 'Review must be less than 500 characters';
            }
            return null;
          },
        ),
      ],
    );
  }
}
