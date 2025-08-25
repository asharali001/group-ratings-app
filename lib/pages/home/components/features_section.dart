import 'package:flutter/material.dart';

import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Features',
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.text,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: FeatureCard(
                title: 'Rate Items',
                description: 'Vote and rate items in your groups',
                icon: Icons.thumb_up,
                iconColor: AppColors.green,
                backgroundColor: AppColors.surface,
                onTap: () {},
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: FeatureCard(
                title: 'View Results',
                description: 'See group ratings and rankings',
                icon: Icons.analytics,
                iconColor: AppColors.purple,
                backgroundColor: AppColors.surface,
                onTap: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}
