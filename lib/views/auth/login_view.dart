import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/controllers/auth_controller.dart';
import '../../app/controllers/connectivity_controller.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_images.dart';
import '../../utils/validators.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/social_login_button.dart';

/// Beautiful login screen with modern design
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

  late AnimationController _animationController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

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
    _animationController.dispose();
    _slideController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
  }

  void _startAnimations() {
    _animationController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _slideController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final keyboardHeight = mediaQuery.viewInsets.bottom;

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(bottom: keyboardHeight),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: mediaQuery.size.height - mediaQuery.padding.top,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    _buildHeader(),
                    const SizedBox(height: 48),
                    _buildLoginForm(),
                    const SizedBox(height: 32),
                    _buildSocialLogin(),
                    const SizedBox(height: 24),
                    _buildBottomSection(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Column(
            children: [
              // App Logo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(24),
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
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              // Welcome Text
              Text(
                'welcome_back'.tr,
                style: AppTextStyles.headlineLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Get.theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'login_subtitle'.tr,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: Get.theme.colorScheme.onSurface.withOpacity(0.7),
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Email Field
              CustomTextField.email(
                label: 'email'.tr,
                hint: 'enter_email'.tr,
                controller: _emailController,
                focusNode: _emailFocusNode,
                textInputAction: TextInputAction.next,
                validator: Validators.email,
                onSubmitted: (_) => _passwordFocusNode.requestFocus(),
              ),
              const SizedBox(height: 20),

              // Password Field
              CustomTextField.password(
                label: 'password'.tr,
                hint: 'enter_password'.tr,
                controller: _passwordController,
                focusNode: _passwordFocusNode,
                textInputAction: TextInputAction.done,
                validator: (value) => Validators.required(value, 'password'.tr),
                onSubmitted: (_) => _handleLogin(),
              ),
              const SizedBox(height: 16),

              // Remember Me & Forgot Password
              Row(
                children: [
                  // Remember Me Checkbox
                  GestureDetector(
                    onTap: () => setState(() => _rememberMe = !_rememberMe),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: _rememberMe ? AppColors.primary : Colors.transparent,
                            border: Border.all(
                              color: _rememberMe ? AppColors.primary : AppColors.grey400,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: _rememberMe
                              ? const Icon(Icons.check, size: 14, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'remember_me'.tr,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Get.theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),

                  // Forgot Password
                  TextButton(
                    onPressed: () => Get.toNamed('/forgot-password'),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'forgot_password'.tr,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Login Button
              Obx(() => CustomButton.primary(
                text: 'login'.tr,
                onPressed: _authController.isLoading ? null : _handleLogin,
                isLoading: _authController.isLoading,
                width: double.infinity,
                size: ButtonSize.large,
              )),
            ],
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
          offset: Offset(0, (1 - _slideAnimation.value.dy) * 50),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: SocialLoginSection(
              providers: const [SocialProvider.google, SocialProvider.apple],
              onProviderSelected: _handleSocialLogin,
              isLoading: _socialLoadingProvider != null,
              loadingProvider: _socialLoadingProvider,
              dividerText: 'or_continue_with'.tr,
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomSection() {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Column(
            children: [
              // Terms and Privacy
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(text: 'by_continuing_you_agree'.tr),
                      TextSpan(text: ' '),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () => Get.toNamed('/terms'),
                          child: Text(
                            'terms_of_service'.tr,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      TextSpan(text: ' ${'and'.tr} '),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () => Get.toNamed('/privacy'),
                          child: Text(
                            'privacy_policy'.tr,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'dont_have_account'.tr,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Get.theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Get.toNamed('/register'),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
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
        // TODO: Implement actual social login
        await _authController.socialLogin(
          provider: provider.name,
          accessToken: 'dummy_token', // Replace with actual token
        );
      } finally {
        if (mounted) {
          setState(() => _socialLoadingProvider = null);
        }
      }
    }, customMessage: 'social_login_requires_internet'.tr);
  }
}

// Add missing translation keys - these should be added to your translation files
extension LoginTranslations on String {
  String get tr {
    final translations = {
      'welcome_back': 'Welcome Back',
      'login_subtitle': 'Sign in to your account to continue',
      'enter_email': 'Enter your email',
      'enter_password': 'Enter your password',
      'or_continue_with': 'Or continue with',
      'by_continuing_you_agree': 'By continuing, you agree to our',
      'and': 'and',
      'dont_have_account': "Don't have an account?",
      'login_requires_internet': 'Login requires an internet connection',
      'social_login_requires_internet': 'Social login requires an internet connection',
    };
    return translations[this] ?? this;
  }
}