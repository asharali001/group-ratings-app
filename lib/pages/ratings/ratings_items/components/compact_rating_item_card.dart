import 'package:flutter/material.dart';

import '/core/__core.dart';
import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';

class CompactRatingItemCard extends StatelessWidget {
  final RatingItem item;
  final VoidCallback onTap;

  const CompactRatingItemCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final averageRating = _calculateAverageRating();
    final ratingCount = item.ratings.length;

    return AppCard(
      variant: AppCardVariant.elevated,
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          // Image Thumbnail
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: AppBorderRadius.mdRadius,
            ),
            child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                ? ClipRRect(
                    borderRadius: AppBorderRadius.mdRadius,
                    child: Image.network(
                      item.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildPlaceholderIcon(context);
                      },
                    ),
                  )
                : _buildPlaceholderIcon(context),
          ),

          const SizedBox(width: AppSpacing.md),

          // Item Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.location?.isNotEmpty == true) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item.location!,
                          style: AppTypography.bodySmall.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 16,
                      color: AppColors.warning,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      ratingCount > 0
                          ? '${averageRating.toStringAsFixed(1)} • $ratingCount rating${ratingCount == 1 ? '' : 's'}'
                          : 'No ratings yet',
                      style: AppTypography.bodySmall.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Chevron
          Icon(
            Icons.chevron_right_rounded,
            color: colorScheme.onSurfaceVariant,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderIcon(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Center(
      child: Icon(
        Icons.image_outlined,
        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        size: 28,
      ),
    );
  }

  double _calculateAverageRating() {
    if (item.ratings.isEmpty) return 0.0;

    final sum = item.ratings.fold<double>(
      0.0,
      (sum, rating) => sum + rating.ratingValue,
    );

    return sum / item.ratings.length;
  }
}
