import 'package:flutter/material.dart';
import '../../../styles/__styles.dart';
import '../../../core/__core.dart';

class CustomFormField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final IconData icon;
  final bool isRequired;
  final int maxLines;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final Color? fillColor;
  final Color? textColor;
  final TextCapitalization? textCapitalization;

  const CustomFormField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.icon,
    required this.isRequired,
    this.maxLines = 1,
    this.validator,
    this.textInputAction,
    this.onFieldSubmitted,
    this.fillColor,
    this.textColor,
    this.textCapitalization,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: AppTypography.titleMedium.copyWith(
                color: context.colors.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (isRequired) ...[
              const SizedBox(width: AppSpacing.xs),
              Text(
                '*',
                style: AppTypography.titleMedium.copyWith(
                  color: context.colors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          textCapitalization: textCapitalization ?? TextCapitalization.none,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.bodyMedium.copyWith(
              color: context.colors.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            prefixIcon: Icon(
              icon,
              color: context.colors.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              borderSide: BorderSide(
                color: context.colors.outline.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              borderSide: BorderSide(
                color: context.colors.outline.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              borderSide: BorderSide(color: context.colors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              borderSide: BorderSide(color: context.colors.error, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              borderSide: BorderSide(color: context.colors.error, width: 2),
            ),
            filled: true,
            fillColor: fillColor ?? AppColors.white.withValues(alpha: 0.3),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
          ),
          style: AppTypography.bodyLarge.copyWith(
            color: textColor ?? context.colors.onSurface,
          ),
          textInputAction:
              textInputAction ??
              (maxLines == 1 ? TextInputAction.next : TextInputAction.done),
          onFieldSubmitted:
              onFieldSubmitted ??
              (maxLines == 1
                  ? (_) => FocusScope.of(context).nextFocus()
                  : null),
          validator: validator,
        ),
      ],
    );
  }
}
