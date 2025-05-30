import 'keys.dart';

/// English (US) translations for authentication
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
};