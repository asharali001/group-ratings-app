import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';

import 'add_rating_controller.dart';
import 'components/__components.dart';

class AddRatingPage extends GetView<AddRatingController> {
  final String groupId;
  final String groupName;

  const AddRatingPage({
    super.key,
    required this.groupId,
    required this.groupName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Rating'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.text,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderSection(groupName: groupName),
              const SizedBox(height: AppSpacing.lg),
              const ImageSection(),
              const SizedBox(height: AppSpacing.lg),
              const FormSection(),
              const SizedBox(height: AppSpacing.lg),
              Obx(
                () => CustomButton(
                  width: double.infinity,
                  onPressed: controller.isUpdatingImage.value
                      ? null
                      : () async {
                          final success = await controller.submitRating(
                            groupId,
                          );
                          if (success) {
                            Get.back();
                          }
                        },
                  text: controller.isUpdatingImage.value
                      ? 'Uploading...'
                      : 'Add Rating',
                  isLoading: controller.isUpdatingImage.value,
                  backgroundColor: AppColors.primary,
                  textColor: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
