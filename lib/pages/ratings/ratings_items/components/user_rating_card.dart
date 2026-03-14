import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/core/__core.dart';
import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';

class UserRatingCard extends StatelessWidget {
  final UserRating userRating;
  final RatingItem ratingItem;
  final bool isCurrentUser;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const UserRatingCard({
    super.key,
    required this.userRating,
    required this.ratingItem,
    required this.isCurrentUser,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final normalized = userRating.normalizedValue.clamp(0.0, 1.0);
    final scale = ratingItem.ratingScale;
    final filledStars = (normalized * 5).round().clamp(0, 5);

    return AppCard(
      variant: AppCardVariant.outlined,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: avatar + name + edit/delete actions
          Row(
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
                size: 32,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  userRating.userName,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              Text(
                DateFormat('MMM d').format(userRating.createdAt),
                style: AppTypography.bodySmall.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
              if (isCurrentUser) ...[
                if (onEdit != null)
                  TextButton(
                    onPressed: onEdit,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Edit',
                      style: AppTypography.bodySmall.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                if (onDelete != null)
                  TextButton(
                    onPressed: onDelete,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Delete',
                      style: AppTypography.bodySmall.copyWith(
                        color: colorScheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ],
          ),

          const SizedBox(height: AppSpacing.sm),

          // Rating row: stars + numeric "X/Y"
          Row(
            children: [
              ...List.generate(5, (i) {
                return Icon(
                  i < filledStars
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  size: 20,
                  color: i < filledStars
                      ? AppColors.starGold
                      : colorScheme.outlineVariant,
                );
              }),
              const SizedBox(width: AppSpacing.sm),
              Text(
                '${_formatRatingValue(userRating.ratingValue)}/$scale',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.starGold,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          // Comment text
          if (userRating.comment != null && userRating.comment!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              userRating.comment!,
              style: AppTypography.bodyMedium.copyWith(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatRatingValue(double value) {
    return value == value.truncate()
        ? value.toInt().toString()
        : value.toStringAsFixed(1);
  }
}
