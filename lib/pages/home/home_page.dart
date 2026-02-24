import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '/ui_components/__ui_components.dart';
import '/styles/__styles.dart';

import 'home_controller.dart';
import 'components/__components.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageLayout(
      title: 'Group Ratings',
      subtitle: 'Rate and review together',
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StatsSection(),
            SizedBox(height: AppSpacing.xl),
            QuickActionsSection(),
          ],
        ),
      ),
    );
  }
}
