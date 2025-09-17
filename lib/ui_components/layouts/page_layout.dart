import 'package:flutter/material.dart';

import '/styles/__styles.dart';

class PageLayout extends StatelessWidget {
  final String title;
  final bool isLoading;
  final String loadingMessage;
  final bool isEmpty;
  final List<Widget> actions;
  final Widget emptyStateWidget;
  final Widget child;

  const PageLayout({
    super.key,
    required this.title,
    this.isLoading = false,
    this.loadingMessage = 'Loading...',
    this.isEmpty = false,
    this.actions = const [],
    this.emptyStateWidget = const SizedBox.shrink(),
    this.child = const SizedBox.shrink(),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Groups'), actions: actions),
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
              padding: const EdgeInsets.only(top: AppSpacing.pageSpacing),
              child: child,
            ),
    );
  }
}
