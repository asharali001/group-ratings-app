import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '/styles/__styles.dart';

import '../auth_controller.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (controller) {
        return SizedBox(
          height: 50,
          child: OutlinedButton.icon(
            onPressed: controller.isLoading ? null : controller.signInWithGoogle,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.gray.withValues(alpha: 0.3)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
              ),
              backgroundColor: AppColors.white,
            ),
            icon: const Icon(
              Icons.g_mobiledata,
              size: 24,
              color: AppColors.text,
            ),
            label: Text(
              'Continue with Google',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.text,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      },
    );
  }
}

