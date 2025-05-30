import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/translations/keys.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../widgets/common/custom_app_bar.dart';

/// Terms of Service document view
class TermsOfServiceView extends StatefulWidget {
  const TermsOfServiceView({super.key});

  @override
  State<TermsOfServiceView> createState() => _TermsOfServiceViewState();
}

class _TermsOfServiceViewState extends State<TermsOfServiceView>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final ScrollController _scrollController = ScrollController();
  double _scrollProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
    _setupScrollListener();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
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
  }

  void _startAnimations() {
    _animationController.forward();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      final maxScrollExtent = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;
      setState(() {
        _scrollProgress = maxScrollExtent > 0
            ? (currentScroll / maxScrollExtent).clamp(0.0, 1.0)
            : 0.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: CustomAppBar(
        title: TranslationKeys.termsOfService.tr,
        showBackButton: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: CircularProgressIndicator(
              value: _scrollProgress,
              strokeWidth: 3,
              backgroundColor: AppColors.grey200,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 32),
                    _buildContent(),
                    const SizedBox(height: 40),
                    _buildLastUpdated(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.gavel,
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
                      TranslationKeys.termsOfService.tr,
                      style: AppTextStyles.titleLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'effective_date'.tr,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'terms_introduction'.tr,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withOpacity(0.9),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            title: '1. ${\'acceptance_of_terms\'.tr}',
            content: 'acceptance_of_terms_content'.tr,
            icon: Icons.check_circle_outline,
          ),
          const SizedBox(height: 24),

          _buildSection(
            title: '2. ${\'description_of_service\'.tr}',
            content: 'description_of_service_content'.tr,
            icon: Icons.miscellaneous_services_outlined,
          ),
          const SizedBox(height: 24),

          _buildSection(
            title: '3. ${\'user_accounts\'.tr}',
            content: 'user_accounts_content'.tr,
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 24),

          _buildSection(
            title: '4. ${\'user_conduct\'.tr}',
            content: 'user_conduct_content'.tr,
            icon: Icons.security_outlined,
          ),
          const SizedBox(height: 24),

          _buildSection(
            title: '5. ${\'privacy_policy\'.tr}',
            content: 'privacy_policy_section_content'.tr,
            icon: Icons.privacy_tip_outlined,
          ),
          const SizedBox(height: 24),

          _buildSection(
            title: '6. ${\'intellectual_property\'.tr}',
            content: 'intellectual_property_content'.tr,
            icon: Icons.copyright_outlined,
          ),
          const SizedBox(height: 24),

          _buildSection(
            title: '7. ${\'disclaimers\'.tr}',
            content: 'disclaimers_content'.tr,
            icon: Icons.warning_amber_outlined,
          ),
          const SizedBox(height: 24),

          _buildSection(
            title: '8. ${\'limitation_of_liability\'.tr}',
            content: 'limitation_of_liability_content'.tr,
            icon: Icons.shield_outlined,
          ),
          const SizedBox(height: 24),

          _buildSection(
            title: '9. ${\'termination\'.tr}',
            content: 'termination_content'.tr,
            icon: Icons.exit_to_app_outlined,
          ),
          const SizedBox(height: 24),

          _buildSection(
            title: '10. ${\'governing_law\'.tr}',
            content: 'governing_law_content'.tr,
            icon: Icons.balance_outlined,
          ),
          const SizedBox(height: 24),

          _buildSection(
            title: '11. ${\'changes_to_terms\'.tr}',
            content: 'changes_to_terms_content'.tr,
            icon: Icons.update_outlined,
          ),
          const SizedBox(height: 24),

          _buildSection(
            title: '12. ${\'contact_information\'.tr}',
            content: 'contact_information_content'.tr,
            icon: Icons.contact_support_outlined,
          ),
        ],
      ),
    );}

    Widget _buildSection({
    required String title,
    required String content,
    required IconData icon,
    }) {
    return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Row(
    children: [
    Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
    color: AppColors.primaryShade,
    borderRadius: BorderRadius.circular(8),
    ),
    child: Icon(
    icon,
    color: AppColors.primary,
    size: 20,
    ),
    ),
    const SizedBox(width: 12),
    Expanded(
    child: Text(
    title,
    style: AppTextStyles.titleMedium.copyWith(
    fontWeight: FontWeight.bold,
    color: AppColors.grey900,
    ),
    ),
    ),
    ],
    ),
    const SizedBox(height: 12),
    Padding(
    padding: const EdgeInsets.only(left: 40),
    child: Text(
    content,
    style: AppTextStyles.bodyMedium.copyWith(
    color: AppColors.grey700,
    height: 1.6,
    ),
    ),
    ),
    ],
    );
    }

    Widget _buildLastUpdated() {
    return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
    color: AppColors.infoShade,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: AppColors.info.withOpacity(0.2)),
    ),
    child: Row(
    children: [
    Icon(
    Icons.info_outline,
    color: AppColors.info,
    size: 24,
    ),
    const SizedBox(width: 12),
    Expanded(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    'last_updated'.tr,
    style: AppTextStyles.titleSmall.copyWith(
    fontWeight: FontWeight.w600,
    color: AppColors.info,
    ),
    ),
    Text(
    'last_updated_date'.tr,
    style: AppTextStyles.bodySmall.copyWith(
    color: AppColors.grey700,
    ),
    ),
    ],
    ),
    ),
    ],
    ),
    );
    }
    }

// Translation extension for terms of service specific content
    extension TermsOfServiceTranslationExtensions on String {
    String get tr {
    final Map<String, String> termsTranslations = {
    'effective_date': 'Effective Date: January 1, 2025',
    'terms_introduction': 'Please read these Terms of Service carefully before using our application. By accessing or using our service, you agree to be bound by these terms.',

    'acceptance_of_terms': 'Acceptance of Terms',
    'acceptance_of_terms_content': 'By downloading, installing, or using this application, you acknowledge that you have read, understood, and agree to be bound by these Terms of Service and our Privacy Policy. If you do not agree to these terms, please do not use our service.',

    'description_of_service': 'Description of Service',
    'description_of_service_content': 'Our application provides digital services including but not limited to user authentication, data management, and interactive features. We reserve the right to modify, suspend, or discontinue any aspect of the service at any time.',

    'user_accounts': 'User Accounts',
    'user_accounts_content': 'You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account. You must provide accurate and complete information when creating your account and keep your information updated.',

    'user_conduct': 'User Conduct',
    'user_conduct_content': 'You agree not to use the service for any unlawful purpose or in any way that could damage, disable, overburden, or impair our servers or networks. You must not attempt to gain unauthorized access to any part of the service.',

    'privacy_policy_section_content': 'Your privacy is important to us. Our Privacy Policy explains how we collect, use, and protect your information when you use our service. By using our service, you also agree to our Privacy Policy.',

    'intellectual_property': 'Intellectual Property',
    'intellectual_property_content': 'The service and its original content, features, and functionality are owned by us and are protected by international copyright, trademark, patent, trade secret, and other intellectual property laws.',

    'disclaimers': 'Disclaimers',
    'disclaimers_content': 'The service is provided on an "as is" and "as available" basis. We make no warranties, express or implied, regarding the service, including but not limited to warranties of merchantability, fitness for a particular purpose, or non-infringement.',

    'limitation_of_liability': 'Limitation of Liability',
    'limitation_of_liability_content': 'In no event shall we be liable for any indirect, incidental, special, consequential, or punitive damages, including but not limited to loss of profits, data, or use, arising out of or relating to your use of the service.',

    'termination': 'Termination',
    'termination_content': 'We may terminate or suspend your account and access to the service immediately, without prior notice, for any breach of these Terms of Service. Upon termination, your right to use the service will cease immediately.',

    'governing_law': 'Governing Law',
    'governing_law_content': 'These Terms shall be governed by and construed in accordance with the laws of the jurisdiction in which our company is incorporated, without regard to its conflict of law provisions.',

    'changes_to_terms': 'Changes to Terms',
    'changes_to_terms_content': 'We reserve the right to modify these Terms of Service at any time. We will notify users of any material changes via email or through the application. Your continued use of the service after such modifications constitutes acceptance of the updated terms.',

    'contact_information': 'Contact Information',
    'contact_information_content': 'If you have any questions about these Terms of Service, please contact us at support@yourapp.com or through the contact information provided in the application.',

    'last_updated': 'Last Updated',
    'last_updated_date': 'These terms were last updated on January 1, 2025. We may update these terms from time to time to reflect changes in our practices or applicable law.',
    };

    return termsTranslations[this] ?? this;
    }
    }