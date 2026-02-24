import 'package:flutter/material.dart';

import '/styles/__styles.dart';

class PageLayout extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final List<Widget> actions;
  final bool isLoading;
  final String loadingMessage;
  final bool isEmpty;
  final Widget emptyStateWidget;
  final Widget child;

  const PageLayout({
    super.key,
    this.title,
    this.subtitle,
    this.actions = const [],
    this.isLoading = false,
    this.loadingMessage = 'Loading...',
    this.isEmpty = false,
    this.emptyStateWidget = const SizedBox.shrink(),
    this.child = const SizedBox.shrink(),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Hero(
      tag: title ?? '',
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                Text(
                  title!,
                  style: AppTypography.titleLarge.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: AppTypography.bodySmall.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
          actions: actions,
        ),
        body: isLoading
            ? SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: AppSpacing.md),
                    Text(loadingMessage),
                  ],
                ),
              )
            : isEmpty
            ? emptyStateWidget
            : Padding(
                padding: const EdgeInsets.all(AppSpacing.pageSpacing),
                child: child,
              ),
      ),
    );
  }
}
