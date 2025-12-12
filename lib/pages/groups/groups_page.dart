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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Groups',
                        style: AppTypography.headlineMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Manage and explore your groups',
                        style: AppTypography.bodyMedium.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => _navigateToCreateGroup(),
                    icon: const Icon(Icons.add_rounded, size: 24),
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: AppTextField(
                label: 'Search groups...',
                prefixIcon: Icons.search_rounded,
                onChanged: (value) {
                  controller.updateSearchQuery(value);
                },
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Groups Grid
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final groups = controller.filteredGroups;

                if (groups.isEmpty) {
                  return _buildEmptyState(context, controller);
                }

                return GridView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                    childAspectRatio: 2.0,
                  ),
                  itemCount: groups.length,
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
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    GroupsListController controller,
  ) {
    final hasSearch = controller.searchQuery.value.isNotEmpty;
    final hasFilter = controller.selectedFilter.value != 'All';
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(
                  alpha: 0.2,
                ), // Standardize
                shape: BoxShape.circle,
              ),
              child: Icon(
                hasSearch || hasFilter
                    ? Icons.search_off
                    : Icons.group_outlined,
                color: colorScheme.primary,
                size: 48,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              hasSearch || hasFilter ? 'No groups found' : 'No groups yet',
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              hasSearch || hasFilter
                  ? 'Try adjusting your search or filters'
                  : 'Create your first group to get started!',
              style: AppTypography.bodyMedium.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (!hasSearch && !hasFilter) ...[
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                onPressed: () => _navigateToCreateGroup(),
                text: 'Create Group',
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _navigateToCreateGroup() {
    Get.toNamed(RouteNames.groups.createGroupPage);
  }
}
