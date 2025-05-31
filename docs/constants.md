# Flutter Template App Constants Documentation

## Overview
The constants folder contains 5 critical files that centralize all application-wide constants, configurations, and styling. This ensures consistency, maintainability, and prevents magic numbers/strings throughout the codebase.

## File Structure
```
lib/constants/
├── api_constants.dart      # API endpoints, HTTP configs, error codes
├── app_colors.dart         # Color palette, themes, financial colors
├── app_constants.dart      # App-wide settings, timeouts, validations
├── app_images.dart         # Asset paths, image management
├── app_text_styles.dart    # Typography system with Google Fonts
└── storage_keys.dart       # Local storage key definitions
```

---

## 1. API Constants (`api_constants.dart`)

### Purpose
Centralizes all API-related configurations, endpoints, and HTTP utilities for consistent network operations.

### Key Components

#### Base URLs & Environment Management
```dart
class ApiConstants {
  static const String baseUrl = 'https://api.example.com/v1';
  static const String baseUrlDev = 'https://dev-api.example.com/v1';
  static const String baseUrlStaging = 'https://staging-api.example.com/v1';
  
  static String get currentBaseUrl => baseUrl; // Environment detection logic
}
```

#### Authentication Endpoints
- `/auth/login`, `/auth/register`, `/auth/logout`
- `/auth/refresh`, `/auth/forgot-password`, `/auth/reset-password`
- `/auth/verify-otp`, `/auth/resend-otp`, `/auth/change-password`
- Social auth: `/auth/google`, `/auth/facebook`, `/auth/apple`

#### User & Profile Endpoints
- `/user/profile`, `/user/avatar`
- File operations: `/files/upload`, `/files/download`, `/files/delete`

#### App Configuration
- `/config/app`, `/config/version`, `/config/maintenance`, `/config/force-update`
- Notifications: `/notifications/*`
- Analytics: `/analytics/events`, `/analytics/crash`

#### HTTP Constants
- Methods: GET, POST, PUT, PATCH, DELETE
- Headers: Content-Type, Authorization, Accept, User-Agent, Device-ID
- Content types: application/json, multipart/form-data
- Status codes: 200-505 range with semantic constants

#### API Response Structure
```dart
// Response keys
static const String data = 'data';
static const String message = 'message';
static const String status = 'status';
static const String success = 'success';

// Pagination
static const String page = 'page';
static const String limit = 'limit';
static const String totalPages = 'total_pages';
```

#### Utility Methods
- `getFullUrl(endpoint)` - Combines base URL with endpoint
- `getBearerToken(token)` - Formats authorization header
- `isSuccessful(statusCode)` - Status code validation
- `getDefaultHeaders()` - Standard request headers
- `getAuthHeaders(token)` - Headers with authentication

#### Grouped Endpoint Classes
```dart
class ApiAuth {
  static const String login = ApiConstants.login;
  // ... other auth endpoints
}

class ApiUser {
  static const String profile = ApiConstants.profile;
  // ... other user endpoints
}
```

---

## 2. Storage Keys (`storage_keys.dart`)

### Purpose
Prevents typos and key conflicts in local storage operations by centralizing all storage key definitions.

### Key Categories

#### Authentication Storage
```dart
static const String accessToken = 'access_token';
static const String refreshToken = 'refresh_token';
static const String isLoggedIn = 'is_logged_in';
static const String userId = 'user_id';
static const String userEmail = 'user_email';
static const String rememberMe = 'remember_me';
static const String biometricEnabled = 'biometric_enabled';
```

#### User Preferences
```dart
static const String isDarkMode = 'is_dark_mode';
static const String selectedLanguage = 'selected_language';
static const String fontSize = 'font_size';
static const String notificationsEnabled = 'notifications_enabled';
static const String soundEnabled = 'sound_enabled';
```

#### App State Management
```dart
static const String isFirstLaunch = 'is_first_launch';
static const String onboardingCompleted = 'onboarding_completed';
static const String lastSyncTime = 'last_sync_time';
static const String appVersion = 'app_version';
```

#### Cache & Data Storage
```dart
static const String userProfile = 'user_profile';
static const String cacheTimestamp = 'cache_timestamp';
static const String offlineData = 'offline_data';
```

#### Device & Permissions
```dart
static const String deviceId = 'device_id';
static const String fcmToken = 'fcm_token';
static const String locationPermission = 'location_permission';
static const String cameraPermission = 'camera_permission';
static const String storagePermission = 'storage_permission';
```

#### Security Settings
```dart
static const String pinCode = 'pin_code';
static const String pinEnabled = 'pin_enabled';
static const String autoLockTime = 'auto_lock_time';
static const String failedAttempts = 'failed_attempts';
```

#### Feature Flags
```dart
static const String betaFeaturesEnabled = 'beta_features_enabled';
static const String analyticsEnabled = 'analytics_enabled';
static const String crashReportingEnabled = 'crash_reporting_enabled';
```

#### Utility
```dart
static List<String> get allKeys => [...]; // All keys for debugging/clearing
```

---

## 3. App Text Styles (`app_text_styles.dart`)

### Dependencies
```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
```

### Purpose
Implements Material Design 3 typography system with Google Fonts (Inter + Fira Code) and provides theme-aware text styles.

### Core Typography System

#### Font Configuration
```dart
static const String fontFamily = 'Inter';
static const FontWeight light = FontWeight.w300;
static const FontWeight regular = FontWeight.w400;
static const FontWeight medium = FontWeight.w500;
static const FontWeight semiBold = FontWeight.w600;
static const FontWeight bold = FontWeight.w700;
static const FontWeight extraBold = FontWeight.w800;
```

#### Typography Scale (Material Design 3)

**Display Styles** (Largest text)
- `displayLarge`: 57px, regular weight, tight line height
- `displayMedium`: 45px, regular weight, tight line height  
- `displaySmall`: 36px, regular weight, tight line height

**Headline Styles**
- `headlineLarge`: 32px, semiBold, normal line height
- `headlineMedium`: 28px, semiBold, normal line height
- `headlineSmall`: 24px, semiBold, normal line height

**Title Styles**
- `titleLarge`: 22px, medium weight, normal line height
- `titleMedium`: 16px, medium weight, wide letter spacing
- `titleSmall`: 14px, medium weight, wide letter spacing

**Body Styles** (Main content)
- `bodyLarge`: 16px, regular weight, relaxed line height
- `bodyMedium`: 14px, regular weight, relaxed line height
- `bodySmall`: 12px, regular weight, normal line height

**Label Styles** (UI elements)
- `labelLarge`: 14px, medium weight, wide letter spacing
- `labelMedium`: 12px, medium weight, wide letter spacing
- `labelSmall`: 11px, medium weight, wide letter spacing

#### Custom App-Specific Styles

**Button Styles**
- `buttonLarge`: 16px, semiBold, tight line height
- `buttonMedium`: 14px, semiBold, tight line height
- `buttonSmall`: 12px, semiBold, tight line height

**Input Field Styles**
- `inputText`: 16px, regular weight
- `inputLabel`: 14px, medium weight
- `inputHint`: 16px, regular weight
- `inputError`: 12px, regular weight (error color)

**Navigation Styles**
- `navigationLabel`: 12px, medium weight, tight line height
- `tabLabel`: 14px, medium weight, tight line height

**Card & List Styles**
- `cardTitle`: 18px, semiBold
- `cardSubtitle`: 14px, regular weight
- `listTitle`: 16px, medium weight
- `listSubtitle`: 14px, regular weight

**Special Styles**
- `code`: Fira Code font, 14px, relaxed line height
- `statusText`: 12px, semiBold, wide letter spacing
- `badgeText`: 10px, bold, wide letter spacing

### Theme-Aware Text Styles

#### Light Theme Text Styles
```dart
class LightTextStyles {
  static TextStyle get displayLarge => AppTextStyles.displayLarge.copyWith(color: LightColors.textPrimary);
  static TextStyle get inputError => AppTextStyles.inputError.copyWith(color: AppColors.error);
  // ... all styles with light theme colors
}
```

#### Dark Theme Text Styles
```dart
class DarkTextStyles {
  static TextStyle get displayLarge => AppTextStyles.displayLarge.copyWith(color: DarkColors.textPrimary);
  static TextStyle get inputError => AppTextStyles.inputError.copyWith(color: AppColors.errorLight);
  // ... all styles with dark theme colors
}
```

### Text Style Utilities
```dart
class TextStyleUtils {
  static TextStyle withColor(TextStyle style, Color color);
  static TextStyle withWeight(TextStyle style, FontWeight weight);
  static TextStyle withSize(TextStyle style, double size);
  static TextStyle withOpacity(TextStyle style, double opacity);
  static TextStyle withUnderline(TextStyle style);
  static TextStyle withLineThrough(TextStyle style);
  static Widget uppercase(String text, TextStyle style);
  static double getResponsiveFontSize(double baseFontSize, double screenWidth);
}
```

---

## 4. App Colors (`app_colors.dart`)

### Dependencies
```dart
import 'package:flutter/material.dart';
```

### Purpose
Financial-focused color system designed for debt tracking applications, emphasizing trust, professionalism, and financial clarity.

### Brand Colors
```dart
// Primary Brand Colors - Deep Financial Blue
static const Color primary = Color(0xFF1E3A8A);        // Blue-800 - Trust & Security
static const Color primaryLight = Color(0xFF3B82F6);   // Blue-500 - Interactive
static const Color primaryDark = Color(0xFF1E40AF);    // Blue-700 - Pressed states
static const Color primaryShade = Color(0xFFEFF6FF);   // Blue-50 - Light backgrounds

// Secondary Colors - Professional Slate
static const Color secondary = Color(0xFF475569);       // Slate-600
static const Color secondaryLight = Color(0xFF64748B);  // Slate-500
static const Color secondaryDark = Color(0xFF334155);   // Slate-700
static const Color secondaryShade = Color(0xFFF8FAFC); // Slate-50
```

### Financial Status Colors
```dart
// Debt Colors (Red spectrum)
static const Color debt = Color(0xFFDC2626);           // Red-600 - Debt amounts
static const Color debtLight = Color(0xFFEF4444);      // Red-500 - Debt indicators
static const Color debtDark = Color(0xFFB91C1C);       // Red-700 - Critical debt
static const Color debtShade = Color(0xFFFEF2F2);      // Red-50 - Backgrounds

// Credit Colors (Green spectrum)
static const Color credit = Color(0xFF059669);         // Emerald-600 - Positive amounts
static const Color creditLight = Color(0xFF10B981);    // Emerald-500 - Credit indicators
static const Color creditDark = Color(0xFF047857);     // Emerald-700 - Confirmed payments
static const Color creditShade = Color(0xFFF0FDF4);    // Green-50 - Backgrounds

// Pending Colors (Amber spectrum)
static const Color pending = Color(0xFFD97706);        // Amber-600 - Pending transactions
static const Color pendingLight = Color(0xFFF59E0B);   // Amber-500 - Pending indicators
static const Color pendingDark = Color(0xFFB45309);    // Amber-700 - Urgent pending
static const Color pendingShade = Color(0xFFFFFBEB);   // Amber-50 - Backgrounds
```

### Neutral Gray Scale
```dart
static const Color white = Color(0xFFFFFFFF);
static const Color black = Color(0xFF000000);
static const Color grey50 = Color(0xFFF9FAFB);   // Lightest
static const Color grey100 = Color(0xFFF3F4F6);
// ... through grey900 = Color(0xFF111827); // Darkest
```

### Status Colors
- Success, Warning, Error, Info (with light, dark, and shade variants)
- Aligned with financial status colors for consistency

### Social/Payment Colors
```dart
static const Color google = Color(0xFF4285F4);
static const Color facebook = Color(0xFF1877F2);
static const Color apple = Color(0xFF000000);
static const Color paypal = Color(0xFF00457C);
static const Color mastercard = Color(0xFFEB001B);
static const Color visa = Color(0xFF1A1F71);
```

### Financial Category Colors
```dart
static const Color housing = Color(0xFF7C3AED);        // Violet-600 - Housing/Rent
static const Color food = Color(0xFFEC4899);           // Pink-500 - Food/Dining
static const Color transport = Color(0xFF0EA5E9);      // Sky-500 - Transportation
static const Color utilities = Color(0xFF06B6D4);      // Cyan-500 - Utilities
static const Color entertainment = Color(0xFFF59E0B);  // Amber-500 - Entertainment
static const Color healthcare = Color(0xFFEF4444);     // Red-500 - Healthcare
static const Color education = Color(0xFF3B82F6);      // Blue-500 - Education
static const Color shopping = Color(0xFF8B5CF6);       // Violet-500 - Shopping
static const Color personal = Color(0xFF10B981);       // Emerald-500 - Personal
```

### Gradients
```dart
static const LinearGradient debtGradient = LinearGradient(
  colors: [debt, debtLight],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
// Similar gradients for credit, primary, and balance
```

### Theme-Specific Color Classes

#### Light Theme Colors
```dart
class LightColors {
  static const Color background = Color(0xFFFAFAFA);   // Slightly warm white
  static const Color surface = AppColors.white;
  static const Color textPrimary = AppColors.grey900;
  static const Color textSecondary = AppColors.grey600;
  static const Color border = AppColors.grey200;
  static const Color inputFill = AppColors.grey50;
  static const Color positiveBalance = AppColors.credit;
  static const Color negativeBalance = AppColors.debt;
}
```

#### Dark Theme Colors
```dart
class DarkColors {
  static const Color background = Color(0xFF0F172A);   // Slate-900 - Deep dark
  static const Color surface = Color(0xFF1E293B);      // Slate-800 - Card surfaces
  static const Color textPrimary = AppColors.white;
  static const Color textSecondary = AppColors.grey300;
  static const Color border = AppColors.grey600;
  static const Color inputFill = Color(0xFF334155);    // Slate-700
  static const Color positiveBalance = AppColors.creditLight;
  static const Color negativeBalance = AppColors.debtLight;
}
```

### Financial Color Utilities
```dart
class FinancialColorUtils {
  // Amount-based coloring
  static Color getAmountColor(double amount, {bool isDarkTheme = false});
  
  // Status-based coloring
  static Color getDebtStatusColor(String status); // paid, overdue, pending, etc.
  static Color getCategoryColor(String category); // housing, food, transport, etc.
  static Color getPriorityColor(int priority); // 1=high, 2=medium, 3=low
  static Color getInterestRateColor(double rate); // Higher rates = more red
  static Color getPaymentMethodColor(String method); // cash, card, paypal, etc.
  
  // Color manipulation
  static Color fromHex(String hexString);
  static String toHex(Color color);
  static Color getContrastingTextColor(Color backgroundColor);
  static Color darken(Color color, [double percent = 10]);
  static Color lighten(Color color, [double percent = 10]);
}
```

---

## 5. App Images (`app_images.dart`)

### Purpose
Centralizes all image asset paths with organized categorization and utility methods for asset management.

### Asset Structure
```
assets/images/
├── icons/
│   ├── common/          # General UI icons (home, search, settings, etc.)
│   ├── navigation/      # Bottom nav icons (active/inactive states)
│   ├── auth/           # Authentication icons (user, lock, social login)
│   ├── payment/        # Payment method icons (visa, mastercard, paypal)
│   ├── status/         # Status indicators (success, warning, error)
│   └── categories/     # Category icons (food, travel, shopping)
├── illustrations/
│   ├── onboarding/     # Onboarding flow illustrations
│   ├── empty_states/   # Empty state illustrations
│   └── errors/         # Error page illustrations
├── backgrounds/        # Background images for various screens
└── flags/             # Country flag icons
```

### Key Asset Categories

#### App Branding
```dart
static const String appLogo = '${_basePath}app_logo.png';
static const String appLogoWhite = '${_basePath}app_logo_white.png';
static const String appLogoIcon = '${_basePath}app_logo_icon.png';
static const String splashLogo = '${_basePath}splash_logo.png';
```

#### Common Icons (SVG)
- UI: home, search, notification, profile, settings, menu
- Actions: back, close, check, edit, delete, share, refresh
- Communication: phone, email, website, location
- Media: camera, gallery, document

#### Navigation Icons
```dart
static Map<String, Map<String, String>> get navigationIcons => {
  'home': {'inactive': navHome, 'active': navHomeActive},
  'search': {'inactive': navSearch, 'active': navSearchActive},
  // ... other nav items with active/inactive states
};
```

#### Authentication Icons
- User management: user, lock, unlock, eye, eye_off
- Biometric: fingerprint, face_id
- Social login: google, facebook, apple, twitter

#### Payment Method Icons
```dart
static Map<String, String> get paymentIcons => {
  'visa': iconVisa,
  'mastercard': iconMastercard,
  'amex': iconAmex,
  'paypal': iconPaypal,
  'wallet': iconWallet,
  'bank_transfer': iconBankTransfer,
};
```

#### Status & State Management
```dart
static Map<String, String> get statusIcons => {
  'success': statusSuccess,
  'warning': statusWarning,
  'error': statusError,
  'info': statusInfo,
  'pending': statusPending,
  'processing': statusProcessing,
};

static Map<String, String> get emptyStateIllustrations => {
  'search': emptySearch,
  'favorites': emptyFavorites,
  'notifications': emptyNotifications,
  'cart': emptyCart,
  'data': emptyData,
  'inbox': emptyInbox,
};

static Map<String, String> get errorIllustrations => {
  '404': error404,
  '500': error500,
  'network': errorNetwork,
  'maintenance': errorMaintenance,
  'general': errorGeneral,
};
```

### Utility Methods
```dart
// Asset type detection
static bool isSvg(String assetPath);
static bool isPng(String assetPath);
static bool isJpg(String assetPath);
static String getAssetType(String assetPath);

// Asset collections
static List<String> get allImages;      // All raster images
static List<String> get allSvgIcons;    // All SVG icons

// Dynamic icon retrieval
static String? getIconByName(String iconName);
```

---

## 6. App Constants (`app_constants.dart`)

### Purpose
Central repository for all application-wide configuration values, timeouts, limits, and settings.

### App Information
```dart
static const String appName = 'Template App';
static const String appVersion = '1.0.0';
static const String packageName = 'com.example.template_app';
static String get fullVersion => '$appVersion+${DateTime.now().millisecondsSinceEpoch}';
```

### Network & API Configuration
```dart
static const int connectionTimeout = 30000;    // 30 seconds
static const int receiveTimeout = 30000;       // 30 seconds
static const int sendTimeout = 30000;          // 30 seconds
static const int maxRetryAttempts = 3;
static const int retryDelay = 1000;           // 1 second
```

### Authentication Settings
```dart
static const int otpLength = 6;
static const int otpExpiryTime = 300;         // 5 minutes
static const int pinLength = 4;
static const int maxLoginAttempts = 5;
static const int lockoutDuration = 900;       // 15 minutes
static const int tokenRefreshBuffer = 300;    // 5 minutes
```

### UI & Animation Timings
```dart
static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
static const Duration splashDuration = Duration(seconds: 3);
static const Duration snackBarDuration = Duration(seconds: 4);
static const Duration debounceDelay = Duration(milliseconds: 500);
static const Duration autoLogoutTime = Duration(minutes: 30);
```

### Pagination Settings
```dart
static const int defaultPageSize = 20;
static const int maxPageSize = 100;
static const int initialPage = 1;
```

### Cache & Storage Limits
```dart
static const int cacheExpiryHours = 24;
static const int maxImageCacheSize = 100 * 1024 * 1024;  // 100MB
static const int maxImageCacheAge = 7;                   // 7 days
static const String cacheDirectory = 'app_cache';
```

### File Upload Constraints
```dart
static const int maxFileSize = 10 * 1024 * 1024;        // 10MB
static const int maxImageSize = 5 * 1024 * 1024;        // 5MB
static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'gif'];
static const List<String> allowedDocumentTypes = ['pdf', 'doc', 'docx'];
```

### Validation Rules
```dart
static const int minPasswordLength = 8;
static const int maxPasswordLength = 50;
static const int minUsernameLength = 3;
static const int maxUsernameLength = 30;
static const int maxNameLength = 50;
static const int maxBioLength = 500;
```

### Date & Time Formats
```dart
static const String dateFormat = 'dd/MM/yyyy';
static const String timeFormat = 'HH:mm';
static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
static const String apiDateFormat = 'yyyy-MM-dd';
static const String apiDateTimeFormat = 'yyyy-MM-ddTHH:mm:ss.SSSZ';
```

### Localization Settings
```dart
static const String defaultLanguage = 'en';
static const String defaultCountry = 'US';
static const List<String> supportedLanguages = ['en', 'ar'];
static const List<String> rtlLanguages = ['ar'];

static bool isRTL(String languageCode) => rtlLanguages.contains(languageCode);
```

### Error & Success Messages
```dart
static const String genericErrorMessage = 'Something went wrong. Please try again.';
static const String networkErrorMessage = 'No internet connection. Please check your network.';
static const String timeoutErrorMessage = 'Request timeout. Please try again.';
static const String unauthorizedErrorMessage = 'Session expired. Please login again.';

static const String loginSuccessMessage = 'Login successful';
static const String registerSuccessMessage = 'Registration successful';
```

### Regular Expressions
```dart
static const String emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
static const String phoneRegex = r'^\+?[1-9]\d{1,14}$';
static const String passwordRegex = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]';
```

### Development Flags
```dart
static const bool isDebugMode = true;
static const bool enableLogging = true;
static const bool enableAnalytics = false;
static const bool enableCrashReporting = false;
```

### Utility Methods
```dart
static Duration getTimeoutDuration(String operation) {
  switch (operation) {
    case 'login': return const Duration(seconds: 15);
    case 'upload': return const Duration(minutes: 5);
    case 'download': return const Duration(minutes: 10);
    default: return const Duration(seconds: 30);
  }
}
```

---

## Usage Patterns & Best Practices

### Import Strategy
```dart
// Always import specific constants files as needed
import 'package:template_app/constants/app_colors.dart';
import 'package:template_app/constants/app_text_styles.dart';
import 'package:template_app/constants/storage_keys.dart';
```

### Theme-Aware Usage
```dart
// Text styles with theme awareness
Text(
  'Hello World',
  style: Theme.of(context).brightness == Brightness.dark
    ? DarkTextStyles.headlineSmall
    : LightTextStyles.headlineSmall,
)

// Color usage with financial context
Container(
  color: FinancialColorUtils.getAmountColor(
    balance,
    isDarkTheme: Theme.of(context).brightness == Brightness.dark,
  ),
)
```

### Storage Operations
```dart
// Using storage keys consistently
await prefs.setString(StorageKeys.accessToken, token);
final isFirstLaunch = prefs.getBool(StorageKeys.isFirstLaunch) ?? true;
```

### API Calls
```dart
// Building API endpoints
final endpoint = ApiConstants.getFullUrl(ApiAuth.login);
final headers = ApiConstants.getAuthHeaders(token);

// Status code validation
if (ApiConstants.isSuccessful(response.statusCode)) {
  // Handle success
}
```

### Asset Loading
```dart
// SVG icons
SvgPicture.asset(AppImages.iconHome)

// Navigation icons with states
final iconPath = AppImages.navigationIcons['home']
  ?[isActive ? 'active' : 'inactive'] ?? AppImages.iconHome;

// Dynamic icon loading
final paymentIcon = AppImages.paymentIcons[paymentMethod] 
  ?? AppImages.iconCreditCard;
```

This documentation provides complete understanding of the constants folder structure, enabling consistent usage across the entire Flutter application without needing to reference the source code again.