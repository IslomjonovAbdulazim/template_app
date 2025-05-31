// lib/app/routes/app_routes.dart
abstract class Routes {
  Routes._();

  // ==================== MAIN APP ROUTES ====================
  static const INITIAL = '/';
  static const SPLASH = '/splash';
  static const HOME = '/home';

  // ==================== AUTHENTICATION ROUTES ====================
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const FORGOT_PASSWORD = '/forgot-password';
  static const RESET_PASSWORD = '/reset-password';
  static const VERIFY_EMAIL = '/verify-email';
  static const TERMS_CONDITIONS = '/terms-conditions';
  static const PRIVACY_POLICY = '/privacy-policy';

  // ==================== ERROR ROUTES ====================
  static const NOT_FOUND = '/not-found';
}