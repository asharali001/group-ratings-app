import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';
import '/core/__core.dart';

import 'my_ratings_controller.dart';
import '../ratings/ratings_items/components/compact_rating_item_card.dart';
import '../ratings/ratings_items/rating_item_details_page.dart';
import '../ratings/ratings_items/rating_items_controller.dart';

class MyRatingsPage extends StatelessWidget {
  const MyRatingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyRatingsController());

    return PageLayout(
      title: 'My Ratings',
      child: Column(
        children: [
          AppTextField(
            label: 'Search',
            hintText: 'Search ratings...',
            prefixIcon: EvaIcons.search,
            onChanged: controller.setSearchQuery,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildFilterSection(controller),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredRatings.isEmpty) {
                final hasSearch = controller.searchQuery.value.isNotEmpty;
                return EmptyStateWidget(
                  svgAsset: hasSearch ? null : 'assets/animations/opinion.svg',
                  icon: hasSearch ? Icons.search_off : null,
                  title: hasSearch ? 'No results found' : 'No ratings yet',
                  description: hasSearch
                      ? 'Try adjusting your search or filters'
                      : 'Start rating items in your groups to see them here',
                  actions: hasSearch
                      ? [
                          TextButton(
                            onPressed: controller.clearFilters,
                            child: const Text('Clear Filters'),
                          ),
                        ]
                      : [
                          AppButton(
                            text: 'Go to Groups',
                            variant: AppButtonVariant.outline,
                            icon: Icons.group_rounded,
                            onPressed: () => Get.toNamed(
                              RouteNames.groups.groupsPage,
                            ),
                          ),
                        ],
                );
              }
              return ListView.separated(
                itemCount: controller.filteredRatings.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final item = controller.filteredRatings[index];
                  return CompactRatingItemCard(
                    item: item,
                    onTap: () => _navigateToRatingDetails(item),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(MyRatingsController controller) {
    return Obx(
      () => Align(
        alignment: Alignment.centerLeft,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildFilterChip(
                'All',
                isSelected: controller.selectedFilter.value == 'all',
                onTap: () => controller.setFilter('all'),
              ),
              const SizedBox(width: AppSpacing.sm),
              _buildFilterChip(
                'Rated',
                isSelected: controller.selectedFilter.value == 'rated',
                onTap: () => controller.setFilter('rated'),
              ),
              const SizedBox(width: AppSpacing.sm),
              _buildFilterChip(
                'Pending',
                isSelected: controller.selectedFilter.value == 'pending',
                onTap: () => controller.setFilter('pending'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    String label, {
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    return AppChip(label: label, isSelected: isSelected, onTap: onTap);
  }

  Future<void> _navigateToRatingDetails(RatingItem item) async {
    // Initialize or get the RatingItemController
    final ratingController = Get.put(RatingItemController());

    // Fetch the group to set the context
    final group = await GroupService.getGroup(item.groupId);
    if (group != null) {
      ratingController.setGroupContext(group);
    }

    // Navigate to details page
    Get.to(
      () => RatingItemDetailsPage(ratingItem: item),
      transition: Transition.cupertino,
    );
  }
}
