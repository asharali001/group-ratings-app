import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

import '/styles/__styles.dart';

class AskAIPage extends StatelessWidget {
  const AskAIPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ask AI',
                style: AppTypography.headlineLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Coming Soon',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              _buildExampleCard('Where did we eat that veggie burger?'),
              const SizedBox(height: AppSpacing.md),
              _buildExampleCard('What\'s my highest rated horror movie?'),
              const SizedBox(height: AppSpacing.md),
              _buildExampleCard('Show me restaurants John and I both loved'),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.gray.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(EvaIcons.bulbOutline, color: AppColors.primary),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        'AI-powered insights will help you discover patterns in your ratings',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.gray,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExampleCard(String question) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.gray.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            EvaIcons.messageCircleOutline,
            color: AppColors.gray,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              question,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.gray),
            ),
          ),
        ],
      ),
    );
  }
}
