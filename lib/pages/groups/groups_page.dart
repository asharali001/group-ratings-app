import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/__core.dart';
import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';

import 'components/__components.dart';
import 'groups_list/groups_list_controller.dart';

class GroupsPage extends StatelessWidget {
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GroupsListController());

    return PageLayout(
      title: 'Groups',
      actions: [
        IconButton(
          onPressed: () => _navigateToCreateGroup(),
          icon: const Icon(Icons.add_rounded, size: 24),
        ),
      ],
      child: Column(
        children: [
          AppTextField(
            label: 'Search groups...',
            prefixIcon: Icons.search_rounded,
            onChanged: (value) {
              controller.updateSearchQuery(value);
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              final groups = controller.filteredGroups;
              if (groups.isEmpty) {
                return _buildEmptyState(context, controller);
              }
              return ListView.separated(
                itemCount: groups.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final group = groups[index];
                  return GroupCard(
                    group: group,
                    isCreator: controller.isGroupCreator(group),
                    index: index,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    GroupsListController controller,
  ) {
    final hasSearch = controller.searchQuery.value.isNotEmpty;
    final hasFilter = controller.selectedFilter.value != 'All';

    if (hasSearch || hasFilter) {
      return EmptyStateWidget(
        icon: Icons.search_off,
        title: 'No groups found',
        description: 'Try adjusting your search or filters',
        actions: const [],
      );
    }

    return EmptyStateWidget(
      svgAsset: 'assets/animations/team.svg',
      title: 'No groups yet',
      description: 'Create your first group to get started!',
      actions: [
        AppButton(
          onPressed: () => _navigateToCreateGroup(),
          text: 'Create Group',
        ),
        const SizedBox(width: AppSpacing.md),
        AppButton(
          onPressed: () => Get.toNamed(RouteNames.groups.joinGroupPage),
          text: 'Join Group',
          variant: AppButtonVariant.outline,
          icon: Icons.login_rounded,
        ),
      ],
    );
  }

  void _navigateToCreateGroup() {
    Get.toNamed(RouteNames.groups.createGroupPage);
  }
}
