import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '/core/__core.dart';
import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';

import 'rating_items_controller.dart';
import 'components/__components.dart';

class RatingsPage extends StatelessWidget {
  final Group group;

  const RatingsPage({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final ratingController = Get.put(RatingItemController());

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
      body: _buildRatingsList(ratingController),
    );
  }

  Widget _buildRatingsList(RatingItemController ratingController) {
    return Obx(() {
      if (ratingController.groupRatings.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, size: 64, color: AppColors.yellow),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'No ratings yet',
                style: AppTypography.titleLarge.copyWith(
                  color: Get.context!.colors.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Be the first to add a rating to this group!',
                style: AppTypography.bodyMedium.copyWith(
                  color: Get.context!.colors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              if (ratingController.canCreateRating())
                CustomButton(
                  onPressed: () =>
                      _navigateToAddRating(Get.context!, ratingController),
                  text: 'Add First Rating',
                  backgroundColor: AppColors.primary,
                  textColor: AppColors.white,
                ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: ratingController.groupRatings.length,
        itemBuilder: (context, index) {
          final rating = ratingController.groupRatings[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: RatingItemCard(
              rating: rating,
              canEdit: ratingController.canEditRating(rating),
              controller: ratingController,
              onEdit: () =>
                  _navigateToEditRating(context, ratingController, rating),
              onDelete: () =>
                  _showDeleteRatingDialog(context, ratingController, rating),
            ),
          );
        },
      );
    });
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

  void _navigateToEditRating(
    BuildContext context,
    RatingItemController ratingController,
    RatingItem rating,
  ) {
    Get.toNamed(
      RouteNames.groups.editRatingPage,
      arguments: {'rating': rating},
    );
  }

  void _showDeleteRatingDialog(
    BuildContext context,
    RatingItemController ratingController,
    RatingItem rating,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Rating'),
        content: Text(
          'Are you sure you want to delete your rating for "${rating.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ratingController.deleteRatingItem(rating.id);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
