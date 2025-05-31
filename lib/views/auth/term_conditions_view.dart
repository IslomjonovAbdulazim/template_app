import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/responsive_scaffold.dart';

class TermsConditionsView extends StatelessWidget {
  const TermsConditionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ResponsiveScaffold(
      appBar: CustomAppBar(
        title: 'Terms & Conditions',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Terms and Conditions',
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
              'Welcome to Template App. These Terms and Conditions ("Terms") govern your use of our mobile application and services. By accessing or using our app, you agree to be bound by these Terms.',
              isDark,
            ),

            // Acceptance of Terms
            _buildSection(
              'Acceptance of Terms',
              'By downloading, installing, or using Template App, you acknowledge that you have read, understood, and agree to be bound by these Terms. If you do not agree to these Terms, please do not use our services.',
              isDark,
            ),

            // User Accounts
            _buildSection(
              'User Accounts',
              '''To access certain features of our app, you may be required to create an account. You agree to:

• Provide accurate, current, and complete information
• Maintain the security of your password and account
• Accept responsibility for all activities under your account
• Notify us immediately of any unauthorized use

You are responsible for safeguarding your account credentials and for all activities that occur under your account.''',
              isDark,
            ),

            // Acceptable Use
            _buildSection(
              'Acceptable Use',
              '''You agree to use our app only for lawful purposes and in accordance with these Terms. You agree not to:

• Use the app in any way that violates applicable laws or regulations
• Transmit harmful, threatening, or offensive content
• Attempt to gain unauthorized access to our systems
• Interfere with or disrupt the app's functionality
• Use automated scripts or bots without permission
• Violate the rights of other users or third parties''',
              isDark,
            ),

            // Intellectual Property
            _buildSection(
              'Intellectual Property',
              'All content, features, and functionality of Template App, including but not limited to text, graphics, logos, icons, images, audio clips, and software, are owned by us or our licensors and are protected by copyright, trademark, and other intellectual property laws.',
              isDark,
            ),

            // Privacy
            _buildSection(
              'Privacy',
              'Your privacy is important to us. Our Privacy Policy explains how we collect, use, and protect your information when you use our services. By using our app, you agree to our Privacy Policy.',
              isDark,
            ),

            // Data Security
            _buildSection(
              'Data Security',
              'We implement appropriate security measures to protect your personal information. However, no method of transmission over the internet or electronic storage is 100% secure, and we cannot guarantee absolute security.',
              isDark,
            ),

            // Service Availability
            _buildSection(
              'Service Availability',
              'We strive to maintain app availability but do not guarantee uninterrupted access. We may temporarily suspend or restrict access for maintenance, updates, or other operational reasons.',
              isDark,
            ),

            // User Content
            _buildSection(
              'User Content',
              'You retain ownership of content you submit through our app. By submitting content, you grant us a worldwide, non-exclusive, royalty-free license to use, modify, and display such content in connection with our services.',
              isDark,
            ),

            // Termination
            _buildSection(
              'Termination',
              'We may terminate or suspend your account and access to our services at our sole discretion, without prior notice, for conduct that we believe violates these Terms or is harmful to other users, us, or third parties.',
              isDark,
            ),

            // Disclaimers
            _buildSection(
              'Disclaimers',
              'Our app is provided "as is" without warranties of any kind. We disclaim all warranties, express or implied, including merchantability, fitness for a particular purpose, and non-infringement.',
              isDark,
            ),

            // Limitation of Liability
            _buildSection(
              'Limitation of Liability',
              'To the maximum extent permitted by law, we shall not be liable for any indirect, incidental, special, consequential, or punitive damages, or any loss of profits or revenues.',
              isDark,
            ),

            // Indemnification
            _buildSection(
              'Indemnification',
              'You agree to indemnify and hold us harmless from any claims, damages, losses, or expenses arising from your use of our app or violation of these Terms.',
              isDark,
            ),

            // Governing Law
            _buildSection(
              'Governing Law',
              'These Terms shall be governed by and construed in accordance with the laws of [Your Jurisdiction], without regard to its conflict of law provisions.',
              isDark,
            ),

            // Changes to Terms
            _buildSection(
              'Changes to Terms',
              'We reserve the right to modify these Terms at any time. We will notify users of significant changes through the app or via email. Continued use of our services constitutes acceptance of modified Terms.',
              isDark,
            ),

            // Contact Information
            _buildSection(
              'Contact Information',
              '''If you have any questions about these Terms and Conditions, please contact us:

Email: support@templateapp.com
Website: www.templateapp.com
Address: [Your Company Address]

For urgent matters, please use our in-app support feature.''',
              isDark,
            ),

            const SizedBox(height: 40),

            // Agreement Confirmation
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.primaryDark.withOpacity(0.1)
                    : AppColors.primaryShade,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? AppColors.primaryDark : AppColors.primary,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: isDark ? AppColors.primaryLight : AppColors.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Agreement Acknowledgment',
                          style: AppTextStyles.titleMedium.copyWith(
                            color: isDark ? AppColors.primaryLight : AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'By using Template App, you acknowledge that you have read, understood, and agree to be bound by these Terms and Conditions.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
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