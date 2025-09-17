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
            icon: Image.asset(
              'assets/images/google-logo.png',
              width: 24,
              height: 24,
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

