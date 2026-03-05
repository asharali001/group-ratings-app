import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';
import 'profile_controller.dart';
import 'components/__components.dart';

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
    final colorScheme = Theme.of(context).colorScheme;

    return PageLayout(
      title: 'Profile',
      subtitle: 'Manage your profile',
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          children: [
            ProfileHeaderSection(
              user: controller.currentUser,
              onEditName: () => _showEditNameDialog(context, controller),
            ),

            const SizedBox(height: AppSpacing.lg),

            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: ProfileStatsSection(
                groupsCount: '${controller.groupsCount}',
                memberSince: controller.memberSince,
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: Obx(
                () => ProfileSettingsSection(
                  isDarkMode: controller.isDarkMode.value,
                  onThemeToggle: controller.toggleTheme,
                  onSignOut: () => controller.signOut(),
                  onDeleteAccount: () =>
                      controller.handleDeleteAccount(context),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),

            // App version
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
}
