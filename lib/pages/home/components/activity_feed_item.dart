import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/__core.dart';
import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';

import '../home_controller.dart';

class ActivityFeedItem extends StatelessWidget {
  final RatingItem item;

  const ActivityFeedItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppCard(
      variant: AppCardVariant.elevated,
      onTap: () => controller.navigateToRatingDetails(item),
      padding: const EdgeInsets.all(AppSpacing.md),
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          if (item.imageUrl != null && item.imageUrl!.isNotEmpty)
            AppAvatar(url: item.imageUrl!, size: 40)
          else
            Container(
              width: 40, // AppAvatarSize.md default is 40
              height: 40,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: AppBorderRadius.mdRadius,
              ),
              child: Icon(
                Icons.image,
                color: colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),

          const SizedBox(width: AppSpacing.md),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: "User rated Item" (simplified for now as "Item Name")
                Text(
                  item.name,
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'in ${item.location} • ${_timeAgo(item.updatedAt ?? item.createdAt)}',
                  style: AppTypography.labelSmall.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),

                // Rating Badge + Description
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getRatingColor(
                          item.averageRating,
                          item.ratingScale,
                        ).withValues(alpha: 0.1),
                        borderRadius: AppBorderRadius.smRadius,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 12,
                            color: _getRatingColor(
                              item.averageRating,
                              item.ratingScale,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item.averageRating.toStringAsFixed(1),
                            style: AppTypography.labelSmall.copyWith(
                              color: _getRatingColor(
                                item.averageRating,
                                item.ratingScale,
                              ),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        item.description ?? '',
                        style: AppTypography.bodySmall.copyWith(
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _timeAgo(DateTime date) {
    final difference = DateTime.now().difference(date);
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}';
    }
  }

  Color _getRatingColor(double rating, int scale) {
    final normalized = rating / scale;
    if (normalized >= 0.8) return AppColors.success;
    if (normalized >= 0.5) return AppColors.primary;
    return AppColors.error;
  }
}
