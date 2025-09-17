import 'package:get/get.dart';
import 'package:group_ratings_app/ui_components/popups/__popups.dart';

import '/core/__core.dart';

class GroupController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final RxBool isLoading = false.obs;

  Future<bool> leaveGroup(String groupId) async {
    try {
      isLoading.value = true;

      final userId = _authService.currentUser?.uid;
      if (userId == null) {
        showCustomSnackBar(message: 'User not authenticated', isError: true);
        return false;
      }

      await GroupService.leaveGroup(groupId: groupId, userId: userId);

      showCustomSnackBar(message: 'Left group successfully', isSuccess: true);

      return true;
    } catch (e) {
      showCustomSnackBar(
        message: 'Failed to leave group: ${e.toString()}',
        isError: true,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
