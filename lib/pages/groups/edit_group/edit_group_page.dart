import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '/core/__core.dart';
import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';

import 'edit_group_controller.dart';

class EditGroupPage extends GetView<EditGroupController> {
  final Group group;

  const EditGroupPage({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    controller.initializeForm(group);

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero emoji circle
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryTint,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      group.category.emoji,
                      style: const TextStyle(fontSize: 36),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Edit Group',
                style: AppTypography.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Update your group details',
                style: AppTypography.bodyMedium.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),

              // Overline label
              Text(
                'GROUP DETAILS',
                style: AppTypography.labelSmall.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              AppTextField(
                label: 'Group Name',
                controller: controller.nameController,
                prefixIcon: Icons.group_rounded,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Group name is required';
                  }
                  if (value.trim().length < 3) {
                    return 'Group name must be at least 3 characters';
                  }
                  if (value.trim().length > 50) {
                    return 'Group name must be less than 50 characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: AppSpacing.md),

              AppTextField(
                label: 'Description',
                hintText: 'Tell people what your group is about (optional)',
                controller: controller.descriptionController,
                prefixIcon: Icons.description_rounded,
                maxLines: 4,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value != null &&
                      value.trim().isNotEmpty &&
                      value.trim().length > 200) {
                    return 'Description must be less than 200 characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: AppSpacing.xl),

              Text(
                'CATEGORY',
                style: AppTypography.labelSmall.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Choose a category for your group',
                style: AppTypography.bodySmall.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              Obx(
                () => CategorySelectorGrid(
                  selectedCategory: controller.selectedCategory.value,
                  onSelected: (category) {
                    controller.selectedCategory.value = category;
                  },
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              Obx(
                () => AppButton(
                  isFullWidth: true,
                  onPressed: controller.isUpdatingGroup.value
                      ? null
                      : () => controller.updateGroup(groupId: group.id),
                  text: 'Update Group',
                  isLoading: controller.isUpdatingGroup.value,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
