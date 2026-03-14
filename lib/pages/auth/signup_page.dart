import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';
import 'components/apple_sign_in_button.dart';
import 'auth_controller.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      init: AuthController()..setSignUpMode(),
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

                  // Hero icon
                  Center(
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryTint,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: KretikLogo(
                          size: 36,
                          variant: KretikLogoVariant.markOnly,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Title + subtitle
                  Text(
                    'Create Account',
                    style: AppTypography.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Join Kretik to start rating with friends',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Sign Up Form
                  _buildSignUpForm(controller),

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
                          'OR CONTINUE WITH',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textSecondary,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider(color: AppColors.border)),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Social buttons side-by-side
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          text: 'Google',
                          variant: AppButtonVariant.outline,
                          iconWidget: Image.asset(
                            'assets/images/google-logo.png',
                            width: 20,
                            height: 20,
                          ),
                          onPressed: controller.isLoading
                              ? null
                              : controller.signInWithGoogle,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      const Expanded(child: AppleSignInButton()),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Link to Sign In
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.toNamed('/signin'),
                        child: Text(
                          'Sign In',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Security banner
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.lock_outline_rounded,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        'Your data is encrypted and secure',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
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

  Widget _buildSignUpForm(AuthController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Display Name Field
        AppTextField(
          controller: controller.displayNameController,
          label: 'Display Name',
          prefixIcon: Icons.person,
          textInputAction: TextInputAction.next,
        ),

        const SizedBox(height: AppSpacing.md),

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
            onFieldSubmitted: (_) => controller.signUpWithEmailAndPassword(),
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
                : controller.signUpWithEmailAndPassword,
            text: 'Sign Up',
            isLoading: controller.isLoading,
            isFullWidth: true,
          );
        }),
      ],
    );
  }
}
