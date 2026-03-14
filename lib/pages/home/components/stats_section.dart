import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';

import '../home_controller.dart';

class StatsSection extends GetView<HomeController> {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          Expanded(
            child: StatPill(
              value: '${controller.totalRatings}',
              label: 'Ratings',
              usePrimaryColor: true,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: StatPill(
              value: '${controller.activeGroupsCount}',
              label: 'Groups',
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: StatPill(
              value: '${controller.totalMembers}',
              label: 'Members',
            ),
          ),
        ],
      ),
    );
  }
}
