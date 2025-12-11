import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/__core.dart';
import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';

import 'rating_items_controller.dart';
import 'components/__components.dart';

class RatingItemDetailsPage extends StatelessWidget {
  final RatingItem ratingItem;

  const RatingItemDetailsPage({super.key, required this.ratingItem});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RatingItemController>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(ratingItem.name),
        actions: [
          if (controller.canEditRating(ratingItem))
            IconButton(
              onPressed: () => _navigateToEditRating(context),
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Edit',
            ),
          IconButton(
            onPressed: () => _showDeleteDialog(context, controller),
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image
            SizedBox(
              height: 200,
              width: double.infinity,
              child: _buildHeroImage(context),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location
                  if (ratingItem.location?.isNotEmpty == true) ...[
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: colorScheme.primary,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          ratingItem.location!,
                          style: AppTypography.bodyMedium.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],

                  // Description
                  if (ratingItem.description?.isNotEmpty == true) ...[
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest.withValues(
                          alpha: 0.5,
                        ),
                        borderRadius: AppBorderRadius.mdRadius,
                      ),
                      child: Text(
                        ratingItem.description!,
                        style: AppTypography.bodyMedium.copyWith(
                          height: 1.6,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],

                  // Ratings Stats
                  _buildRatingsStats(context),

                  const SizedBox(height: AppSpacing.lg),

                  // Ratings List
                  if (ratingItem.ratings.isNotEmpty) ...[
                    ...ratingItem.ratings.map(
                      (rating) => _buildRatingItem(context, rating, controller),
                    ),
                  ] else
                    _buildEmptyState(context),

                  // Bottom Padding
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: controller.canCreateRating()
          ? Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: AppButton(
                  onPressed: () => _showRatingDialog(controller),
                  text: controller.hasUserRated(ratingItem.id)
                      ? 'Edit Rating'
                      : 'Rate',
                  icon: controller.hasUserRated(ratingItem.id)
                      ? Icons.edit_rounded
                      : Icons.add_rounded,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildHeroImage(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Stack(
      fit: StackFit.expand,
      children: [
        if (ratingItem.imageUrl != null && ratingItem.imageUrl!.isNotEmpty)
          Image.network(
            ratingItem.imageUrl!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildPlaceholderGradient(context);
            },
          )
        else
          _buildPlaceholderGradient(context),
        // Gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withValues(alpha: 0.3)],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderGradient(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primaryContainer,
            colorScheme.secondaryContainer,
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          color: colorScheme.primary.withValues(alpha: 0.5),
          size: 64,
        ),
      ),
    );
  }

  Widget _buildRatingsStats(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final avgRating = _calculateAverageRating();
    final ratingCount = ratingItem.ratings.length;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary.withValues(alpha: 0.1),
            colorScheme.secondary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: AppBorderRadius.lgRadius,
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          // Average Rating
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: AppBorderRadius.mdRadius,
            ),
            child: Column(
              children: [
                Text(
                  ratingCount > 0 ? avgRating.toStringAsFixed(1) : '-',
                  style: AppTypography.headlineMedium.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Icon(
                  Icons.star_rounded,
                  color: colorScheme.onPrimary,
                  size: 20,
                ),
              ],
            ),
          ),

          const SizedBox(width: AppSpacing.lg),

          // Stats
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ratingCount == 0
                      ? 'No ratings yet'
                      : '$ratingCount rating${ratingCount == 1 ? '' : 's'}',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Scale: 1-${ratingItem.ratingScale}',
                  style: AppTypography.bodySmall.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingItem(
    BuildContext context,
    UserRating userRating,
    RatingItemController controller,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isCurrentUser =
        controller.hasUserRated(ratingItem.id) &&
        controller.getCurrentUserRating(ratingItem.id)?.userId ==
            userRating.userId;

    return AppCard(
      variant: AppCardVariant.outlined,
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Avatar
          AppAvatar(
            url: null, // Assuming no URL for now, can add if available
            initials: userRating.userName.isNotEmpty
                ? userRating.userName[0].toUpperCase()
                : '?',
            backgroundColor: isCurrentUser
                ? colorScheme.primary
                : colorScheme.secondary,
            foregroundColor: colorScheme.onPrimary,
            size: 40,
          ),

          const SizedBox(width: AppSpacing.md),

          // User Info and Rating
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      userRating.userName,
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    if (isCurrentUser) ...[
                      const SizedBox(width: 8),
                      // "You" badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'You',
                          style: AppTypography.bodySmall.copyWith(
                            color: colorScheme.onPrimary,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                    const Spacer(),
                    // Rating Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(
                          alpha: 0.2,
                        ), // Or colorScheme.tertiary
                        borderRadius: AppBorderRadius.smRadius,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 14,
                            color: AppColors.warning,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${userRating.ratingValue.toInt()}/${ratingItem.ratingScale}',
                            style: AppTypography.bodySmall.copyWith(
                              fontWeight: FontWeight.w700,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (userRating.comment != null &&
                    userRating.comment!.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    userRating.comment!,
                    style: AppTypography.bodySmall.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.star_outline_rounded,
                color: colorScheme.primary,
                size: 48,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'No ratings yet',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Be the first to rate this item!',
              style: AppTypography.bodyMedium.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateAverageRating() {
    if (ratingItem.ratings.isEmpty) return 0.0;
    final sum = ratingItem.ratings.fold<double>(
      0.0,
      (sum, rating) => sum + rating.ratingValue,
    );
    return sum / ratingItem.ratings.length;
  }

  void _showRatingDialog(RatingItemController controller) {
    final currentUserRating = controller.getCurrentUserRating(ratingItem.id);

    Get.bottomSheet(
      AddUserRatingDialog(
        ratingItem: ratingItem,
        existingRating: currentUserRating,
        onRatingSubmitted: (ratingValue, comment) async {
          if (currentUserRating != null) {
            await controller.updateUserRating(
              ratingItemId: ratingItem.id,
              ratingValue: ratingValue,
              comment: comment,
            );
          } else {
            await controller.addUserRating(
              ratingItemId: ratingItem.id,
              ratingValue: ratingValue,
              comment: comment,
            );
          }
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void _navigateToEditRating(BuildContext context) {
    Get.toNamed(
      RouteNames.groups.editRatingPage,
      arguments: {'rating': ratingItem},
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    RatingItemController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) => AppDialog(
        title: 'Delete Item',
        description:
            'Are you sure you want to delete "${ratingItem.name}"? This action cannot be undone.',
        primaryActionText: 'Delete',
        onPrimaryAction: () {
          Navigator.of(context).pop();
          controller.deleteRatingItem(ratingItem.id);
          Get.back(); // Go back to group details
        },
        secondaryActionText: 'Cancel',
        isDestructive: true,
      ),
    );
  }
}
