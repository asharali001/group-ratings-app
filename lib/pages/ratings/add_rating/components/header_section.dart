import 'package:flutter/material.dart';

import '/styles/__styles.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key, required this.groupName});

  final String groupName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add New Rating',
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.text,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Share your experience with "$groupName"',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.textLight),
        ),
      ],
    );
  }
}
