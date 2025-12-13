import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '/core/__core.dart';
import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';

import '../groups_list/groups_list_controller.dart';

class GroupCard extends StatelessWidget {
  final Group group;
  final bool isCreator;
  final int index;

  const GroupCard({
    super.key,
    required this.group,
    required this.isCreator,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final groupsListController = Get.find<GroupsListController>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppCard(
      variant: AppCardVariant.flat,
      padding: const EdgeInsets.all(AppSpacing.md),
      onTap: () => groupsListController.navigateToGroupRatings(group),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  group.name,
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _buildOptionsMenu(context),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              _buildChip(
                label: isCreator ? 'Owner' : 'Member',
                fg: colorScheme.primary,
                bg: colorScheme.primary.withValues(alpha: 0.1),
              ),
              _buildCodeChip(colorScheme),
              _buildChip(
                label: group.category.displayName,
                fg: colorScheme.onSurface,
                bg: colorScheme.surfaceContainer,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            group.description ?? 'No description',
            style: AppTypography.bodyMedium.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }

  Widget _buildOptionsMenu(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      height: 24,
      width: 24,
      child: PopupMenuButton<String>(
        padding: EdgeInsets.zero,
        icon: Icon(
          Icons.more_horiz,
          size: 20,
          color: colorScheme.onSurfaceVariant,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: AppBorderRadius.mdRadius,
        ),
        color: colorScheme.surfaceContainer,
        onSelected: (value) {
          if (value == 'edit') {
            _navigateToEditGroup();
          } else if (value == 'copy') {
            _copyGroupCodeToClipboard(group.groupCode);
          } else if (value == 'leave') {
            _showLeaveGroupDialog(context);
          }
        },
        itemBuilder: (context) => [
          if (isCreator)
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  const Icon(EvaIcons.editOutline, size: 18),
                  const SizedBox(width: 12),
                  Text('Edit Group', style: AppTypography.bodyMedium),
                ],
              ),
            ),
          PopupMenuItem(
            value: 'copy',
            child: Row(
              children: [
                const Icon(EvaIcons.copyOutline, size: 18),
                const SizedBox(width: 12),
                Text('Copy Code', style: AppTypography.bodyMedium),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'leave',
            child: Row(
              children: [
                Icon(
                  isCreator ? EvaIcons.trash2Outline : EvaIcons.logOutOutline,
                  size: 18,
                  color: colorScheme.error,
                ),
                const SizedBox(width: 12),
                Text(
                  isCreator ? 'Delete Group' : 'Leave Group',
                  style: TextStyle(color: colorScheme.error),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToEditGroup() {
    Get.toNamed(RouteNames.groups.editGroupPage, arguments: {'group': group});
  }

  void _showLeaveGroupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AppDialog(
        title: 'Confirm Action',
        description: isCreator
            ? 'Delete group "${group.name}"? This cannot be undone.'
            : 'Leave group "${group.name}"?',
        primaryActionText: isCreator ? 'Delete' : 'Leave',
        secondaryActionText: 'Cancel',
        isDestructive: true,
        onPrimaryAction: () {
          Get.find<GroupsListController>().leaveGroup(group.id);
        },
        onSecondaryAction: () {
          // Dialog auto-closes, no need to manually pop
        },
      ),
    );
  }

  void _copyGroupCodeToClipboard(String code) {
    Clipboard.setData(ClipboardData(text: code));
    Get.snackbar('Success', 'Group code copied');
  }

  Widget _buildChip({
    required String label,
    required Color fg,
    required Color bg,
    IconData? icon,
    bool isOutlined = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppBorderRadius.smRadius,
        border: isOutlined
            ? Border.all(color: fg.withValues(alpha: 0.4))
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppTypography.labelMedium.copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeChip(ColorScheme colorScheme) {
    return GestureDetector(
      onTap: () => _copyGroupCodeToClipboard(group.groupCode),
      child: _buildChip(
        label: group.groupCode,
        fg: colorScheme.onSurface,
        bg: colorScheme.surfaceContainer,
        icon: Icons.code_rounded,
        isOutlined: true,
      ),
    );
  }
}
