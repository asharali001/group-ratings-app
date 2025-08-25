import 'package:get/instance_manager.dart';

import '../__core.dart';
import '../../pages/__pages.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    // ## SERVICES
    Get.put(AuthService(), permanent: true);

    // ## Controllers
    Get.put(AuthController());
    Get.put(HomeController());
    Get.put(GroupsListController());
  }
}
