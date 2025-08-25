import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/__core.dart';
import '/styles/__styles.dart';
import '/ui_components/buttons/custom_button.dart';

class AddUserRatingDialog extends StatefulWidget {
  final RatingItem ratingItem;
  final UserRating? existingRating;
  final Function(double) onRatingSubmitted;

  const AddUserRatingDialog({
    super.key,
    required this.ratingItem,
    this.existingRating,
    required this.onRatingSubmitted,
  });

  @override
  State<AddUserRatingDialog> createState() => _AddUserRatingDialogState();
}

class _AddUserRatingDialogState extends State<AddUserRatingDialog> {
  late double _ratingValue;
  final TextEditingController _commentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _ratingValue = widget.existingRating?.ratingValue ?? 1.0;
    if (widget.existingRating != null) {
      // You could add a comment field to UserRating model if needed
      // _commentController.text = widget.existingRating!.comment ?? '';
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingRating != null;
    final title = isEditing ? 'Edit Your Rating' : 'Rate This Item';

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  isEditing ? Icons.edit : Icons.star,
                  color: context.colors.primary,
                  size: 24,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    title,
                    style: AppTypography.titleLarge.copyWith(
                      color: context.colors.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            // Item Info
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: context.colors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
                border: Border.all(color: context.colors.outline),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.ratingItem.name,
                    style: AppTypography.titleMedium.copyWith(
                      color: context.colors.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (widget.ratingItem.description != null &&
                      widget.ratingItem.description!.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      widget.ratingItem.description!,
                      style: AppTypography.bodyMedium.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Rating Scale Display
            Text(
              'Rating Scale: 1-${widget.ratingItem.ratingScale}',
              style: AppTypography.bodyMedium.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Rating Input
            Center(
              child: Column(
                children: [
                  Text(
                    'Your Rating: ${_ratingValue.toInt()}',
                    style: AppTypography.titleMedium.copyWith(
                      color: context.colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Slider(
                    value: _ratingValue,
                    min: 1.0,
                    max: widget.ratingItem.ratingScale.toDouble(),
                    divisions: widget.ratingItem.ratingScale - 1,
                    activeColor: context.colors.primary,
                    inactiveColor: context.colors.outline,
                    onChanged: (value) {
                      setState(() {
                        _ratingValue = value;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '1',
                        style: AppTypography.bodySmall.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        '${widget.ratingItem.ratingScale}',
                        style: AppTypography.bodySmall.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Cancel',
                    backgroundColor: context.colors.surfaceContainerHighest,
                    textColor: context.colors.onSurface,
                    onPressed: () => Get.back(),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: CustomButton(
                    text: isEditing ? 'Update' : 'Submit',
                    onPressed: _isSubmitting ? null : _submitRating,
                    isLoading: _isSubmitting,
                    backgroundColor: context.colors.primary,
                    textColor: context.colors.onPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitRating() async {
    if (_ratingValue < 1) {
      Get.snackbar(
        'Invalid Rating',
        'Please select a rating between 1 and ${widget.ratingItem.ratingScale}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      widget.onRatingSubmitted(_ratingValue);
      Get.back();
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }
}
