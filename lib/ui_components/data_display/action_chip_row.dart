import 'package:flutter/material.dart';

import '../../styles/__styles.dart';

class ActionChipItem {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool isFilled;

  const ActionChipItem({
    required this.label,
    this.icon,
    this.onTap,
    this.isFilled = false,
  });
}

class ActionChipRow extends StatelessWidget {
  final List<ActionChipItem> chips;

  const ActionChipRow({super.key, required this.chips});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: chips.asMap().entries.map((entry) {
          final chip = entry.value;
          final isFilled = chip.isFilled;

          return Padding(
            padding: EdgeInsets.only(
              right: entry.key < chips.length - 1 ? AppSpacing.sm : 0,
            ),
            child: GestureDetector(
              onTap: chip.onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm + 2,
                ),
                decoration: BoxDecoration(
                  color: isFilled
                      ? colorScheme.primary
                      : colorScheme.surface,
                  borderRadius: AppBorderRadius.fullRadius,
                  border: isFilled
                      ? null
                      : Border.all(color: colorScheme.outlineVariant),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (chip.icon != null) ...[
                      Icon(
                        chip.icon,
                        size: 16,
                        color: isFilled
                            ? Colors.white
                            : colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                    ],
                    Text(
                      chip.label,
                      style: AppTypography.labelLarge.copyWith(
                        color: isFilled
                            ? Colors.white
                            : colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
