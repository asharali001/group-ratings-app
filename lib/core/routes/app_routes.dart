import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '/core/__core.dart';
import '/pages/__pages.dart';

class AppRoutes {
  static final routes = [
    // Auth routes
    GetPage(name: RouteNames.auth.signInPage, page: () => const SignInPage()),
    GetPage(name: RouteNames.auth.signUpPage, page: () => const SignUpPage()),

    // App routes
    GetPage(name: RouteNames.mainApp.homePage, page: () => const HomePage()),
    GetPage(
      name: RouteNames.mainApp.profilePage,
      page: () => const ProfilePage(),
    ),

    // Group routes
    GetPage(name: RouteNames.groups.groupsPage, page: () => const GroupsPage()),
    GetPage(
      name: RouteNames.groups.createGroupPage,
      page: () => const CreateGroupPage(),
      binding: CreateGroupBinding(),
    ),
    GetPage(
      name: RouteNames.groups.joinGroupPage,
      page: () => const JoinGroupPage(),
      binding: JoinGroupBinding(),
    ),
    GetPage(
      name: RouteNames.groups.editGroupPage,
      page: () {
        final arguments = Get.arguments;
        if (arguments != null && arguments['group'] != null) {
          return EditGroupPage(group: arguments['group']);
        }
        return const Scaffold(body: Center(child: Text('Group not found')));
      },
      binding: EditGroupBinding(),
    ),
    GetPage(
      name: RouteNames.groups.ratingsPage,
      page: () {
        final arguments = Get.arguments;
        if (arguments != null && arguments['group'] != null) {
          return RatingsPage(group: arguments['group']);
        }
        return const Scaffold(body: Center(child: Text('Group not found')));
      },
    ),
    GetPage(
      name: RouteNames.groups.addRatingPage,
      binding: AddRatingBinding(),
      page: () {
        final arguments = Get.arguments;
        if (arguments != null &&
            arguments['groupId'] != null &&
            arguments['groupName'] != null) {
          return AddRatingPage(
            groupId: arguments['groupId'],
            groupName: arguments['groupName'],
          );
        }
        return const Scaffold(body: Center(child: Text('Group not found')));
      },
    ),
    GetPage(
      name: RouteNames.groups.editRatingPage,
      binding: EditRatingBinding(),
      page: () {
        final arguments = Get.arguments;
        if (arguments != null && arguments['rating'] != null) {
          return EditRatingPage(rating: arguments['rating']);
        }
        return const Scaffold(body: Center(child: Text('Rating not found')));
      },
    ),

    // Page not found
    GetPage(
      name: RouteNames.other.pageNoFound,
      page: () => const Scaffold(body: Center(child: Text('Page not found'))),
    ),
  ];
}
