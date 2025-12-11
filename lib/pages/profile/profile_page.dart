import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';
import 'profile_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _showEditNameDialog(BuildContext context, ProfileController controller) {
    final TextEditingController nameController = TextEditingController(
      text: controller.currentUser?.displayName,
    );

    Get.dialog(
      AppDialog(
        title: 'Edit Display Name',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              label: 'Display Name',
              controller: nameController,
              hintText: 'Enter your name',
              prefixIcon: Icons.person_outline_rounded,
              textCapitalization: TextCapitalization.words,
            ),
          ],
        ),
        primaryActionText: 'Save',
        onPrimaryAction: () =>
            controller.updateDisplayName(nameController.text),
        secondaryActionText: 'Cancel',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: AppTypography.headlineSmall.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = controller.currentUser;

        return ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            // User Avatar and Info
            Center(
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
                        backgroundColor: colorScheme.primary.withValues(
                          alpha: 0.1,
                        ),
                        foregroundColor: colorScheme.primary,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => _showEditNameDialog(context, controller),
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
                    onTap: () => _showEditNameDialog(context, controller),
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
            ),

            const SizedBox(height: AppSpacing.xl),

            // Stats Row
            Container(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(AppBorderRadius.lg),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatItem(
                    context,
                    'Groups',
                    '${controller.groupsCount}',
                  ),
                  Container(
                    height: 40,
                    width: 1,
                    color: colorScheme.outlineVariant,
                  ),
                  _buildStatItem(context, 'Joined', controller.memberSince),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),

            // Actions
            Padding(
              padding: const EdgeInsets.only(left: AppSpacing.xs),
              child: Text(
                'Account Settings',
                style: AppTypography.titleSmall.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _buildListTile(
                    context,
                    icon: Icons.logout_rounded,
                    title: 'Sign Out',
                    onTap: () => controller.signOut(),
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
                    onTap: () => controller.handleDeleteAccount(context),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),

            // Version Info
            Center(
              child: Text(
                'Version 1.0.0',
                style: AppTypography.bodySmall.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        );
      }),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: colorScheme.onSurfaceVariant,
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
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
