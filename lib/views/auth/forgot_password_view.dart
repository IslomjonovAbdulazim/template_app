import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/controllers/auth_controller.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../utils/validators.dart';
import '../../widgets/common/custom_button_widget.dart';
import '../../widgets/common/custom_text_field_widget.dart';
import '../../widgets/common/responsive_scaffold.dart';

class ForgotPasswordView extends GetView<AuthController> {
  ForgotPasswordView({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _emailSent = false.obs;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PageScaffold(
      title: 'forgot_password'.tr,
      showConnectivityBanner: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Obx(() => _emailSent.value
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

          // Email Field
          EmailTextField(
            controller: _emailController,
            validator: Validators.email,
          ),
          const SizedBox(height: 32),

          // Send Reset Link Button
          Obx(() => CustomButton(
            text: 'send_reset_link'.tr,
            onPressed: controller.isLoading ? null : _handleSendResetLink,
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

          const SizedBox(height: 32),

          // Back to Login
          _buildBackToLoginLink(isDark),
        ],
      ),
    );
  }

  Widget _buildSuccessContent(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 40),

        // Success Icon
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.successShade,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.email, // todo:::::::::::::::::::::::::::::::::::
            size: 50,
            color: AppColors.success,
          ),
        ),
        const SizedBox(height: 32),

        // Success Title
        Text(
          'email_sent'.tr,
          style: AppTextStyles.headlineMedium.copyWith(
            color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),

        // Success Message
        Text(
          'We\'ve sent a password reset link to ${_emailController.text}',
          style: AppTextStyles.bodyLarge.copyWith(
            color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),

        Text(
          'check_spam'.tr,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isDark ? DarkColors.textTertiary : LightColors.textTertiary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 48),

        // Resend Button
        CustomButton(
          text: 'Resend Email',
          onPressed: _handleResendEmail,
          type: ButtonType.secondary,
          size: ButtonSize.large,
        ),
        const SizedBox(height: 16),

        // Back to Login
        CustomButton(
          text: 'back_to_login'.tr,
          onPressed: () => Get.back(),
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
            gradient: AppColors.balanceGradient,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.lock_reset,
            size: 40,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),

        // Title
        Text(
          'reset_password'.tr,
          style: AppTextStyles.headlineMedium.copyWith(
            color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),

        // Instructions
        Text(
          'reset_instructions'.tr,
          style: AppTextStyles.bodyLarge.copyWith(
            color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildBackToLoginLink(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Remember your password?',
          style: AppTextStyles.bodyMedium.copyWith(
            color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
          ),
        ),
        TextButton(
          onPressed: () => Get.back(),
          child: Text(
            'back_to_login'.tr,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  void _handleSendResetLink() {
    if (_formKey.currentState?.validate() ?? false) {
      controller.forgotPassword(_emailController.text.trim()).then((response) {
        // if (response.isSuccess) { todo   ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        //   _emailSent.value = true;
        // }
      });
    }
  }

  void _handleResendEmail() {
    controller.forgotPassword(_emailController.text.trim());
  }
}