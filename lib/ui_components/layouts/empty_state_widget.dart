import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/styles/__styles.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String description;
  final IconData? icon;
  final String? svgAsset;
  final List<Widget> actions;
  final Color? iconColor;
  final Color? iconBackgroundColor;

  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.description,
    this.icon,
    this.svgAsset,
    required this.actions,
    this.iconColor,
    this.iconBackgroundColor,
  }) : assert(icon != null || svgAsset != null,
            'Either icon or svgAsset must be provided');

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (svgAsset != null)
              SvgPicture.asset(
                svgAsset!,
                height: 180,
              )
            else
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: iconBackgroundColor ?? AppColors.primaryTint,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 48,
                  color: iconColor ?? AppColors.primary,
                ),
              ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              description,
              style: AppTypography.bodyMedium.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (actions.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.lg),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: actions),
            ],
          ],
        ),
      ),
    );
  }
}
