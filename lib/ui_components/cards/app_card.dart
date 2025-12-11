import 'package:flutter/material.dart';
import '../../styles/__styles.dart';

enum AppCardVariant { elevated, outlined, flat }

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final AppCardVariant variant;
  final Color? color;
  final double? width;
  final double? height;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.variant = AppCardVariant.flat,
    this.color,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Determine Shape & Elevation based on variant
    ShapeBorder? shape;
    double? elevation;
    Color? effectiveColor = color;

    switch (variant) {
      case AppCardVariant.elevated:
        elevation = 1;
        effectiveColor ??= theme.colorScheme.primaryContainer;
        shape = const RoundedRectangleBorder(
          borderRadius: AppBorderRadius.mdRadius,
          side: BorderSide.none,
        );
        break;
      case AppCardVariant.outlined:
        elevation = 0;
        effectiveColor ??= theme.colorScheme.surface;
        shape = RoundedRectangleBorder(
          borderRadius: AppBorderRadius.mdRadius,
          side: BorderSide(color: theme.colorScheme.outline),
        );
        break;
      case AppCardVariant.flat:
        elevation = 0;
        effectiveColor ??= theme.colorScheme.surfaceContainerHighest;
        shape = const RoundedRectangleBorder(
          borderRadius: AppBorderRadius.mdRadius,
          side: BorderSide.none,
        );
        break;
    }

    Widget cardContent = Container(
      width: width,
      height: height,
      padding: padding ?? AppSpacing.paddingMd,
      child: child,
    );

    if (onTap != null) {
      cardContent = InkWell(
        onTap: onTap,
        borderRadius: AppBorderRadius.mdRadius,
        child: cardContent,
      );
    }

    return Card(
      margin: margin ?? EdgeInsets.zero,
      elevation: elevation,
      shape: shape,
      color: effectiveColor, // If null, falls back to CardTheme
      clipBehavior: Clip.antiAlias,
      child: cardContent,
    );
  }
}
