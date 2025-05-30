import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/controllers/auth_controller.dart';
import '../../app/controllers/connectivity_controller.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../utils/validators.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/social_login_button.dart';

/// Beautiful registration screen with step-by-step design and animations
class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> with TickerProviderStateMixin {
  final AuthController _authController = Get.find<AuthController>();
  final ConnectivityController _connectivityController = Get.find<ConnectivityController>();

  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  late AnimationController _animationController;
  late AnimationController _stepController;
  late AnimationController _progressController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _progressAnimation;

  int _currentStep = 0;
  bool _acceptTerms = false;
  String? _socialLoadingProvider;
  late PageController _pageController;

  final List<StepInfo> _steps = [
    StepInfo(
      title: 'Personal Information',
      subtitle: 'Tell us about yourself',
      icon: Icons.person_outline,
    ),
    StepInfo(
      title: 'Account Details',
      subtitle: 'Create your secure account',
      icon: Icons.security_outlined,
    ),
    StepInfo(
      title: 'Terms & Verification',
      subtitle: 'Almost done! Final step',
      icon: Icons.verified_user_outlined,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _setupAnimations();
    _startAnimations();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _stepController.dispose();
    _progressController.dispose();
    _pageController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _stepController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 800),
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
      parent: _stepController,
      curve: Curves.easeOutCubic,
    ));

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimations() {
    _animationController.forward();
    _stepController.forward();
    _updateProgress();
  }

  void _updateProgress() {
    _progressController.animateTo((_currentStep + 1) / _steps.length);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final keyboardHeight = mediaQuery.viewInsets.bottom;

    return Scaffold(
      body: Container(
        decoration: _buildBackgroundGradient(),
        child: SafeArea(
          child: Column(
            children: [
              // Header with Progress
              _buildHeader(),

              // Form Content
              Expanded(
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: keyboardHeight + 20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          const SizedBox(height: 32),
                          _buildStepContent(),
                          const SizedBox(height: 32),
                          if (_currentStep < 2) _buildSocialSection(),
                          const SizedBox(height: 24),
                          _buildBottomSection(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Back Button and Title
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _currentStep > 0 ? _previousStep() : Get.back(),
                      icon: const Icon(Icons.arrow_back_ios),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.grey100,
                        padding: const EdgeInsets.all(12),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'create_account'.tr,
                            style: AppTextStyles.titleLarge.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.grey900,
                            ),
                          ),
                          Text(
                            'step_progress'.tr.replaceAll('{current}', '${_currentStep + 1}').replaceAll('{total}', '${_steps.length}'),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.grey600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Progress Bar with Steps
                _buildProgressIndicator(),
                const SizedBox(height: 16),

                // Current Step Info
                _buildStepInfo(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      children: List.generate(_steps.length, (index) {
        final isActive = index <= _currentStep;
        final isCompleted = index < _currentStep;

        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  height: 4,
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.primary : AppColors.grey200,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              if (index < _steps.length - 1) const SizedBox(width: 8),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStepInfo() {
    final step = _steps[_currentStep];

    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            step.icon,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.title,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey900,
                ),
              ),
              Text(
                step.subtitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.grey600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepContent() {
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
            ],
          ),
          child: Form(
            key: _formKey,
            child: _buildCurrentStepForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStepForm() {
    switch (_currentStep) {
      case 0:
        return _buildPersonalInfoStep();
      case 1:
        return _buildAccountDetailsStep();
      case 2:
        return _buildTermsAndVerificationStep();
      default:
        return Container();
    }
  }

  Widget _buildPersonalInfoStep() {
    return Column(
      children: [
        // Profile Avatar Placeholder
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.person_outline,
                size: 50,
                color: Colors.white,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),

        // First Name
        _buildAnimatedField(
          controller: _firstNameController,
          focusNode: _firstNameFocusNode,
          label: 'first_name'.tr,
          hint: 'enter_first_name'.tr,
          icon: Icons.person_outline,
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.words,
          validator: (value) => Validators.name(value, 'first_name'.tr),
          onSubmitted: (_) => _lastNameFocusNode.requestFocus(),
        ),
        const SizedBox(height: 20),

        // Last Name
        _buildAnimatedField(
          controller: _lastNameController,
          focusNode: _lastNameFocusNode,
          label: 'last_name'.tr,
          hint: 'enter_last_name'.tr,
          icon: Icons.person_outline,
          textInputAction: TextInputAction.done,
          textCapitalization: TextCapitalization.words,
          validator: (value) => Validators.name(value, 'last_name'.tr),
          onSubmitted: (_) => _nextStep(),
        ),
      ],
    );
  }

  Widget _buildAccountDetailsStep() {
    return Column(
      children: [
        // Email
        _buildAnimatedField(
          controller: _emailController,
          focusNode: _emailFocusNode,
          label: 'email'.tr,
          hint: 'enter_email'.tr,
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator: Validators.email,
          onSubmitted: (_) => _phoneFocusNode.requestFocus(),
        ),
        const SizedBox(height: 20),

        // Phone Number
        _buildAnimatedField(
          controller: _phoneController,
          focusNode: _phoneFocusNode,
          label: 'phone_number'.tr,
          hint: 'enter_phone_number'.tr,
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          validator: Validators.phone,
          onSubmitted: (_) => _passwordFocusNode.requestFocus(),
        ),
        const SizedBox(height: 20),

        // Password
        _buildAnimatedField(
          controller: _passwordController,
          focusNode: _passwordFocusNode,
          label: 'password'.tr,
          hint: 'enter_password'.tr,
          icon: Icons.lock_outline,
          isPassword: true,
          textInputAction: TextInputAction.next,
          validator: Validators.password,
          onSubmitted: (_) => _confirmPasswordFocusNode.requestFocus(),
        ),
        const SizedBox(height: 20),

        // Confirm Password
        _buildAnimatedField(
          controller: _confirmPasswordController,
          focusNode: _confirmPasswordFocusNode,
          label: 'confirm_password'.tr,
          hint: 'confirm_your_password'.tr,
          icon: Icons.lock_outline,
          isPassword: true,
          textInputAction: TextInputAction.done,
          validator: (value) => Validators.confirmPassword(value, _passwordController.text),
          onSubmitted: (_) => _nextStep(),
        ),
        const SizedBox(height: 16),

        // Password Strength Indicator
        _buildPasswordStrength(),
      ],
    );
  }

  Widget _buildTermsAndVerificationStep() {
    return Column(
      children: [
        // Success Icon
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: AppColors.successGradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.success.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.check,
            size: 40,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),

        Text(
          'almost_done'.tr,
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.grey900,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),

        Text(
          'review_and_confirm'.tr,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.grey600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),

        // Terms and Conditions
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.grey50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.grey200),
          ),
          child: Column(
            children: [
              // Terms Checkbox
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _acceptTerms = !_acceptTerms),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: _acceptTerms ? AppColors.primary : Colors.transparent,
                        border: Border.all(
                          color: _acceptTerms ? AppColors.primary : AppColors.grey400,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: _acceptTerms
                          ? const Icon(Icons.check, size: 16, color: Colors.white)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.grey700,
                              height: 1.5,
                            ),
                            children: [
                              TextSpan(text: 'i_agree_to'.tr),
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
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    TextCapitalization? textCapitalization,
    bool isPassword = false,
    String? Function(String?)? validator,
    void Function(String)? onSubmitted,
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
          prefixIcon: Icon(icon),
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization ?? TextCapitalization.none,
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

  Widget _buildPasswordStrength() {
    final password = _passwordController.text;
    final strength = _getPasswordStrength(password);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'password_strength'.tr,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.grey600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(4, (index) {
            Color color = AppColors.grey200;
            if (index < strength) {
              if (strength <= 1) color = AppColors.error;
              else if (strength <= 2) color = AppColors.warning;
              else if (strength <= 3) color = AppColors.info;
              else color = AppColors.success;
            }

            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(right: index < 3 ? 4 : 0),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 4),
        Text(
          _getPasswordStrengthText(strength),
          style: AppTextStyles.bodySmall.copyWith(
            color: _getPasswordStrengthColor(strength),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialSection() {
    if (_currentStep != 0) return const SizedBox.shrink();

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
                border: Border.all(color: AppColors.grey200.withOpacity(0.5)),
              ),
              child: SocialLoginSection(
                providers: const [SocialProvider.google, SocialProvider.apple],
                onProviderSelected: _handleSocialLogin,
                isLoading: _socialLoadingProvider != null,
                loadingProvider: _socialLoadingProvider,
                dividerText: 'or_register_with'.tr,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomSection() {
    return Column(
      children: [
        // Navigation Buttons
        Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: CustomButton.outline(
                  text: 'previous'.tr,
                  onPressed: _previousStep,
                  icon: const Icon(Icons.arrow_back, size: 20),
                ),
              ),
            if (_currentStep > 0) const SizedBox(width: 16),
            Expanded(
              flex: _currentStep > 0 ? 1 : 2,
              child: _buildNextButton(),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Login Link
        if (_currentStep == 0)
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
                  'already_have_account'.tr,
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
    );
  }

  Widget _buildNextButton() {
    final isLastStep = _currentStep == _steps.length - 1;
    final isEnabled = isLastStep ? _acceptTerms : true;

    return Obx(() => Container(
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
        onPressed: !isEnabled || _authController.isLoading ? null :
        isLastStep ? _handleRegister : _nextStep,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _authController.isLoading
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
              isLastStep ? 'create_account'.tr : 'next'.tr,
              style: AppTextStyles.buttonLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              isLastStep ? Icons.check : Icons.arrow_forward,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
      ),
    ));
  }

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      if (_validateCurrentStep()) {
        setState(() {
          _currentStep++;
        });
        _pageController.animateToPage(
          _currentStep,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        _stepController.reset();
        _stepController.forward();
        _updateProgress();
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _stepController.reset();
      _stepController.forward();
      _updateProgress();
    }
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _firstNameController.text.isNotEmpty &&
            _lastNameController.text.isNotEmpty;
      case 1:
        return _formKey.currentState?.validate() ?? false;
      case 2:
        return _acceptTerms;
      default:
        return true;
    }
  }

  void _handleRegister() {
    if (!_formKey.currentState!.validate() || !_acceptTerms) return;

    FocusScope.of(context).unfocus();

    _connectivityController.executeIfConnected(() async {
      await _authController.register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phone: _phoneController.text.trim(),
      );
    }, customMessage: 'registration_requires_internet'.tr);
  }

  void _handleSocialLogin(SocialProvider provider) {
    setState(() => _socialLoadingProvider = provider.name);

    _connectivityController.executeIfConnected(() async {
      try {
        await _authController.socialLogin(
          provider: provider.name,
          accessToken: 'dummy_token_${provider.name}',
        );
      } finally {
        if (mounted) {
          setState(() => _socialLoadingProvider = null);
        }
      }
    }, customMessage: 'social_registration_requires_internet'.tr);
  }

  int _getPasswordStrength(String password) {
    if (password.isEmpty) return 0;

    int strength = 0;
    if (password.length >= 8) strength++;
    if (RegExp(r'[a-z]').hasMatch(password)) strength++;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength++;
    if (RegExp(r'[0-9]').hasMatch(password)) strength++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) strength++;

    return strength > 4 ? 4 : strength;
  }

  String _getPasswordStrengthText(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return 'weak'.tr;
      case 2:
        return 'fair'.tr;
      case 3:
        return 'good'.tr;
      case 4:
        return 'strong'.tr;
      default:
        return '';
    }
  }

  Color _getPasswordStrengthColor(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return AppColors.error;
      case 2:
        return AppColors.warning;
      case 3:
        return AppColors.info;
      case 4:
        return AppColors.success;
      default:
        return AppColors.grey400;
    }
  }
}

class StepInfo {
  final String title;
  final String subtitle;
  final IconData icon;

  StepInfo({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

// Additional translation keys
extension RegisterTranslations on String {
  String get tr {
    final translations = {
      'create_account': 'Create Account',
      'step_progress': 'Step {current} of {total}',
      'enter_first_name': 'Enter your first name',
      'enter_last_name': 'Enter your last name',
      'enter_phone_number': 'Enter your phone number',
      'confirm_your_password': 'Confirm your password',
      'password_strength': 'Password Strength',
      'almost_done': 'Almost Done!',
      'review_and_confirm': 'Please review your information and accept our terms',
      'i_agree_to': 'I agree to the',
      'or_register_with': 'Or register with',
      'already_have_account': 'Already have an account?',
      'weak': 'Weak',
      'fair': 'Fair',
      'good': 'Good',
      'strong': 'Strong',
      'registration_requires_internet': 'Registration requires an internet connection',
      'social_registration_requires_internet': 'Social registration requires an internet connection',
    };
    return translations[this] ?? this;
  }
}