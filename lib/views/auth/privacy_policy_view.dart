import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/responsive_scaffold.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ResponsiveScaffold(
      appBar: CustomAppBar(
        title: 'Privacy Policy',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Privacy Policy',
              style: AppTextStyles.headlineMedium.copyWith(
                color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Last updated: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
              ),
            ),

            const SizedBox(height: 32),

            // Introduction
            _buildSection(
              'Introduction',
              'Template App ("we", "our", or "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application and services.',
              isDark,
            ),

            // Information We Collect
            _buildSection(
              'Information We Collect',
              '''We may collect information about you in a variety of ways:

Personal Information:
• Name, email address, and contact information
• Profile picture and biographical information
• Account credentials and preferences

Usage Information:
• App usage patterns and features accessed
• Device information (model, operating system, unique identifiers)
• Log data (IP address, browser type, access times)

Location Information:
• Approximate location based on IP address
• Precise location (only with your permission)

Financial Information:
• Payment card information (processed securely by third-party providers)
• Transaction history and payment preferences''',
              isDark,
            ),

            // How We Use Your Information
            _buildSection(
              'How We Use Your Information',
              '''We use collected information for various purposes:

Service Provision:
• Create and manage your account
• Provide and maintain our services
• Process transactions and payments
• Send service-related communications

Improvement and Analytics:
• Analyze usage patterns to improve our app
• Develop new features and functionality
• Monitor and analyze trends and usage

Communication:
• Send updates, security alerts, and support messages
• Respond to inquiries and provide customer support
• Send promotional materials (with your consent)

Legal and Security:
• Comply with legal obligations
• Protect against fraud and unauthorized access
• Enforce our terms and policies''',
              isDark,
            ),

            // Information Sharing
            _buildSection(
              'Information Sharing and Disclosure',
              '''We do not sell, trade, or rent your personal information. We may share information in these situations:

Service Providers:
• Third-party vendors who assist in providing our services
• Payment processors for transaction handling
• Analytics providers for app improvement

Legal Requirements:
• When required by law or legal process
• To protect our rights, property, or safety
• To investigate potential violations of our terms

Business Transfers:
• In connection with mergers, acquisitions, or asset sales
• With appropriate confidentiality protections

With Your Consent:
• When you explicitly agree to share information
• For features that require third-party integration''',
              isDark,
            ),

            // Data Security
            _buildSection(
              'Data Security',
              '''We implement appropriate security measures to protect your information:

Technical Safeguards:
• Encryption of data in transit and at rest
• Secure servers and databases
• Regular security assessments and updates

Access Controls:
• Limited access to personal information
• Employee training on data protection
• Multi-factor authentication systems

However, no method of transmission over the internet or electronic storage is 100% secure. We cannot guarantee absolute security.''',
              isDark,
            ),

            // Data Retention
            _buildSection(
              'Data Retention',
              '''We retain your information for as long as necessary to:

• Provide our services and maintain your account
• Comply with legal obligations
• Resolve disputes and enforce agreements
• Achieve the purposes outlined in this policy

When you delete your account, we will delete or anonymize your personal information, except where retention is required by law.''',
              isDark,
            ),

            // Your Rights and Choices
            _buildSection(
              'Your Rights and Choices',
              '''You have several rights regarding your personal information:

Access and Portability:
• Request access to your personal information
• Receive a copy of your data in a portable format

Correction and Updates:
• Update or correct inaccurate information
• Modify your profile and preferences

Deletion:
• Request deletion of your personal information
• Delete your account and associated data

Communication Preferences:
• Opt out of promotional communications
• Manage notification settings
• Control marketing preferences

Location Settings:
• Enable or disable location services
• Control location data sharing''',
              isDark,
            ),

            // Children's Privacy
            _buildSection(
              'Children\'s Privacy',
              'Our app is not intended for children under 13 years of age. We do not knowingly collect personal information from children under 13. If we discover we have collected information from a child under 13, we will delete it immediately.',
              isDark,
            ),

            // International Users
            _buildSection(
              'International Users',
              'If you are accessing our app from outside the United States, please note that your information may be transferred to, stored, and processed in the United States where our servers are located.',
              isDark,
            ),

            // Third-Party Services
            _buildSection(
              'Third-Party Services',
              '''Our app may contain links to third-party websites or integrate with third-party services:

• Google Analytics for usage analytics
• Firebase for authentication and cloud services
• Payment processors (Stripe, PayPal)
• Social media platforms for authentication

These third parties have their own privacy policies. We are not responsible for their privacy practices.''',
              isDark,
            ),

            // Cookies and Tracking
            _buildSection(
              'Cookies and Tracking Technologies',
              '''We use various technologies to collect information:

• Cookies for preferences and authentication
• Local storage for app functionality
• Analytics tools for usage tracking
• Push notification tokens

You can control these through your device settings and app preferences.''',
              isDark,
            ),

            // Changes to Privacy Policy
            _buildSection(
              'Changes to This Privacy Policy',
              'We may update this Privacy Policy periodically. We will notify you of significant changes through the app, email, or by posting a notice on our website. Your continued use constitutes acceptance of the updated policy.',
              isDark,
            ),

            // Contact Information
            _buildSection(
              'Contact Us',
              '''If you have questions about this Privacy Policy or our data practices:

Email: privacy@templateapp.com
Support: support@templateapp.com
Website: www.templateapp.com/privacy

Data Protection Officer:
Email: dpo@templateapp.com

Mailing Address:
Template App Privacy Team
[Your Company Address]
[City, State, ZIP Code]

We will respond to privacy inquiries within 30 days.''',
              isDark,
            ),

            const SizedBox(height: 40),

            // Privacy Commitment
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.success.withOpacity(0.1)
                    : AppColors.successShade,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? AppColors.successLight : AppColors.success,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.shield_outlined,
                        color: isDark ? AppColors.successLight : AppColors.success,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Our Privacy Commitment',
                          style: AppTextStyles.titleMedium.copyWith(
                            color: isDark ? AppColors.successLight : AppColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'We are committed to protecting your privacy and being transparent about our data practices. Your trust is important to us.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            // GDPR/CCPA Notice
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.grey800.withOpacity(0.3)
                    : AppColors.grey100.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Regulatory Compliance',
                    style: AppTextStyles.titleSmall.copyWith(
                      color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We comply with applicable data protection regulations including GDPR, CCPA, and other privacy laws. For specific rights under these regulations, please contact our Data Protection Officer.',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.titleLarge.copyWith(
              color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}