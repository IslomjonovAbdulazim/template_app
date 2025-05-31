// lib/app/routes/app_pages.dart
import 'package:get/get.dart';
import '../../views/auth/forgot_password_view.dart';
import '../../views/auth/login_view.dart';
import '../../views/auth/privacy_policy_view.dart';
import '../../views/auth/register_view.dart';
import '../../views/auth/reset_password_view.dart';
import '../../views/auth/term_conditions_view.dart';
import '../../views/auth/verify_email_view.dart';
import '../../views/home/home_view.dart';
import '../bindings/initial_binding.dart';
import '../middleware/auth_middleware.dart';
import '../views/auth/forgot_password_view.dart';
import '../views/auth/login_view.dart';
import '../views/auth/register_view.dart';
import '../views/auth/reset_password_view.dart';
import '../views/auth/verify_email_view.dart';
import '../views/auth/terms_conditions_view.dart';
import '../views/auth/privacy_policy_view.dart';
import '../views/home/home_view.dart';
import '../views/splash/splash_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH; // Start with splash screen

  static final routes = [
    // ==================== SPLASH ====================
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
      binding: InitialBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),

    // ==================== HOME ====================
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: BindingsBuilder(() {
        // Controllers already bound from InitialBinding
      }),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
      middlewares: [
        AuthMiddleware(requiresAuth: true),
      ],
    ),

    // ==================== AUTHENTICATION ROUTES ====================
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: BindingsBuilder(() {
        // AuthController is already bound from InitialBinding
      }),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
      middlewares: [
        // Redirect to home if already logged in
        AuthMiddleware(redirectIfAuthenticated: true),
      ],
    ),

    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterView(),
      binding: BindingsBuilder(() {
        // AuthController is already bound from InitialBinding
      }),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
      middlewares: [
        AuthMiddleware(redirectIfAuthenticated: true),
      ],
    ),

    GetPage(
      name: Routes.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    GetPage(
      name: Routes.RESET_PASSWORD,
      page: () => const ResetPasswordView(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    GetPage(
      name: Routes.VERIFY_EMAIL,
      page: () => const VerifyEmailView(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
      middlewares: [
        AuthMiddleware(requiresAuth: true),
      ],
    ),

    // ==================== LEGAL PAGES ====================
    GetPage(
      name: Routes.TERMS_CONDITIONS,
      page: () => const TermsConditionsView(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    GetPage(
      name: Routes.PRIVACY_POLICY,
      page: () => const PrivacyPolicyView(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    // ==================== FALLBACK ROUTE ====================
    GetPage(
      name: Routes.NOT_FOUND,
      page: () => const NotFoundView(),
      transition: Transition.fade,
    ),
  ];
}