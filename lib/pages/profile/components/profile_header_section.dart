import 'package:flutter/material.dart';

import '/core/models/user_model.dart';
import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';

class ProfileHeaderSection extends StatelessWidget {
  final UserModel? user;
  final VoidCallback onEditName;

  const ProfileHeaderSection({
    super.key,
    required this.user,
    required this.onEditName,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colorScheme.primary.withValues(alpha: 0.03),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              AppAvatar(
                url: user?.photoURL,
                initials: (user?.displayName ?? 'U')
                    .substring(0, 1)
                    .toUpperCase(),
                size: 100,
                backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                foregroundColor: colorScheme.primary,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: onEditName,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colorScheme.surface,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.edit_rounded,
                      size: 16,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          GestureDetector(
            onTap: onEditName,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    user?.displayName ?? 'User',
                    style: AppTypography.headlineSmall.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.edit_rounded,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            user?.email ?? 'No email',
            style: AppTypography.bodyMedium.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
