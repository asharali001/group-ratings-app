import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '/core/__core.dart';
import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';

import '../home_controller.dart';

class ActivityFeedSection extends GetView<HomeController> {
  const ActivityFeedSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Activity',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            GestureDetector(
              onTap: controller.navigateToMyRatingsTab,
              child: Text(
                'View All',
                style: AppTypography.labelLarge.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Obx(() {
          final items = controller.recentRatings;

          if (items.isEmpty) {
            return EmptyStateWidget(
              svgAsset: 'assets/animations/feedback.svg',
              title: 'No ratings yet',
              description:
                  'Join a group and start rating items with your friends',
              actions: [
                AppButton(
                  text: 'Join a Group',
                  variant: AppButtonVariant.outline,
                  icon: Icons.group_add_rounded,
                  onPressed: () =>
                      Get.toNamed(RouteNames.groups.joinGroupPage),
                ),
              ],
            );
          }

          return Column(
            children: items.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: _ActivityCard(
                  item: item,
                  onTap: () => controller.navigateToRatingDetails(item),
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final RatingItem item;
  final VoidCallback onTap;

  const _ActivityCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final avgRating = item.averageRating;
    final ratingCount = item.ratings.length;

    return AppCard(
      variant: AppCardVariant.outlined,
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Row(
        children: [
          // Image thumbnail
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppBorderRadius.lg),
                bottomLeft: Radius.circular(AppBorderRadius.lg),
              ),
            ),
            child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                ? ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppBorderRadius.lg),
                      bottomLeft: Radius.circular(AppBorderRadius.lg),
                    ),
                    child: Image.network(
                      item.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Center(
                        child: Icon(
                          Icons.image_outlined,
                          color: colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.4),
                          size: 28,
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Icon(
                      Icons.image_outlined,
                      color:
                          colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                      size: 28,
                    ),
                  ),
          ),
          const SizedBox(width: AppSpacing.md),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
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
                  if (item.description != null &&
                      item.description!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      item.description!,
                      style: AppTypography.bodySmall.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.xs),
                  // Rating badge
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
                                  ? avgRating.toStringAsFixed(1)
                                  : '—',
                              style: AppTypography.labelMedium.copyWith(
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
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
