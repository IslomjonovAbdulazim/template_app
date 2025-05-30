import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/controllers/auth_controller.dart';
import '../../app/controllers/connectivity_controller.dart';
import '../../app/translations/keys.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_images.dart';
import '../../utils/validators.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/social_login_button.dart';

/// Enhanced login screen with proper translations and error handling
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with TickerProviderStateMixin {
  final AuthController _authController = Get.find<AuthController>();
  final ConnectivityController _connectivityController = Get.find<ConnectivityController>();

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _logoController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotationAnimation;

  bool _rememberMe = false;
  String? _socialLoadingProvider;

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
    _logoController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
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

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
    ));

    _logoRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeInOut),
    ));
  }

  void _startAnimations() {
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _slideController.forward();
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      _logoController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    final screenHeight = mediaQuery.size.height;

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
                  minHeight: screenHeight - mediaQuery.padding.top - keyboardHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 60),
                        _buildHeader(),
                        const SizedBox(height: 40),
                        _buildLoginForm(),
                        const SizedBox(height: 24),
                        _buildSocialLogin(),
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
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFF8FAFF),
          Color(0xFFEBF4FF),
          Color(0xFFF0F9FF),
        ],
        stops: [0.0, 0.5, 1.0],
      ),
    );
  }

  Widget _buildHeader() {
    return AnimatedBuilder(
      animation: Listenable.merge([_fadeAnimation, _logoController]),
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Animated Logo
              Transform.scale(
                scale: _logoScaleAnimation.value,
                child: Transform.rotate(
                  angle: _logoRotationAnimation.value * 0.1,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.1),
                          blurRadius: 40,
                          offset: const Offset(0, 20),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.fingerprint,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Welcome Text with Shimmer Effect
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.secondary,
                    AppColors.accent,
                  ],
                ).createShader(bounds),
                child: Text(
                  TranslationKeys.welcomeBack.tr,
                  style: AppTextStyles.displaySmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 12),

              Text(
                'sign_in_to_continue'.tr,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.grey600,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoginForm() {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          padding: const EdgeInsets.all(24),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Email Field with Custom Design
                _buildAnimatedTextField(
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  label: TranslationKeys.email.tr,
                  hint: 'enter_email'.tr,
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: Validators.email,
                  onSubmitted: (_) => _passwordFocusNode.requestFocus(),
                ),
                const SizedBox(height: 20),

                // Password Field with Custom Design
                _buildAnimatedTextField(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  label: TranslationKeys.password.tr,
                  hint: 'enter_password'.tr,
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  validator: (value) => Validators.required(value, TranslationKeys.password.tr),
                  onSubmitted: (_) => _handleLogin(),
                ),
                const SizedBox(height: 20),

                // Remember Me & Forgot Password Row
                Row(
                  children: [
                    // Custom Remember Me Checkbox
                    GestureDetector(
                      onTap: () => setState(() => _rememberMe = !_rememberMe),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: _rememberMe ? AppColors.primary : Colors.transparent,
                              border: Border.all(
                                color: _rememberMe ? AppColors.primary : AppColors.grey400,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: _rememberMe
                                ? const Icon(Icons.check, size: 16, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            TranslationKeys.rememberMe.tr,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.grey700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),

                    // Forgot Password Link
                    TextButton(
                      onPressed: () => Get.toNamed('/forgot-password'),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        TranslationKeys.forgotPassword.tr,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Login Button with Animation
                Obx(() => _buildAnimatedButton(
                  text: TranslationKeys.login.tr,
                  isLoading: _authController.isLoading,
                  onPressed: _authController.isLoading ? null : _handleLogin,
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required IconData prefixIcon,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    String? Function(String?)? validator,
    void Function(String)? onSubmitted,
    bool isPassword = false,
  }) {
    return Focus(
      onFocusChange: (hasFocus) => setState(() {}),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: focusNode.hasFocus
              ? [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ]
              : [],
        ),
        child: CustomTextField(
          controller: controller,
          focusNode: focusNode,
          label: label,
          hint: hint,
          prefixIcon: Icon(prefixIcon),
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          isPassword: isPassword,
          validator: validator,
          onSubmitted: onSubmitted,
          borderRadius: 16,
          fillColor: focusNode.hasFocus
              ? AppColors.primaryShade.withOpacity(0.3)
              : AppColors.grey50,
        ),
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
            : Text(
          text,
          style: AppTextStyles.buttonLarge.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialLogin() {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, (1 - _slideAnimation.value.dy) * 30),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.grey200.withOpacity(0.5),
                ),
              ),
              child: Column(
                children: [
                  // Divider with "OR" text
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                AppColors.grey300,
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'or_continue_with'.tr,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.grey500,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.grey300,
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Social Login Buttons
                  Row(
                    children: [
                      // Google Login
                      Expanded(
                        child: _buildSocialButton(
                          provider: SocialProvider.google,
                          icon: Icons.g_mobiledata,
                          label: 'Google',
                          color: Colors.white,
                          borderColor: AppColors.grey300,
                          textColor: AppColors.grey700,
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Apple Login
                      Expanded(
                        child: _buildSocialButton(
                          provider: SocialProvider.apple,
                          icon: Icons.apple,
                          label: 'Apple',
                          color: Colors.black,
                          borderColor: Colors.black,
                          textColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSocialButton({
    required SocialProvider provider,
    required IconData icon,
    required String label,
    required Color color,
    required Color borderColor,
    required Color textColor,
  }) {
    final isLoading = _socialLoadingProvider == provider.name;

    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : () => _handleSocialLogin(provider),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(textColor),
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.buttonMedium.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
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
              // Terms and Privacy
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.grey600,
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(text: 'by_continuing_agree'.tr),
                      TextSpan(text: ' '),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () => Get.toNamed('/terms'),
                          child: Text(
                            TranslationKeys.termsOfService.tr,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      TextSpan(text: ' ${TranslationKeys.and.tr} '),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () => Get.toNamed('/privacy'),
                          child: Text(
                            TranslationKeys.privacyPolicy.tr,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Sign Up Link
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
                      TranslationKeys.dontHaveAccount.tr,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.grey700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => Get.toNamed('/register'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          TranslationKeys.signUp.tr,
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

  void _handleLogin() {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    _connectivityController.executeIfConnected(() async {
      await _authController.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        rememberMe: _rememberMe,
      );
    }, customMessage: 'login_requires_internet'.tr);
  }

  void _handleSocialLogin(SocialProvider provider) {
    setState(() => _socialLoadingProvider = provider.name);

    _connectivityController.executeIfConnected(() async {
      try {
        switch (provider) {
          case SocialProvider.google:
          // TODO: Implement Google Sign In
            await _mockSocialLogin('google');
            break;
          case SocialProvider.apple:
          // TODO: Implement Apple Sign In
            await _mockSocialLogin('apple');
            break;
          case SocialProvider.facebook:
          // TODO: Implement Facebook Login
            await _mockSocialLogin('facebook');
            break;
        }
      } finally {
        if (mounted) {
          setState(() => _socialLoadingProvider = null);
        }
      }
    }, customMessage: 'social_login_requires_internet'.tr);
  }

  Future<void> _mockSocialLogin(String provider) async {
    // Mock implementation - replace with actual social login
    await Future.delayed(const Duration(seconds: 2));

    await _authController.socialLogin(
      provider: provider,
      accessToken: 'mock_token_$provider',
    );
  }
}

// Additional translation keys extension for login screen specific terms
extension LoginTranslationExtensions on String {
  String get tr {
    final Map<String, String> loginTranslations = {
      'sign_in_to_continue': 'Sign in to your account to continue your journey',
      'enter_email': 'Enter your email address',
      'enter_password': 'Enter your password',
      'or_continue_with': 'Or continue with',
      'by_continuing_agree': 'By continuing, you agree to our',
      'login_requires_internet': 'Login requires an internet connection',
      'social_login_requires_internet': 'Social login requires an internet connection',
    };

    return loginTranslations[this] ?? this;
  }
}