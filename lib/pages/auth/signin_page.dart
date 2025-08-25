import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';
import 'components/google_sign_in_button.dart';

import 'auth_controller.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      init: AuthController()..setSignInMode(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.white,
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
                          color: AppColors.textLight,
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
                      Expanded(child: Divider(color: AppColors.gray.withValues(alpha: 0.3))),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                        child: Text(
                          'OR',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textLight,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: AppColors.gray.withValues(alpha: 0.3))),
                    ],
                  ),
                  
                  const SizedBox(height: AppSpacing.lg),
                  
                  // Google Sign In Button
                  const GoogleSignInButton(),
                  
                  const SizedBox(height: AppSpacing.lg),
                  
                  // Link to Sign Up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textLight,
                        ),
                      ),
                      TextButton(
                        onPressed: () => Get.toNamed('/signup'),
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
        CustomTextField(
          controller: controller.emailController,
          labelText: 'Email',
          prefixIcon: Icons.email,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
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
          onSubmitted: () => controller.signInWithEmailAndPassword(),
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
            : controller.signInWithEmailAndPassword,
          text: controller.isLoading 
            ? 'Please wait...'
            : 'Sign In',
          isLoading: controller.isLoading,
        ),
        
        const SizedBox(height: AppSpacing.md),
        
        // Forgot Password
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
  }
}
