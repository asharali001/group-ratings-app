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

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Groups'),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(RouteNames.groups.createGroupPage),
            icon: const Icon(Icons.add),
            tooltip: 'Create Group',
          ),
        ],
      ),
      body: Obx(() {
        if (groupController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (groupController.userGroups.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.group_outlined,
                  size: 64,
                  color: AppColors.gray,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'No groups yet',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Create or join a group to get started',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textLight,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      onPressed: () =>
                          Get.toNamed(RouteNames.groups.createGroupPage),
                      text: 'Create Group',
                      backgroundColor: AppColors.primary,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    CustomButton(
                      onPressed: () =>
                          Get.toNamed(RouteNames.groups.joinGroupPage),
                      text: 'Join Group',
                      backgroundColor: AppColors.blue,
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        return ListView.builder(
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
        );
      }),
    );
  }
}
