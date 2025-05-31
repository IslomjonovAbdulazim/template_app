
// Simple pages
import 'package:get/get.dart';
import '../../views/auth/forgot_password_view.dart';
import '../../views/auth/login_view.dart';
import '../../views/auth/register_view.dart';
import '../../views/home/home_view.dart';
import '../../views/splash/splash_view.dart';
import '../bindings/initial_binding.dart';
import '../middleware/auth_middleware.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.INITIAL;

  static final routes = [
    // Splash screen (initial route)
    GetPage(
      name: '/',
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
    ),
  ];
}