import 'package:flutter/material.dart';
import '../../styles/__styles.dart';

class AppChip extends StatelessWidget {
  final String label;
  final VoidCallback? onDeleted;
  final VoidCallback? onPressed;
  final Widget? avatar;
  final bool isSelected;

  const AppChip({
    super.key,
    required this.label,
    this.onDeleted,
    this.onPressed,
    this.avatar,
    this.isSelected = false,
    this.onTap,
  });

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (onPressed != null || onTap != null) {
      // Use FilterChip when isSelected is provided for better visual feedback
      if (isSelected != false || onTap != null || onPressed != null) {
        return FilterChip(
          label: Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          avatar: avatar,
          selected: isSelected,
          onSelected: (_) {
            onTap?.call();
            onPressed?.call();
          },
          backgroundColor: colorScheme.surfaceVariant,
          selectedColor: colorScheme.primary.withValues(alpha: 0.2),
          checkmarkColor: colorScheme.primary,
          side: BorderSide(
            color: isSelected
                ? colorScheme.primary.withValues(alpha: 0.5)
                : colorScheme.outlineVariant,
          ),
        );
      }
      return ActionChip(
        label: Text(label),
        avatar: avatar,
        onPressed: onTap ?? onPressed,
      );
    }
    
    return Chip(
      label: Text(label),
      avatar: avatar,
      onDeleted: onDeleted,
    );
  }
}
