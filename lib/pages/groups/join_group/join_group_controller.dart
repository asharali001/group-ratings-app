import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '/core/__core.dart';
import '/ui_components/__ui_components.dart';

class JoinGroupController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final RxBool isJoiningGroup = false.obs;

  // Form state
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController groupCodeController = TextEditingController();

  Future<bool> joinGroup() async {
    if (!formKey.currentState!.validate()) return false;
    try {
      final groupCode = groupCodeController.text.trim().toUpperCase();
      isJoiningGroup.value = true;

      final userId = _authService.currentUser?.uid;
      if (userId == null) {
        showCustomSnackBar(message: 'User not authenticated', isError: true);
        return false;
      }

      final group = await GroupService.joinGroup(
        groupCode: groupCode,
        userName: _authService.currentUser?.displayName ?? '',
        userId: userId,
      );

      if (group != null) {
        showCustomSnackBar(
          message: 'Successfully joined "${group.name}"!',
          isSuccess: true,
        );
        return true;
      } else {
        showCustomSnackBar(
          message: 'Group not found or invalid code',
          isError: true,
        );
        return false;
      }
    } catch (e) {
      showCustomSnackBar(
        message: 'Failed to join group: ${e.toString()}',
        isError: true,
      );
      return false;
    } finally {
      isJoiningGroup.value = false;
    }
  }

  @override
  void onClose() {
    groupCodeController.dispose();
    super.onClose();
  }
}
