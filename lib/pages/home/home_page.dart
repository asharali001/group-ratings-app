import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '/core/__core.dart';
import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';

import 'home_controller.dart';
import 'components/__components.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Get.find<AuthService>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome header
              Obx(() => Row(
                children: [
                  AppAvatar(
                    initials: _getInitials(authService.effectiveUserDisplayName),
                    url: authService.effectiveUserPhotoURL,
                    size: 48,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back,',
                        style: AppTypography.bodySmall.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        _getFirstName(authService.effectiveUserDisplayName),
                        style: AppTypography.headlineSmall.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ],
              )),
              const SizedBox(height: AppSpacing.xl),
              const StatsSection(),
              const SizedBox(height: AppSpacing.xl),
              const QuickActionsSection(),
              const SizedBox(height: AppSpacing.xl),
              const ActivityFeedSection(),
            ],
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  String _getFirstName(String name) {
    final parts = name.trim().split(' ');
    return parts.isNotEmpty ? parts[0] : 'User';
  }
}
