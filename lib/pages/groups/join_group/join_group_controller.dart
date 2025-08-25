import 'package:get/get.dart';

import '/core/__core.dart';

class JoinGroupController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final RxBool isJoiningGroup = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString successMessage = ''.obs;

  /// Join a group using a group code
  Future<bool> joinGroup(String groupCode) async {
    try {
      isJoiningGroup.value = true;
      errorMessage.value = '';

      final userId = _authService.currentUser?.uid;
      if (userId == null) {
        errorMessage.value = 'User not authenticated';
        return false;
      }

      final group = await GroupService.joinGroup(
        groupCode: groupCode,
        userId: userId,
      );

      if (group != null) {
        successMessage.value = 'Successfully joined "${group.name}"!';
        return true;
      } else {
        errorMessage.value = 'Group not found or invalid code';
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Failed to join group: ${e.toString()}';
      return false;
    } finally {
      isJoiningGroup.value = false;
    }
  }

  /// Clear error message
  void clearError() {
    errorMessage.value = '';
  }

  /// Clear success message
  void clearSuccess() {
    successMessage.value = '';
  }
}
