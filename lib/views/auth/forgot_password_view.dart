import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/controllers/auth_controller.dart';
import '../../app/controllers/connectivity_controller.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../utils/validators.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

/// Beautiful forgot password screen with animations
class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> with TickerProviderStateMixin {
  final AuthController _authController = Get.find<AuthController>();
  final ConnectivityController _connectivityController = Get.find<ConnectivityController>();

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _emailFocusNode = FocusNode();

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _floatingController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _floatingAnimation;

  bool _emailSent = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _floatingController.dispose();
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _floatingController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _floatingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimations() {
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _slideController.forward();
    });
    _floatingController.repeat(reverse: true);
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
                  _emailSent ? 'check_your_email'.tr : 'forgot_password'.tr,
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
      animation: Listenable.merge([_fadeAnimation, _floatingAnimation]),
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Transform.translate(
            offset: Offset(0, _floatingAnimation.value * 10 - 5),
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                gradient: _emailSent ? AppColors.successGradient : AppColors.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (_emailSent ? AppColors.success : AppColors.primary).withOpacity(0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                  BoxShadow(
                    color: (_emailSent ? AppColors.success : AppColors.primary).withOpacity(0.1),
                    blurRadius: 60,
                    offset: const Offset(0, 30),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background pattern
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 2,
                      ),
                    ),
                  ),
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                  ),
                  // Main icon
                  Icon(
                    _emailSent ? Icons.mark_email_read_outlined : Icons.lock_reset,
                    size: 80,
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
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.1),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: _emailSent ? _buildEmailSentContent() : _buildForgotPasswordForm(),
        ),
      ),
    );
  }

  Widget _buildForgotPasswordForm() {
    return Container(
      key: const ValueKey('forgot_form'),
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
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Title and description
            Text(
              'reset_password_title'.tr,
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.grey900,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'reset_password_description'.tr,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.grey600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Email input
            Focus(
              onFocusChange: (hasFocus) => setState(() {}),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: _emailFocusNode.hasFocus
                      ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ]
                      : [],
                ),
                child: CustomTextField(
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  label: 'email'.tr,
                  hint: 'enter_email_for_reset'.tr,
                  prefixIcon: const Icon(Icons.email_outlined),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  validator: Validators.email,
                  onSubmitted: (_) => _handleForgotPassword(),
                  borderRadius: 16,
                  fillColor: _emailFocusNode.hasFocus
                      ? AppColors.primaryShade.withOpacity(0.3)
                      : AppColors.grey50,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Reset button
            Obx(() => _buildAnimatedButton(
              text: 'send_reset_link'.tr,
              isLoading: _authController.isLoading,
              onPressed: _authController.isLoading ? null : _handleForgotPassword,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailSentContent() {
    return Container(
      key: const ValueKey('email_sent'),
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
            color: AppColors.success.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Success message
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.successShade,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              size: 40,
              color: AppColors.success,
            ),
          ),
          const SizedBox(height: 24),

          Text(
            'email_sent_title'.tr,
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
                TextSpan(text: 'email_sent_description'.tr),
                TextSpan(text: ' '),
                TextSpan(
                  text: _emailController.text,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Instructions
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.infoShade,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.info.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.info,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'email_instructions_title'.tr,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.info,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'email_instructions_description'.tr,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.grey700,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Action buttons
          Column(
            children: [
              // Resend email button
              CustomButton.outline(
                text: 'resend_email'.tr,
                onPressed: _handleResendEmail,
                icon: const Icon(Icons.refresh, size: 20),
                width: double.infinity,
              ),
              const SizedBox(height: 16),

              // Back to login button
              CustomButton.primary(
                text: 'back_to_login'.tr,
                onPressed: () => Get.offAllNamed('/login'),
                icon: const Icon(Icons.arrow_back, size: 20),
                width: double.infinity,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedButton({
    required String text,
    required bool isLoading,
    VoidCallback? onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: onPressed != null ? AppColors.primaryGradient : null,
        color: onPressed == null ? AppColors.grey300 : null,
        borderRadius: BorderRadius.circular(16),
        boxShadow: onPressed != null
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
              Icons.send,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    if (_emailSent) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Help text
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.grey200.withOpacity(0.5)),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.help_outline,
                      color: AppColors.primary,
                      size: 32,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'need_help_title'.tr,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.grey900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'need_help_description'.tr,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.grey600,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => Get.toNamed('/support'),
                      child: Text(
                        'contact_support'.tr,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
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
                      'remember_password'.tr,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.grey700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'sign_in'.tr,
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

  void _handleForgotPassword() {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    _connectivityController.executeIfConnected(() async {
      final success = await _performForgotPassword();
      if (success) {
        setState(() {
          _emailSent = true;
        });
        _startAnimations(); // Restart animations for new content
      }
    }, customMessage: 'internet_required_for_reset'.tr);
  }

  void _handleResendEmail() {
    _connectivityController.executeIfConnected(() async {
      await _performForgotPassword();

      // Show success message
      Get.showSnackbar(GetSnackBar(
        title: 'email_resent'.tr,
        message: 'check_inbox_again'.tr,
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      ));
    }, customMessage: 'internet_required_for_resend'.tr);
  }

  Future<bool> _performForgotPassword() async {
    try {
      await _authController.forgotPassword(_emailController.text.trim());
      return true;
    } catch (e) {
      return false;
    }
  }
}

// Additional translation keys
extension ForgotPasswordTranslations on String {
  String get tr {
    final translations = {
      'check_your_email': 'Check Your Email',
      'reset_password_title': 'Forgot Password?',
      'reset_password_description': 'Don\'t worry! Enter your email address and we\'ll send you a link to reset your password.',
      'enter_email_for_reset': 'Enter your email address',
      'send_reset_link': 'Send Reset Link',
      'email_sent_title': 'Email Sent Successfully!',
      'email_sent_description': 'We\'ve sent a password reset link to',
      'email_instructions_title': 'What\'s Next?',
      'email_instructions_description': 'Check your email inbox and click the reset link. The link will expire in 15 minutes for security.',
      'resend_email': 'Resend Email',
      'back_to_login': 'Back to Login',
      'need_help_title': 'Need Help?',
      'need_help_description': 'If you\'re having trouble receiving the email, check your spam folder or contact our support team.',
      'remember_password': 'Remember your password?',
      'internet_required_for_reset': 'Internet connection required to send reset link',
      'internet_required_for_resend': 'Internet connection required to resend email',
      'email_resent': 'Email Resent',
      'check_inbox_again': 'Please check your inbox again',
    };
    return translations[this] ?? this;
  }
}