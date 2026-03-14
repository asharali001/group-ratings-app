import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

import '/styles/__styles.dart';
import 'main_layout_controller.dart';

class MainLayout extends GetView<MainLayoutController> {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = controller.pages;
    return Scaffold(
      body: Obx(
        () => IndexedStack(index: controller.currentIndex, children: pages),
      ),
      bottomNavigationBar: const NavigationBar(),
    );
  }
}

class NavigationBar extends StatelessWidget {
  const NavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: const SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NavbarItem(index: 0, icon: EvaIcons.home, label: 'Home'),
            NavbarItem(index: 1, icon: EvaIcons.people, label: 'Groups'),
            NavbarItem(index: 2, icon: EvaIcons.star, label: 'Ratings'),
            NavbarItem(index: 3, icon: EvaIcons.messageCircle, label: 'Ask AI'),
            NavbarItem(index: 4, icon: EvaIcons.person, label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

class NavbarItem extends GetView<MainLayoutController> {
  const NavbarItem({
    super.key,
    required this.index,
    required this.icon,
    required this.label,
  });

  final int index;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
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
