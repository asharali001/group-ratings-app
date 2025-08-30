import 'package:get/get.dart';
import '../../core/__core.dart';

class HomeController extends GetxController {
  final RxList<Group> _userGroups = <Group>[].obs;
  final RxList<RatingItem> _ratings = <RatingItem>[].obs;
  final RxBool _isLoading = false.obs;

  List<Group> get userGroups => _userGroups;
  List<RatingItem> get ratings => _ratings;
  bool get isLoading => _isLoading.value;
  int get totalRatings => _ratings.length;
  int get activeGroupsCount => _userGroups.length;

  @override
  void onInit() {
    super.onInit();
    _loadUserGroups();
    _loadRatings();
  }

  Future<void> _loadUserGroups() async {
    try {
      _isLoading.value = true;
      final authService = Get.find<AuthService>();

      final userId = authService.currentUserId;
      if (userId != null) {
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

  Future<void> _loadRatings() async {
    try {
      _isLoading.value = true;
      final authService = Get.find<AuthService>();
      final userId = authService.currentUserId;
      if (userId != null) {
        final ratingService = Get.put(RatingService());
        ratingService.getUserRatingItems(userId).listen((ratings) {
          _ratings.assignAll(ratings);
        });
      }
    } catch (e) {
      print('Error loading ratings: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await _loadUserGroups();
    await _loadRatings();
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
