import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:get/get.dart';

import '../rating_items_controller.dart';
import '/core/__core.dart';
import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';
import 'add_user_rating_dialog.dart';

class RatingItemCard extends StatelessWidget {
  final RatingItem rating;
  final bool canEdit;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final RatingItemController? controller;

  const RatingItemCard({
    super.key,
    required this.rating,
    required this.canEdit,
    this.onEdit,
    this.onDelete,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppCard(
      variant: AppCardVariant.outlined,
      padding: EdgeInsets.zero, // Padding handled internally by sub-widgets
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroImage(context),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: AppSpacing.md),
                if (rating.description?.isNotEmpty == true) ...[
                  Text(
                    rating.description!,
                    style: AppTypography.bodyMedium.copyWith(
                      color: colorScheme.onSurface,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                _buildUserRatingsSection(context),
                const SizedBox(height: AppSpacing.md),
                _buildFooter(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppBorderRadius.xl),
          topRight: Radius.circular(AppBorderRadius.xl),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary.withValues(alpha: 0.1),
            colorScheme.primary.withValues(alpha: 0.05),
          ],
        ),
      ),
      child: rating.imageUrl != null && rating.imageUrl!.isNotEmpty
          ? ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppBorderRadius.xl),
                topRight: Radius.circular(AppBorderRadius.xl),
              ),
              child: Image.network(
                rating.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholderIcon(context);
                },
              ),
            )
          : _buildPlaceholderIcon(context),
    );
  }

  Widget _buildPlaceholderIcon(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.image_outlined, color: colorScheme.primary, size: 48),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                rating.name,
                style: AppTypography.bodyLarge.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: AppTypography.semiBold,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              if (rating.location?.isNotEmpty == true)
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: colorScheme.primary,
                      size: 16,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      rating.location!,
                      style: AppTypography.bodyMedium.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),

        const SizedBox(width: AppSpacing.sm),

        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (canEdit)
              _buildActionButton(
                context: context,
                icon: EvaIcons.editOutline,
                onTap: onEdit,
                color: colorScheme.primary,
                tooltip: 'Edit Rating',
              ),
            if (canEdit) const SizedBox(width: 12),
            _buildActionButton(
              context: context,
              icon: EvaIcons.trash2Outline,
              onTap: onDelete,
              color: colorScheme.error,
              tooltip: 'Delete Rating',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback? onTap,
    required Color color,
    required String tooltip,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Tooltip(
      message: tooltip,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(AppBorderRadius.full),
          border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppBorderRadius.full),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Icon(icon, size: 20, color: color),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserRatingsSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasRatings = rating.ratings.isNotEmpty;
    final currentUserRating = controller?.getCurrentUserRating(rating.id);
    final canRate = controller != null && controller!.canCreateRating();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.star_rounded,
                color: colorScheme.primary,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ratings',
                    style: AppTypography.titleMedium.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '${rating.ratings.length} rating${rating.ratings.length == 1 ? '' : 's'}',
                    style: AppTypography.bodySmall.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (canRate) _buildRateButton(context, currentUserRating),
          ],
        ),

        const SizedBox(height: 20),

        // Ratings List
        if (hasRatings) ...[
          ...rating.ratings.map(
            (userRating) => _buildRatingItem(context, userRating),
          ),
        ] else ...[
          _buildEmptyState(context),
        ],
      ],
    );
  }

  Widget _buildRateButton(BuildContext context, UserRating? currentUserRating) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: colorScheme.primary,
      borderRadius: AppBorderRadius.mdRadius,
      child: InkWell(
        onTap: _showRatingDialog,
        borderRadius: AppBorderRadius.mdRadius,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                currentUserRating != null
                    ? Icons.edit_rounded
                    : Icons.add_rounded,
                size: 16,
                color: colorScheme.onPrimary,
              ),
              const SizedBox(width: 6),
              Text(
                currentUserRating != null ? 'Edit' : 'Rate',
                style: AppTypography.bodySmall.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Text(
          'No ratings yet. Be the first to rate this item!',
          style: AppTypography.bodyMedium.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildRatingItem(BuildContext context, UserRating userRating) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isCurrentUser =
        controller?.hasUserRated(rating.id) == true &&
        controller?.getCurrentUserRating(rating.id)?.userId ==
            userRating.userId;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCurrentUser
            ? colorScheme.primary.withValues(alpha: 0.08)
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrentUser
              ? colorScheme.primary.withValues(alpha: 0.2)
              : colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Avatar
          AppAvatar(
            url: null, // Use user image if available
            initials: userRating.userName.isNotEmpty
                ? userRating.userName[0].toUpperCase()
                : '?',
            size: 40,
            backgroundColor: isCurrentUser
                ? colorScheme.primary
                : colorScheme.secondary,
            foregroundColor: colorScheme.onPrimary,
          ),

          const SizedBox(width: 16),

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
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (isCurrentUser) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(8),
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
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 16,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${userRating.ratingValue.toInt()}/${rating.ratingScale}',
                      style: AppTypography.bodyMedium.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                if (userRating.comment != null &&
                    userRating.comment!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    userRating.comment!,
                    style: AppTypography.bodySmall.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),

          // Rating Date
          Text(
            _formatDate(userRating.createdAt),
            style: AppTypography.bodySmall.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppBorderRadius.full),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.schedule_outlined,
              size: 14,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              _formatDate(rating.createdAt),
              style: AppTypography.bodySmall.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRatingDialog() {
    if (controller == null) return;

    final currentUserRating = controller!.getCurrentUserRating(rating.id);

    Get.bottomSheet(
      AddUserRatingDialog(
        ratingItem: rating,
        existingRating: currentUserRating,
        onRatingSubmitted: (ratingValue, comment) async {
          if (currentUserRating != null) {
            await controller!.updateUserRating(
              ratingItemId: rating.id,
              ratingValue: ratingValue,
              comment: comment,
            );
          } else {
            await controller!.addUserRating(
              ratingItemId: rating.id,
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks == 1 ? '' : 's'} ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
