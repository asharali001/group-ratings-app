import 'package:get/get.dart';

import 'edit_group_controller.dart';

class EditGroupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditGroupController>(() => EditGroupController());
  }
}
