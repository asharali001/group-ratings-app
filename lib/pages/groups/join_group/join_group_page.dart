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
      appBar: AppBar(title: const Text('Join Group')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Join a Group',
                    style: AppTypography.headlineMedium.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Enter the group code to join an existing group',
                    style: AppTypography.bodyLarge.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xl),

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

              const SizedBox(height: AppSpacing.md),

              // Info Text
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.1),
                  borderRadius: AppBorderRadius.mdRadius,
                  border: Border.all(
                    color: AppColors.info.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      color: AppColors.info,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Group codes are 6 characters long and can contain letters and numbers. Ask the group creator for the code.',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.info,
                        ),
                      ),
                    ),
                  ],
                ),
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
