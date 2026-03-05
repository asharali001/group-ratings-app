import 'package:flutter/material.dart';

import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';

class ProfileSettingsSection extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeToggle;
  final VoidCallback onSignOut;
  final VoidCallback onDeleteAccount;

  const ProfileSettingsSection({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
    required this.onSignOut,
    required this.onDeleteAccount,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Preferences section
        const SectionHeader(title: 'Preferences'),
        const SizedBox(height: AppSpacing.sm),
        AppCard(
          padding: EdgeInsets.zero,
          child: InkWell(
            onTap: () => onThemeToggle(!isDarkMode),
            borderRadius: AppBorderRadius.mdRadius,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.dark_mode_rounded,
                    color: colorScheme.onSurface,
                    size: 24,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      'Dark Mode',
                      style: AppTypography.bodyLarge.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Switch.adaptive(
                    value: isDarkMode,
                    onChanged: onThemeToggle,
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.xl),

        // Account section
        const SectionHeader(title: 'Account'),
        const SizedBox(height: AppSpacing.sm),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _buildListTile(
                context,
                icon: Icons.logout_rounded,
                title: 'Sign Out',
                onTap: onSignOut,
              ),
              Divider(
                height: 1,
                color: colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
              _buildListTile(
                context,
                icon: Icons.delete_forever_rounded,
                title: 'Delete Account',
                textColor: colorScheme.error,
                iconColor: colorScheme.error,
                onTap: onDeleteAccount,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? colorScheme.onSurface, size: 24),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                title,
                style: AppTypography.bodyLarge.copyWith(
                  color: textColor ?? colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
