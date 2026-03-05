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
  late TextEditingController _ratingInputController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _ratingValue = widget.existingRating?.ratingValue ??
        (widget.ratingItem.ratingScale / 2).ceilToDouble();
    _commentController =
        TextEditingController(text: widget.existingRating?.comment);
    _ratingInputController =
        TextEditingController(text: _ratingValue.toInt().toString());
  }

  @override
  void dispose() {
    _ratingInputController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _setRating(double value, {bool fromInput = false}) {
    final clamped =
        value.clamp(1, widget.ratingItem.ratingScale).toDouble();
    setState(() {
      _ratingValue = clamped;
      if (!fromInput) {
        _ratingInputController.text = clamped.toInt().toString();
      }
    });
  }

  Color _getRatingColor(double normalized) {
    if (normalized < 0.33) return AppColors.error;
    if (normalized < 0.66) return AppColors.warning;
    return AppColors.success;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isEditing = widget.existingRating != null;
    final ratingScale = widget.ratingItem.ratingScale;
    final normalized = _ratingValue / ratingScale;
    final ratingColor = _getRatingColor(normalized);

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

              // Title + subtitle
              Text(
                'Rate ${widget.ratingItem.name}',
                style: AppTypography.titleLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'Scale: 1-$ratingScale',
                style: AppTypography.bodySmall.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Rating display - simple centered pill
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: ratingColor.withValues(alpha: 0.1),
                  borderRadius: AppBorderRadius.fullRadius,
                  border: Border.all(
                    color: ratingColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '${_ratingValue.toInt()}',
                      style: AppTypography.headlineMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: ratingColor,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '/ $ratingScale',
                      style: AppTypography.bodyLarge.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Slider
              AppSlider(
                value: _ratingValue,
                min: 1.0,
                max: ratingScale.toDouble(),
                divisions: ratingScale - 1,
                onChanged: (value) => _setRating(value),
              ),

              // Scale Labels
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.md),
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
                      '$ratingScale',
                      style: AppTypography.bodyMedium.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // Stepper for large scales
              if (ratingScale > 10) ...[
                const SizedBox(height: AppSpacing.md),
                _buildStepper(colorScheme, ratingScale),
              ],

              const SizedBox(height: AppSpacing.lg),

              // Comment Field
              AppTextField(
                controller: _commentController,
                label: 'Comment (optional)',
                hintText: 'What did you think? Share your experience...',
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

  Widget _buildStepper(ColorScheme colorScheme, int ratingScale) {
    return Row(
      children: [
        // Decrease buttons
        _buildStepButton(
            '-1', () => _setRating(_ratingValue - 1), colorScheme),
        _buildStepButton(
            '-5', () => _setRating(_ratingValue - 5), colorScheme),
        if (ratingScale > 50)
          _buildStepButton('-10', () => _setRating(_ratingValue - 10),
              colorScheme),

        // Text field in the center
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: SizedBox(
              height: 40,
              child: TextField(
                controller: _ratingInputController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                textAlign: TextAlign.center,
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: colorScheme.surface,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: AppBorderRadius.smRadius,
                    borderSide: BorderSide(color: colorScheme.outlineVariant),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppBorderRadius.smRadius,
                    borderSide: BorderSide(color: colorScheme.outlineVariant),
                  ),
                ),
                onChanged: (text) {
                  final parsed = double.tryParse(text);
                  if (parsed != null) {
                    _setRating(parsed, fromInput: true);
                  }
                },
              ),
            ),
          ),
        ),

        // Increase buttons
        if (ratingScale > 50)
          _buildStepButton('+10', () => _setRating(_ratingValue + 10),
              colorScheme),
        _buildStepButton(
            '+5', () => _setRating(_ratingValue + 5), colorScheme),
        _buildStepButton(
            '+1', () => _setRating(_ratingValue + 1), colorScheme),
      ],
    );
  }

  Widget _buildStepButton(
    String label,
    VoidCallback onPressed,
    ColorScheme colorScheme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: SizedBox(
        height: 36,
        width: 40,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.zero,
            side: BorderSide(color: colorScheme.outlineVariant),
            shape: const RoundedRectangleBorder(
              borderRadius: AppBorderRadius.smRadius,
            ),
          ),
          child: Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
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
      widget.onRatingSubmitted(
        _ratingValue,
        _commentController.text.trim().isEmpty
            ? null
            : _commentController.text.trim(),
      );
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
