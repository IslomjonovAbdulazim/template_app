/// API endpoints and configurations
/// Centralized location for all API-related constants
class ApiConstants {
  ApiConstants._();

  // Base URLs
  static const String baseUrl = 'https://api.example.com/v1';
  static const String baseUrlDev = 'https://dev-api.example.com/v1';
  static const String baseUrlStaging = 'https://staging-api.example.com/v1';

  // Get base URL based on environment
  static String get currentBaseUrl {
    // You can implement environment detection here
    return baseUrl; // Default to production
  }

  // Authentication Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resendOtp = '/auth/resend-otp';
  static const String changePassword = '/auth/change-password';
  static const String deleteAccount = '/auth/delete-account';

  // Social Authentication
  static const String googleAuth = '/auth/google';
  static const String facebookAuth = '/auth/facebook';
  static const String appleAuth = '/auth/apple';

  // User Profile Endpoints
  static const String profile = '/user/profile';
  static const String updateProfile = '/user/profile';
  static const String uploadAvatar = '/user/avatar';
  static const String deleteAvatar = '/user/avatar';

  // App Configuration
  static const String appConfig = '/config/app';
  static const String appVersionEndpoint = '/config/version';
  static const String maintenanceModeEndpoint = '/config/maintenance';
  static const String forceUpdate = '/config/force-update';

  // Notification Endpoints
  static const String registerDevice = '/notifications/register';
  static const String unregisterDevice = '/notifications/unregister';
  static const String notifications = '/notifications';
  static const String markAsRead = '/notifications/read';
  static const String notificationSettings = '/notifications/settings';

  // File Upload/Download
  static const String uploadFile = '/files/upload';
  static const String downloadFile = '/files/download';
  static const String deleteFile = '/files/delete';

  // Analytics & Tracking
  static const String analytics = '/analytics/events';
  static const String crashReport = '/analytics/crash';
  static const String feedback = '/analytics/feedback';

  // Support & Help
  static const String contactSupport = '/support/contact';
  static const String faq = '/support/faq';
  static const String reportBug = '/support/bug-report';

  // Content Management
  static const String terms = '/content/terms';
  static const String privacy = '/content/privacy';
  static const String about = '/content/about';

  // HTTP Methods
  static const String get = 'GET';
  static const String post = 'POST';
  static const String put = 'PUT';
  static const String patch = 'PATCH';
  static const String delete = 'DELETE';

  // HTTP Headers
  static const String contentType = 'Content-Type';
  static const String authorization = 'Authorization';
  static const String accept = 'Accept';
  static const String userAgent = 'User-Agent';
  static const String deviceId = 'X-Device-ID';
  static const String appVersionHeader = 'X-App-Version';
  static const String platform = 'X-Platform';
  static const String language = 'Accept-Language';

  // Content Types
  static const String applicationJson = 'application/json';
  static const String multipartFormData = 'multipart/form-data';
  static const String applicationFormUrlEncoded = 'application/x-www-form-urlencoded';

  // API Response Keys
  static const String data = 'data';
  static const String message = 'message';
  static const String status = 'status';
  static const String success = 'success';
  static const String error = 'error';
  static const String errors = 'errors';
  static const String code = 'code';
  static const String meta = 'meta';
  static const String pagination = 'pagination';

  // Pagination Keys
  static const String page = 'page';
  static const String limit = 'limit';
  static const String totalPages = 'total_pages';
  static const String totalItems = 'total_items';
  static const String hasNext = 'has_next';
  static const String hasPrevious = 'has_previous';

  // Common Query Parameters
  static const String search = 'search';
  static const String sortBy = 'sort_by';
  static const String sortOrder = 'sort_order';
  static const String filter = 'filter';
  static const String include = 'include';
  static const String fields = 'fields';

  // HTTP Status Codes
  static const int ok = 200;
  static const int created = 201;
  static const int accepted = 202;
  static const int noContent = 204;
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int methodNotAllowed = 405;
  static const int conflict = 409;
  static const int unprocessableEntity = 422;
  static const int tooManyRequests = 429;
  static const int internalServerError = 500;
  static const int badGateway = 502;
  static const int serviceUnavailable = 503;
  static const int gatewayTimeout = 504;

  // Error Codes (Custom API Error Codes)
  static const String invalidCredentials = 'INVALID_CREDENTIALS';
  static const String accountLocked = 'ACCOUNT_LOCKED';
  static const String accountNotVerified = 'ACCOUNT_NOT_VERIFIED';
  static const String tokenExpired = 'TOKEN_EXPIRED';
  static const String tokenInvalid = 'TOKEN_INVALID';
  static const String userNotFound = 'USER_NOT_FOUND';
  static const String emailAlreadyExists = 'EMAIL_ALREADY_EXISTS';
  static const String phoneAlreadyExists = 'PHONE_ALREADY_EXISTS';
  static const String validationError = 'VALIDATION_ERROR';
  static const String rateLimitExceeded = 'RATE_LIMIT_EXCEEDED';
  static const String maintenanceModeError = 'MAINTENANCE_MODE';
  static const String forceUpdateRequired = 'FORCE_UPDATE_REQUIRED';

  /// Get full URL by combining base URL with endpoint
  static String getFullUrl(String endpoint) {
    return '$currentBaseUrl$endpoint';
  }

  /// Get authorization header value
  static String getBearerToken(String token) {
    return 'Bearer $token';
  }

  /// Check if status code is successful
  static bool isSuccessful(int statusCode) {
    return statusCode >= 200 && statusCode < 300;
  }

  /// Check if status code indicates client error
  static bool isClientError(int statusCode) {
    return statusCode >= 400 && statusCode < 500;
  }

  /// Check if status code indicates server error
  static bool isServerError(int statusCode) {
    return statusCode >= 500 && statusCode < 600;
  }

  /// Get default headers for API requests
  static Map<String, String> getDefaultHeaders() {
    return {
      contentType: applicationJson,
      accept: applicationJson,
      userAgent: 'TemplateApp/1.0.0',
      platform: 'mobile',
    };
  }

  /// Get headers with authorization token
  static Map<String, String> getAuthHeaders(String token) {
    final headers = getDefaultHeaders();
    headers[authorization] = getBearerToken(token);
    return headers;
  }

}

/// Common API endpoints grouped by feature
class ApiAuth {
  static const String login = ApiConstants.login;
  static const String register = ApiConstants.register;
  static const String logout = ApiConstants.logout;
  static const String refresh = ApiConstants.refreshToken;
  static const String forgotPassword = ApiConstants.forgotPassword;
  static const String resetPassword = ApiConstants.resetPassword;
  static const String verifyOtp = ApiConstants.verifyOtp;
}

class ApiUser {
  static const String profile = ApiConstants.profile;
  static const String updateProfile = ApiConstants.updateProfile;
  static const String uploadAvatar = ApiConstants.uploadAvatar;
}

class ApiConfig {
  static const String app = ApiConstants.appConfig;
  static const String version = ApiConstants.appVersionEndpoint;
  static const String maintenance = ApiConstants.maintenanceModeEndpoint;
}