import 'package:get/get.dart';

import 'add_rating_controller.dart';

class AddRatingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddRatingController>(() => AddRatingController());
  }
}
