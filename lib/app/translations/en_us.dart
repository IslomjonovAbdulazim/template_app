import 'keys.dart';

/// English (US) translations - Updated with all features
const Map<String, String> enUS = {
  // General Actions
  TranslationKeys.ok: 'OK',
  TranslationKeys.cancel: 'Cancel',
  TranslationKeys.confirm: 'Confirm',
  TranslationKeys.save: 'Save',
  TranslationKeys.loading: 'Loading...',
  TranslationKeys.error: 'Error',
  TranslationKeys.success: 'Success',
  TranslationKeys.retry: 'Retry',

  // Authentication - Core Actions
  TranslationKeys.login: 'Login',
  TranslationKeys.register: 'Register',
  TranslationKeys.signUp: 'Sign Up',
  TranslationKeys.signIn: 'Sign In',
  TranslationKeys.signOut: 'Sign Out',
  TranslationKeys.forgotPassword: 'Forgot Password?',
  TranslationKeys.resetPassword: 'Reset Password',
  TranslationKeys.changePassword: 'Change Password',

  // Authentication - Form Fields
  TranslationKeys.email: 'Email',
  TranslationKeys.password: 'Password',
  TranslationKeys.confirmPassword: 'Confirm Password',
  TranslationKeys.currentPassword: 'Current Password',
  TranslationKeys.newPassword: 'New Password',
  TranslationKeys.firstName: 'First Name',
  TranslationKeys.lastName: 'Last Name',
  TranslationKeys.fullName: 'Full Name',
  TranslationKeys.username: 'Username',
  TranslationKeys.phoneNumber: 'Phone Number',
  TranslationKeys.dateOfBirth: 'Date of Birth',
  TranslationKeys.rememberMe: 'Remember me',

  // Social Authentication
  TranslationKeys.signInWithGoogle: 'Sign in with Google',
  TranslationKeys.signInWithFacebook: 'Sign in with Facebook',
  TranslationKeys.signInWithApple: 'Sign in with Apple',
  TranslationKeys.or: 'OR',

  // Validation Messages
  TranslationKeys.fieldRequired: 'This field is required',
  TranslationKeys.invalidEmail: 'Please enter a valid email address',
  TranslationKeys.invalidPhone: 'Please enter a valid phone number',
  TranslationKeys.passwordTooShort: 'Password must be at least 8 characters',
  TranslationKeys.passwordsDontMatch: 'Passwords do not match',
  TranslationKeys.invalidUsername: 'Username can only contain letters, numbers, and underscores',
  TranslationKeys.usernameTooShort: 'Username must be at least 3 characters',
  TranslationKeys.nameTooShort: 'Name must be at least 2 characters',

  // Authentication Success Messages
  TranslationKeys.loginSuccessful: 'Login successful',
  TranslationKeys.registrationSuccessful: 'Registration successful',
  TranslationKeys.passwordChanged: 'Password changed successfully',
  TranslationKeys.passwordResetSent: 'Password reset email sent',
  TranslationKeys.emailVerified: 'Email verified successfully',
  TranslationKeys.phoneVerified: 'Phone verified successfully',

  // Authentication Error Messages
  TranslationKeys.loginFailed: 'Login failed. Please check your credentials.',
  TranslationKeys.registrationFailed: 'Registration failed. Please try again.',
  TranslationKeys.networkError: 'No internet connection. Please check your network.',
  TranslationKeys.serverError: 'Server error. Please try again later.',
  TranslationKeys.unknownError: 'Something went wrong. Please try again.',
  TranslationKeys.sessionExpired: 'Session expired. Please login again.',
  TranslationKeys.unauthorized: 'You are not authorized to perform this action.',
  TranslationKeys.validationError: 'Please fix the errors and try again.',

  // PIN & OTP
  TranslationKeys.enterPin: 'Enter PIN',
  TranslationKeys.verifyPin: 'Verify PIN',
  TranslationKeys.enterOtp: 'Enter OTP',
  TranslationKeys.verifyOtp: 'Verify OTP',
  TranslationKeys.resendOtp: 'Resend OTP',
  TranslationKeys.otpSent: 'OTP sent successfully',
  TranslationKeys.invalidOtp: 'Invalid OTP. Please try again.',
  TranslationKeys.otpExpired: 'OTP has expired. Please request a new one.',

  // Biometric Authentication
  TranslationKeys.biometricLogin: 'Biometric Login',
  TranslationKeys.fingerprint: 'Fingerprint',
  TranslationKeys.faceId: 'Face ID',
  TranslationKeys.biometricPrompt: 'Use your fingerprint or face to authenticate',
  TranslationKeys.biometricError: 'Biometric authentication failed',
  TranslationKeys.biometricNotAvailable: 'Biometric authentication is not available',

  // Account Setup
  TranslationKeys.createAccount: 'Create Account',
  TranslationKeys.alreadyHaveAccount: 'Already have an account?',
  TranslationKeys.dontHaveAccount: 'Don\'t have an account?',
  TranslationKeys.agreeToTerms: 'I agree to the Terms of Service and Privacy Policy',
  TranslationKeys.termsOfService: 'Terms of Service',
  TranslationKeys.privacyPolicy: 'Privacy Policy',
  TranslationKeys.and: 'and',

  // Welcome & Onboarding
  TranslationKeys.welcome: 'Welcome',
  TranslationKeys.welcomeBack: 'Welcome back!',
  TranslationKeys.getStarted: 'Get Started',
  TranslationKeys.continueAsGuest: 'Continue as Guest',

  // Common Phrases for Auth
  TranslationKeys.pleaseWait: 'Please wait...',
  TranslationKeys.tryAgain: 'Try Again',
  TranslationKeys.checkConnection: 'Please check your internet connection',

  // Language-related keys
  TranslationKeys.language: 'Language',
  TranslationKeys.selectLanguage: 'Select Language',
  TranslationKeys.changingLanguage: 'Changing language...',
  TranslationKeys.languageChanged: 'Language changed successfully',
  TranslationKeys.languageChangeFailed: 'Failed to change language',
  TranslationKeys.systemLanguageNotSupported: 'System language not supported',
  TranslationKeys.resetToSystemLanguage: 'Reset to system language',
  TranslationKeys.resetToDefaultLanguage: 'Reset to default language',
  TranslationKeys.failedToResetLanguage: 'Failed to reset language',

  // Terms of Service Keys
  'terms_effective_date': 'Effective Date: January 1, 2025',
  'terms_introduction': 'Please read these Terms of Service carefully before using our application. By accessing or using our service, you agree to be bound by these terms.',
  'terms_acceptance': 'Acceptance of Terms',
  'terms_acceptance_content': 'By downloading, installing, or using this application, you acknowledge that you have read, understood, and agree to be bound by these Terms of Service and our Privacy Policy. If you do not agree to these terms, please do not use our service.',
  'terms_service_description': 'Description of Service',
  'terms_service_description_content': 'Our application provides digital services including but not limited to user authentication, data management, and interactive features. We reserve the right to modify, suspend, or discontinue any aspect of the service at any time.',
  'terms_user_accounts': 'User Accounts',
  'terms_user_accounts_content': 'You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account. You must provide accurate and complete information when creating your account and keep your information updated.',
  'terms_user_conduct': 'User Conduct',
  'terms_user_conduct_content': 'You agree not to use the service for any unlawful purpose or in any way that could damage, disable, overburden, or impair our servers or networks. You must not attempt to gain unauthorized access to any part of the service.',
  'terms_privacy_policy': 'Privacy Policy',
  'terms_privacy_policy_content': 'Your privacy is important to us. Our Privacy Policy explains how we collect, use, and protect your information when you use our service. By using our service, you also agree to our Privacy Policy.',
  'terms_intellectual_property': 'Intellectual Property',
  'terms_intellectual_property_content': 'The service and its original content, features, and functionality are owned by us and are protected by international copyright, trademark, patent, trade secret, and other intellectual property laws.',
  'terms_disclaimers': 'Disclaimers',
  'terms_disclaimers_content': 'The service is provided on an "as is" and "as available" basis. We make no warranties, express or implied, regarding the service, including but not limited to warranties of merchantability, fitness for a particular purpose, or non-infringement.',
  'terms_limitation_liability': 'Limitation of Liability',
  'terms_limitation_liability_content': 'In no event shall we be liable for any indirect, incidental, special, consequential, or punitive damages, including but not limited to loss of profits, data, or use, arising out of or relating to your use of the service.',
  'terms_termination': 'Termination',
  'terms_termination_content': 'We may terminate or suspend your account and access to the service immediately, without prior notice, for any breach of these Terms of Service. Upon termination, your right to use the service will cease immediately.',
  'terms_governing_law': 'Governing Law',
  'terms_governing_law_content': 'These Terms shall be governed by and construed in accordance with the laws of the jurisdiction in which our company is incorporated, without regard to its conflict of law provisions.',
  'terms_changes': 'Changes to Terms',
  'terms_changes_content': 'We reserve the right to modify these Terms of Service at any time. We will notify users of any material changes via email or through the application. Your continued use of the service after such modifications constitutes acceptance of the updated terms.',
  'terms_contact_info': 'Contact Information',
  'terms_contact_info_content': 'If you have any questions about these Terms of Service, please contact us at support@yourapp.com or through the contact information provided in the application.',
  'terms_last_updated': 'Last Updated',
  'terms_last_updated_date': 'These terms were last updated on January 1, 2025. We may update these terms from time to time to reflect changes in our practices or applicable law.',

  // Email Verification Keys
  'email_verified_success': 'Email Verified Successfully',
  'verify_email': 'Verify Email',
  'enter_verification_code': 'Enter Verification Code',
  'verification_code_sent_to': 'We\'ve sent a 6-digit verification code to',
  'email_verified_successfully': 'Email Verified Successfully!',
  'email_verification_success_description': 'Your email has been verified successfully. You can now access all features of your account.',
  'welcome_aboard': 'Welcome Aboard!',
  'welcome_message_description': 'Your account is now fully activated. Start exploring and enjoy all the amazing features we have to offer.',
  'continue_to_app': 'Continue to App',
  'didnt_receive_code': 'Didn\'t receive the code?',
  'resend_verification_code': 'Resend Verification Code',
  'resend_in_seconds': 'Resend in {seconds} seconds',
  'verification_tips': 'Verification Tips',
  'verification_tips_description': 'Check your spam folder if you don\'t see the email. The code expires in 15 minutes.',
  'wrong_email_address': 'Wrong email address?',
  'change_email': 'Change Email',
  'internet_required_for_verification': 'Internet connection required for verification',
  'internet_required_for_resend': 'Internet connection required to resend code',
  'verification_code_sent': 'Verification Code Sent',
  'new_verification_code_sent': 'New verification code sent to your email',
};