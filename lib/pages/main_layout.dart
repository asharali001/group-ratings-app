import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

import '/pages/__pages.dart';
import '/styles/__styles.dart';
import 'main_layout_controller.dart';

class MainLayout extends GetView<MainLayoutController> {
  const MainLayout({super.key});

  final List<Widget> _pages = const [
    HomePage(),
    GroupsPage(),
    MyRatingsPage(),
    AskAIPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(index: controller.currentIndex, children: _pages),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  context: context,
                  index: 0,
                  icon: EvaIcons.home,
                  label: 'Home',
                ),
                _buildNavItem(
                  context: context,
                  index: 1,
                  icon: EvaIcons.people,
                  label: 'Groups',
                ),
                _buildNavItem(
                  context: context,
                  index: 2,
                  icon: EvaIcons.star,
                  label: 'My Ratings',
                ),
                _buildNavItem(
                  context: context,
                  index: 3,
                  icon: EvaIcons.messageCircle,
                  label: 'Ask AI',
                ),
                _buildNavItem(
                  context: context,
                  index: 4,
                  icon: EvaIcons.person,
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required String label,
  }) {
    return Obx(() {
      final isSelected = controller.currentIndex == index;
      final color = isSelected
          ? AppColors.primary
          : AppColors.onSurfaceVariant.withValues(alpha: 0.6);

      return GestureDetector(
        onTap: () => controller.changeTab(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 4),
              Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  color: color,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
