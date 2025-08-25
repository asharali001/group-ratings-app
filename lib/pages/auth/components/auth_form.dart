import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';

import '../auth_controller.dart';

class AuthForm extends StatelessWidget {
  const AuthForm({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Display Name Field (only for sign up)
            if (controller.isSignUp) ...[
              CustomTextField(
                controller: controller.displayNameController,
                labelText: 'Display Name',
                prefixIcon: Icons.person,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            
            // Email Field
            CustomTextField(
              controller: controller.emailController,
              labelText: 'Email',
              prefixIcon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: controller.isSignUp 
                ? TextInputAction.next 
                : TextInputAction.done,
            ),
            
            const SizedBox(height: AppSpacing.md),
            
            // Password Field
            CustomTextField(
              controller: controller.passwordController,
              labelText: 'Password',
              prefixIcon: Icons.lock,
              obscureText: !controller.isPasswordVisible,
              suffixIcon: IconButton(
                icon: Icon(
                  controller.isPasswordVisible 
                    ? Icons.visibility_off 
                    : Icons.visibility,
                  color: AppColors.textLight,
                ),
                onPressed: controller.togglePasswordVisibility,
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: () => _handleSubmit(controller),
            ),
            
            const SizedBox(height: AppSpacing.md),
            
            // Error Message
            if (controller.errorMessage.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                  border: Border.all(
                    color: AppColors.red.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: AppColors.red,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        controller.errorMessage,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            
            const SizedBox(height: AppSpacing.lg),
            
            // Submit Button
            CustomButton(
              onPressed: controller.isLoading 
                ? null 
                : () => _handleSubmit(controller),
              text: controller.isLoading 
                ? 'Please wait...'
                : (controller.isSignUp ? 'Sign Up' : 'Sign In'),
              isLoading: controller.isLoading,
            ),
            
            const SizedBox(height: AppSpacing.md),
            
            // Forgot Password (only for sign in)
            if (!controller.isSignUp)
              TextButton(
                onPressed: controller.isLoading 
                  ? null 
                  : controller.resetPassword,
                child: Text(
                  'Forgot Password?',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  void _handleSubmit(AuthController controller) {
    if (controller.isSignUp) {
      controller.signUpWithEmailAndPassword();
    } else {
      controller.signInWithEmailAndPassword();
    }
  }
}

