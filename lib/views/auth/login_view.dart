import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/controllers/auth_controller.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../utils/validators.dart';
import '../../widgets/common/custom_button_widget.dart';
import '../../widgets/common/custom_text_field_widget.dart';
import '../../widgets/common/responsive_scaffold.dart';

class LoginView extends GetView<AuthController> {
  LoginView({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rememberMe = false.obs;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PageScaffold(
      showBackButton: false,
      showConnectivityBanner: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),

                // Logo/Header
                _buildHeader(isDark),
                const SizedBox(height: 48),

                // Email Field
                EmailTextField(
                  controller: _emailController,
                  validator: Validators.email,
                ),
                const SizedBox(height: 16),

                // Password Field
                PasswordTextField(
                  controller: _passwordController,
                  validator: Validators.password,
                ),
                const SizedBox(height: 16),

                // Remember Me & Forgot Password
                _buildOptionsRow(),
                const SizedBox(height: 32),

                // Login Button
                Obx(() => CustomButton(
                  text: 'login_button'.tr,
                  onPressed: controller.isLoading ? null : _handleLogin,
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

                // Divider
                _buildDivider(isDark),
                const SizedBox(height: 32),

                // Social Login (Optional)
                _buildSocialLogin(),
                const SizedBox(height: 40),

                // Sign Up Link
                _buildSignUpLink(isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Column(
      children: [
        // App Icon/Logo
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.lock_outline,
            size: 40,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),

        // Welcome Text
        Text(
          'welcome_back'.tr,
          style: AppTextStyles.headlineMedium.copyWith(
            color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),

        Text(
          'Sign in to your account',
          style: AppTextStyles.bodyLarge.copyWith(
            color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildOptionsRow() {
    return Row(
      children: [
        // Remember Me
        Expanded(
          child: Obx(() => Row(
            children: [
              Checkbox(
                value: _rememberMe.value,
                onChanged: (value) => _rememberMe.value = value ?? false,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'remember_me'.tr,
                  style: AppTextStyles.bodyMedium,
                ),
              ),
            ],
          )),
        ),

        // Forgot Password
        TextButton(
          onPressed: () => Get.toNamed('/forgot-password'),
          child: Text(
            'forgot_password'.tr,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: isDark ? DarkColors.border : LightColors.border,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or'.tr,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isDark ? DarkColors.textTertiary : LightColors.textTertiary,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: isDark ? DarkColors.border : LightColors.border,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialLogin() {
    return Column(
      children: [
        // Google Login
        CustomButton(
          text: 'Continue with Google',
          onPressed: _handleGoogleLogin,
          type: ButtonType.secondary,
          size: ButtonSize.large,
          icon: Icons.g_mobiledata,
        ),
        const SizedBox(height: 12),

        // Apple Login (iOS only - you can add platform check)
        CustomButton(
          text: 'Continue with Apple',
          onPressed: _handleAppleLogin,
          type: ButtonType.secondary,
          size: ButtonSize.large,
          icon: Icons.apple,
        ),
      ],
    );
  }

  Widget _buildSignUpLink(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'no_account'.tr,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
          ),
        ),
        TextButton(
          onPressed: () => Get.toNamed('/register'),
          child: Text(
            'sign_up'.tr,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      controller.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        rememberMe: _rememberMe.value,
      );
    }
  }

  void _handleGoogleLogin() {
    // Implement Google login
    Get.showSnackbar(GetSnackBar(
      title: 'Coming Soon',
      message: 'Google login will be available soon',
      duration: const Duration(seconds: 2),
    ));
  }

  void _handleAppleLogin() {
    // Implement Apple login
    Get.showSnackbar(GetSnackBar(
      title: 'Coming Soon',
      message: 'Apple login will be available soon',
      duration: const Duration(seconds: 2),
    ));
  }
}