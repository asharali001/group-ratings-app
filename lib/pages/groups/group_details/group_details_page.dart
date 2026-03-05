import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '/core/__core.dart';
import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';

import '../../ratings/ratings_items/rating_items_controller.dart';
import '../../ratings/ratings_items/components/__components.dart';
import '../../ratings/ratings_items/rating_item_details_page.dart';

class GroupDetailsPage extends StatelessWidget {
  final Group group;

  const GroupDetailsPage({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final ratingController = Get.put(RatingItemController());
    final colorScheme = Theme.of(context).colorScheme;

    // Set the group context when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ratingController.setGroupContext(group);
    });

    return PageLayout(
      actions: [
        IconButton(
          onPressed: () => _navigateToEditGroup(context, ratingController),
          icon: const Icon(Icons.edit),
          tooltip: 'Edit Group',
        ),
      ],
      bottomNavigationBar: Obx(() {
        if (!ratingController.canCreateRating()) return const SizedBox.shrink();
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      variant: AppButtonVariant.outline,
                      text: 'Invite',
                      icon: Icons.person_add_rounded,
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(text: group.groupCode),
                        );
                        showCustomSnackBar(
                          message: 'Group code "${group.groupCode}" copied!',
                          isSuccess: true,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppButton(
                      text: 'Add Item',
                      icon: Icons.add_rounded,
                      onPressed: () =>
                          _navigateToAddRating(context, ratingController),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
      child: Obx(() {
        final itemCount = ratingController.filteredRatings.length;
        final totalCount = ratingController.groupRatings.length;
        final hasSearchOrFilter =
            ratingController.searchQuery.value.isNotEmpty ||
            ratingController.selectedFilter.value != 'All';

        if (totalCount == 0 && !hasSearchOrFilter) {
          return Column(
            children: [
              GroupHeaderSection(group: group, itemCount: 0),
              GroupMembersSection(group: group),
              Expanded(
                child: EmptyStateWidget(
                  icon: Icons.star_rounded,
                  title: 'No items yet',
                  description:
                      'Be the first to add an item to this group!',
                  actions: [
                    if (ratingController.canCreateRating())
                      AppButton(
                        onPressed: () =>
                            _navigateToAddRating(context, ratingController),
                        text: 'Add First Item',
                      ),
                  ],
                ),
              ),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GroupHeaderSection(group: group, itemCount: totalCount),
            const SizedBox(height: AppSpacing.sm),
            GroupMembersSection(group: group),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              label: 'Search',
              hintText: 'Search items...',
              prefixIcon: Icons.search_rounded,
              onChanged: (value) {
                ratingController.updateSearchQuery(value);
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              height: 40,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Obx(
                  () => Row(
                    children: [
                      _buildFilterChip(
                        'All',
                        isSelected:
                            ratingController.selectedFilter.value == 'All',
                        onTap: () => ratingController.updateFilter('All'),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      _buildFilterChip(
                        'My Ratings',
                        isSelected:
                            ratingController.selectedFilter.value ==
                            'My Ratings',
                        onTap: () =>
                            ratingController.updateFilter('My Ratings'),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      _buildFilterChip(
                        'Highest Rated',
                        isSelected:
                            ratingController.selectedFilter.value ==
                            'Highest Rated',
                        onTap: () =>
                            ratingController.updateFilter('Highest Rated'),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      _buildFilterChip(
                        'Newest',
                        isSelected:
                            ratingController.selectedFilter.value == 'Newest',
                        onTap: () => ratingController.updateFilter('Newest'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              itemCount == totalCount
                  ? 'Items ($itemCount)'
                  : 'Items ($itemCount of $totalCount)',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: itemCount == 0 && hasSearchOrFilter
                    ? const EmptyStateWidget(
                        key: ValueKey('empty_search'),
                        icon: Icons.search_off_rounded,
                        title: 'No items match your search',
                        description:
                            'Try adjusting your search or filter criteria',
                        actions: [],
                      )
                    : ListView.separated(
                        key: const ValueKey('items_list'),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemCount: ratingController.filteredRatings.length,
                        itemBuilder: (context, index) =>
                            CompactRatingItemCard(
                          item: ratingController.filteredRatings[index],
                          onTap: () => _navigateToRatingDetails(
                            ratingController.filteredRatings[index],
                          ),
                        ),
                      ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildFilterChip(
    String label, {
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    return AppChip(label: label, isSelected: isSelected, onTap: onTap);
  }

  void _navigateToAddRating(
    BuildContext context,
    RatingItemController ratingController,
  ) {
    Get.toNamed(
      RouteNames.groups.addRatingPage,
      arguments: {'groupId': group.id, 'groupName': group.name},
    );
  }

  void _navigateToEditGroup(
    BuildContext context,
    RatingItemController ratingController,
  ) {
    Get.toNamed(RouteNames.groups.editGroupPage, arguments: {'group': group});
  }

  void _navigateToRatingDetails(RatingItem item) {
    Get.to(
      () => RatingItemDetailsPage(ratingItem: item),
      transition: Transition.cupertino,
    );
  }
}
