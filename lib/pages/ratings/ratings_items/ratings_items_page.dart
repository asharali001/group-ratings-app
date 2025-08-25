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
        title: Text(
          group.name,
          style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(AppBorderRadius.lg),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showAddRatingDialog(context, ratingController),
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
      if (ratingController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (ratingController.groupRatings.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: Get.context!.colors.surfaceContainerHighest.withValues(
                    alpha: 0.3,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.star_outline,
                  size: 64,
                  color: Get.context!.colors.onSurfaceVariant,
                ),
              ),
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
                      _showAddRatingDialog(Get.context!, ratingController),
                  text: 'Add First Rating',
                  backgroundColor: Get.context!.colors.primary,
                  textColor: Get.context!.colors.onPrimary,
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
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: RatingItemCard(
              rating: rating,
              canEdit: ratingController.canEditRating(rating),
              controller: ratingController,
              onEdit: () =>
                  _showEditRatingDialog(context, ratingController, rating),
              onDelete: () =>
                  _showDeleteRatingDialog(context, ratingController, rating),
            ),
          );
        },
      );
    });
  }

  void _showAddRatingDialog(
    BuildContext context,
    RatingItemController ratingController,
  ) {
    showDialog(
      context: context,
      builder: (context) => AddRatingDialog(
        groupId: group.id,
        onRatingCreated: () {
          // The rating will be automatically added to the list via the stream
          Get.snackbar(
            'Success',
            'Rating added successfully!',
            backgroundColor: AppColors.green,
            colorText: AppColors.white,
            snackPosition: SnackPosition.BOTTOM,
            borderRadius: AppBorderRadius.md,
            margin: const EdgeInsets.all(AppSpacing.md),
          );
        },
      ),
    );
  }

  void _showEditRatingDialog(
    BuildContext context,
    RatingItemController ratingController,
    RatingItem rating,
  ) {
    showDialog(
      context: context,
      builder: (context) => EditRatingDialog(
        rating: rating,
        onRatingUpdated: () {
          // The rating will be automatically updated in the list via the stream
          Get.snackbar(
            'Success',
            'Rating updated successfully!',
            backgroundColor: AppColors.green,
            colorText: AppColors.white,
            snackPosition: SnackPosition.BOTTOM,
            borderRadius: AppBorderRadius.md,
            margin: const EdgeInsets.all(AppSpacing.md),
          );
        },
      ),
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
