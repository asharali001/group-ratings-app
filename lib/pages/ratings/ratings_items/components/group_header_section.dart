import 'package:flutter/material.dart';

import '/core/__core.dart';
import '/styles/__styles.dart';

class GroupHeaderSection extends StatelessWidget {
  final Group group;
  final int itemCount;

  const GroupHeaderSection({
    super.key,
    required this.group,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          group.name,
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
        if (group.description != null && group.description!.isNotEmpty) ...[
          Text(group.description!, style: AppTypography.bodyMedium),
        ],
      ],
    );
  }
}
