import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '/core/__core.dart';
import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';

import '../../ratings/ratings_items/rating_items_controller.dart';
import '../../ratings/ratings_items/components/__components.dart';
import '../../ratings/ratings_items/rating_item_details_page.dart';

class GroupDetailsPage extends StatefulWidget {
  final Group group;

  const GroupDetailsPage({super.key, required this.group});

  @override
  State<GroupDetailsPage> createState() => _GroupDetailsPageState();
}

class _GroupDetailsPageState extends State<GroupDetailsPage> {
  int _activeTab = 0;

  @override
  void initState() {
    super.initState();
    final ratingController = Get.put(RatingItemController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ratingController.setGroupContext(widget.group);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ratingController = Get.find<RatingItemController>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 450,
              pinned: true,
              floating: false,
              title: innerBoxIsScrolled
                  ? Text(
                      widget.group.name,
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  : null,
              actions: [
                IconButton(
                  onPressed: () => _navigateToEditGroup(),
                  icon: const Icon(Icons.edit),
                  tooltip: 'Edit Group',
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(top: kToolbarHeight),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Large emoji circle
                        Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              widget.group.category.emoji,
                              style: const TextStyle(fontSize: 44),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        // Group name
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                          ),
                          child: Text(
                            widget.group.name,
                            style: AppTypography.headlineMedium.copyWith(
                              color: colorScheme.onSurface,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        // Meta text
                        Text(
                          '${widget.group.members.length} members \u00B7 Group',
                          style: AppTypography.bodyMedium.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        // Stat pills
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                          ),
                          child: _buildStatPills(ratingController),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: UnderlineTabRow(
                  tabs: const ['Rated Items', 'Members', 'About'],
                  activeIndex: _activeTab,
                  onTap: (index) => setState(() => _activeTab = index),
                ),
              ),
            ),
          ];
        },
        body: _buildTabContent(ratingController, colorScheme),
      ),
      bottomNavigationBar: Obx(() {
        if (!ratingController.canCreateRating()) return const SizedBox.shrink();
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      variant: AppButtonVariant.outline,
                      text: 'Invite',
                      icon: Icons.person_add_rounded,
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(text: widget.group.groupCode),
                        );
                        showCustomSnackBar(
                          message:
                              'Group code "${widget.group.groupCode}" copied!',
                          isSuccess: true,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppButton(
                      text: 'Add Item',
                      icon: Icons.add_rounded,
                      onPressed: () => _navigateToAddRating(ratingController),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStatPills(RatingItemController ratingController) {
    return Obx(() {
      final itemCount = ratingController.groupRatings.length;
      final allRatings = ratingController.groupRatings;
      double avgRating = 0;
      int ratedCount = 0;
      for (final item in allRatings) {
        if (item.ratings.isNotEmpty) {
          avgRating += item.averageRating;
          ratedCount++;
        }
      }
      if (ratedCount > 0) avgRating = avgRating / ratedCount;

      return Row(
        children: [
          Expanded(
            child: StatPill(
              value: '$itemCount',
              label: 'Items Rated',
              usePrimaryColor: true,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: StatPill(
              value: ratedCount > 0 ? avgRating.toStringAsFixed(1) : '\u2014',
              label: 'Avg Rating',
            ),
          ),
        ],
      );
    });
  }

  Widget _buildTabContent(
    RatingItemController ratingController,
    ColorScheme colorScheme,
  ) {
    switch (_activeTab) {
      case 0:
        return _buildRatedItemsTab(ratingController, colorScheme);
      case 1:
        return _buildMembersTab();
      case 2:
        return _buildAboutTab(colorScheme);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildRatedItemsTab(
    RatingItemController ratingController,
    ColorScheme colorScheme,
  ) {
    return Obx(() {
      final itemCount = ratingController.filteredRatings.length;
      final totalCount = ratingController.groupRatings.length;
      final hasSearchOrFilter =
          ratingController.searchQuery.value.isNotEmpty ||
          ratingController.selectedFilter.value != 'All';

      if (totalCount == 0 && !hasSearchOrFilter) {
        return EmptyStateWidget(
          icon: Icons.star_rounded,
          title: 'No items yet',
          description: 'Be the first to add an item to this group!',
          actions: [
            if (ratingController.canCreateRating())
              AppButton(
                onPressed: () => _navigateToAddRating(ratingController),
                text: 'Add First Item',
              ),
          ],
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.md,
              right: AppSpacing.md,
              top: AppSpacing.md,
            ),
            child: AppTextField(
              label: 'Search',
              hintText: 'Search items...',
              prefixIcon: Icons.search_rounded,
              onChanged: (value) {
                ratingController.updateSearchQuery(value);
              },
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 40,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Obx(
                () => Row(
                  children: [
                    _buildFilterChip(
                      'All',
                      isSelected:
                          ratingController.selectedFilter.value == 'All',
                      onTap: () => ratingController.updateFilter('All'),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _buildFilterChip(
                      'My Ratings',
                      isSelected:
                          ratingController.selectedFilter.value == 'My Ratings',
                      onTap: () => ratingController.updateFilter('My Ratings'),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _buildFilterChip(
                      'Highest Rated',
                      isSelected:
                          ratingController.selectedFilter.value ==
                          'Highest Rated',
                      onTap: () =>
                          ratingController.updateFilter('Highest Rated'),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _buildFilterChip(
                      'Newest',
                      isSelected:
                          ratingController.selectedFilter.value == 'Newest',
                      onTap: () => ratingController.updateFilter('Newest'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Text(
              itemCount == totalCount
                  ? 'Items ($itemCount)'
                  : 'Items ($itemCount of $totalCount)',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: itemCount == 0 && hasSearchOrFilter
                  ? const EmptyStateWidget(
                      key: ValueKey('empty_search'),
                      icon: Icons.search_off_rounded,
                      title: 'No items match your search',
                      description:
                          'Try adjusting your search or filter criteria',
                      actions: [],
                    )
                  : ListView.separated(
                      key: const ValueKey('items_list'),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemCount: ratingController.filteredRatings.length,
                      itemBuilder: (context, index) => CompactRatingItemCard(
                        item: ratingController.filteredRatings[index],
                        onTap: () => _navigateToRatingDetails(
                          ratingController.filteredRatings[index],
                        ),
                      ),
                    ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildMembersTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: GroupMembersSection(group: widget.group),
    );
  }

  Widget _buildAboutTab(ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          if (widget.group.description != null &&
              widget.group.description!.isNotEmpty) ...[
            Text(
              'DESCRIPTION',
              style: AppTypography.labelSmall.copyWith(
                color: colorScheme.onSurface,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              widget.group.description!,
              style: AppTypography.bodyLarge.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          // Category
          Text(
            'CATEGORY',
            style: AppTypography.labelSmall.copyWith(
              color: colorScheme.onSurface,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Text(
                widget.group.category.emoji,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                widget.group.category.displayName,
                style: AppTypography.bodyLarge.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'GROUP CODE',
            style: AppTypography.labelSmall.copyWith(
              color: colorScheme.onSurfaceVariant,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: widget.group.groupCode));
              showCustomSnackBar(
                message: 'Group code copied!',
                isSuccess: true,
              );
            },
            child: AppCard(
              width: double.infinity,
              variant: AppCardVariant.outlined,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.lg,
              ),
              child: Column(
                children: [
                  Text(
                    widget.group.groupCode,
                    style: AppTypography.mono.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.copy_rounded,
                        size: 14,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        'Tap to copy',
                        style: AppTypography.bodySmall.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Created date
          Text(
            'CREATED',
            style: AppTypography.labelSmall.copyWith(
              color: colorScheme.onSurfaceVariant,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(
                Icons.calendar_today_rounded,
                size: 16,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                DateFormat('MMM d, yyyy').format(widget.group.createdAt),
                style: AppTypography.bodyLarge.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // Action buttons
          AppButton(
            variant: AppButtonVariant.outline,
            text: 'Edit Group',
            icon: Icons.edit_rounded,
            isFullWidth: true,
            onPressed: () => _navigateToEditGroup(),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppButton(
            variant: AppButtonVariant.ghost,
            text: 'Leave Group',
            icon: Icons.logout_rounded,
            isFullWidth: true,
            onPressed: () => _showLeaveGroupDialog(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label, {
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    return AppChip(label: label, isSelected: isSelected, onTap: onTap);
  }

  void _navigateToAddRating(RatingItemController ratingController) {
    Get.toNamed(
      RouteNames.groups.addRatingPage,
      arguments: {'groupId': widget.group.id, 'groupName': widget.group.name},
    );
  }

  void _navigateToEditGroup() {
    Get.toNamed(
      RouteNames.groups.editGroupPage,
      arguments: {'group': widget.group},
    );
  }

  void _navigateToRatingDetails(RatingItem item) {
    Get.to(
      () => RatingItemDetailsPage(ratingItem: item),
      transition: Transition.cupertino,
    );
  }

  void _showLeaveGroupDialog() {
    showDialog(
      context: context,
      builder: (context) => AppDialog(
        title: 'Leave Group',
        description: 'Leave group "${widget.group.name}"?',
        primaryActionText: 'Leave',
        secondaryActionText: 'Cancel',
        isDestructive: true,
        onPrimaryAction: () {
          Get.back(); // close dialog
          Get.back(); // go back to groups list
        },
        onSecondaryAction: () {},
      ),
    );
  }
}
