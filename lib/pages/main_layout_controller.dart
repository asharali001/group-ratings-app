import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '/pages/__pages.dart';

class MainLayoutController extends GetxController {
  final RxInt _currentIndex = 0.obs;

  int get currentIndex => _currentIndex.value;

  void changeTab(int index) {
    _currentIndex.value = index;
  }

  final List<Widget> pages = const [
    HomePage(),
    GroupsPage(),
    MyRatingsPage(),
    AskAIPage(),
    ProfilePage(),
  ];
}
