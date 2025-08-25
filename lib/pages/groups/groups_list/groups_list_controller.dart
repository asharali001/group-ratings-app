import 'package:get/get.dart';

import '/core/__core.dart';
import '/constants/enums.dart';

class GroupsListController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final RxList<Group> userGroups = <Group>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserGroups();
  }

  /// Load all groups where the user is a member
  void loadUserGroups() {
    final userId = _authService.currentUser?.uid;
    if (userId != null) {
      GroupService.getUserGroups(userId).listen((groups) {
        userGroups.value = groups;
      });
    }
  }

  /// Leave a group
  Future<bool> leaveGroup(String groupId) async {
    try {
      isLoading.value = true;

      final userId = _authService.currentUser?.uid;
      if (userId == null) {
        return false;
      }

      await GroupService.leaveGroup(groupId: groupId, userId: userId);

      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Check if user is the creator of a group
  bool isGroupCreator(Group group) {
    final userId = _authService.currentUser?.uid;
    return group.members.firstWhereOrNull((e) => e.userId == userId)?.role ==
        GroupMemberRole.admin;
  }

  /// Check if user is a member of a group
  bool isGroupMember(Group group) {
    final userId = _authService.currentUser?.uid;
    return userId != null && group.members.any((e) => e.userId == userId);
  }

  /// Navigate to group ratings page
  void navigateToGroupRatings(Group group) {
    Get.toNamed(RouteNames.groups.ratingsPage, arguments: {'group': group});
  }
}
