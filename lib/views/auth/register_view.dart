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

/// Beautiful registration screen with step-by-step design
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
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  int _currentStep = 0;
  bool _acceptTerms = false;
  String? _socialLoadingProvider;
  late PageController _pageController;

  final List<String> _stepTitles = [
    'Personal Information',
    'Contact Details',
    'Security Setup',
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
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _stepController = AnimationController(
      duration: const Duration(milliseconds: 600),
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
  }

  void _startAnimations() {
    _animationController.forward();
    _stepController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final keyboardHeight = mediaQuery.viewInsets.bottom;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        title: Text('create_account'.tr),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            // Progress Indicator
            _buildProgressIndicator(),

            // Form Content
            Expanded(
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
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              children: [
                // Step Dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    final isActive = index <= _currentStep;
                    final isCompleted = index < _currentStep;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: isActive ? 32 : 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? AppColors.success
                            : isActive
                            ? AppColors.primary
                            : AppColors.grey300,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: isCompleted
                          ? const Icon(Icons.check, size: 8, color: Colors.white)
                          : null,
                    );
                  }),
                ),
                const SizedBox(height: 16),

                // Step Title
                Text(
                  _stepTitles[_currentStep],
                  style: AppTextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Get.theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'step_progress'.tr.replaceAll('{current}', '${_currentStep + 1}').replaceAll('{total}', '3'),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStepContent() {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Form(
          key: _formKey,
          child: _buildCurrentStepForm(),
        ),
      ),
    );
  }

  Widget _buildCurrentStepForm() {
    switch (_currentStep) {
      case 0:
        return _buildPersonalInfoStep();
      case 1:
        return _buildContactStep();
      case 2:
        return _buildSecurityStep();
      default:
        return Container();
    }
  }

  Widget _buildPersonalInfoStep() {
    return Column(
      children: [
        // Profile Avatar Placeholder
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.primaryShade,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 2),
          ),
          child: Stack(
            children: [
              Center(
                child: Icon(
                  Icons.person_outline,
                  size: 50,
                  color: AppColors.primary,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
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
        ),
        const SizedBox(height: 32),

        // First Name
        CustomTextField(
          label: 'first_name'.tr,
          hint: 'enter_first_name'.tr,
          controller: _firstNameController,
          focusNode: _firstNameFocusNode,
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.words,
          prefixIcon: const Icon(Icons.person_outline),
          validator: (value) => Validators.name(value, 'first_name'.tr),
          onSubmitted: (_) => _lastNameFocusNode.requestFocus(),
        ),
        const SizedBox(height: 20),

        // Last Name
        CustomTextField(
          label: 'last_name'.tr,
          hint: 'enter_last_name'.tr,
          controller: _lastNameController,
          focusNode: _lastNameFocusNode,
          textInputAction: TextInputAction.done,
          textCapitalization: TextCapitalization.words,
          prefixIcon: const Icon(Icons.person_outline),
          validator: (value) => Validators.name(value, 'last_name'.tr),
          onSubmitted: (_) => _nextStep(),
        ),
      ],
    );
  }

  Widget _buildContactStep() {
    return Column(
      children: [
    // Email
    CustomTextField.email(
    label: 'email'.tr,
      hint: 'enter_email'.tr,
      controller: _emailController,
      focusNode: _emailFocusNode,
      textInputAction: TextInputAction.next,
      validator: Validators.email,
      onSubmitted: (_) => _phoneFocusNode.requestFocus(),
    ),
    const SizedBox(height: 20),

    // Phone Number
    CustomTextField.phone(
    label: 'phone_number'.tr,
    hint: 'enter_phone_number'.tr,
    controller: _phoneController,
    focusNode: _phoneFocusNode,
    textInputAction: TextInputAction.done,
    validator: Validators.phone,
    onSubmitted: (_) => _nextStep(),
    ),
    const SizedBox(height: 16),

    // Info Text
    Container(
    padding: const EdgeInsets.all(16),