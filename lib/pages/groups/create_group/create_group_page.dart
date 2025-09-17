import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '/core/__core.dart';
import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';

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
                () => CustomButton(
                  width: double.infinity,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Group Details',
          style: AppTypography.titleLarge.copyWith(
            color: context.colors.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Group Name Field
        CustomFormField(
          label: 'Group Name',
          hint: 'Enter a memorable group name',
          controller: controller.nameController,
          icon: Icons.group_rounded,
          isRequired: true,
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
          () => CategoryDropdown(
            value: controller.selectedCategory,
            onChanged: controller.updateSelectedCategory,
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // Group Description Field
        CustomFormField(
          label: 'Description',
          hint: 'Tell people what your group is about (optional)',
          controller: controller.descriptionController,
          icon: Icons.description_rounded,
          isRequired: false,
          maxLines: 4,
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
