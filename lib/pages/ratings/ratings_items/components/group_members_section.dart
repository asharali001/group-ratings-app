import 'package:flutter/material.dart';

import '/core/__core.dart';
import '/styles/__styles.dart';
import '/constants/enums.dart';
import '/ui_components/__ui_components.dart';

class GroupMembersSection extends StatefulWidget {
  final Group group;

  const GroupMembersSection({super.key, required this.group});

  @override
  State<GroupMembersSection> createState() => _GroupMembersSectionState();
}

class _GroupMembersSectionState extends State<GroupMembersSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final members = widget.group.members;
    final totalMembers = members.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Members ($totalMembers)',
          trailing: totalMembers > 5
              ? GestureDetector(
                  onTap: () => setState(() => _isExpanded = !_isExpanded),
                  child: Text(
                    _isExpanded ? 'Show less' : 'Show all',
                    style: AppTypography.bodySmall.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : null,
        ),
        const SizedBox(height: AppSpacing.sm),
        AvatarStack(
          avatars: members
              .map((m) => AvatarStackItem(name: m.name))
              .toList(),
          maxDisplay: 5,
          avatarSize: 36,
          onOverflowTap: () => setState(() => _isExpanded = true),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: AppCard(
              variant: AppCardVariant.flat,
              padding: EdgeInsets.zero,
              child: Column(
                children: members.asMap().entries.map((entry) {
                  final i = entry.key;
                  final member = entry.value;
                  return _buildMemberListItem(
                    context,
                    member,
                    showDivider: i < members.length - 1,
                  );
                }).toList(),
              ),
            ),
          ),
          crossFadeState: _isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 250),
        ),
      ],
    );
  }

  Widget _buildMemberListItem(
    BuildContext context,
    GroupMember member, {
    bool showDivider = true,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isAdmin = member.role == GroupMemberRole.admin;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              AppAvatar(
                initials: member.name.isNotEmpty
                    ? member.name[0].toUpperCase()
                    : '?',
                backgroundColor:
                    isAdmin ? colorScheme.primary : colorScheme.secondary,
                foregroundColor: colorScheme.onPrimary,
                size: 36,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.name,
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      isAdmin ? 'Admin' : 'Member',
                      style: AppTypography.bodySmall.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (isAdmin)
                Icon(
                  Icons.workspace_premium_rounded,
                  size: 18,
                  color: colorScheme.primary,
                ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: AppSpacing.md,
            endIndent: AppSpacing.md,
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
      ],
    );
  }
}
