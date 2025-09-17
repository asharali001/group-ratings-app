import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '/core/__core.dart';
import '/constants/__constants.dart';
import '/ui_components/__ui_components.dart';

class EditGroupController extends GetxController {
  final RxBool isUpdatingGroup = false.obs;

  final formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final Rx<GroupCategory> selectedCategory = GroupCategory.other.obs;

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  void initializeForm(Group group) {
    nameController.text = group.name;
    descriptionController.text = group.description ?? '';
    selectedCategory.value = group.category;
  }

  Future<bool> updateGroup({required String groupId}) async {
    if (!formKey.currentState!.validate()) return false;
    try {
      isUpdatingGroup.value = true;

      await GroupService.updateGroup(
        groupId: groupId,
        name: nameController.text.trim(),
        description: descriptionController.text.trim().isEmpty
            ? null
            : descriptionController.text.trim(),
        category: selectedCategory.value,
      );

      showCustomSnackBar(
        message: 'Group updated successfully!',
        isSuccess: true,
      );
      return true;
    } catch (e) {
      showCustomSnackBar(
        message: 'Failed to update group: ${e.toString()}',
        isError: true,
      );
      return false;
    } finally {
      isUpdatingGroup.value = false;
    }
  }
}
