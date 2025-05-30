import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../app/controllers/auth_controller.dart';
import '../../app/controllers/connectivity_controller.dart';
import '../../app/translations/keys.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../widgets/common/custom_button.dart';

/// Verify reset password screen with OTP verification
class VerifyResetPasswordView extends StatefulWidget {
  const VerifyResetPasswordView({super.key});

  @override
  State<VerifyResetPasswordView> createState() => _VerifyResetPasswordViewState();
}

class _VerifyResetPasswordViewState extends State<VerifyResetPasswordView>
    with TickerProviderStateMixin {
  final AuthController _authController = Get.find<AuthController>();
  final ConnectivityController _connectivityController = Get.find<ConnectivityController>();

  final _otpController = TextEditingController();
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;

  String _currentOtp = '';
  bool _isOtpComplete = false;
  int _resendCountdown = 60;
  bool _canResend = false;

  // Get email from arguments
  String get email => Get.arguments?['email'] ?? '';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
    _startResendCountdown();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimations() {
    _animationController.forward();
    _pulseController.repeat(reverse: true);
  }

  void _startResendCountdown() {
    _canResend = false;
    _resendCountdown = 60;

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _resendCountdown--;
          if (_resendCountdown <= 0) {
            _canResend = true;
          }
        });
        return _resendCountdown > 0;
      }
      return false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final keyboardHeight = mediaQuery.viewInsets.bottom;

    return Scaffold(
      body: Container(
        decoration: _buildBackgroundGradient(),
        child: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(bottom: keyboardHeight + 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: mediaQuery.size.height - mediaQuery.padding.top - keyboardHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        _buildHeader(),
                        const SizedBox(height: 40),
                        _buildIllustration(),
                        const SizedBox(height: 40),
                        _buildContent(),
                        const Spacer(),
                        _buildBottomSection(),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBackgroundGradient() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFF0F9FF),
          Color(0xFFEBF4FF),
          Color(0xFFF8FAFF),
        ],
        stops: [0.0, 0.5, 1.0],
      ),
    );
  }

  Widget _buildHeader() {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back_ios),
                  style: IconButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'verify_reset_code'.tr,
                  style: AppTextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.grey900,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIllustration() {
    return AnimatedBuilder(
      animation: Listenable.merge([_fadeAnimation, _pulseAnimation]),
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Transform.scale(
            scale: _pulseAnimation.value,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    blurRadius: 60,
                    offset: const Offset(0, 30),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background circles
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 2,
                      ),
                    ),
                  ),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                  ),
                  // Main icon
                  const Icon(
                    Icons.security,
                    size: 70,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
              BoxShadow(
                color: AppColors.primary.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              // Title and description
              Text(
                'enter_verification_code'.tr,
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.grey900,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.grey600,
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(text: 'verification_code_sent_to'.tr),
                    TextSpan(text: ' '),
                    TextSpan(
                      text: email,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // OTP Input
              PinCodeTextField(
                appContext: context,
                length: 6,
                controller: _otpController,
                onChanged: (value) {
                  setState(() {
                    _currentOtp = value;
                    _isOtpComplete = value.length == 6;
                  });
                },
                onCompleted: (value) {
                  _handleVerifyOtp();
                },
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(12),
                  fieldHeight: 56,
                  fieldWidth: 48,
                  activeFillColor: AppColors.primaryShade.withOpacity(0.1),
                  inactiveFillColor: AppColors.grey50,
                  selectedFillColor: AppColors.primaryShade.withOpacity(0.2),
                  activeColor: AppColors.primary,
                  inactiveColor: AppColors.grey300,
                  selectedColor: AppColors.primary,
                  borderWidth: 2,
                ),
                enableActiveFill: true,
                keyboardType: TextInputType.number,
                textStyle: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.grey900,
                ),
                animationType: AnimationType.fade,
                animationDuration: const Duration(milliseconds: 300),
                backgroundColor: Colors.transparent,
                enablePinAutofill: true,
              ),
              const SizedBox(height: 32),

              // Verify button
              Obx(() => _buildAnimatedButton(
                text: TranslationKeys.verifyOtp.tr,
                isLoading: _authController.isLoading,
                isEnabled: _isOtpComplete,
                onPressed: _isOtpComplete && !_authController.isLoading ? _handleVerifyOtp : null,
              )),
              const SizedBox(height: 24),

              // Resend section
              _buildResendSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedButton({
    required String text,
    required bool isLoading,
    required bool isEnabled,
    VoidCallback? onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: isEnabled ? AppColors.primaryGradient : null,
        color: !isEnabled ? AppColors.grey300 : null,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isEnabled
            ? [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ]
            : [],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isLoading
            ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: AppTextStyles.buttonLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResendSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        children: [
          Text(
            'didnt_receive_code'.tr,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.grey700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          if (_canResend)
            TextButton(
              onPressed: _handleResendOtp,
              child: Text(
                TranslationKeys.resendOtp.tr,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
              ),
            )
          else
            Text(
              'resend_in_seconds'.tr.replaceAll('{seconds}', _resendCountdown.toString()),
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.grey500,
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Security info
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.grey200.withOpacity(0.5)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      color: AppColors.primary,
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'security_notice'.tr,
                            style: AppTextStyles.titleSmall.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.grey900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'security_notice_description'.tr,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.grey600,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Back to login
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.grey200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'wrong_email'.tr,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.grey700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => Get.offAllNamed('/login'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'try_different_email'.tr,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleVerifyOtp() {
    if (_currentOtp.length != 6) return;

    FocusScope.of(context).unfocus();

    _connectivityController.executeIfConnected(() async {
      try {
        await _authController.verifyOtp(
          email: email,
          otp: _currentOtp,
          type: 'password_reset',
        );

        // Navigate to reset password screen
        Get.toNamed('/reset-password', arguments: {
          'email': email,
          'token': _currentOtp, // In real app, this would be a proper token
        });
      } catch (e) {
        // Clear OTP on error
        _otpController.clear();
        setState(() {
          _currentOtp = '';
          _isOtpComplete = false;
        });
      }
    }, customMessage: 'internet_required_for_verification'.tr);
  }

  void _handleResendOtp() {
    _connectivityController.executeIfConnected(() async {
      await _authController.resendOtp(
        email: email,
        type: 'password_reset',
      );

      // Restart countdown
      _startResendCountdown();

      // Show success message
      Get.showSnackbar(GetSnackBar(
        title: TranslationKeys.otpSent.tr,
        message: 'new_code_sent'.tr,
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      ));
    }, customMessage: 'internet_required_for_resend'.tr);
  }
}

// Translation extension for verify reset password specific terms
extension VerifyResetPasswordTranslationExtensions on String {
  String get tr {
    final Map<String, String> verifyResetPasswordTranslations = {
      'verify_reset_code': 'Verify Reset Code',
      'enter_verification_code': 'Enter Verification Code',
      'verification_code_sent_to': 'We\'ve sent a 6-digit verification code to',
      'didnt_receive_code': 'Didn\'t receive the code?',
      'resend_in_seconds': 'Resend in {seconds} seconds',
      'security_notice': 'Security Notice',
      'security_notice_description': 'This code expires in 15 minutes for your security. Don\'t share it with anyone.',
      'wrong_email': 'Wrong email address?',
      'try_different_email': 'Try Different Email',
      'internet_required_for_verification': 'Internet connection required for verification',
      'internet_required_for_resend': 'Internet connection required to resend code',
      'new_code_sent': 'New verification code sent',
    };

    return verifyResetPasswordTranslations[this] ?? this;
  }
}