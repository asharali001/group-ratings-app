import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';
import '/constants/enums.dart';

import 'create_group_controller.dart';

class CreateGroupPage extends GetView<CreateGroupController> {
  const CreateGroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Group')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFormSection(context, controller),
              const SizedBox(height: AppSpacing.md),
              Obx(
                () => AppButton(
                  isFullWidth: true,
                  onPressed: controller.isCreatingGroup.value
                      ? null
                      : controller.createGroup,
                  text: 'Create Group',
                  isLoading: controller.isCreatingGroup.value,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormSection(
    BuildContext context,
    CreateGroupController controller,
  ) {
    var theme = Theme.of(context);
    var colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Group Details',
          style: AppTypography.titleLarge.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Group Name Field
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

        // Category Field
        Obx(
          () => AppDropdown<GroupCategory>(
            label: 'Category',
            value: controller.selectedCategory,
            onChanged: controller.updateSelectedCategory,
            prefixIcon: Icons.category_rounded,
            items: GroupCategory.allCategories.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Row(
                  children: [
                    Text(category.emoji),
                    const SizedBox(width: AppSpacing.sm),
                    Text(category.displayName),
                  ],
                ),
              );
            }).toList(),
            validator: (value) =>
                value == null ? 'Please select a category' : null,
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // Group Description Field
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
      ],
    );
  }
}
