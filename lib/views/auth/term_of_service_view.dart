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
            width: 24,
            height: 24,
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
                      TermsKeys.effectiveDate.tr,
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
            TermsKeys.termsIntroduction.tr,
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
            title: '1. ${TermsKeys.acceptanceOfTerms.tr}',
            content: TermsKeys.acceptanceOfTermsContent.tr,
            icon: Icons.check_circle_outline,
          ),
          const SizedBox(height: 24),

          _buildSection(
            title: '2. ${TermsKeys.descriptionOfService.tr}',
            content: TermsKeys.descriptionOfServiceContent.tr,
            icon: Icons.miscellaneous_services_outlined,
          ),
          const SizedBox(height: 24),

          _buildSection(
            title: '3. ${TermsKeys.userAccounts.tr}',
            content: TermsKeys.userAccountsContent.tr,
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 24),

          _buildSection(
            title: '4. ${TermsKeys.userConduct.tr}',
            content: TermsKeys.userConductContent.tr,
            icon: Icons.security_outlined,
          ),
          const SizedBox(height: 24),

          _buildSection(
            title: '5. ${TermsKeys.privacyPolicy.tr}',
            content: TermsKeys.privacyPolicySectionContent.tr,
            icon: Icons.privacy_tip_outlined,
          ),
          const SizedBox(height: 24),

          _buildSection(
            title: '6. ${TermsKeys.intellectualProperty.tr}',
            content: TermsKeys.intellectualPropertyContent.tr,
            icon: Icons.copyright_outlined,
          ),
          const SizedBox(height: 24),

          _buildSection(
            title: '7. ${TermsKeys.disclaimers.tr}',
            content: TermsKeys.disclaimersContent.tr,
            icon: Icons.warning_amber_outlined,
          ),
          const SizedBox(height: 24),

          _buildSection(
            title: '8. ${TermsKeys.limitationOfLiability.tr}',
            content: TermsKeys.limitationOfLiabilityContent.tr,
            icon: Icons.shield_outlined,
          ),
          const SizedBox(height: 24),

          _buildSection(
            title: '9. ${TermsKeys.termination.tr}',
            content: TermsKeys.terminationContent.tr,
            icon: Icons.exit_to_app_outlined,
          ),
          const SizedBox(height: 24),

          _buildSection(
            title: '10. ${TermsKeys.governingLaw.tr}',
            content: TermsKeys.governingLawContent.tr,
            icon: Icons.balance_outlined,
          ),
          const SizedBox(height: 24),

          _buildSection(
            title: '11. ${TermsKeys.changesToTerms.tr}',
            content: TermsKeys.changesToTermsContent.tr,
            icon: Icons.update_outlined,
          ),
          const SizedBox(height: 24),

          _buildSection(
            title: '12. ${TermsKeys.contactInformation.tr}',
            content: TermsKeys.contactInformationContent.tr,
            icon: Icons.contact_support_outlined,
          ),
        ],
      ),
    );
  }

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
                  TermsKeys.lastUpdated.tr,
                  style: AppTextStyles.titleSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.info,
                  ),
                ),
                Text(
                  TermsKeys.lastUpdatedDate.tr,
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

/// Terms of Service specific translation keys
class TermsKeys {
  TermsKeys._();

  static const String effectiveDate = 'terms_effective_date';
  static const String termsIntroduction = 'terms_introduction';
  static const String acceptanceOfTerms = 'terms_acceptance';
  static const String acceptanceOfTermsContent = 'terms_acceptance_content';
  static const String descriptionOfService = 'terms_service_description';
  static const String descriptionOfServiceContent = 'terms_service_description_content';
  static const String userAccounts = 'terms_user_accounts';
  static const String userAccountsContent = 'terms_user_accounts_content';
  static const String userConduct = 'terms_user_conduct';
  static const String userConductContent = 'terms_user_conduct_content';
  static const String privacyPolicy = 'terms_privacy_policy';
  static const String privacyPolicySectionContent = 'terms_privacy_policy_content';
  static const String intellectualProperty = 'terms_intellectual_property';
  static const String intellectualPropertyContent = 'terms_intellectual_property_content';
  static const String disclaimers = 'terms_disclaimers';
  static const String disclaimersContent = 'terms_disclaimers_content';
  static const String limitationOfLiability = 'terms_limitation_liability';
  static const String limitationOfLiabilityContent = 'terms_limitation_liability_content';
  static const String termination = 'terms_termination';
  static const String terminationContent = 'terms_termination_content';
  static const String governingLaw = 'terms_governing_law';
  static const String governingLawContent = 'terms_governing_law_content';
  static const String changesToTerms = 'terms_changes';
  static const String changesToTermsContent = 'terms_changes_content';
  static const String contactInformation = 'terms_contact_info';
  static const String contactInformationContent = 'terms_contact_info_content';
  static const String lastUpdated = 'terms_last_updated';
  static const String lastUpdatedDate = 'terms_last_updated_date';
}