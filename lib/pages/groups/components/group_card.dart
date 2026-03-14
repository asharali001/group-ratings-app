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
      variant: AppCardVariant.outlined,
      padding: EdgeInsets.zero,
      onTap: () => groupsListController.navigateToGroupRatings(group),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left accent bar
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppBorderRadius.lg),
                  bottomLeft: Radius.circular(AppBorderRadius.lg),
                ),
              ),
            ),
            // Card content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left: emoji circle
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          group.category.emoji,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    // Right: all content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Overline: ENTRY #XX · CATEGORY
                          Text(
                            'ENTRY #${(index + 1).toString().padLeft(2, '0')} \u00B7 ${group.category.displayName.toUpperCase()}',
                            style: AppTypography.labelSmall.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 10,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          // Name row + options menu
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                          const SizedBox(height: AppSpacing.xs),
                          // Metadata row: members • items
                          Row(
                            children: [
                              Icon(
                                Icons.people_rounded,
                                size: 13,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                '${group.members.length}',
                                style: AppTypography.bodySmall.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.xs,
                                ),
                                child: Text(
                                  '\u2022',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.star_rounded,
                                size: 13,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                '${group.ratingItemsCount}',
                                style: AppTypography.bodySmall.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          if (group.description != null &&
                              group.description!.isNotEmpty) ...[
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              group.description!,
                              style: AppTypography.bodySmall.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                height: 1.4,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
        onSecondaryAction: () {},
      ),
    );
  }

  void _copyGroupCodeToClipboard(String code) {
    Clipboard.setData(ClipboardData(text: code));
    Get.snackbar('Success', 'Group code copied');
  }
}
