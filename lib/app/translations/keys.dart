/// Centralized translation keys for the application
/// All translation files should use these keys to ensure consistency
class TranslationKeys {
  TranslationKeys._();

  // General Actions
  static const String ok = 'ok';
  static const String cancel = 'cancel';
  static const String confirm = 'confirm';
  static const String save = 'save';
  static const String loading = 'loading';
  static const String error = 'error';
  static const String success = 'success';
  static const String retry = 'retry';

  // Authentication - Core Actions
  static const String login = 'login';
  static const String register = 'register';
  static const String signUp = 'sign_up';
  static const String signIn = 'sign_in';
  static const String signOut = 'sign_out';
  static const String forgotPassword = 'forgot_password';
  static const String resetPassword = 'reset_password';
  static const String changePassword = 'change_password';

  // Authentication - Form Fields
  static const String email = 'email';
  static const String password = 'password';
  static const String confirmPassword = 'confirm_password';
  static const String currentPassword = 'current_password';
  static const String newPassword = 'new_password';
  static const String firstName = 'first_name';
  static const String lastName = 'last_name';
  static const String fullName = 'full_name';
  static const String username = 'username';
  static const String phoneNumber = 'phone_number';
  static const String dateOfBirth = 'date_of_birth';
  static const String rememberMe = 'remember_me';

  // Social Authentication
  static const String signInWithGoogle = 'sign_in_with_google';
  static const String signInWithFacebook = 'sign_in_with_facebook';
  static const String signInWithApple = 'sign_in_with_apple';
  static const String or = 'or';

  // Validation Messages
  static const String fieldRequired = 'field_required';
  static const String invalidEmail = 'invalid_email';
  static const String invalidPhone = 'invalid_phone';
  static const String passwordTooShort = 'password_too_short';
  static const String passwordsDontMatch = 'passwords_dont_match';
  static const String invalidUsername = 'invalid_username';
  static const String usernameTooShort = 'username_too_short';
  static const String nameTooShort = 'name_too_short';

  // Authentication Success Messages
  static const String loginSuccessful = 'login_successful';
  static const String registrationSuccessful = 'registration_successful';
  static const String passwordChanged = 'password_changed';
  static const String passwordResetSent = 'password_reset_sent';
  static const String emailVerified = 'email_verified';
  static const String phoneVerified = 'phone_verified';

  // Authentication Error Messages
  static const String loginFailed = 'login_failed';
  static const String registrationFailed = 'registration_failed';
  static const String networkError = 'network_error';
  static const String serverError = 'server_error';
  static const String unknownError = 'unknown_error';
  static const String sessionExpired = 'session_expired';
  static const String unauthorized = 'unauthorized';
  static const String validationError = 'validation_error';

  // PIN & OTP
  static const String enterPin = 'enter_pin';
  static const String verifyPin = 'verify_pin';
  static const String enterOtp = 'enter_otp';
  static const String verifyOtp = 'verify_otp';
  static const String resendOtp = 'resend_otp';
  static const String otpSent = 'otp_sent';
  static const String invalidOtp = 'invalid_otp';
  static const String otpExpired = 'otp_expired';

  // Biometric Authentication
  static const String biometricLogin = 'biometric_login';
  static const String fingerprint = 'fingerprint';
  static const String faceId = 'face_id';
  static const String biometricPrompt = 'biometric_prompt';
  static const String biometricError = 'biometric_error';
  static const String biometricNotAvailable = 'biometric_not_available';

  // Account Setup
  static const String createAccount = 'create_account';
  static const String alreadyHaveAccount = 'already_have_account';
  static const String dontHaveAccount = 'dont_have_account';
  static const String agreeToTerms = 'agree_to_terms';
  static const String termsOfService = 'terms_of_service';
  static const String privacyPolicy = 'privacy_policy';
  static const String and = 'and';

  // Welcome & Onboarding
  static const String welcome = 'welcome';
  static const String welcomeBack = 'welcome_back';
  static const String getStarted = 'get_started';
  static const String continueAsGuest = 'continue_as_guest';

  // Common Phrases for Auth
  static const String pleaseWait = 'please_wait';
  static const String tryAgain = 'try_again';
  static const String checkConnection = 'check_connection';

  // Language-related keys (for LanguageController)
  static const String language = 'language';
  static const String selectLanguage = 'select_language';
  static const String changingLanguage = 'changing_language';
  static const String languageChanged = 'language_changed';
  static const String languageChangeFailed = 'language_change_failed';
  static const String systemLanguageNotSupported = 'system_language_not_supported';
  static const String resetToSystemLanguage = 'reset_to_system_language';
  static const String resetToDefaultLanguage = 'reset_to_default_language';
  static const String failedToResetLanguage = 'failed_to_reset_language';
}