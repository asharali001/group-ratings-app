import 'package:flutter/material.dart';

import '/core/__core.dart';
import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';

class RatingOverviewSection extends StatelessWidget {
  final RatingItem ratingItem;

  const RatingOverviewSection({super.key, required this.ratingItem});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final ratings = ratingItem.ratings;
    final avgRating = _calculateAverageRating();
    final ratingCount = ratings.length;

    if (ratingCount == 0) {
      return AppCard(
        variant: AppCardVariant.flat,
        color: colorScheme.primary.withValues(alpha: 0.05),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Text(
              'No ratings yet',
              style: AppTypography.bodyMedium.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      );
    }

    return AppCard(
      variant: AppCardVariant.flat,
      color: colorScheme.primary.withValues(alpha: 0.05),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left column: average rating
          Column(
            children: [
              Text(
                avgRating.toStringAsFixed(1),
                style: AppTypography.headlineMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                '/ ${ratingItem.ratingScale}',
                style: AppTypography.bodySmall.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$ratingCount rating${ratingCount == 1 ? '' : 's'}',
                style: AppTypography.labelSmall.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(width: AppSpacing.lg),
          // Right column: distribution bar
          Expanded(
            child: RatingDistributionBar(
              ratings: ratings,
              ratingScale: ratingItem.ratingScale,
            ),
          ),
        ],
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
}
