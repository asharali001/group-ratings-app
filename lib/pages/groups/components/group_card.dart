import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '/core/__core.dart';
import '/styles/__styles.dart';

import '../group_controller.dart';

class GroupCard extends StatefulWidget {
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
  State<GroupCard> createState() => _GroupCardState();
}

class _GroupCardState extends State<GroupCard> with TickerProviderStateMixin {
  final GroupController controller = Get.put(GroupController());

  @override
  void initState() {
    super.initState();
    controller.loadGroupRatingItems(widget.group.id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        border: Border.all(
          color: context.colors.outline.withValues(alpha: 0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(AppBorderRadius.xl),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppBorderRadius.xl),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    widget.group.description!,
                    style: AppTypography.bodyMedium.copyWith(
                      color: context.colors.onSurface,
                      height: 1.5,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _buildFooter(),
                ],
              ),
            ),

            // Action buttons overlay
            Positioned(
              top: AppSpacing.md,
              right: AppSpacing.md,
              child: _buildActionButtons(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // Modern avatar with gradient border
        SizedBox(
          width: 80,
          height: 80,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              color: context.colors.surfaceContainerHighest,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              child: widget.group.imageUrl != null
                  ? Image.network(
                      widget.group.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                context.colors.primary.withValues(alpha: 0.1),
                                context.colors.primary.withValues(alpha: 0.1),
                              ],
                            ),
                          ),
                          child: Icon(
                            Icons.group_rounded,
                            color: context.colors.primary,
                            size: 28,
                          ),
                        );
                      },
                    )
                  : Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withValues(alpha: 0.1),
                            AppColors.purple.withValues(alpha: 0.1),
                          ],
                        ),
                      ),
                      child: Icon(
                        Icons.group_rounded,
                        color: context.colors.primary,
                        size: 28,
                      ),
                    ),
            ),
          ),
        ),

        const SizedBox(width: AppSpacing.sm),

        // Group info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.group.name,
                style: AppTypography.bodyLarge.copyWith(
                  color: context.colors.onSurface,
                  fontWeight: AppTypography.semiBold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildStatusChips(),
            ],
          ),
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
            color: widget.isCreator
                ? context.colors.primary
                : context.colors.secondary,
            borderRadius: BorderRadius.circular(AppBorderRadius.round),
          ),
          child: Text(
            widget.isCreator ? 'Creator' : 'Member',
            style: AppTypography.bodySmall.copyWith(
              color: widget.isCreator
                  ? context.colors.onPrimary
                  : context.colors.onSurface,
              fontWeight: AppTypography.semiBold,
            ),
          ),
        ),

        // Group code chip
        GestureDetector(
          onTap: () => _copyGroupCodeToClipboard(widget.group.groupCode),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppBorderRadius.round),
              border: Border.all(color: context.colors.outline, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.code_rounded,
                  size: 14,
                  color: context.colors.onSurface,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  widget.group.groupCode,
                  style: AppTypography.bodySmall.copyWith(
                    color: context.colors.onSurface,
                    fontWeight: AppTypography.medium,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        border: Border.all(
          color: context.colors.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          _buildFooterItem(
            icon: Icons.people_rounded,
            label:
                '${widget.group.members.length} member${widget.group.members.length == 1 ? '' : 's'}',
            color: AppColors.blue,
          ),
          const SizedBox(width: AppSpacing.lg),
          Obx(() {
            return _buildFooterItem(
              icon: Icons.star_rounded,
              label: '${controller.groupRatingItems.length} ratings',
              color: AppColors.yellow,
            );
          }),
          const Spacer(),
          _buildFooterItem(
            icon: Icons.schedule_rounded,
            label: _formatDate(widget.group.createdAt),
            color: context.colors.onSurface,
            isDate: true,
          ),
        ],
      ),
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
        Container(
          padding: const EdgeInsets.all(AppSpacing.xs),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppBorderRadius.sm),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: context.colors.onSurface,
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
        if (widget.isCreator) ...[
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
          icon: widget.isCreator
              ? EvaIcons.trash2Outline
              : EvaIcons.logOutOutline,
          onTap: () => _showLeaveGroupDialog(context),
          color: widget.isCreator
              ? context.colors.error
              : context.colors.onSurface,
          tooltip: widget.isCreator ? 'Delete Group' : 'Leave Group',
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
    return Tooltip(
      message: tooltip,
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.surface.withValues(alpha: 0.9),
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
      ),
    );
  }

  void _navigateToEditGroup() {
    Get.toNamed(
      RouteNames.groups.editGroupPage,
      arguments: {'group': widget.group},
    );
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
          widget.isCreator
              ? 'Are you sure you want to leave "${widget.group.name}"? Since you are the creator, this will delete the group for all members.'
              : 'Are you sure you want to leave "${widget.group.name}"?',
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
              groupController.leaveGroup(widget.group.id);
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Group code copied to clipboard')),
    );
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
