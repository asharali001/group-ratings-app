import 'package:flutter/material.dart';

import '/core/__core.dart';
import '/styles/__styles.dart';

class GroupHeaderSection extends StatelessWidget {
  final Group group;
  final int itemCount;

  const GroupHeaderSection({
    super.key,
    required this.group,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            group.name,
            style: AppTypography.titleLarge.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          if (group.description != null && group.description!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              group.description!,
              style: AppTypography.bodyMedium.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ],

          const SizedBox(height: AppSpacing.lg),

          // Stats Row
          Row(
            children: [
              _buildStat(
                context,
                icon: Icons.people_rounded,
                label:
                    '${group.memberIds.length} member${group.memberIds.length == 1 ? '' : 's'}',
                color: colorScheme.primary,
              ),
              const SizedBox(width: AppSpacing.xl),
              _buildStat(
                context,
                icon: Icons.star_rounded,
                label: '$itemCount item${itemCount == 1 ? '' : 's'}',
                color: AppColors.warning,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
