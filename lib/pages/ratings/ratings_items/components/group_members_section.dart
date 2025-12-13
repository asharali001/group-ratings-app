import 'package:flutter/material.dart';

import '/core/__core.dart';
import '/styles/__styles.dart';
import '/constants/enums.dart';

class GroupMembersSection extends StatefulWidget {
  final Group group;

  const GroupMembersSection({super.key, required this.group});

  @override
  State<GroupMembersSection> createState() => _GroupMembersSectionState();
}

class _GroupMembersSectionState extends State<GroupMembersSection> {
  bool _isExpanded = false;
  static const int _maxDisplayedMembers = 6;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final members = widget.group.members;
    final colorScheme = theme.colorScheme;
    final totalMembers = members.length;
    final shouldShowExpandButton = totalMembers > _maxDisplayedMembers;
    final displayedMembers = _isExpanded
        ? members
        : members.take(_maxDisplayedMembers).toList();

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Members ($totalMembers)',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              if (shouldShowExpandButton)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 4,
                    ),
                  ),
                  child: Text(
                    _isExpanded ? 'Show less' : 'Show all',
                    style: AppTypography.bodySmall.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              ...displayedMembers.map(
                (member) => _buildMemberChip(context, member),
              ),
              if (!_isExpanded && shouldShowExpandButton)
                _buildMoreChip(context, totalMembers - _maxDisplayedMembers),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMemberChip(BuildContext context, GroupMember member) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isAdmin = member.role == GroupMemberRole.admin;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: isAdmin
            ? colorScheme.primary.withValues(alpha: 0.1)
            : colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(AppBorderRadius.full),
        border: Border.all(
          color: isAdmin
              ? colorScheme.primary.withValues(alpha: 0.3)
              : colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Avatar
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isAdmin ? colorScheme.primary : colorScheme.secondary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                member.name.isNotEmpty ? member.name[0].toUpperCase() : '?',
                style: AppTypography.bodySmall.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          // Name
          Text(
            member.name,
            style: AppTypography.bodyMedium.copyWith(
              color: isAdmin ? colorScheme.primary : colorScheme.onSurface,
              fontWeight: isAdmin ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoreChip(BuildContext context, int remainingCount) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = true;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppBorderRadius.full),
          border: Border.all(color: colorScheme.primary.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_rounded, size: 16, color: colorScheme.primary),
            const SizedBox(width: 4),
            Text(
              '$remainingCount more',
              style: AppTypography.bodyMedium.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
