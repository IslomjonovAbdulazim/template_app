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
  final _phoneController = TextEditingController();
  final _acceptTerms = false.obs;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PageScaffold(
      title: 'register'.tr,
      showConnectivityBanner: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                _buildHeader(isDark),
                const SizedBox(height: 32),

                // First Name
                CustomTextField(
                  label: 'first_name'.tr,
                  hint: 'Enter your first name',
                  controller: _firstNameController,
                  prefixIcon: Icons.person_outline,
                  validator: (value) => Validators.name(value, 'First name'),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16),

                // Last Name
                CustomTextField(
                  label: 'last_name'.tr,
                  hint: 'Enter your last name',
                  controller: _lastNameController,
                  prefixIcon: Icons.person_outline,
                  validator: (value) => Validators.name(value, 'Last name'),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16),

                // Email
                EmailTextField(
                  controller: _emailController,
                  validator: Validators.email,
                ),
                const SizedBox(height: 16),

                // Phone (Optional)
                CustomTextField(
                  label: 'Phone (Optional)',
                  hint: 'Enter your phone number',
                  controller: _phoneController,
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      return Validators.phone(value);
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password
                PasswordTextField(
                  controller: _passwordController,
                  validator: Validators.password,
                ),
                const SizedBox(height: 16),

                // Confirm Password
                PasswordTextField(
                  label: 'confirm_password'.tr,
                  controller: _confirmPasswordController,
                  validator: (value) => Validators.confirmPassword(
                    value,
                    _passwordController.text,
                  ),
                ),
                const SizedBox(height: 24),

                // Terms and Conditions
                _buildTermsCheckbox(isDark),
                const SizedBox(height: 32),

                // Register Button
                Obx(() => CustomButton(
                  text: 'register_button'.tr,
                  onPressed: controller.isLoading ? null : _handleRegister,
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
        // Icon
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: AppColors.creditGradient,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.person_add_outlined,
            size: 40,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),

        // Title
        Text(
          'create_account'.tr,
          style: AppTextStyles.headlineMedium.copyWith(
            color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),

        // Subtitle
        Text(
          'Join us and start your journey',
          style: AppTextStyles.bodyLarge.copyWith(
            color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTermsCheckbox(bool isDark) {
    return Obx(() => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _acceptTerms.value,
          onChanged: (value) => _acceptTerms.value = value ?? false,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: () => _acceptTerms.value = !_acceptTerms.value,
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                ),
                children: [
                  TextSpan(text: 'I agree to the '),
                  TextSpan(
                    text: 'Terms and Conditions',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
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
        TextButton(
          onPressed: () => Get.back(),
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
    if (!_acceptTerms.value) {
      Get.showSnackbar(GetSnackBar(
        title: 'error'.tr,
        message: 'Please accept the terms and conditions',
        backgroundColor: AppColors.error,
        duration: const Duration(seconds: 3),
      ));
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      controller.register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
      );
    }
  }
}