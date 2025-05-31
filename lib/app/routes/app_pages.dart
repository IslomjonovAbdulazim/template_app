import 'package:get/get.dart';
import '../../views/auth/forgot_password_view.dart';
import '../../views/auth/login_view.dart';
import '../../views/auth/register_view.dart';
import '../../views/auth/reset_password_view.dart';
import '../../views/auth/verify_email_view.dart';
import '../../views/general/splash_view.dart';
import '../../views/home/home_view.dart';
import '../bindings/initial_binding.dart';
import '../middleware/auth_middleware.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.INITIAL;

  static final routes = [
    // Splash screen (initial route)
    GetPage(
      name: Routes.INITIAL,
      page: () => const SplashView(),
      binding: InitialBinding(), // This sets up all services
    ),

    // Home (requires authentication)
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      middlewares: [RequiresAuthMiddleware()],
    ),

    // Login (redirect to home if already logged in)
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginView(),
      middlewares: [GuestOnlyMiddleware()],
    ),

    // Register (redirect to home if already logged in)
    GetPage(
      name: Routes.REGISTER,
      page: () => RegisterView(),
      middlewares: [GuestOnlyMiddleware()],
    ),

    // Forgot Password
    GetPage(
      name: Routes.FORGOT_PASSWORD,
      page: () => ForgotPasswordView(),
      middlewares: [GuestOnlyMiddleware()],
    ),

    // Reset Password
    GetPage(
      name: Routes.RESET_PASSWORD,
      page: () => ResetPasswordView(),
      middlewares: [GuestOnlyMiddleware()],
    ),

    // Email Verification
    GetPage(
      name: Routes.VERIFY_EMAIL,
      page: () => const VerifyEmailView(),
      // No middleware - can be accessed by partially authenticated users
    ),
  ];
}