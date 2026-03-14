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
    final colorScheme = Theme.of(context).colorScheme;
    final averageRating = _calculateAverageRating();
    final ratingCount = item.ratings.length;

    return AppCard(
      variant: AppCardVariant.outlined,
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Left edge color indicator
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: _getIndicatorColor(),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppBorderRadius.md),
                  bottomLeft: Radius.circular(AppBorderRadius.md),
                ),
              ),
            ),

            const SizedBox(width: AppSpacing.sm),

            // Image Thumbnail
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Container(
                width: 72,
                height: 72,
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
            ),

            const SizedBox(width: AppSpacing.md),

            // Item Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
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
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.starGold.withValues(alpha: 0.15),
                            borderRadius: AppBorderRadius.fullRadius,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                size: 14,
                                color: AppColors.starGold,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                ratingCount > 0
                                    ? '${averageRating.toStringAsFixed(1)} / ${item.ratingScale}'
                                    : 'No ratings',
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.starGold,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (ratingCount > 0) ...[
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            '$ratingCount rating${ratingCount == 1 ? '' : 's'}',
                            style: AppTypography.bodySmall.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Chevron
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.md),
              child: Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getIndicatorColor() {
    if (item.ratings.isEmpty) return AppColors.outlineVariant;
    final avg = _calculateAverageRating();
    final normalized = avg / item.ratingScale;
    if (normalized < 0.33) return AppColors.error.withValues(alpha: 0.6);
    if (normalized < 0.66) return AppColors.warning.withValues(alpha: 0.6);
    return AppColors.success.withValues(alpha: 0.6);
  }

  Widget _buildPlaceholderIcon(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
