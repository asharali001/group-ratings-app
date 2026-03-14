import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/models/chat_message.dart';
import '/core/models/group.dart';
import '/core/models/rating_item.dart';
import '/core/services/ai_service.dart';
import '/core/services/group_service.dart';
import '/core/services/rating_service.dart';
import '/core/routes/route_names.dart';
import '/pages/ratings/ratings_items/rating_item_details_page.dart';
import '/pages/ratings/ratings_items/rating_items_controller.dart';

class AskAIController extends GetxController {
  final AiService _aiService = AiService();

  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isLoading = false.obs;
  final TextEditingController inputController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  // Cache for fetched reference data
  final Map<String, Group> _groupCache = {};
  final Map<String, RatingItem> _ratingItemCache = {};

  Future<Group?> fetchGroup(String groupId) async {
    if (_groupCache.containsKey(groupId)) return _groupCache[groupId];
    final group = await GroupService.getGroup(groupId);
    if (group != null) _groupCache[groupId] = group;
    return group;
  }

  Future<RatingItem?> fetchRatingItem(String itemId) async {
    if (_ratingItemCache.containsKey(itemId)) return _ratingItemCache[itemId];
    final item = await RatingService().getRatingItem(itemId);
    if (item != null) _ratingItemCache[itemId] = item;
    return item;
  }

  Future<void> sendMessage(String question) async {
    final trimmed = question.trim();
    if (trimmed.isEmpty || isLoading.value) return;
    inputController.clear();
    messages.add(ChatMessage(role: ChatRole.user, text: trimmed));
    _scrollToBottom();
    isLoading.value = true;
    try {
      final result = await _aiService.queryAI(trimmed);
      messages.add(
        ChatMessage(
          role: ChatRole.assistant,
          text: result.answer,
          references: result.references,
        ),
      );
    } catch (e) {
      messages.add(
        ChatMessage(
          role: ChatRole.assistant,
          text: "Sorry, something went wrong. Please try again.",
        ),
      );
    } finally {
      isLoading.value = false;
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> navigateToGroup(String groupId) async {
    final group = await GroupService.getGroup(groupId);
    if (group != null) {
      Get.toNamed(RouteNames.groups.ratingsPage, arguments: {'group': group});
    }
  }

  Future<void> navigateToRatingItem(String itemId, String? groupId) async {
    final item = await RatingService().getRatingItem(itemId);
    if (item == null) return;

    final ratingController = Get.put(RatingItemController());

    if (groupId != null) {
      final group = await GroupService.getGroup(groupId);
      if (group != null) {
        ratingController.setGroupContext(group);
      }
    }

    Get.to(
      () => RatingItemDetailsPage(ratingItem: item),
      transition: Transition.cupertino,
    );
  }

  @override
  void onClose() {
    inputController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
