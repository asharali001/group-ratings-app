import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';
import 'components/apple_sign_in_button.dart';
import 'auth_controller.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      init: AuthController()..setSignInMode(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSpacing.xl),

                  // App Logo/Title
                  Column(
                    children: [
                      const Icon(
                        Icons.group,
                        size: 80,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Group Ratings',
                        style: AppTypography.headlineLarge.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Welcome back! Sign in to continue',
                        style: AppTypography.bodyLarge.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Sign In Form
                  _buildSignInForm(controller),

                  const SizedBox(height: AppSpacing.lg),

                  // Divider
                  Row(
                    children: [
                      const Expanded(child: Divider(color: AppColors.border)),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                        ),
                        child: Text(
                          'OR',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider(color: AppColors.border)),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Google Sign In Button
                  AppButton(
                    text: 'Continue with Google',
                    variant: AppButtonVariant.outline,
                    isFullWidth: true,
                    iconWidget: Image.asset(
                      'assets/images/google-logo.png',
                      width: 24,
                      height: 24,
                    ),
                    onPressed: controller.isLoading
                        ? null
                        : controller.signInWithGoogle,
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Apple Sign In Button
                  // Keeping the wrapper as it likely handles specific Apple JS/Native logic internally or styling quirks
                  // But checking if we should replace it? logic is simple controller call.
                  // For now, keep as is for safety, but ensure height matches.
                  const AppleSignInButton(),

                  const SizedBox(height: AppSpacing.lg),

                  // Link to Sign Up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.toNamed('/signup'),
                        child: Text(
                          'Sign Up',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSignInForm(AuthController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Email Field
        AppTextField(
          controller: controller.emailController,
          label: 'Email',
          prefixIcon: Icons.email,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),

        const SizedBox(height: AppSpacing.md),

        // Password Field
        Obx(() {
          return AppTextField(
            controller: controller.passwordController,
            label: 'Password',
            prefixIcon: Icons.lock,
            obscureText: !controller.isPasswordVisible,
            suffixIcon: IconButton(
              icon: Icon(
                controller.isPasswordVisible
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: AppColors.textTertiary,
              ),
              onPressed: controller.togglePasswordVisibility,
            ),
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => controller.signInWithEmailAndPassword(),
          );
        }),

        const SizedBox(height: AppSpacing.md),

        // Error Message
        Obx(() {
          if (controller.errorMessage.isEmpty) return const SizedBox.shrink();
          return Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              borderRadius: AppBorderRadius.smRadius,
              border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.error_outline,
                  color: AppColors.error,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    controller.errorMessage,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),

        const SizedBox(height: AppSpacing.lg),

        // Submit Button
        Obx(() {
          return AppButton(
            onPressed: controller.isLoading
                ? null
                : controller.signInWithEmailAndPassword,
            text: 'Sign In',
            isLoading: controller.isLoading,
            isFullWidth: true,
          );
        }),

        const SizedBox(height: AppSpacing.md),

        // Forgot Password
        Align(
          alignment: Alignment.center,
          child: AppButton(
            variant: AppButtonVariant.ghost,
            onPressed: controller.isLoading ? null : controller.resetPassword,
            text: 'Forgot Password?',
          ),
        ),
      ],
    );
  }
}
