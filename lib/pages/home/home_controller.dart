import 'dart:async';
import 'package:get/get.dart';

import '/core/__core.dart';
import '/ui_components/__ui_components.dart';

class HomeController extends GetxController {
  final RxList<Group> _userGroups = <Group>[].obs;
  final RxList<RatingItem> _ratings = <RatingItem>[].obs;
  final RxBool _isLoading = false.obs;

  StreamSubscription<List<Group>>? _groupsSubscription;
  StreamSubscription<List<RatingItem>>? _ratingsSubscription;
  StreamSubscription<UserModel?>? _authStateSubscription;

  List<Group> get userGroups => _userGroups;
  List<RatingItem> get ratings => _ratings;
  bool get isLoading => _isLoading.value;
  int get activeGroupsCount => _userGroups.length;

  // Stats
  int get totalRatings => _ratings.length;

  @override
  void onInit() {
    super.onInit();
    // Listen to auth state changes to reload data when user logs in
    final authService = Get.find<AuthService>();
    _authStateSubscription = authService.authStateChanges.listen((user) {
      if (user != null) {
        _loadUserGroups();
        _loadRatings();
      } else {
        clearUserData();
      }
    });

    // Load initial data if user is already authenticated
    if (authService.currentUserId != null) {
      _loadUserGroups();
      _loadRatings();
    }
  }

  @override
  void onClose() {
    _authStateSubscription?.cancel();
    _groupsSubscription?.cancel();
    _ratingsSubscription?.cancel();
    super.onClose();
  }

  Future<void> _loadUserGroups() async {
    try {
      // Cancel existing subscription
      _groupsSubscription?.cancel();

      _isLoading.value = true;
      final authService = Get.find<AuthService>();
      final userId = authService.currentUserId;

      if (userId != null) {
        // Listen to groups
        _groupsSubscription = GroupService.getUserGroups(userId).listen((
          groups,
        ) {
          _userGroups.assignAll(groups);
          _isLoading.value = false;
        });
      } else {
        _isLoading.value = false;
      }
    } catch (e) {
      showCustomSnackBar(message: 'Failed to load your groups', isError: true);
      _isLoading.value = false;
    }
  }

  Future<void> _loadRatings() async {
    try {
      // Cancel existing subscription
      _ratingsSubscription?.cancel();

      _isLoading.value = true;
      final authService = Get.find<AuthService>();
      final userId = authService.currentUserId;
      if (userId != null) {
        final ratingService = Get.put(RatingService());
        _ratingsSubscription = ratingService.getUserRatingItems(userId).listen((
          ratings,
        ) {
          _ratings.assignAll(ratings);
          _isLoading.value = false;
        });
      } else {
        _isLoading.value = false;
      }
    } catch (e) {
      showCustomSnackBar(message: 'Failed to load your ratings', isError: true);
      _isLoading.value = false;
    }
  }

  /// Clear all user-specific data
  void clearUserData() {
    _groupsSubscription?.cancel();
    _ratingsSubscription?.cancel();
    _groupsSubscription = null;
    _ratingsSubscription = null;
    _userGroups.clear();
    _ratings.clear();
    _isLoading.value = false;
  }

  void navigateToGroupRatings(Group group) {
    Get.toNamed(RouteNames.groups.ratingsPage, arguments: {'group': group});
  }

  void navigateToRatingDetails(RatingItem item) {
    Get.toNamed(
      RouteNames.groups.ratingDetailsPage,
      arguments: {'ratingItem': item},
    );
  }

  void navigateToCreateGroup() {
    Get.toNamed(RouteNames.groups.createGroupPage);
  }

  void navigateToJoinGroup() {
    Get.toNamed(RouteNames.groups.joinGroupPage);
  }

  void navigateToGroupsPage() {
    Get.toNamed(RouteNames.groups.groupsPage);
  }
}
