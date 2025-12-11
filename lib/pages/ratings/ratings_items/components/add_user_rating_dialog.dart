import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/__core.dart';
import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';

class AddUserRatingDialog extends StatefulWidget {
  final RatingItem ratingItem;
  final UserRating? existingRating;
  final Function(double, String?) onRatingSubmitted;

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
  late TextEditingController _commentController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _ratingValue = widget.existingRating?.ratingValue ?? 
        (widget.ratingItem.ratingScale / 2).ceilToDouble();
    _commentController = TextEditingController(text: widget.existingRating?.comment);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isEditing = widget.existingRating != null;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppBorderRadius.xl),
          topRight: Radius.circular(AppBorderRadius.xl),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.lg,
            AppSpacing.xl,
            AppSpacing.xl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag Handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: AppBorderRadius.fullRadius,
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Title
              Text(
                isEditing 
                    ? 'Rate ${widget.ratingItem.name}'
                    : 'Rate ${widget.ratingItem.name}',
                style: AppTypography.titleLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.xl),

              // Rating Display
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: AppBorderRadius.fullRadius,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      '${_ratingValue.toInt()}',
                      style: AppTypography.titleLarge.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      ' / ${widget.ratingItem.ratingScale}',
                      style: AppTypography.bodyLarge.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Slider
              AppSlider(
                value: _ratingValue,
                min: 1.0,
                max: widget.ratingItem.ratingScale.toDouble(),
                divisions: widget.ratingItem.ratingScale - 1,
                onChanged: (value) {
                  setState(() {
                    _ratingValue = value;
                  });
                },
              ),

              // Scale Labels
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '1',
                      style: AppTypography.bodyMedium.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${widget.ratingItem.ratingScale}',
                      style: AppTypography.bodyMedium.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Comment Field
              AppTextField(
                controller: _commentController,
                label: 'Comment (optional)',
                hintText: 'Share your thoughts...',
                maxLines: 3,
                textInputAction: TextInputAction.done,
              ),

              const SizedBox(height: AppSpacing.xl),

              // Submit Button
              AppButton(
                text: isEditing ? 'Update Rating' : 'Submit Rating',
                onPressed: _isSubmitting ? null : _submitRating,
                isLoading: _isSubmitting,
                isFullWidth: true,
              ),

              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitRating() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      widget.onRatingSubmitted(_ratingValue, _commentController.text.trim().isEmpty ? null : _commentController.text.trim());
      Get.back();
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}
