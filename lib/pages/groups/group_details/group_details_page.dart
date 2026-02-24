import 'package:get/get.dart';
import 'package:flutter/material.dart';

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
        IconButton(
          onPressed: () => _navigateToAddRating(context, ratingController),
          icon: const Icon(Icons.add),
          tooltip: 'Add Rating',
        ),
      ],
      child: Obx(() {
        final itemCount = ratingController.filteredRatings.length;
        final totalCount = ratingController.groupRatings.length;

        if (itemCount == 0 &&
            ratingController.searchQuery.value.isEmpty &&
            ratingController.selectedFilter.value == 'All') {
          return Column(
            children: [
              GroupHeaderSection(group: group, itemCount: 0),
              GroupMembersSection(group: group),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 64,
                        color: AppColors.yellow,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'No items yet',
                        style: AppTypography.titleLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Be the first to add an item to this group!',
                        style: AppTypography.bodyMedium.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      if (ratingController.canCreateRating())
                        AppButton(
                          onPressed: () =>
                              _navigateToAddRating(context, ratingController),
                          text: 'Add First Item',
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GroupHeaderSection(group: group, itemCount: itemCount),
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
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppSpacing.sm),
                itemCount: ratingController.filteredRatings.length,
                itemBuilder: (context, index) => CompactRatingItemCard(
                  item: ratingController.filteredRatings[index],
                  onTap: () => _navigateToRatingDetails(
                    ratingController.filteredRatings[index],
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
