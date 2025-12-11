import 'package:flutter/material.dart';
import '../../styles/__styles.dart';

class AppIcon extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final double? size;

  const AppIcon(this.icon, {super.key, this.color, this.size});

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: color ?? AppColors.textPrimary,
      size: size ?? 24.0,
    );
  }
}
