import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';

import '../add_rating_controller.dart';

class FormSection extends GetView<AddRatingController> {
  const FormSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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

        // Rating Scale as chips
        Text(
          'Rating Scale',
          style: AppTypography.bodyMedium.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Obx(() {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  AddRatingController.availableRatingScales.map((scale) {
                final isSelected = controller.ratingScale.value == scale;
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: ChoiceChip(
                    label: Text('$scale'),
                    selected: isSelected,
                    onSelected: (_) => controller.setRatingScale(scale),
                    selectedColor: colorScheme.primary,
                    labelStyle: AppTypography.labelMedium.copyWith(
                      color: isSelected
                          ? colorScheme.onPrimary
                          : colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppBorderRadius.smRadius,
                      side: BorderSide(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.outlineVariant,
                      ),
                    ),
                    showCheckmark: false,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                  ),
                );
              }).toList(),
            ),
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

        // Your Rating Section
        const SectionHeader(
          title: 'Your Rating',
          subtitle: 'Rate this item now or later',
        ),
        const SizedBox(height: AppSpacing.md),

        // Rating display with color coding
        Obx(() {
          final rating = controller.initialRating.value;
          final scale = controller.ratingScale.value;
          final normalized = scale > 0 ? rating / scale : 0.0;
          final ratingColor = _getRatingColor(normalized, colorScheme);

          return Column(
            children: [
              // Centered rating indicator
              Center(
                child: TweenAnimationBuilder<Color?>(
                  tween: ColorTween(
                    begin: colorScheme.outlineVariant,
                    end: ratingColor,
                  ),
                  duration: const Duration(milliseconds: 300),
                  builder: (context, color, child) {
                    return Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: color ?? colorScheme.outlineVariant,
                          width: 3,
                        ),
                      ),
                      child: Center(
                        child: rating > 0
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    rating.toStringAsFixed(rating == rating.roundToDouble() ? 0 : 1),
                                    style:
                                        AppTypography.headlineSmall.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: color,
                                    ),
                                  ),
                                  Text(
                                    '/ $scale',
                                    style: AppTypography.bodySmall.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                'N/A',
                                style: AppTypography.titleMedium.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppSlider(
                value: rating,
                min: 0,
                max: scale.toDouble(),
                divisions: scale,
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

  Color _getRatingColor(double normalized, ColorScheme colorScheme) {
    if (normalized <= 0) return colorScheme.outlineVariant;
    if (normalized < 0.33) return AppColors.error;
    if (normalized < 0.66) return AppColors.warning;
    return AppColors.success;
  }
}
