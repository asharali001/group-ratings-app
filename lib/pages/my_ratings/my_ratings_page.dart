import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';
import '/core/__core.dart';

import 'my_ratings_controller.dart';

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
            _buildFilterChips(controller),
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
                    return _buildRatingCard(item, controller);
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
      padding: const EdgeInsets.all(AppSpacing.lg),
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
          TextField(
            onChanged: controller.setSearchQuery,
            decoration: InputDecoration(
              hintText: 'Search ratings...',
              prefixIcon: const Icon(EvaIcons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: AppColors.surfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(MyRatingsController controller) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Row(
          children: [
            _buildChip('All', 'all', controller),
            const SizedBox(width: AppSpacing.sm),
            _buildChip('Highest Rated', 'highest', controller),
            const SizedBox(width: AppSpacing.sm),
            _buildChip('Recent', 'recent', controller),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(
    String label,
    String value,
    MyRatingsController controller,
  ) {
    final isSelected = controller.selectedFilter.value == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => controller.setFilter(value),
      backgroundColor: AppColors.surfaceVariant,
      selectedColor: AppColors.primary.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : AppColors.textLight,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
      ),
    );
  }

  Widget _buildRatingCard(RatingItem item, MyRatingsController controller) {
    final userRating = item.ratings.firstWhereOrNull(
      (r) => r.userId == controller.currentUserId,
    );

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: ListTile(
        tileColor: Theme.of(Get.context!).colorScheme.primaryContainer,
        shape: const RoundedRectangleBorder(
          borderRadius: AppBorderRadius.mdRadius,
        ),
        leading: item.imageUrl != null && item.imageUrl!.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.imageUrl!,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 56,
                    height: 56,
                    color: AppColors.surfaceVariant,
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
              )
            : Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.star),
              ),
        title: Text(
          item.name,
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.description != null && item.description!.isNotEmpty)
              Text(
                item.description!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodySmall,
              ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, size: 16, color: AppColors.yellow),
                const SizedBox(width: 4),
                Text(
                  '${userRating?.ratingValue.toStringAsFixed(1) ?? 'N/A'}/${item.ratingScale}',
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
