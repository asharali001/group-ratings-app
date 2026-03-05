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

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Group')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(title: 'Group Details'),
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

              const SectionHeader(
                title: 'Category',
                subtitle: 'Choose a category for your group',
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
