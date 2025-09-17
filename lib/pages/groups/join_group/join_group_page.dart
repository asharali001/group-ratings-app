import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '/core/__core.dart';
import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';

import 'join_group_controller.dart';

class JoinGroupPage extends GetView<JoinGroupController> {
  const JoinGroupPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                      color: context.colors.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Enter the group code to join an existing group',
                    style: AppTypography.bodyLarge.copyWith(
                      color: context.colors.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),
              CustomFormField(
                controller: controller.groupCodeController,
                label: 'Group Code',
                hint: 'Enter 6-digit group code',
                icon: Icons.vpn_key,
                isRequired: true,
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
                  color: AppColors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  border: Border.all(
                    color: AppColors.blue.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppColors.blue,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Group codes are 6 characters long and can contain letters and numbers. Ask the group creator for the code.',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // Join Button
              Obx(
                () => CustomButton(
                  width: double.infinity,
                  onPressed: controller.isJoiningGroup.value
                      ? null
                      : controller.joinGroup,
                  text: 'Join Group',
                  backgroundColor: AppColors.primary,
                  textColor: context.colors.onPrimary,
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
