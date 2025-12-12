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

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(controller),
            _buildFilterSection(controller),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.filteredRatings.isEmpty) {
                  return EmptyStateWidget(
                    icon: Icons.star_outline,
                    title: controller.searchQuery.value.isNotEmpty
                        ? 'No results found'
                        : 'No ratings yet',
                    description: controller.searchQuery.value.isNotEmpty
                        ? 'Try adjusting your search or filters'
                        : 'Start rating items in your groups to see them here',
                    actions: controller.searchQuery.value.isNotEmpty
                        ? [
                            TextButton(
                              onPressed: controller.clearFilters,
                              child: const Text('Clear Filters'),
                            ),
                          ]
                        : const [],
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: controller.filteredRatings.length,
                  itemBuilder: (context, index) {
                    final item = controller.filteredRatings[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: CompactRatingItemCard(
                        item: item,
                        onTap: () => _navigateToRatingDetails(item),
                      ),
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

  Widget _buildHeader(MyRatingsController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Ratings',
            style: AppTypography.headlineLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Search',
            hintText: 'Search ratings...',
            prefixIcon: EvaIcons.search,
            onChanged: controller.setSearchQuery,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(MyRatingsController controller) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.md,
        ),
        child: Align(
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
