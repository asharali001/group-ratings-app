import 'package:flutter/material.dart';

import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';

class ProfileSettingsSection extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeToggle;
  final VoidCallback onSignOut;
  final VoidCallback onDeleteAccount;
  final bool canMirror;
  final bool isMirroring;
  final VoidCallback? onMirrorUser;
  final VoidCallback? onStopMirroring;

  const ProfileSettingsSection({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
    required this.onSignOut,
    required this.onDeleteAccount,
    this.canMirror = false,
    this.isMirroring = false,
    this.onMirrorUser,
    this.onStopMirroring,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Preferences section - uppercase overline
        Text(
          'PREFERENCES',
          style: AppTypography.labelSmall.copyWith(
            color: colorScheme.onSurfaceVariant,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppCard(
          variant: AppCardVariant.outlined,
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              InkWell(
                onTap: () => onThemeToggle(!isDarkMode),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppBorderRadius.md),
                  topRight: Radius.circular(AppBorderRadius.md),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryTint,
                          borderRadius: AppBorderRadius.mdRadius,
                        ),
                        child: const Icon(
                          Icons.dark_mode_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
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
              Divider(
                height: 1,
                color: colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryTint,
                        borderRadius: AppBorderRadius.mdRadius,
                      ),
                      child: const Icon(
                        Icons.language_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        'Language',
                        style: AppTypography.bodyLarge.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      'English (US)',
                      style: AppTypography.bodyMedium.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.xl),

        // Account section - uppercase overline
        Text(
          'ACCOUNT',
          style: AppTypography.labelSmall.copyWith(
            color: colorScheme.onSurfaceVariant,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppCard(
          variant: AppCardVariant.outlined,
          padding: EdgeInsets.zero,
          child: _buildListTile(
            context,
            icon: Icons.delete_forever_rounded,
            title: 'Delete Account',
            textColor: colorScheme.error,
            iconColor: colorScheme.error,
            iconBgColor: colorScheme.error.withValues(alpha: 0.1),
            onTap: onDeleteAccount,
          ),
        ),

        if (canMirror) ...[
          const SizedBox(height: AppSpacing.xl),
          Text(
            'ADMIN',
            style: AppTypography.labelSmall.copyWith(
              color: const Color(0xFFD97706),
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            variant: AppCardVariant.outlined,
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _buildListTile(
                  context,
                  icon: Icons.supervisor_account_rounded,
                  title: 'Mirror User',
                  onTap: onMirrorUser ?? () {},
                  textColor: const Color(0xFFD97706),
                  iconColor: const Color(0xFFD97706),
                  iconBgColor: const Color(0xFFFEF3C7),
                ),
                if (isMirroring) ...[
                  Divider(
                    height: 1,
                    color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                  _buildListTile(
                    context,
                    icon: Icons.stop_circle_rounded,
                    title: 'Stop Mirroring',
                    onTap: onStopMirroring ?? () {},
                    textColor: colorScheme.error,
                    iconColor: colorScheme.error,
                    iconBgColor: colorScheme.error.withValues(alpha: 0.1),
                  ),
                ],
              ],
            ),
          ),
        ],

        const SizedBox(height: AppSpacing.xl),

        // Standalone logout
        Center(
          child: GestureDetector(
            onTap: onSignOut,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.logout_rounded, size: 20, color: colorScheme.error),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Log Out',
                  style: AppTypography.bodyLarge.copyWith(
                    color: colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
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
    Color? iconBgColor,
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
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBgColor ?? AppColors.primaryTint,
                borderRadius: AppBorderRadius.mdRadius,
              ),
              child: Icon(
                icon,
                color: iconColor ?? AppColors.primary,
                size: 20,
              ),
            ),
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
