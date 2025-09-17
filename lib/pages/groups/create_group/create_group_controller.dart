import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '/core/__core.dart';
import '/constants/__constants.dart';
import '/ui_components/__ui_components.dart';

class CreateGroupController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final RxBool isCreatingGroup = false.obs;

  // Form controllers
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  final Rx<GroupCategory> _selectedCategory = GroupCategory.other.obs;

  GlobalKey<FormState> get formKey => _formKey;
  TextEditingController get nameController => _nameController;
  TextEditingController get descriptionController => _descriptionController;
  GroupCategory get selectedCategory => _selectedCategory.value;

  @override
  void onClose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.onClose();
  }

  Future<bool> createGroup() async {
    if (!_formKey.currentState!.validate()) return false;

    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim().isEmpty
        ? null
        : _descriptionController.text.trim();
    final category = _selectedCategory.value;

    try {
      isCreatingGroup.value = true;

      final userId = _authService.currentUser?.uid;
      if (userId == null) {
        showCustomSnackBar(message: 'User not authenticated', isError: true);
        return false;
      }

      final group = await GroupService.createGroup(
        name: name,
        description: description,
        category: category,
        user: _authService.currentUser!,
      );

      showCustomSnackBar(
        message: 'Group "${group.name}" created successfully!',
        isSuccess: true,
      );
      return true;
    } catch (e) {
      showCustomSnackBar(
        message: 'Failed to create group: ${e.toString()}',
        isError: true,
      );
      return false;
    } finally {
      isCreatingGroup.value = false;
    }
  }

  void updateSelectedCategory(GroupCategory? newValue) {
    if (newValue != null) {
      _selectedCategory.value = newValue;
    }
  }
}
