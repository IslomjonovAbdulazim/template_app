import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../app/controllers/auth_controller.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_text_styles.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/custom_button_widget.dart';
import '../../widgets/common/responsive_scaffold.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  final AuthController _authController = AuthController.instance;
  final TextEditingController _otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _currentOtp = '';
  bool _hasError = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ResponsiveScaffold(
      appBar: CustomAppBar(
        title: 'verify_email'.tr,
        showBackButton: true,
        onBackPressed: () => _showExitConfirmation(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),

                        // Email verification icon
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: (isDark ? AppColors.primaryLight : AppColors.primary)
                                .withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.mark_email_read_outlined,
                            size: 50,
                            color: isDark ? AppColors.primaryLight : AppColors.primary,
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Title
                        Text(
                          'verification_sent'.tr,
                          style: AppTextStyles.headlineSmall.copyWith(
                            color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 16),

                        // Description
                        Obx(() => RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                              height: 1.5,
                            ),
                            children: [
                              TextSpan(text: 'check_email'.tr),
                              const TextSpan(text: '\n\n'),
                              TextSpan(
                                text: _authController.userEmail,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        )),

                        const SizedBox(height: 40),

                        // OTP Input
                        _buildOtpInput(isDark),

                        const SizedBox(height: 16),

                        // Error message
                        Obx(() => _authController.hasVerificationError
                            ? Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.errorShade,
                            borderRadius: BorderRadius.circular(8),
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
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _authController.verificationError,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.error,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                            : const SizedBox.shrink()),

                        const SizedBox(height: 24),

                        // Verify button
                        Obx(() => CustomButton(
                          text: 'verify_email'.tr,
                          onPressed: _currentOtp.length == AppConstants.otpLength
                              ? _verifyEmail
                              : null,
                          isLoading: _authController.isVerificationLoading,
                          width: double.infinity,
                          type: ButtonType.primary,
                          size: ButtonSize.large,
                        )),

                        const SizedBox(height: 24),

                        // Resend code section
                        _buildResendSection(isDark),

                        const SizedBox(height: 32),

                        // Help text
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.grey800.withOpacity(0.3)
                                : AppColors.grey100.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.help_outline,
                                color: isDark ? DarkColors.textTertiary : LightColors.textTertiary,
                                size: 20,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'check_spam_folder'.tr,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: isDark ? DarkColors.textTertiary : LightColors.textTertiary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Skip verification option (only if allowed)
              if (_shouldShowSkipOption())
                Column(
                  children: [
                    const Divider(),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: 'skip_for_now'.tr,
                      onPressed: () => _authController.skipEmailVerification(),
                      type: ButtonType.text,
                      width: double.infinity,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpInput(bool isDark) {
    return PinCodeTextField(
      appContext: context,
      length: AppConstants.otpLength,
      controller: _otpController,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      animationType: AnimationType.fade,
      animationDuration: const Duration(milliseconds: 300),
      enableActiveFill: true,
      autoFocus: true,
      autoDisposeControllers: false,
      textStyle: AppTextStyles.headlineMedium.copyWith(
        color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(12),
        fieldHeight: 56,
        fieldWidth: 48,
        borderWidth: 2,
        activeFillColor: isDark ? DarkColors.inputFill : LightColors.inputFill,
        inactiveFillColor: isDark ? DarkColors.inputFill : LightColors.inputFill,
        selectedFillColor: isDark ? DarkColors.inputFill : LightColors.inputFill,
        activeColor: isDark ? DarkColors.inputFocusBorder : LightColors.inputFocusBorder,
        inactiveColor: isDark ? DarkColors.inputBorder : LightColors.inputBorder,
        selectedColor: isDark ? DarkColors.inputFocusBorder : LightColors.inputFocusBorder,
        errorBorderColor: AppColors.error,
      ),
      onChanged: (value) {
        setState(() {
          _currentOtp = value;
          _hasError = false;
        });

        // Clear error when user starts typing - FIXED: Using public method
        if (_authController.hasVerificationError) {
          _authController.clearVerificationError(); // ✅ Now using public method
        }
      },
      onCompleted: (value) {
        _currentOtp = value;
        // Auto-verify when all digits are entered
        Future.delayed(const Duration(milliseconds: 300), () {
          if (_currentOtp.length == AppConstants.otpLength) {
            _verifyEmail();
          }
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter verification code';
        }
        if (value.length != AppConstants.otpLength) {
          return 'Please enter all ${AppConstants.otpLength} digits';
        }
        return null;
      },
      errorTextSpace: 0, // Hide default error text space
      beforeTextPaste: (text) {
        // Allow pasting only numeric values
        return text?.contains(RegExp(r'^[0-9]+$')) ?? false;
      },
    );
  }

  Widget _buildResendSection(bool isDark) {
    return Obx(() {
      if (_authController.canResendCode) {
        return CustomButton(
          text: 'resend_verification'.tr,
          onPressed: _resendVerificationCode,
          isLoading: _authController.isResendingCode,
          type: ButtonType.text,
          width: double.infinity,
        );
      } else {
        return Column(
          children: [
            Text(
              'Resend code in ${_authController.resendCooldownSeconds} seconds',
              style: AppTextStyles.bodyMedium.copyWith(
                color: isDark ? DarkColors.textTertiary : LightColors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 4,
              child: LinearProgressIndicator(
                value: 1 - (_authController.resendCooldownSeconds / 60),
                backgroundColor: isDark ? AppColors.grey700 : AppColors.grey200,
                valueColor: AlwaysStoppedAnimation(
                  isDark ? AppColors.primaryLight : AppColors.primary,
                ),
              ),
            ),
          ],
        );
      }
    });
  }

  void _verifyEmail() async {
    if (_currentOtp.length != AppConstants.otpLength) {
      setState(() {
        _hasError = true;
      });
      return;
    }

    // Add haptic feedback
    HapticFeedback.lightImpact();

    await _authController.verifyEmail(_currentOtp);
  }

  void _resendVerificationCode() async {
    // Add haptic feedback
    HapticFeedback.lightImpact();

    // Clear current OTP
    _otpController.clear();
    setState(() {
      _currentOtp = '';
      _hasError = false;
    });

    await _authController.resendVerificationCode();
  }

  bool _shouldShowSkipOption() {
    // Show skip option based on your business logic
    // For example, only for certain user types or during onboarding
    return true; // Change this based on your requirements
  }

  void _showExitConfirmation() {
    Get.dialog(
      AlertDialog(
        title: Text('exit_verification'.tr),
        content: Text('Are you sure you want to exit email verification?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('stay'.tr),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(); // Close dialog
              Get.back(); // Go back to previous screen
            },
            child: Text('exit'.tr),
          ),
        ],
      ),
    );
  }
}