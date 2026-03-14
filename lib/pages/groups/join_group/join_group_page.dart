import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';

import 'join_group_controller.dart';

class JoinGroupPage extends GetView<JoinGroupController> {
  const JoinGroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.md),

              // Hero illustration
              Center(
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryTint,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.group_add_rounded,
                    color: AppColors.primary,
                    size: 72,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Title + subtitle
              Text(
                'Enter Invite Code',
                style: AppTypography.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Paste the unique code you received to instantly join your team or community group.',
                style: AppTypography.bodyMedium.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.xl),

              // Overline label
              Text(
                'INVITE CODE',
                style: AppTypography.labelSmall.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              AppTextField(
                controller: controller.groupCodeController,
                label: 'Group Code',
                hintText: 'Enter 6-digit group code',
                prefixIcon: Icons.vpn_key_rounded,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => controller.joinGroup(),
                textCapitalization: TextCapitalization.characters,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Group code is required';
                  }
                  if (value.trim().length != 6) {
                    return 'Group code must be exactly 6 characters';
                  }
                  if (!RegExp(
                    r'^[A-Z0-9]{6}$',
                  ).hasMatch(value.trim().toUpperCase())) {
                    return 'Group code can only contain letters and numbers';
                  }
                  return null;
                },
              ),

              const SizedBox(height: AppSpacing.sm),

              Text(
                'Codes are case-sensitive and typically 6 characters long.',
                style: AppTypography.bodySmall.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.xl),

              // Join Button
              Obx(
                () => AppButton(
                  isFullWidth: true,
                  onPressed: controller.isJoiningGroup.value
                      ? null
                      : controller.joinGroup,
                  text: 'Join Group',
                  isLoading: controller.isJoiningGroup.value,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
