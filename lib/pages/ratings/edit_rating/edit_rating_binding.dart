import 'package:get/get.dart';

import 'edit_rating_controller.dart';

class EditRatingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditRatingController>(() => EditRatingController());
  }
}
