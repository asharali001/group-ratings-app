import 'package:get/get.dart';
import 'package:flutter/material.dart';

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
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        ActionChipRow(
          chips: [
            ActionChipItem(
              label: 'Rate Item',
              icon: Icons.add,
              isFilled: true,
              onTap: controller.navigateToGroupsTab,
            ),
            ActionChipItem(
              label: 'Join Group',
              onTap: controller.navigateToJoinGroup,
            ),
            ActionChipItem(
              label: 'Create Group',
              onTap: controller.navigateToCreateGroup,
            ),
          ],
        ),
      ],
    );
  }
}
