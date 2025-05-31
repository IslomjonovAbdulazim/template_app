import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/controllers/auth_controller.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../utils/validators.dart';
import '../../widgets/common/custom_button_widget.dart';
import '../../widgets/common/custom_text_field_widget.dart';
import '../../widgets/common/responsive_scaffold.dart';

class ResetPasswordView extends GetView<AuthController> {
  ResetPasswordView({super.key});

  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _passwordReset = false.obs;

  // Get token from route parameters
  String get token => Get.parameters['token'] ?? '';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PageScaffold(
      title: 'reset_password'.tr,
      showBackButton: false,
      showConnectivityBanner: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Obx(() => _passwordReset.value
              ? _buildSuccessContent(isDark)
              : _buildFormContent(isDark)
          ),
        ),
      ),
    );
  }

  Widget _buildFormContent(bool isDark) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 40),

          // Header
          _buildHeader(isDark),
          const SizedBox(height: 48),

          // Password Requirements Info
          _buildPasswordInfo(isDark),
          const SizedBox(height: 24),

          // New Password Field
          PasswordTextField(
            label: 'new_password'.tr,
            controller: _passwordController,
            validator: Validators.password,
          ),
          const SizedBox(height: 16),

          // Confirm Password Field
          PasswordTextField(
            label: 'confirm_new_password'.tr,
            controller: _confirmPasswordController,
            validator: (value) => Validators.confirmPassword(
              value,
              _passwordController.text,
            ),
          ),
          const SizedBox(height: 32),

          // Reset Password Button
          Obx(() => CustomButton(
            text: 'reset_button'.tr,
            onPressed: controller.isLoading ? null : _handleResetPassword,
            isLoading: controller.isLoading,
            type: ButtonType.primary,
            size: ButtonSize.large,
          )),
          const SizedBox(height: 24),

          // Error Message
          Obx(() => controller.hasError
              ? Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.errorShade,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.error.withOpacity(0.3)),
            ),
            child: Text(
              controller.authError,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.error,
              ),
              textAlign: TextAlign.center,
            ),
          )
              : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessContent(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 80),

        // Success Icon
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.successShade,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_circle_outline,
            size: 50,
            color: AppColors.success,
          ),
        ),
        const SizedBox(height: 32),

        // Success Title
        Text(
          'reset_success'.tr,
          style: AppTextStyles.headlineMedium.copyWith(
            color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),

        // Success Message
        Text(
          'Your password has been successfully reset. You can now sign in with your new password.',
          style: AppTextStyles.bodyLarge.copyWith(
            color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 48),

        // Continue to Login
        CustomButton(
          text: 'Continue to Login',
          onPressed: () => Get.offAllNamed('/login'),
          type: ButtonType.primary,
          size: ButtonSize.large,
        ),
      ],
    );
  }

  Widget _buildHeader(bool isDark) {
    return Column(
      children: [
        // Icon
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.security,
            size: 40,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),

        // Title
        Text(
          'Create New Password',
          style: AppTextStyles.headlineMedium.copyWith(
            color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),

        // Instructions
        Text(
          'strong_password'.tr,
          style: AppTextStyles.bodyLarge.copyWith(
            color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPasswordInfo(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.infoShade,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.info.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppColors.info,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Password Requirements',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.info,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildPasswordRequirement('At least 8 characters long'),
          _buildPasswordRequirement('Contains uppercase and lowercase letters'),
          _buildPasswordRequirement('Contains at least one number'),
          _buildPasswordRequirement('Contains at least one special character'),
        ],
      ),
    );
  }

  Widget _buildPasswordRequirement(String requirement) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            size: 16,
            color: AppColors.success,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              requirement,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.info,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleResetPassword() {
    if (token.isEmpty) {
      Get.showSnackbar(GetSnackBar(
        title: 'error'.tr,
        message: 'invalid_token'.tr,
        backgroundColor: AppColors.error,
        duration: const Duration(seconds: 3),
      ));
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      controller.resetPassword(
        token: token,
        newPassword: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      ).then((response) {
        // if (response.isSuccess) { // todo:::::::::::::::::::::::::::
        //   _passwordReset.value = true;
        // }
      });
    }
  }
}