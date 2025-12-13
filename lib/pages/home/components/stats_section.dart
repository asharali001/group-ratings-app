import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';

import '../home_controller.dart';

class StatsSection extends GetView<HomeController> {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Obx(
          () => Row(
            children: [
              Expanded(
                child: StatsCard(
                  title: 'Active Groups',
                  value: '${controller.activeGroupsCount}',
                  icon: Icons.group,
                  iconColor: AppColors.primary,
                  onTap: controller.navigateToGroupsTab,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: StatsCard(
                  title: 'Total Ratings',
                  value: '${controller.totalRatings}',
                  icon: Icons.star,
                  iconColor: AppColors.yellow,
                  onTap: controller.navigateToMyRatingsTab,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
