/// Storage keys used throughout the application
/// Centralized location for all local storage keys to avoid typos and conflicts
class StorageKeys {
  StorageKeys._();

  // Authentication related keys
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String isLoggedIn = 'is_logged_in';
  static const String userId = 'user_id';
  static const String userEmail = 'user_email';
  static const String rememberMe = 'remember_me';
  static const String biometricEnabled = 'biometric_enabled';

  // User preferences
  static const String isDarkMode = 'is_dark_mode';
  static const String selectedLanguage = 'selected_language';
  static const String fontSize = 'font_size';
  static const String notificationsEnabled = 'notifications_enabled';
  static const String soundEnabled = 'sound_enabled';

  // App state
  static const String isFirstLaunch = 'is_first_launch';
  static const String onboardingCompleted = 'onboarding_completed';
  static const String lastSyncTime = 'last_sync_time';
  static const String appVersion = 'app_version';

  // Cache keys
  static const String userProfile = 'user_profile';
  static const String cacheTimestamp = 'cache_timestamp';
  static const String offlineData = 'offline_data';

  // Device settings
  static const String deviceId = 'device_id';
  static const String fcmToken = 'fcm_token';
  static const String locationPermission = 'location_permission';
  static const String cameraPermission = 'camera_permission';
  static const String storagePermission = 'storage_permission';

  // Security
  static const String pinCode = 'pin_code';
  static const String pinEnabled = 'pin_enabled';
  static const String autoLockTime = 'auto_lock_time';
  static const String failedAttempts = 'failed_attempts';

  // Feature flags
  static const String betaFeaturesEnabled = 'beta_features_enabled';
  static const String analyticsEnabled = 'analytics_enabled';
  static const String crashReportingEnabled = 'crash_reporting_enabled';

  /// Get all keys as a list for debugging or clearing storage
  static List<String> get allKeys => [
    accessToken,
    refreshToken,
    isLoggedIn,
    userId,
    userEmail,
    rememberMe,
    biometricEnabled,
    isDarkMode,
    selectedLanguage,
    fontSize,
    notificationsEnabled,
    soundEnabled,
    isFirstLaunch,
    onboardingCompleted,
    lastSyncTime,
    appVersion,
    userProfile,
    cacheTimestamp,
    offlineData,
    deviceId,
    fcmToken,
    locationPermission,
    cameraPermission,
    storagePermission,
    pinCode,
    pinEnabled,
    autoLockTime,
    failedAttempts,
    betaFeaturesEnabled,
    analyticsEnabled,
    crashReportingEnabled,
  ];
}