import 'package:get/get.dart';
import '../../core/__core.dart';

class HomeController extends GetxController {
  final RxList<Group> _userGroups = <Group>[].obs;
  final RxBool _isLoading = false.obs;
  final RxInt _totalRatings = 0.obs;

  List<Group> get userGroups => _userGroups;
  bool get isLoading => _isLoading.value;
  int get totalRatings => _totalRatings.value;
  int get activeGroupsCount => _userGroups.length;

  @override
  void onInit() {
    super.onInit();
    _loadUserGroups();
  }

  Future<void> _loadUserGroups() async {
    try {
      _isLoading.value = true;
      final authService = Get.find<AuthService>();

      final userId = authService.currentUserId;
      if (userId != null) {
        // Listen to the stream of user groups
        GroupService.getUserGroups(userId).listen((groups) {
          _userGroups.assignAll(groups);
        });
      }
    } catch (e) {
      print('Error loading user groups: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await _loadUserGroups();
  }

  void navigateToGroupRatings(Group group) {
    Get.toNamed(RouteNames.groups.ratingsPage, arguments: {'group': group});
  }

  void navigateToCreateGroup() {
    Get.toNamed(RouteNames.groups.createGroupPage);
  }

  void navigateToJoinGroup() {
    Get.toNamed(RouteNames.groups.joinGroupPage);
  }

  void navigateToGroupsPage() {
    Get.toNamed(RouteNames.mainApp.groupsPage);
  }
}
