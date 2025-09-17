import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';

import '../add_rating_controller.dart';

class FormSection extends GetView<AddRatingController> {
  const FormSection({super.key});

  @override
  Widget build(BuildContext context) {
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
        Obx(() {
          return CustomDropdown<int>(
            items: AddRatingController.availableRatingScales,
            value: controller.ratingScale.value,
            onChanged: (value) {
              if (value != null) {
                controller.setRatingScale(value);
              }
            },
            label: 'Rating Scale',
            hintText: 'Select rating scale',
            isRequired: true,
            itemBuilder: (context, scale, isSelected) {
              String label = '$scale Points';
              return Row(
                children: [
                  Icon(
                    Icons.circle_rounded,
                    size: 16,
                    color: isSelected ? AppColors.primary : AppColors.textLight,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    label,
                    style: AppTypography.bodyMedium.copyWith(
                      color: isSelected ? AppColors.primary : AppColors.text,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  ),
                ],
              );
            },
            displayBuilder: (scale) {
              if (scale == null) return const SizedBox.shrink();
              String label = '$scale Points';
              return Row(
                children: [
                  const Icon(
                    Icons.circle_rounded,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    label,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.text,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            },
          );
        }),

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
}
