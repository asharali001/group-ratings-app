import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '/core/__core.dart';
import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';

import 'join_group_controller.dart';

class JoinGroupPage extends StatefulWidget {
  const JoinGroupPage({super.key});

  @override
  State<JoinGroupPage> createState() => _JoinGroupPageState();
}

class _JoinGroupPageState extends State<JoinGroupPage> {
  final _formKey = GlobalKey<FormState>();
  final _groupCodeController = TextEditingController();
  final _groupController = Get.put(JoinGroupController());

  @override
  void dispose() {
    _groupCodeController.dispose();
    super.dispose();
  }

  Future<void> _joinGroup() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await _groupController.joinGroup(
      _groupCodeController.text.trim().toUpperCase(),
    );

    if (success) {
      Get.back();
      Get.snackbar(
        'Success',
        _groupController.successMessage.value,
        backgroundColor: AppColors.green,
        colorText: AppColors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'Error',
        _groupController.errorMessage.value,
        backgroundColor: AppColors.red,
        colorText: AppColors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Join Group')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: context.colors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                      ),
                      child: Icon(
                        Icons.group_add,
                        size: 60,
                        color: context.colors.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Join a Group',
                      style: AppTypography.headlineMedium.copyWith(
                        color: context.colors.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Enter the group code to join an existing group',
                      style: AppTypography.bodyLarge.copyWith(
                        color: context.colors.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Group Code Field
              Text(
                'Group Code *',
                style: AppTypography.titleMedium.copyWith(
                  color: context.colors.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _groupCodeController,
                decoration: InputDecoration(
                  labelText: 'Enter 6-digit group code',
                  prefixIcon: const Icon(Icons.vpn_key),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                    borderSide: BorderSide(
                      color: context.colors.onSurface.withValues(alpha: 0.3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                    borderSide: BorderSide(
                      color: AppColors.gray.withValues(alpha: 0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                    borderSide: const BorderSide(color: AppColors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                    borderSide: const BorderSide(color: AppColors.red),
                  ),
                  filled: true,
                  fillColor: context.colors.surfaceContainer,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.md,
                  ),
                ),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _joinGroup(),
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

              const SizedBox(height: AppSpacing.xl),

              // Join Button
              Obx(
                () => CustomButton(
                  onPressed: _groupController.isJoiningGroup.value
                      ? null
                      : _joinGroup,
                  text: 'Join Group',
                  backgroundColor: context.colors.primary,
                  textColor: context.colors.onPrimary,
                  isLoading: _groupController.isJoiningGroup.value,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
