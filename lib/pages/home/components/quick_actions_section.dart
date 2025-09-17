import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '/core/__core.dart';
import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';

import '../home_controller.dart';

class QuickActionsSection extends GetView<HomeController> {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTypography.titleLarge.copyWith(
            color: context.colors.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        QuickActionCard(
          title: 'Create New Group',
          subtitle: 'Start rating with friends',
          icon: Icons.add_circle_outline,
          iconColor: AppColors.primary,
          onTap: controller.navigateToCreateGroup,
        ),
        const SizedBox(height: AppSpacing.md),
        QuickActionCard(
          title: 'Join Existing Group',
          subtitle: 'Enter group code',
          icon: Icons.group_add,
          iconColor: AppColors.secondary,
          onTap: controller.navigateToJoinGroup,
        ),
      ],
    );
  }
}
