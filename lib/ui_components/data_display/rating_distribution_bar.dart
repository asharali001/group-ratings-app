import 'package:flutter/material.dart';

import '/core/models/user_rating.dart';
import '/styles/__styles.dart';

class RatingDistributionBar extends StatelessWidget {
  final List<UserRating> ratings;
  final int ratingScale;

  const RatingDistributionBar({
    super.key,
    required this.ratings,
    required this.ratingScale,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final buckets = _buildBuckets();
    final maxCount =
        buckets.values.fold<int>(0, (max, v) => v > max ? v : max);

    // Calculate max label width based on longest label
    final maxLabelLength = buckets.keys
        .fold<int>(0, (max, k) => k.length > max ? k.length : max);
    final labelWidth = (maxLabelLength * 7.0).clamp(20.0, 56.0);

    return Column(
      children: buckets.entries.toList().reversed.map((entry) {
        final fraction = maxCount > 0 ? entry.value / maxCount : 0.0;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              SizedBox(
                width: labelWidth,
                child: Text(
                  entry.key,
                  style: AppTypography.labelSmall.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: ClipRRect(
                  borderRadius: AppBorderRadius.smRadius,
                  child: SizedBox(
                    height: 8,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerHighest,
                                borderRadius: AppBorderRadius.smRadius,
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeOut,
                              width: constraints.maxWidth * fraction,
                              decoration: BoxDecoration(
                                color: colorScheme.primary,
                                borderRadius: AppBorderRadius.smRadius,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              SizedBox(
                width: 20,
                child: Text(
                  '${entry.value}',
                  style: AppTypography.labelSmall.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Map<String, int> _buildBuckets() {
    final buckets = <String, int>{};

    if (ratingScale <= 5) {
      for (int i = 1; i <= ratingScale; i++) {
        buckets['$i'] = 0;
      }
      for (final r in ratings) {
        final key = '${r.ratingValue.round().clamp(1, ratingScale)}';
        buckets[key] = (buckets[key] ?? 0) + 1;
      }
    } else if (ratingScale <= 10) {
      for (int i = 1; i <= ratingScale; i += 2) {
        final end = (i + 1).clamp(1, ratingScale);
        buckets['$i-$end'] = 0;
      }
      for (final r in ratings) {
        final v = r.ratingValue.round().clamp(1, ratingScale);
        final bucketStart = ((v - 1) ~/ 2) * 2 + 1;
        final bucketEnd = (bucketStart + 1).clamp(1, ratingScale);
        final key = '$bucketStart-$bucketEnd';
        buckets[key] = (buckets[key] ?? 0) + 1;
      }
    } else {
      final bucketSize = ratingScale / 5;
      for (int i = 0; i < 5; i++) {
        final start = (i * bucketSize + 1).round();
        final end = ((i + 1) * bucketSize).round();
        buckets['$start-$end'] = 0;
      }
      for (final r in ratings) {
        final v = r.ratingValue.round().clamp(1, ratingScale);
        final bucketIndex = ((v - 1) / bucketSize).floor().clamp(0, 4);
        final start = (bucketIndex * bucketSize + 1).round();
        final end = ((bucketIndex + 1) * bucketSize).round();
        final key = '$start-$end';
        buckets[key] = (buckets[key] ?? 0) + 1;
      }
    }

    return buckets;
  }
}
