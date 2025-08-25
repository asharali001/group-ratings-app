import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:get/get.dart';

import '../rating_items_controller.dart';
import '/core/__core.dart';
import '/styles/__styles.dart';
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
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: context.colors.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Image Section
          _buildHeroImage(context),

          // Content Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Title and Actions
                _buildHeader(context),

                const SizedBox(height: 16),

                // Description
                if (rating.description?.isNotEmpty == true) ...[
                  Text(
                    rating.description!,
                    style: AppTypography.bodyMedium.copyWith(
                      color: context.colors.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // User Ratings Section
                _buildUserRatingsSection(),

                // Footer
                const SizedBox(height: 20),
                _buildFooter(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage(BuildContext context) {
    return Container(
      height: 280,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.colors.primary.withValues(alpha: 0.1),
            context.colors.primary.withValues(alpha: 0.05),
          ],
        ),
      ),
      child: rating.imageUrl != null && rating.imageUrl!.isNotEmpty
          ? ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
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
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: context.colors.primary.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.image_outlined,
          color: context.colors.primary,
          size: 48,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
                style: AppTypography.headlineSmall.copyWith(
                  color: context.colors.onSurface,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              // Location
              if (rating.location?.isNotEmpty == true)
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: context.colors.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      rating.location!,
                      style: AppTypography.bodyMedium.copyWith(
                        color: context.colors.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),

        const SizedBox(width: 16),

        // Action Buttons
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (canEdit)
              _buildActionButton(
                context,
                icon: EvaIcons.editOutline,
                onTap: onEdit,
                color: context.colors.primary,
              ),
            if (canEdit) const SizedBox(width: 12),
            _buildActionButton(
              context,
              icon: EvaIcons.trash2Outline,
              onTap: onDelete,
              color: context.colors.error,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback? onTap,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Icon(icon, size: 20, color: color),
          ),
        ),
      ),
    );
  }

  Widget _buildUserRatingsSection() {
    final hasRatings = rating.ratings.isNotEmpty;
    final currentUserRating = controller?.getCurrentUserRating(rating.id);
    final canRate = controller != null && controller!.canCreateRating();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Get.context!.colors.surfaceContainerHighest.withValues(
          alpha: 0.5,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Get.context!.colors.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Get.context!.colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.star_rounded,
                  size: 18,
                  color: Get.context!.colors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User Ratings',
                      style: AppTypography.titleMedium.copyWith(
                        color: Get.context!.colors.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${rating.ratings.length} rating${rating.ratings.length == 1 ? '' : 's'}',
                      style: AppTypography.bodySmall.copyWith(
                        color: Get.context!.colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (canRate) _buildRateButton(currentUserRating),
            ],
          ),

          const SizedBox(height: 20),

          // Ratings List
          if (hasRatings) ...[
            ...rating.ratings.map((userRating) => _buildRatingItem(userRating)),
          ] else ...[
            _buildEmptyState(),
          ],
        ],
      ),
    );
  }

  Widget _buildRateButton(UserRating? currentUserRating) {
    return Container(
      decoration: BoxDecoration(
        color: Get.context!.colors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _showRatingDialog,
          borderRadius: BorderRadius.circular(12),
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
                  color: Get.context!.colors.onPrimary,
                ),
                const SizedBox(width: 6),
                Text(
                  currentUserRating != null ? 'Edit' : 'Rate',
                  style: AppTypography.bodySmall.copyWith(
                    color: Get.context!.colors.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Get.context!.colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Get.context!.colors.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Get.context!.colors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.star_outline_rounded,
              size: 16,
              color: Get.context!.colors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'No ratings yet. Be the first to rate this item!',
              style: AppTypography.bodyMedium.copyWith(
                color: Get.context!.colors.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingItem(UserRating userRating) {
    final isCurrentUser =
        controller?.hasUserRated(rating.id) == true &&
        controller?.getCurrentUserRating(rating.id)?.userId ==
            userRating.userId;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCurrentUser
            ? Get.context!.colors.primary.withValues(alpha: 0.08)
            : Get.context!.colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrentUser
              ? Get.context!.colors.primary.withValues(alpha: 0.2)
              : Get.context!.colors.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          // User Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isCurrentUser
                  ? Get.context!.colors.primary
                  : Get.context!.colors.onSurfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                userRating.userName.isNotEmpty
                    ? userRating.userName[0].toUpperCase()
                    : '?',
                style: AppTypography.titleSmall.copyWith(
                  color: Get.context!.colors.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
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
                        color: Get.context!.colors.onSurface,
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
                          color: Get.context!.colors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'You',
                          style: AppTypography.bodySmall.copyWith(
                            color: Get.context!.colors.onPrimary,
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
                    Icon(
                      Icons.star_rounded,
                      size: 16,
                      color: Get.context!.colors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${userRating.ratingValue.toInt()}/${rating.ratingScale}',
                      style: AppTypography.bodyMedium.copyWith(
                        color: Get.context!.colors.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Rating Date
          Text(
            _formatDate(userRating.createdAt),
            style: AppTypography.bodySmall.copyWith(
              color: Get.context!.colors.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: context.colors.onSurfaceVariant.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.schedule_outlined,
                size: 14,
                color: context.colors.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                _formatDate(rating.createdAt),
                style: AppTypography.bodySmall.copyWith(
                  color: context.colors.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        if (rating.ratings.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  context.colors.primary.withValues(alpha: 0.1),
                  context.colors.primary.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: context.colors.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star_rounded,
                  size: 14,
                  color: context.colors.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  '${rating.ratings.length} rating${rating.ratings.length == 1 ? '' : 's'}',
                  style: AppTypography.bodySmall.copyWith(
                    color: context.colors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _showRatingDialog() {
    if (controller == null) return;

    final currentUserRating = controller!.getCurrentUserRating(rating.id);

    Get.dialog(
      AddUserRatingDialog(
        ratingItem: rating,
        existingRating: currentUserRating,
        onRatingSubmitted: (ratingValue) async {
          if (currentUserRating != null) {
            await controller!.updateUserRating(
              ratingItemId: rating.id,
              ratingValue: ratingValue,
            );
          } else {
            await controller!.addUserRating(
              ratingItemId: rating.id,
              ratingValue: ratingValue,
            );
          }
        },
      ),
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
