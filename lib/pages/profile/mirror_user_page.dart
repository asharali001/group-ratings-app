import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/models/user_model.dart';
import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';
import 'profile_controller.dart';

class MirrorUserPage extends StatefulWidget {
  const MirrorUserPage({super.key});

  @override
  State<MirrorUserPage> createState() => _MirrorUserPageState();
}

class _MirrorUserPageState extends State<MirrorUserPage> {
  late final ProfileController _controller;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = Get.find<ProfileController>();
    _searchController.text = _controller.mirrorSearchQuery.value;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.loadUsersForMirror();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Get.back(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mirror User',
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            Text(
              'View the app as someone else',
              style: AppTypography.bodySmall.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        titleSpacing: 0,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            child: Obx(() => AppTextField(
              label: 'Search',
              controller: _searchController,
              hintText: 'Search by name or email…',
              prefixIcon: Icons.search_rounded,
              onChanged: _controller.updateMirrorSearch,
              suffixIcon: _controller.mirrorSearchQuery.value.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close_rounded, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        _controller.updateMirrorSearch('');
                      },
                    )
                  : null,
            )),
          ),

          // User list
          Expanded(
            child: Obx(() {
              if (_controller.isLoading.value && _controller.allUsers.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              final users = _controller.paginatedMirrorUsers;
              final totalFiltered = _controller.filteredMirrorUsers.length;

              if (totalFiltered == 0) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        size: 48,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'No users found',
                        style: AppTypography.bodyLarge.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.xs,
                ),
                itemCount: users.length + (_controller.hasMoreMirrorUsers ? 1 : 0),
                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                itemBuilder: (_, i) {
                  if (i == users.length) {
                    // Load more button
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      child: Center(
                        child: TextButton.icon(
                          onPressed: _controller.loadMoreMirrorUsers,
                          icon: const Icon(Icons.expand_more_rounded),
                          label: Text(
                            'Show more (${totalFiltered - users.length} remaining)',
                          ),
                        ),
                      ),
                    );
                  }
                  return _UserTile(
                    user: users[i],
                    isActive: _controller.mirroredUser.value?.uid == users[i].uid,
                    onTap: () {
                      _controller.startMirroring(users[i]);
                      Get.back();
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  final UserModel user;
  final bool isActive;
  final VoidCallback onTap;

  const _UserTile({
    required this.user,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppBorderRadius.lgRadius,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              AppAvatar(
                url: user.photoURL,
                initials: (user.displayName ?? 'U')[0].toUpperCase(),
                size: 48,
                backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                foregroundColor: colorScheme.primary,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.displayName ?? user.uid,
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    if (user.email != null)
                      Text(
                        user.email!,
                        style: AppTypography.bodySmall.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
              if (isActive)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(9999),
                    border: Border.all(color: const Color(0xFFF59E0B)),
                  ),
                  child: Text(
                    'Active',
                    style: AppTypography.labelSmall.copyWith(
                      color: const Color(0xFFD97706),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              else
                Icon(
                  Icons.chevron_right_rounded,
                  color: colorScheme.onSurfaceVariant,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
