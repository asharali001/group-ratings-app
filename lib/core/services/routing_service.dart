import 'package:get/get.dart';
import 'package:flutter/widgets.dart';

class RoutingService {
  static bool canPop() {
    return Get.previousRoute.isNotEmpty;
  }

  static void pop({dynamic result}) {
    if (canPop()) {
      Get.back(result: result);
    }
  }

  static void popAll(BuildContext context) {
    while (canPop()) {
      pop();
    }
  }

  static void pushNamed(
    BuildContext context,
    String routeName, {
    Map<String, String>? args,
  }) {
    Get.toNamed(
      routeName,
      parameters: args ?? {},
    );
  }

  static void popAllPushNamed(BuildContext context, String routeName,
      {Map<String, String>? args}) {
    Get.offAllNamed(
      routeName,
      parameters: args ?? {},
    );
  }

  static void replaceNamed(BuildContext context, String routeName,
      {Map<String, String>? args}) {
    Get.offNamed(
      routeName,
      parameters: args ?? {},
    );
  }
}
