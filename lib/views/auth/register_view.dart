import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/controllers/auth_controller.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../utils/validators.dart';
import '../../widgets/common/custom_button_widget.dart';
import '../../widgets/common/custom_text_field_widget.dart';
import '../../widgets/common/responsive_scaffold.dart';

class RegisterView extends GetView<AuthController> {
  RegisterView({super.key});

  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _acceptTerms = false.obs;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ResponsiveScaffold(
      showBackButton: true,
      showConnectivityBanner: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                // Header Section
                _buildHeader(isDark),
                const SizedBox(height: 40),

                // Name Fields Row
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'first_name'.tr,
                        controller: _firstNameController,
                        prefixIcon: Icons.person_outline,
                        validator: (value) => Validators.name(value, 'first_name'.tr),
                        textCapitalization: TextCapitalization.words,
                        autofillHints: const [AutofillHints.givenName],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        label: 'last_name'.tr,
                        controller: _lastNameController,
                        prefixIcon: Icons.person_outline,
                        validator: (value) => Validators.name(value, 'last_name'.tr),
                        textCapitalization: TextCapitalization.words,
                        autofillHints: const [AutofillHints.familyName],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

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
                  label: 'password'.tr,
                  validator: Validators.password,
                  autofillHints: const [AutofillHints.newPassword],
                ),
                const SizedBox(height: 16),

                // Confirm Password Field
                PasswordTextField(
                  controller: _confirmPasswordController,
                  label: 'confirm_password'.tr,
                  validator: (value) => Validators.confirmPassword(
                    value,
                    _passwordController.text,
                  ),
                  autofillHints: const [AutofillHints.newPassword],
                ),
                const SizedBox(height: 24),

                // Password Requirements
                _buildPasswordRequirements(isDark),
                const SizedBox(height: 24),

                // Terms and Conditions
                _buildTermsAcceptance(isDark),
                const SizedBox(height: 32),

                // Register Button
                Obx(() => CustomButton(
                  text: 'register_button'.tr,
                  onPressed: (controller.isLoading || !_acceptTerms.value)
                      ? null
                      : _handleRegister,
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

                // Sign In Link
                _buildSignInLink(isDark),

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
            gradient: AppColors.creditGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.credit.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.person_add_outlined,
            size: 40,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),

        // Welcome Text
        Text(
          'create_account'.tr,
          style: AppTextStyles.headlineMedium.copyWith(
            color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),

        Text(
          'join_us_today'.tr,
          style: AppTextStyles.bodyLarge.copyWith(
            color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPasswordRequirements(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.infoShade,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.info.withOpacity(0.3),
        ),
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
                'password_requirements'.tr,
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.info,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildPasswordRequirement('At least 8 characters'),
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
            Icons.check_circle_outline,
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

  Widget _buildTermsAcceptance(bool isDark) {
    return Obx(() => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _acceptTerms.value,
          onChanged: (value) => _acceptTerms.value = value ?? false,
          activeColor: AppColors.primary,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: () => _acceptTerms.value = !_acceptTerms.value,
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.bodySmall.copyWith(
                  color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                ),
                children: [
                  TextSpan(text: 'i_agree_to_the'.tr),
                  TextSpan(text: ' '),
                  TextSpan(
                    text: 'terms_conditions'.tr,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  TextSpan(text: ' '),
                  TextSpan(text: 'and'.tr),
                  TextSpan(text: ' '),
                  TextSpan(
                    text: 'privacy_policy'.tr,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
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

  Widget _buildSignInLink(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'already_have_account'.tr,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
          ),
        ),
        const SizedBox(width: 4),
        TextButton(
          onPressed: () => Get.back(),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'sign_in'.tr,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  void _handleRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      if (!_acceptTerms.value) {
        Get.showSnackbar(GetSnackBar(
          title: 'error'.tr,
          message: 'accept_terms'.tr,
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 3),
        ));
        return;
      }

      controller.register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
      );
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}