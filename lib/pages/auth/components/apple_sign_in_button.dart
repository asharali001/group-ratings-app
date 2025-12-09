import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '/pages/auth/auth_controller.dart';

class AppleSignInButton extends StatelessWidget {
  const AppleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: GetBuilder<AuthController>(
        builder: (controller) {
          return SignInWithAppleButton(
            onPressed: controller.isLoading 
              ? () {} 
              : () => controller.signInWithApple(),
          );
        },
      ),
    );
  }
}
