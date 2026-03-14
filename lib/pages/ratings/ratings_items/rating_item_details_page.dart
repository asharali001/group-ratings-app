import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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

    return Obx(() {
      final currentItem = controller.getRatingById(ratingItem.id) ?? ratingItem;
      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;
      final hasImage =
          currentItem.imageUrl != null && currentItem.imageUrl!.isNotEmpty;

      return Scaffold(
        body: CustomScrollView(
          slivers: [
            // SliverAppBar with hero image
            SliverAppBar(
              expandedHeight: 280,
              pinned: true,
              leading: _ScrimmedIconButton(
                icon: Icons.arrow_back,
                onPressed: () => Get.back(),
              ),
              actions: [
                if (controller.canEditRating(currentItem))
                  _ScrimmedIconButton(
                    icon: Icons.edit_outlined,
                    onPressed: () =>
                        _navigateToEditRating(context, currentItem),
                  ),
                _ScrimmedIconButton(
                  icon: Icons.delete_outline,
                  onPressed: () =>
                      _showDeleteDialog(context, controller, currentItem),
                ),
                const SizedBox(width: AppSpacing.xs),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Image or gradient fallback
                    if (hasImage)
                      Image.network(
                        currentItem.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildGradientFallback(colorScheme);
                        },
                      )
                    else
                      _buildGradientFallback(colorScheme),

                    // Bottom gradient overlay
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.6),
                            ],
                            stops: const [0.0, 0.4, 1.0],
                          ),
                        ),
                      ),
                    ),

                    // Bottom-left: Item name + location
                    Positioned(
                      bottom: AppSpacing.lg,
                      left: AppSpacing.lg,
                      right: AppSpacing.lg,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentItem.name,
                            style: AppTypography.titleLarge.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          if (currentItem.location?.isNotEmpty == true) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.white70,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  currentItem.location!,
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Description
                    if (currentItem.description?.isNotEmpty == true) ...[
                      Text(
                        currentItem.description!,
                        style: AppTypography.bodyMedium.copyWith(
                          height: 1.6,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ],

                    // Created date
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 14,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          'Added ${DateFormat('MMM d, yyyy').format(currentItem.createdAt)}',
                          style: AppTypography.bodySmall.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Rating overview (avg + distribution)
                    // RatingOverviewSection(ratingItem: currentItem),
                    // const SizedBox(height: AppSpacing.lg),

                    // Reviews section
                    SectionHeader(
                      title: 'Reviews (${currentItem.ratings.length})',
                    ),
                    const SizedBox(height: AppSpacing.md),

                    if (currentItem.ratings.isNotEmpty)
                      ...currentItem.ratings.map((rating) {
                        final isCurrent = _isCurrentUser(
                          rating,
                          controller,
                          currentItem,
                        );
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: UserRatingCard(
                            userRating: rating,
                            ratingItem: currentItem,
                            isCurrentUser: isCurrent,
                            onEdit: isCurrent
                                ? () =>
                                      _showRatingDialog(controller, currentItem)
                                : null,
                            onDelete: isCurrent
                                ? () => _showDeleteUserRatingDialog(
                                    context,
                                    controller,
                                    currentItem,
                                  )
                                : null,
                          ),
                        );
                      })
                    else
                      _buildEmptyState(context),

                    // Bottom padding for FAB clearance
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
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
                    onPressed: () => _showRatingDialog(controller, currentItem),
                    text: controller.hasUserRated(currentItem.id)
                        ? 'Edit Rating'
                        : 'Rate',
                    icon: controller.hasUserRated(currentItem.id)
                        ? Icons.edit_rounded
                        : Icons.add_rounded,
                  ),
                ),
              )
            : null,
      );
    });
  }

  Widget _buildGradientFallback(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary.withValues(alpha: 0.3),
            colorScheme.secondary.withValues(alpha: 0.2),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.star_rounded,
          size: 48,
          color: Colors.white.withValues(alpha: 0.3),
        ),
      ),
    );
  }

  bool _isCurrentUser(
    UserRating userRating,
    RatingItemController controller,
    RatingItem currentItem,
  ) {
    return controller.hasUserRated(currentItem.id) &&
        controller.getCurrentUserRating(currentItem.id)?.userId ==
            userRating.userId;
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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

  void _showRatingDialog(
    RatingItemController controller,
    RatingItem currentItem,
  ) {
    final currentUserRating = controller.getCurrentUserRating(currentItem.id);

    Get.bottomSheet(
      AddUserRatingDialog(
        ratingItem: currentItem,
        existingRating: currentUserRating,
        onRatingSubmitted: (ratingValue, comment) async {
          if (currentUserRating != null) {
            await controller.updateUserRating(
              ratingItemId: currentItem.id,
              ratingValue: ratingValue,
              comment: comment,
            );
          } else {
            await controller.addUserRating(
              ratingItemId: currentItem.id,
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

  void _navigateToEditRating(BuildContext context, RatingItem currentItem) {
    Get.toNamed(
      RouteNames.groups.editRatingPage,
      arguments: {'rating': currentItem},
    );
  }

  void _showDeleteUserRatingDialog(
    BuildContext context,
    RatingItemController controller,
    RatingItem currentItem,
  ) {
    showDialog(
      context: context,
      builder: (context) => AppDialog(
        title: 'Delete Rating',
        description:
            'Are you sure you want to delete your rating? This action cannot be undone.',
        primaryActionText: 'Delete',
        onPrimaryAction: () {
          Navigator.of(context).pop();
          controller.removeUserRating(ratingItemId: currentItem.id);
        },
        secondaryActionText: 'Cancel',
        isDestructive: true,
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    RatingItemController controller,
    RatingItem currentItem,
  ) {
    showDialog(
      context: context,
      builder: (context) => AppDialog(
        title: 'Delete Item',
        description:
            'Are you sure you want to delete "${currentItem.name}"? This action cannot be undone.',
        primaryActionText: 'Delete',
        onPrimaryAction: () {
          Navigator.of(context).pop();
          controller.deleteRatingItem(currentItem.id);
          Get.back();
        },
        secondaryActionText: 'Cancel',
        isDestructive: true,
      ),
    );
  }
}

class _ScrimmedIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _ScrimmedIconButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.sm,
      ),
      child: Material(
        color: Colors.black.withValues(alpha: 0.35),
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }
}
