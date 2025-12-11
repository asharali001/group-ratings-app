import 'package:flutter/material.dart';
import '../../styles/__styles.dart';

class AppBottomSheet extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? footer;

  const AppBottomSheet({
    super.key,
    required this.title,
    required this.child,
    this.footer,
  });

  static Future<T?> show<T>(BuildContext context, {
    required String title,
    required Widget child,
    Widget? footer,
    bool isScrollControlled = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      builder: (context) => AppBottomSheet(
        title: title,
        footer: footer,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Handle keyboard and safe area
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle + Title
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: AppSpacing.sm),
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textTertiary.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text(
                title,
                style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: child,
              ),
            ),
            if (footer != null) ...[
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: footer!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
