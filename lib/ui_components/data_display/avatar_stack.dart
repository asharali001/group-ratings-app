import 'package:flutter/material.dart';

import '/ui_components/data_display/app_avatar.dart';
import '/styles/__styles.dart';

class AvatarStackItem {
  final String name;
  final String? url;

  const AvatarStackItem({required this.name, this.url});
}

class AvatarStack extends StatelessWidget {
  final List<AvatarStackItem> avatars;
  final int maxDisplay;
  final double avatarSize;
  final double overlapFactor;
  final VoidCallback? onOverflowTap;

  const AvatarStack({
    super.key,
    required this.avatars,
    this.maxDisplay = 5,
    this.avatarSize = 32,
    this.overlapFactor = 0.3,
    this.onOverflowTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final displayCount =
        avatars.length > maxDisplay ? maxDisplay : avatars.length;
    final hasOverflow = avatars.length > maxDisplay;
    final totalItems = hasOverflow ? displayCount + 1 : displayCount;
    final itemWidth = avatarSize * (1 - overlapFactor);
    final totalWidth = itemWidth * (totalItems - 1) + avatarSize;

    return SizedBox(
      width: totalWidth,
      height: avatarSize,
      child: Stack(
        children: [
          for (int i = 0; i < displayCount; i++)
            Positioned(
              left: i * itemWidth,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.surface,
                    width: 2,
                  ),
                ),
                child: AppAvatar(
                  initials: avatars[i].name.isNotEmpty
                      ? avatars[i].name[0].toUpperCase()
                      : '?',
                  url: avatars[i].url,
                  size: avatarSize - 4,
                ),
              ),
            ),
          if (hasOverflow)
            Positioned(
              left: displayCount * itemWidth,
              child: GestureDetector(
                onTap: onOverflowTap,
                child: Container(
                  width: avatarSize,
                  height: avatarSize,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colorScheme.surface,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '+${avatars.length - maxDisplay}',
                      style: AppTypography.labelSmall.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
