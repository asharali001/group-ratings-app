import 'package:get/get.dart';

import 'rating_items_controller.dart';

class RatingItemBinding extends Bindings {
  @override
  void dependencies() {
    // Use putIfAbsent pattern - if controller exists, use it; otherwise create new one
    if (!Get.isRegistered<RatingItemController>()) {
      Get.put(RatingItemController());
    }
  }
}

