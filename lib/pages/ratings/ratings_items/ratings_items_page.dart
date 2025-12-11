import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '/core/__core.dart';
import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';

import 'rating_items_controller.dart';
import 'rating_item_details_page.dart';
import 'components/__components.dart';

class RatingsPage extends StatelessWidget {
  final Group group;

  const RatingsPage({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final ratingController = Get.put(RatingItemController());
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Set the group context when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ratingController.setGroupContext(group);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(group.name),
        actions: [
          IconButton(
            onPressed: () => _navigateToAddRating(context, ratingController),
            icon: const Icon(Icons.add),
            tooltip: 'Add Rating',
          ),
        ],
      ),
      body: Obx(() {
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

        return CustomScrollView(
          slivers: [
            // Group Header
            SliverToBoxAdapter(
              child: GroupHeaderSection(group: group, itemCount: itemCount),
            ),

            // Members Section
            SliverToBoxAdapter(child: GroupMembersSection(group: group)),

            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.sm,
                ),
                child: AppTextField(
                  label: 'Search',
                  hintText: 'Search items...',
                  prefixIcon: Icons.search_rounded,
                  onChanged: (value) {
                    ratingController.updateSearchQuery(value);
                  },
                ),
              ),
            ),

            // Filter Chips
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
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
            ),

            // Section Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.md,
                ),
                child: Text(
                  itemCount == totalCount
                      ? 'Items ($itemCount)'
                      : 'Items ($itemCount of $totalCount)',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ),

            // Compact Rating Items List
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final rating = ratingController.filteredRatings[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: CompactRatingItemCard(
                      item: rating,
                      onTap: () => _navigateToRatingDetails(rating),
                    ),
                  );
                }, childCount: itemCount),
              ),
            ),

            // Bottom padding
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
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

  void _navigateToRatingDetails(RatingItem item) {
    Get.to(
      () => RatingItemDetailsPage(ratingItem: item),
      transition: Transition.cupertino,
    );
  }
}
