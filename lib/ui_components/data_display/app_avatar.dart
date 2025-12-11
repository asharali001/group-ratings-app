import 'package:flutter/material.dart';
import '../../styles/__styles.dart';



class AppAvatar extends StatelessWidget {
  final String? url;
  final String? initials;
  final double size;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const AppAvatar({
    super.key,
    this.url,
    this.initials,
    this.size = 40.0,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final double radius = _getRadius();
    final double fontSize = _getFontSize();

    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? AppColors.primary.withValues(alpha: 0.1),
      backgroundImage: url != null ? NetworkImage(url!) : null,
      child: url == null
          ? Text(
              initials?.toUpperCase() ?? '',
              style: AppTypography.titleMedium.copyWith(
                fontSize: fontSize,
                color: foregroundColor ?? AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            )
          : null,
    );
  }

  double _getRadius() {
    return size / 2;
  }

  double _getFontSize() {
    return size * 0.4; // 40% of the diameter
  }
}
