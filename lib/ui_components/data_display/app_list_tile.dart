import 'package:flutter/material.dart';
import '../../styles/__styles.dart';

class AppListTile extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool enabled;
  final bool selected;
  final Color? tileColor;

  const AppListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.enabled = true,
    this.selected = false,
    this.tileColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: title != null
          ? DefaultTextStyle(
              style: AppTypography.bodyLarge.copyWith(
                fontWeight: FontWeight.w500,
              ),
              child: title!,
            )
          : null,
      subtitle: subtitle != null
          ? DefaultTextStyle(
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              child: subtitle!,
            )
          : null,
      trailing: trailing,
      onTap: onTap,
      enabled: enabled,
      selected: selected,
      tileColor: tileColor,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: AppBorderRadius.mdRadius,
      ),
    );
  }
}
