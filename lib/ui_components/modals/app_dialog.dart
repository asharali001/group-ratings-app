import 'package:flutter/material.dart';
import '../../styles/__styles.dart';
import '../buttons/app_button.dart';

class AppDialog extends StatelessWidget {
  final String title;
  final String? description;
  final Widget? content;
  final String? primaryActionText;
  final VoidCallback? onPrimaryAction;
  final String? secondaryActionText;
  final VoidCallback? onSecondaryAction;
  final bool isDestructive;

  const AppDialog({
    super.key,
    required this.title,
    this.description,
    this.content,
    this.primaryActionText,
    this.onPrimaryAction,
    this.secondaryActionText,
    this.onSecondaryAction,
    this.isDestructive = false,
  });

  static Future<T?> show<T>(BuildContext context, {
    required String title,
    String? description,
    Widget? content,
    String? primaryActionText,
    VoidCallback? onPrimaryAction,
    String? secondaryActionText,
    VoidCallback? onSecondaryAction,
    bool isDestructive = false,
  }) {
    return showDialog<T>(
      context: context,
      builder: (context) => AppDialog(
        title: title,
        description: description,
        content: content,
        primaryActionText: primaryActionText,
        onPrimaryAction: onPrimaryAction,
        secondaryActionText: secondaryActionText,
        onSecondaryAction: onSecondaryAction,
        isDestructive: isDestructive,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (description != null)
            Text(description!, style: AppTypography.bodyMedium),
          if (description != null && content != null)
            const SizedBox(height: AppSpacing.md),
          if (content != null) content!,
        ],
      ),
      actions: [
        if (secondaryActionText != null)
          AppButton(
            text: secondaryActionText!,
            variant: AppButtonVariant.ghost,
            onPressed: () {
              Navigator.of(context).pop();
              onSecondaryAction?.call();
            },
          ),
        if (primaryActionText != null)
          AppButton(
            text: primaryActionText!,
            variant: isDestructive ? AppButtonVariant.destructive : AppButtonVariant.primary,
            onPressed: () {
              Navigator.of(context).pop();
              onPrimaryAction?.call();
            },
          ),
      ],
    );
  }
}
