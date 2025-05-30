/// Application-wide constants
/// Contains all constant values used throughout the app
class AppConstants {
  AppConstants._();

  // App Information
  static const String appName = 'Template App';
  static const String appVersion = '1.0.0';
  static const String packageName = 'com.example.template_app';

  // Network & API
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  static const int sendTimeout = 30000; // 30 seconds
  static const int maxRetryAttempts = 3;
  static const int retryDelay = 1000; // 1 second

  // Authentication
  static const int otpLength = 6;
  static const int otpExpiryTime = 300; // 5 minutes in seconds
  static const int pinLength = 4;
  static const int maxLoginAttempts = 5;
  static const int lockoutDuration = 900; // 15 minutes in seconds
  static const int tokenRefreshBuffer = 300; // 5 minutes in seconds

  // UI & Animation
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration snackBarDuration = Duration(seconds: 4);
  static const Duration debounceDelay = Duration(milliseconds: 500);
  static const Duration autoLogoutTime = Duration(minutes: 30);

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  static const int initialPage = 1;

  // Cache & Storage
  static const int cacheExpiryHours = 24;
  static const int maxImageCacheSize = 100 * 1024 * 1024; // 100MB
  static const int maxImageCacheAge = 7; // 7 days
  static const String cacheDirectory = 'app_cache';

  // File Upload
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'gif'];
  static const List<String> allowedDocumentTypes = ['pdf', 'doc', 'docx'];

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 50;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 30;
  static const int maxNameLength = 50;
  static const int maxBioLength = 500;

  // Device & Biometric
  static const String fingerprintKey = 'fingerprint_auth';
  static const String faceIdKey = 'face_id_auth';
  static const int biometricTimeout = 60; // seconds

  // Notification
  static const String notificationChannelId = 'template_app_notifications';
  static const String notificationChannelName = 'Template App Notifications';
  static const String notificationChannelDesc = 'General notifications for Template App';

  // Social Login
  static const List<String> googleScopes = ['email', 'profile'];
  static const List<String> facebookPermissions = ['email', 'public_profile'];

  // Location
  static const double defaultLatitude = 0.0;
  static const double defaultLongitude = 0.0;
  static const double locationAccuracy = 100.0; // meters
  static const int locationTimeoutSeconds = 30;

  // Date & Time
  static const String dateFormat = 'dd/MM/yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String apiDateFormat = 'yyyy-MM-dd';
  static const String apiDateTimeFormat = 'yyyy-MM-ddTHH:mm:ss.SSSZ';

  // Currency & Number Formatting
  static const String defaultCurrency = 'USD';
  static const String currencySymbol = '\$';
  static const int decimalPlaces = 2;

  // Language & Localization
  static const String defaultLanguage = 'en';
  static const String defaultCountry = 'US';
  static const List<String> supportedLanguages = ['en', 'ar'];
  static const List<String> rtlLanguages = ['ar'];

  // Theme
  static const String defaultFontFamily = 'Inter';
  static const double defaultFontSize = 14.0;
  static const double smallFontSize = 12.0;
  static const double largeFontSize = 16.0;

  // Error Messages
  static const String genericErrorMessage = 'Something went wrong. Please try again.';
  static const String networkErrorMessage = 'No internet connection. Please check your network.';
  static const String timeoutErrorMessage = 'Request timeout. Please try again.';
  static const String unauthorizedErrorMessage = 'Session expired. Please login again.';

  // Success Messages
  static const String loginSuccessMessage = 'Login successful';
  static const String registerSuccessMessage = 'Registration successful';
  static const String updateSuccessMessage = 'Updated successfully';
  static const String deleteSuccessMessage = 'Deleted successfully';

  // Regular Expressions
  static const String emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phoneRegex = r'^\+?[1-9]\d{1,14}$';
  static const String passwordRegex = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]';

  // Development & Debug
  static const bool isDebugMode = true;
  static const bool enableLogging = true;
  static const bool enableAnalytics = false;
  static const bool enableCrashReporting = false;

  /// Get app version info
  static String get fullVersion => '$appVersion+${DateTime.now().millisecondsSinceEpoch}';

  /// Check if language is RTL
  static bool isRTL(String languageCode) => rtlLanguages.contains(languageCode);

  /// Get timeout duration for different operations
  static Duration getTimeoutDuration(String operation) {
    switch (operation) {
      case 'login':
        return const Duration(seconds: 15);
      case 'upload':
        return const Duration(minutes: 5);
      case 'download':
        return const Duration(minutes: 10);
      default:
        return const Duration(seconds: 30);
    }
  }
}