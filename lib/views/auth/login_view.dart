import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/controllers/auth_controller.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../utils/validators.dart';
import '../../widgets/common/custom_button_widget.dart';
import '../../widgets/common/custom_text_field_widget.dart';
import '../../widgets/common/responsive_scaffold.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final AuthController controller = AuthController.instance;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rememberMe = false.obs;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ResponsiveScaffold(
      showConnectivityBanner: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),

                // Header Section
                _buildHeader(isDark),
                const SizedBox(height: 48),

                // Email Field
                EmailTextField(
                  controller: _emailController,
                  validator: Validators.email,
                  autofillHints: const [AutofillHints.email],
                ),
                const SizedBox(height: 16),

                // Password Field
                PasswordTextField(
                  controller: _passwordController,
                  validator: (value) => Validators.required(value, 'password'.tr),
                  autofillHints: const [AutofillHints.password],
                ),
                const SizedBox(height: 16),

                // Remember Me & Forgot Password Row
                _buildOptionsRow(isDark),
                const SizedBox(height: 32),

                // Login Button
                Obx(() => CustomButton(
                  text: 'login_button'.tr,
                  onPressed: controller.isLoading ? null : _handleLogin,
                  isLoading: controller.isLoading,
                  type: ButtonType.primary,
                  size: ButtonSize.large,
                  width: double.infinity,
                )),

                const SizedBox(height: 24),

                // Error Message
                Obx(() => _buildErrorMessage(isDark)),

                const SizedBox(height: 32),

                // Divider with OR
                _buildDivider(isDark),
                const SizedBox(height: 32),

                // Sign Up Link
                _buildSignUpLink(isDark),

                const SizedBox(height: 24),
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
        // App Logo
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
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
          'sign_in_to_continue'.tr,
          style: AppTextStyles.bodyLarge.copyWith(
            color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildOptionsRow(bool isDark) {
    return Row(
      children: [
        // Remember Me Checkbox
        Expanded(
          child: Obx(() => CheckboxListTile(
            value: _rememberMe.value,
            onChanged: (value) => _rememberMe.value = value ?? false,
            title: Text(
              'remember_me'.tr,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
              ),
            ),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: AppColors.primary,
            dense: true,
          )),
        ),

        // Forgot Password Link
        TextButton(
          onPressed: () => Get.toNamed('/forgot-password'),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          ),
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

  Widget _buildErrorMessage(bool isDark) {
    if (!controller.hasError) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.errorShade,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.error.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              controller.authError,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: isDark ? DarkColors.border : LightColors.border,
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or'.tr,
            style: AppTextStyles.bodySmall.copyWith(
              color: isDark ? DarkColors.textTertiary : LightColors.textTertiary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: isDark ? DarkColors.border : LightColors.border,
            thickness: 1,
          ),
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
        const SizedBox(width: 4),
        TextButton(
          onPressed: () => Get.toNamed('/register'),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
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
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
