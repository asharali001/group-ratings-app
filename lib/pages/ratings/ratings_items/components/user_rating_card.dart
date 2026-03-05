import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/core/__core.dart';
import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';

class UserRatingCard extends StatelessWidget {
  final UserRating userRating;
  final RatingItem ratingItem;
  final bool isCurrentUser;

  const UserRatingCard({
    super.key,
    required this.userRating,
    required this.ratingItem,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final normalized = userRating.normalizedValue.clamp(0.0, 1.0);
    final ratingColor = _getRatingColor(normalized);
    final scale = ratingItem.ratingScale;

    return AppCard(
      variant: AppCardVariant.outlined,
      padding: const EdgeInsets.all(AppSpacing.md),
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top: star row or rating pill
          if (scale <= 5)
            _buildStarRow(normalized, colorScheme)
          else
            _buildRatingPill(ratingColor, colorScheme),

          // Comment text
          if (userRating.comment != null &&
              userRating.comment!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              userRating.comment!,
              style: AppTypography.bodyMedium.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ],

          const SizedBox(height: AppSpacing.md),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.sm),

          // Bottom row: avatar + name + "You" badge + date
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppAvatar(
                url: null,
                initials: userRating.userName.isNotEmpty
                    ? userRating.userName[0].toUpperCase()
                    : '?',
                backgroundColor: isCurrentUser
                    ? colorScheme.primary
                    : colorScheme.secondary,
                foregroundColor: colorScheme.onPrimary,
                size: 36,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                userRating.userName,
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              if (isCurrentUser) ...[
                const SizedBox(width: AppSpacing.xs),
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
              Text(
                DateFormat.yMMMd().format(userRating.createdAt),
                style: AppTypography.labelSmall.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStarRow(double normalized, ColorScheme colorScheme) {
    final filledStars = (normalized * 5).round().clamp(0, 5);
    return Row(
      children: List.generate(5, (i) {
        return Icon(
          i < filledStars ? Icons.star_rounded : Icons.star_outline_rounded,
          size: 22,
          color: i < filledStars
              ? AppColors.warning
              : colorScheme.outlineVariant,
        );
      }),
    );
  }

  Widget _buildRatingPill(Color ratingColor, ColorScheme colorScheme) {
    final value = userRating.ratingValue;
    final displayValue = value == value.truncate()
        ? value.toInt().toString()
        : value.toStringAsFixed(1);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: ratingColor.withValues(alpha: 0.12),
        borderRadius: AppBorderRadius.smRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            displayValue,
            style: AppTypography.titleLarge.copyWith(
              color: ratingColor,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            ' / ${ratingItem.ratingScale}',
            style: AppTypography.bodySmall.copyWith(
              color: ratingColor.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Color _getRatingColor(double normalized) {
    if (normalized < 0.33) return AppColors.error;
    if (normalized < 0.66) return AppColors.warning;
    return AppColors.success;
  }
}
