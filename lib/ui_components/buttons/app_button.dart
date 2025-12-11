import 'package:flutter/material.dart';
import '../../styles/__styles.dart';

enum AppButtonVariant {
  primary,
  secondary,
  outline,
  ghost,
  destructive,
}

enum AppButtonSize {
  sm,
  md,
  lg,
}

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? icon;
  final Widget? iconWidget;
  final bool isLoading;
  final bool isFullWidth;
  final bool isDisabled;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.md,
    this.icon,
    this.iconWidget,
    this.isLoading = false,
    this.isFullWidth = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    // Effective disabled state
    final isEffectiveDisabled = isDisabled || isLoading || onPressed == null;

    final Widget buttonChild = _buildChild(context);
    final ButtonStyle baseStyle = _getButtonStyle(context);
    final ButtonStyle effectiveStyle = baseStyle.copyWith(
      minimumSize: WidgetStateProperty.all(
        isFullWidth ? Size(double.infinity, _getHeight()) : Size(0, _getHeight()),
      ),
      padding: WidgetStateProperty.all(_getPadding()),
    );

    switch (variant) {
      case AppButtonVariant.primary:
      case AppButtonVariant.secondary:
      case AppButtonVariant.destructive:
        return FilledButton(
          onPressed: isEffectiveDisabled ? null : onPressed,
          style: effectiveStyle,
          child: buttonChild,
        );
      case AppButtonVariant.outline:
        return OutlinedButton(
          onPressed: isEffectiveDisabled ? null : onPressed,
          style: effectiveStyle,
          child: buttonChild,
        );
      case AppButtonVariant.ghost:
        return TextButton(
          onPressed: isEffectiveDisabled ? null : onPressed,
          style: effectiveStyle,
          child: buttonChild,
        );
    }
  }

  Widget _buildChild(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: _getLoadingIndicatorColor(context),
        ),
      );
    }

    if (icon != null || iconWidget != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (iconWidget != null)
            iconWidget!
          else if (icon != null)
            Icon(icon, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Text(text),
        ],
      );
    }

    return Text(text);
  }

  ButtonStyle _getButtonStyle(BuildContext context) {
    final theme = Theme.of(context);
    
    switch (variant) {
      case AppButtonVariant.primary:
        return theme.filledButtonTheme.style!.copyWith(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.textSecondary.withValues(alpha: 0.12);
            }
            return AppColors.primary;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.textSecondary.withValues(alpha: 0.38);
            }
            return AppColors.onPrimary;
          }),
        );
      case AppButtonVariant.secondary:
        return theme.filledButtonTheme.style!.copyWith(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
             if (states.contains(WidgetState.disabled)) {
              return AppColors.textSecondary.withValues(alpha: 0.12);
            }
            return AppColors.secondary;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.textSecondary.withValues(alpha: 0.38);
            }
            return AppColors.onSecondary;
          }),
        );
      case AppButtonVariant.destructive:
        return theme.filledButtonTheme.style!.copyWith(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
             if (states.contains(WidgetState.disabled)) {
              return AppColors.textSecondary.withValues(alpha: 0.12);
            }
            return AppColors.error;
          }),
          foregroundColor: WidgetStateProperty.all(AppColors.white),
        );
      case AppButtonVariant.outline:
        return theme.outlinedButtonTheme.style!.copyWith(
          side: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return BorderSide(color: AppColors.textSecondary.withValues(alpha: 0.12));
            }
            return const BorderSide(color: AppColors.border); // Default outline color
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.textSecondary.withValues(alpha: 0.38);
            }
            return AppColors.textPrimary;
          }),
        );
      case AppButtonVariant.ghost:
         return theme.textButtonTheme.style!.copyWith(
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.textSecondary.withValues(alpha: 0.38);
            }
            return AppColors.textPrimary;
          }),
        );
    }
  }

  double _getHeight() {
    switch (size) {
      case AppButtonSize.sm:
        return 32;
      case AppButtonSize.md:
        return 44;
      case AppButtonSize.lg:
        return 56;
    }
  }

  EdgeInsetsGeometry _getPadding() {
    switch (size) {
      case AppButtonSize.sm:
        return AppSpacing.paddingHSm;
      case AppButtonSize.md:
        return AppSpacing.paddingHMd;
      case AppButtonSize.lg:
        return AppSpacing.paddingHLg;
    }
  }

  Color _getLoadingIndicatorColor(BuildContext context) {
    if (variant == AppButtonVariant.outline || variant == AppButtonVariant.ghost) {
      return AppColors.primary;
    }
    return AppColors.white; // Filled buttons usually have contrast text
  }
}
