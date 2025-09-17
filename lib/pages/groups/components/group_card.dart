import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '/core/__core.dart';
import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';
import '/constants/enums.dart';

import '../group_controller.dart';

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
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        border: Border.all(color: AppColors.outline),
        borderRadius: BorderRadius.circular(AppBorderRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: AppSpacing.lg),
          Text(
            group.description!,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.onSurface,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.name,
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: AppTypography.semiBold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _buildStatusChips(),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            _buildActionButtons(),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusChips() {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.xs,
      children: [
        // Role chip
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: isCreator ? AppColors.primary : AppColors.secondary,
            borderRadius: BorderRadius.circular(AppBorderRadius.round),
          ),
          child: Text(
            isCreator ? 'Creator' : 'Member',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.white,
              fontWeight: AppTypography.semiBold,
            ),
          ),
        ),
        // Group code chip
        GestureDetector(
          onTap: () => _copyGroupCodeToClipboard(group.groupCode),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.cardBackgroundHighest,
              borderRadius: BorderRadius.circular(AppBorderRadius.round),
              border: Border.all(color: AppColors.outline),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.code_rounded,
                  size: 12,
                  color: AppColors.onSurface,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  group.groupCode,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: AppTypography.medium,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
        ),
        // Category chip
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: AppColors.blue.withValues(alpha: 0.02),
            borderRadius: BorderRadius.circular(AppBorderRadius.round),
            border: Border.all(color: AppColors.blue.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(group.category.emoji, style: const TextStyle(fontSize: 12)),
              const SizedBox(width: AppSpacing.xs),
              Text(
                group.category.displayName,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.blue,
                  fontWeight: AppTypography.medium,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Row(
          children: [
            _buildFooterItem(
              icon: Icons.people_rounded,
              label:
                  '${group.memberIds.length} member${group.memberIds.length == 1 ? '' : 's'}',
              color: AppColors.primary,
            ),
            const SizedBox(width: AppSpacing.lg),
            _buildFooterItem(
              icon: Icons.star_rounded,
              label: '${group.ratingItemsCount} ratings',
              color: AppColors.yellow,
            ),
            const Spacer(),
            _buildFooterItem(
              icon: Icons.schedule_rounded,
              label: _formatDate(group.createdAt),
              color: AppColors.onSurface,
              isDate: true,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        _buildMembersPreview(),
      ],
    );
  }

  Widget _buildMembersPreview() {
    final displayMembers = group.members.take(3).toList();
    final remainingCount = group.members.length - 3;

    return Row(
      children: [
        const Icon(
          Icons.people_outline_rounded,
          size: 16,
          color: AppColors.textLight,
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          'Members: ',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textLight,
            fontWeight: AppTypography.medium,
          ),
        ),
        Expanded(
          child: Row(
            children: [
              ...displayMembers.map(
                (member) => Container(
                  margin: const EdgeInsets.only(right: AppSpacing.xs),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: member.role == GroupMemberRole.admin
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                    border: Border.all(
                      color: member.role == GroupMemberRole.admin
                          ? AppColors.primary.withValues(alpha: 0.3)
                          : AppColors.outline,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (member.role == GroupMemberRole.admin)
                        const Icon(
                          Icons.admin_panel_settings_rounded,
                          size: 12,
                          color: AppColors.primary,
                        ),
                      if (member.role == GroupMemberRole.admin)
                        const SizedBox(width: AppSpacing.xs),
                      Text(
                        member.name,
                        style: AppTypography.bodySmall.copyWith(
                          color: member.role == GroupMemberRole.admin
                              ? AppColors.primary
                              : AppColors.text,
                          fontWeight: AppTypography.medium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (remainingCount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                    border: Border.all(color: AppColors.outline),
                  ),
                  child: Text(
                    '+$remainingCount more',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textLight,
                      fontWeight: AppTypography.medium,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooterItem({
    required IconData icon,
    required String label,
    required Color color,
    bool isDate = false,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.onSurface,
            fontWeight: AppTypography.medium,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Edit button for creator
        if (isCreator) ...[
          _buildActionButton(
            icon: EvaIcons.editOutline,
            onTap: _navigateToEditGroup,
            color: AppColors.blue,
            tooltip: 'Edit Group',
          ),
          const SizedBox(width: AppSpacing.sm),
        ],

        // Leave/Delete button
        _buildActionButton(
          icon: isCreator ? EvaIcons.trash2Outline : EvaIcons.logOutOutline,
          onTap: () => _showLeaveGroupDialog(Get.context!),
          color: isCreator ? AppColors.error : AppColors.onSurface,
          tooltip: isCreator ? 'Delete Group' : 'Leave Group',
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
    required String tooltip,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppBorderRadius.round),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppBorderRadius.round),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Icon(icon, size: 20, color: color),
          ),
        ),
      ),
    );
  }

  void _navigateToEditGroup() {
    Get.toNamed(RouteNames.groups.editGroupPage, arguments: {'group': group});
  }

  void _showLeaveGroupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        ),
        title: Text(
          'Leave Group',
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.text,
            fontWeight: AppTypography.semiBold,
          ),
        ),
        content: Text(
          isCreator
              ? 'Are you sure you want to leave "${group.name}"? Since you are the creator, this will delete the group for all members.'
              : 'Are you sure you want to leave "${group.name}"?',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textLight,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textLight,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
            ),
            child: Text(
              'Cancel',
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: AppTypography.medium,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              final groupController = Get.find<GroupController>();
              groupController.leaveGroup(group.id);
            },
            child: Text(
              'Leave',
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: AppTypography.semiBold,
                color: context.colors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _copyGroupCodeToClipboard(String groupCode) {
    Clipboard.setData(ClipboardData(text: groupCode));
    showCustomSnackBar(message: 'Group code copied to clipboard');
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '${weeks}w ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
