import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '/styles/__styles.dart';

import 'home_controller.dart';
import 'components/__components.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppbar(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatsSection(),
                    SizedBox(height: AppSpacing.xl),
                    QuickActionsSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
