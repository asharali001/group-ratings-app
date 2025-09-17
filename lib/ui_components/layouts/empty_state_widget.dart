import 'package:flutter/material.dart';

import '/styles/__styles.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final List<Widget> actions;
  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppColors.gray),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            description,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textLight,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: actions),
        ],
      ),
    );
  }
}
