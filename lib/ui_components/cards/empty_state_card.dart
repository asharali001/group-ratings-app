import 'package:flutter/material.dart';

import '/core/__core.dart';
import '/styles/__styles.dart';

class EmptyStateCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final List<Widget>? actions;

  const EmptyStateCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.iconColor = AppColors.gray,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        border: Border.all(
          color: context.colors.outline.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppBorderRadius.lg),
            ),
            child: Icon(icon, color: iconColor, size: 48),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            title,
            style: AppTypography.titleLarge.copyWith(
              color: context.colors.onSurface,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            description,
            style: AppTypography.bodyMedium.copyWith(
              color: context.colors.onSurface,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          if (actions != null) ...[
            const SizedBox(height: AppSpacing.lg),
            ...actions!,
          ],
        ],
      ),
    );
  }
}
