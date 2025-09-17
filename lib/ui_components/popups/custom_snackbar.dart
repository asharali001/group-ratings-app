import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/styles/__styles.dart';

void showCustomSnackBar({
  required String message,
  String? actionButtonText,
  bool isError = false,
  bool isSuccess = false,
  VoidCallback? onActionPressed,
}) {
  Get.snackbar(
    '', // Empty title
    message,
    snackPosition: SnackPosition.BOTTOM,
    duration: const Duration(seconds: 5),
    backgroundColor: isError
        ? AppColors.error
        : isSuccess
        ? AppColors.success
        : AppColors.onSurface,
    colorText: AppColors.white,
    margin: const EdgeInsets.symmetric(horizontal: 18.0),
    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
    borderRadius: 12.0,
    isDismissible: true,
    dismissDirection: DismissDirection.horizontal,
    forwardAnimationCurve: Curves.easeOutBack,
    reverseAnimationCurve: Curves.easeInBack,
    animationDuration: const Duration(milliseconds: 300),
    mainButton: actionButtonText != null
        ? TextButton(
            onPressed: onActionPressed ?? () => Get.back(),
            child: Text(
              actionButtonText,
              style: const TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        : null,
    titleText: const SizedBox.shrink(),
    messageText: Text(
      message,
      style: const TextStyle(
        color: AppColors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
