import 'package:flutter/material.dart';

import '/styles/__styles.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key, required this.groupName});

  final String groupName;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Text(
      'Share your experience with "$groupName"',
      style: AppTypography.bodyMedium.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }
}
