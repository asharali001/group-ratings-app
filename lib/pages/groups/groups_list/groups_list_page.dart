import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '/core/__core.dart';
import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';

import 'groups_list_controller.dart';
import '../components/group_card.dart';

class GroupsPage extends StatelessWidget {
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final groupController = Get.find<GroupsListController>();

    return Obx(() {
      return PageLayout(
        title: 'My Groups',
        isLoading: groupController.isLoading.value,
        isEmpty: groupController.userGroups.isEmpty,
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(RouteNames.groups.createGroupPage),
            icon: const Icon(Icons.add),
            tooltip: 'Create Group',
          ),
        ],
        emptyStateWidget: EmptyStateWidget(
          icon: Icons.group_outlined,
          title: 'No groups yet',
          description: 'Create or join a group to get started',
          actions: [
            CustomButton(
              onPressed: () => Get.toNamed(RouteNames.groups.createGroupPage),
              text: 'Create Group',
              backgroundColor: AppColors.primary,
            ),
            const SizedBox(width: AppSpacing.md),
            CustomButton(
              onPressed: () => Get.toNamed(RouteNames.groups.joinGroupPage),
              text: 'Join Group',
              backgroundColor: AppColors.secondary,
            ),
          ],
        ),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          itemCount: groupController.userGroups.length,
          itemBuilder: (context, index) {
            final group = groupController.userGroups[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: GestureDetector(
                onTap: () => groupController.navigateToGroupRatings(group),
                child: GroupCard(
                  group: group,
                  isCreator: groupController.isGroupCreator(group),
                  index: index,
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
