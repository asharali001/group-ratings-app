import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

import '/core/models/chat_message.dart';
import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';
import 'ask_ai_controller.dart';

class AskAIPage extends StatelessWidget {
  const AskAIPage({super.key});

  static const _suggestions = [
    'Where did we eat that veggie burger?',
    "What's my highest rated horror movie?",
    'Show me restaurants John and I both loved',
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AskAIController());
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text('Ask AI', style: AppTypography.titleLarge),
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1,
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.messages.isEmpty) {
                return _buildEmptyState(context, controller);
              }
              return _buildMessageList(context, controller);
            }),
          ),
          _buildInputRow(context, controller),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AskAIController controller) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        const SizedBox(height: AppSpacing.xl),
        Container(
          alignment: Alignment.center,
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: AppBorderRadius.xlRadius,
            ),
            child: const Icon(
              EvaIcons.messageCircle,
              color: AppColors.primary,
              size: 32,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Ask anything about your ratings',
          textAlign: TextAlign.center,
          style: AppTypography.titleMedium,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Search across all your groups, items, and reviews',
          textAlign: TextAlign.center,
          style: AppTypography.bodySmall.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          'Try asking',
          style: AppTypography.labelMedium.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        ..._suggestions.map(
          (q) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: _SuggestionChip(
              question: q,
              onTap: () => controller.sendMessage(q),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageList(BuildContext context, AskAIController controller) {
    return ListView.builder(
      controller: controller.scrollController,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      itemCount: controller.messages.length + (controller.isLoading.value ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == controller.messages.length) {
          return const _TypingIndicator();
        }
        final message = controller.messages[index];
        return _MessageBubble(message: message);
      },
    );
  }

  Widget _buildInputRow(BuildContext context, AskAIController controller) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.sm,
        top: AppSpacing.sm,
        bottom: AppSpacing.sm + MediaQuery.of(context).padding.bottom,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: AppTextField(
              label: '',
              hintText: 'Ask about your ratings...',
              controller: controller.inputController,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 1,
              textInputAction: TextInputAction.send,
              onFieldSubmitted: (_) => controller.sendMessage(
                controller.inputController.text,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Obx(
            () => IconButton.filled(
              onPressed: controller.isLoading.value
                  ? null
                  : () => controller.sendMessage(controller.inputController.text),
              icon: controller.isLoading.value
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(EvaIcons.arrowUpward, size: 20),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.4),
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Message Bubble ───────────────────────────────────────────────────────────

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == ChatRole.user;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            _AIAvatar(),
            const SizedBox(width: AppSpacing.sm),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                _BubbleContent(message: message, isUser: isUser),
                if (!isUser && message.references.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  _ReferenceCards(references: message.references),
                ],
              ],
            ),
          ),
          if (isUser) const SizedBox(width: AppSpacing.xl),
        ],
      ),
    );
  }
}

class _AIAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: AppBorderRadius.fullRadius,
      ),
      child: const Icon(EvaIcons.flash, color: Colors.white, size: 16),
    );
  }
}

class _BubbleContent extends StatelessWidget {
  final ChatMessage message;
  final bool isUser;

  const _BubbleContent({required this.message, required this.isUser});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm + 2,
      ),
      decoration: BoxDecoration(
        color: isUser
            ? AppColors.primary
            : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(AppBorderRadius.lg),
          topRight: const Radius.circular(AppBorderRadius.lg),
          bottomLeft: Radius.circular(isUser ? AppBorderRadius.lg : AppBorderRadius.sm),
          bottomRight: Radius.circular(isUser ? AppBorderRadius.sm : AppBorderRadius.lg),
        ),
      ),
      child: Text(
        message.text,
        style: AppTypography.bodyMedium.copyWith(
          color: isUser
              ? Colors.white
              : theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}

// ─── Reference Cards ─────────────────────────────────────────────────────────

class _ReferenceCards extends StatelessWidget {
  final List<AIReference> references;

  const _ReferenceCards({required this.references});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AskAIController>();
    final visible = references.take(3).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: visible.map((ref) {
        final isGroup = ref.type == 'group';
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: isGroup
              ? _GroupReferenceCard(reference: ref, controller: controller)
              : _RatingItemReferenceCard(reference: ref, controller: controller),
        );
      }).toList(),
    );
  }
}

class _GroupReferenceCard extends StatelessWidget {
  final AIReference reference;
  final AskAIController controller;

  const _GroupReferenceCard({required this.reference, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return FutureBuilder(
      future: controller.fetchGroup(reference.id),
      builder: (context, snapshot) {
        final group = snapshot.data;

        return Material(
          color: colorScheme.surfaceContainerLow,
          borderRadius: AppBorderRadius.mdRadius,
          child: InkWell(
            onTap: () => controller.navigateToGroup(reference.id),
            borderRadius: AppBorderRadius.mdRadius,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.sm + 2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.15),
                ),
                borderRadius: AppBorderRadius.mdRadius,
              ),
              child: Row(
                children: [
                  // Category emoji circle
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      group?.category.emoji ?? '👥',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reference.name,
                          style: AppTypography.titleSmall.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 2),
                        // Metadata row
                        Row(
                          children: [
                            Icon(Icons.people_rounded, size: 13, color: colorScheme.onSurfaceVariant),
                            const SizedBox(width: 3),
                            Text(
                              group != null
                                  ? '${group.memberIds.length} member${group.memberIds.length == 1 ? '' : 's'}'
                                  : 'Group',
                              style: AppTypography.bodySmall.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            if (group != null) ...[
                              Text(
                                ' \u2022 ',
                                style: AppTypography.bodySmall.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              Icon(Icons.star_rounded, size: 13, color: colorScheme.onSurfaceVariant),
                              const SizedBox(width: 3),
                              Text(
                                '${group.ratingItemsCount} item${group.ratingItemsCount == 1 ? '' : 's'}',
                                style: AppTypography.bodySmall.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (group?.description?.isNotEmpty == true) ...[
                          const SizedBox(height: 2),
                          Text(
                            group!.description!,
                            style: AppTypography.bodySmall.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              height: 1.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RatingItemReferenceCard extends StatelessWidget {
  final AIReference reference;
  final AskAIController controller;

  const _RatingItemReferenceCard({required this.reference, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return FutureBuilder(
      future: controller.fetchRatingItem(reference.id),
      builder: (context, snapshot) {
        final item = snapshot.data;
        final averageRating = item?.averageRating ?? 0.0;
        final ratingCount = item?.ratings.length ?? 0;

        return Material(
          color: colorScheme.surfaceContainerLow,
          borderRadius: AppBorderRadius.mdRadius,
          child: InkWell(
            onTap: () => controller.navigateToRatingItem(reference.id, reference.groupId),
            borderRadius: AppBorderRadius.mdRadius,
            child: Container(
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.15),
                ),
                borderRadius: AppBorderRadius.mdRadius,
              ),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    // Image thumbnail
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(AppBorderRadius.md),
                          bottomLeft: Radius.circular(AppBorderRadius.md),
                        ),
                      ),
                      child: item?.imageUrl != null && item!.imageUrl!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(AppBorderRadius.md),
                                bottomLeft: Radius.circular(AppBorderRadius.md),
                              ),
                              child: Image.network(
                                item.imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Center(
                                  child: Icon(
                                    Icons.image_outlined,
                                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                                    size: 24,
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              child: Icon(
                                Icons.image_outlined,
                                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                                size: 24,
                              ),
                            ),
                    ),
                    const SizedBox(width: AppSpacing.sm),

                    // Item info
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              reference.name,
                              style: AppTypography.titleSmall.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (item?.location?.isNotEmpty == true) ...[
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Icon(Icons.location_on_outlined, size: 13, color: colorScheme.onSurfaceVariant),
                                  const SizedBox(width: 3),
                                  Expanded(
                                    child: Text(
                                      item!.location!,
                                      style: AppTypography.bodySmall.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            const SizedBox(height: 2),
                            // Rating row
                            Row(
                              children: [
                                const Icon(Icons.star_rounded, size: 14, color: AppColors.warning),
                                const SizedBox(width: 3),
                                Text(
                                  ratingCount > 0
                                      ? '${averageRating.toStringAsFixed(1)} / ${item!.ratingScale}'
                                      : 'No ratings yet',
                                  style: AppTypography.labelMedium.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                if (ratingCount > 0)
                                  Text(
                                    ' \u2022 $ratingCount rating${ratingCount == 1 ? '' : 's'}',
                                    style: AppTypography.bodySmall.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Chevron
                    Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        size: 20,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─── Typing Indicator ────────────────────────────────────────────────────────

class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AIAvatar(),
          const SizedBox(width: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm + 2,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppBorderRadius.lg),
                topRight: Radius.circular(AppBorderRadius.lg),
                bottomLeft: Radius.circular(AppBorderRadius.sm),
                bottomRight: Radius.circular(AppBorderRadius.lg),
              ),
            ),
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _Dot(opacity: _animation.value),
                    const SizedBox(width: 4),
                    _Dot(opacity: _animation.value * 0.7),
                    const SizedBox(width: 4),
                    _Dot(opacity: _animation.value * 0.4),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final double opacity;
  const _Dot({required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity.clamp(0.2, 1.0),
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

// ─── Suggestion Chip ─────────────────────────────────────────────────────────

class _SuggestionChip extends StatelessWidget {
  final String question;
  final VoidCallback onTap;

  const _SuggestionChip({required this.question, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: AppBorderRadius.mdRadius,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.4),
          ),
          borderRadius: AppBorderRadius.mdRadius,
        ),
        child: Row(
          children: [
            Icon(
              EvaIcons.messageCircleOutline,
              color: AppColors.primary,
              size: 18,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(question, style: AppTypography.bodyMedium),
            ),
            Icon(
              EvaIcons.arrowForwardOutline,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
