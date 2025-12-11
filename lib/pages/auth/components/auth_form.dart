import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';

import '../auth_controller.dart';

class AuthForm extends StatelessWidget {
  const AuthForm({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final controller = Get.find<AuthController>();

    // Use Obx to listen to changes
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Display Name Field (only for sign up)
            if (controller.isSignUp) ...[
              AppTextField(
                controller: controller.displayNameController,
                label: 'Display Name',
                prefixIcon: Icons.person_rounded,
                textInputAction: TextInputAction.next,
                enabled: !controller.isLoading,
              ),
              const SizedBox(height: AppSpacing.md),
            ],

            // Email Field
            AppTextField(
              controller: controller.emailController,
              label: 'Email',
              prefixIcon: Icons.email_rounded,
              keyboardType: TextInputType.emailAddress,
              textInputAction: controller.isSignUp
                  ? TextInputAction.next
                  : TextInputAction.done,
              enabled: !controller.isLoading,
            ),

            const SizedBox(height: AppSpacing.md),

            // Password Field
            AppTextField(
              controller: controller.passwordController,
              label: 'Password',
              prefixIcon: Icons.lock_rounded,
              obscureText: !controller.isPasswordVisible,
              enabled: !controller.isLoading,
              suffixIcon: IconButton(
                icon: Icon(
                  controller.isPasswordVisible
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  color: colorScheme.onSurfaceVariant,
                ),
                onPressed: controller.togglePasswordVisibility,
              ),
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _handleSubmit(controller),
            ),

            const SizedBox(height: AppSpacing.md),

            // Error Message
            if (controller.errorMessage.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: colorScheme.error.withValues(alpha: 0.1),
                  borderRadius: AppBorderRadius.smRadius,
                  border: Border.all(
                    color: colorScheme.error.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      color: colorScheme.error,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        controller.errorMessage,
                        style: AppTypography.bodyMedium.copyWith(
                          color: colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: AppSpacing.lg),

            // Submit Button
            AppButton(
              onPressed: controller.isLoading
                  ? null
                  : () => _handleSubmit(controller),
              text: controller.isLoading
                  ? 'Please wait...'
                  : (controller.isSignUp ? 'Sign Up' : 'Sign In'),
              isLoading: controller.isLoading,
              isFullWidth: true,
            ),

            const SizedBox(height: AppSpacing.md),

            // Forgot Password (only for sign in)
            if (!controller.isSignUp)
              Center(
                child: TextButton(
                  onPressed: controller.isLoading
                      ? null
                      : controller.resetPassword,
                  child: Text(
                    'Forgot Password?',
                    style: AppTypography.bodyMedium.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ));
  }

  void _handleSubmit(AuthController controller) {
    if (controller.isSignUp) {
      controller.signUpWithEmailAndPassword();
    } else {
      controller.signInWithEmailAndPassword();
    }
  }
}
