import 'package:flutter/material.dart';

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
    if (onPressed != null || onTap != null) {
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
