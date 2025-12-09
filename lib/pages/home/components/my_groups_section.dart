import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '/core/__core.dart';
import '/styles/__styles.dart';
import '/constants/enums.dart';
import '/ui_components/__ui_components.dart';

import '../home_controller.dart';
import '/pages/groups/components/group_card.dart';

class MyGroupsSection extends GetView<HomeController> {
  const MyGroupsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'My Groups',
              style: AppTypography.titleLarge.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton.icon(
              onPressed: controller.navigateToGroupsPage,
              icon: const Icon(Icons.arrow_forward),
              label: const Text('View All'),
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Obx(() {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.userGroups.isEmpty) {
            return EmptyStateCard(
              title: 'No groups yet',
              description:
                  'Create or join a group to get started with rating items together',
              icon: Icons.group_outlined,
              iconColor: AppColors.onSurface,
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CustomButton(
                        onPressed: controller.navigateToCreateGroup,
                        text: 'Create Group',
                        backgroundColor: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: CustomButton(
                        onPressed: controller.navigateToJoinGroup,
                        text: 'Join Group',
                        backgroundColor: AppColors.indigo,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }

          return Column(
            children: [
              ...controller.userGroups
                  .take(3)
                  .map(
                    (group) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: GestureDetector(
                        onTap: () => controller.navigateToGroupRatings(group),
                        child: GroupCard(
                          group: group,
                          isCreator:
                              group.members
                                  .firstWhereOrNull(
                                    (e) =>
                                        e.userId ==
                                        Get.find<AuthService>().currentUserId,
                                  )
                                  ?.role ==
                              GroupMemberRole.admin,
                          index: controller.userGroups.indexOf(group),
                        ),
                      ),
                    ),
                  ),
              if (controller.userGroups.length > 3)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.md),
                  child: Center(
                    child: TextButton.icon(
                      onPressed: controller.navigateToGroupsPage,
                      icon: const Icon(Icons.arrow_forward),
                      label: Text(
                        'View ${controller.userGroups.length - 3} more groups',
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                      ),
                    ),
                  ),
                ),
            ],
          );
        }),
      ],
    );
  }
}
