import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';

/// Simple auth middleware - just login/guest protection
class AuthMiddleware extends GetMiddleware {
  /// Whether this route requires authentication
  final bool requiresAuth;

  /// Whether to redirect if user is already authenticated (for login/register pages)
  final bool redirectIfAuthenticated;

  AuthMiddleware({
    this.requiresAuth = false,
    this.redirectIfAuthenticated = false,
  });

  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    try {
      // Check if auth controller is available
      if (!Get.isRegistered<AuthController>()) {
        log('AuthMiddleware: AuthController not registered');
        return null;
      }

      final authController = AuthController.instance;
      final isLoggedIn = authController.isLoggedIn;

      log('AuthMiddleware: Route: $route, LoggedIn: $isLoggedIn');

      // 1. Redirect to home if already authenticated (for login/register pages)
      if (redirectIfAuthenticated && isLoggedIn) {
        log('AuthMiddleware: User already authenticated, redirecting to home');
        return const RouteSettings(name: Routes.HOME);
      }

      // 2. Redirect to login if authentication required but not logged in
      if (requiresAuth && !isLoggedIn) {
        log('AuthMiddleware: Authentication required, redirecting to login');
        return const RouteSettings(name: Routes.LOGIN);
      }

      log('AuthMiddleware: Access granted to: $route');
      return null; // Allow access

    } catch (e) {
      log('AuthMiddleware: Error: $e');
      return null; // Allow access on error to prevent app breaking
    }
  }
}

/// Simple middleware for protected routes
class RequiresAuthMiddleware extends AuthMiddleware {
  RequiresAuthMiddleware() : super(requiresAuth: true);
}

/// Simple middleware for guest-only routes (login/register)
class GuestOnlyMiddleware extends AuthMiddleware {
  GuestOnlyMiddleware() : super(redirectIfAuthenticated: true);
}

/// Simple auth helper for manual checks
class AuthHelper {
  static AuthController get _authController => AuthController.instance;

  /// Check if user is authenticated
  static bool get isAuthenticated => _authController.isLoggedIn;

  /// Check if user is guest
  static bool get isGuest => !_authController.isLoggedIn;

  /// Require authentication for a function
  static T? requireAuth<T>(T Function() function) {
    if (!isAuthenticated) {
      Get.offAllNamed(Routes.LOGIN);
      return null;
    }
    return function();
  }

  /// Guard widget - show content only if authenticated
  static Widget authGuard({
    required Widget child,
    Widget? fallback,
  }) {
    if (!isAuthenticated) {
      return fallback ?? const SizedBox.shrink();
    }
    return child;
  }

  /// Guard widget - show content only for guests
  static Widget guestGuard({
    required Widget child,
    Widget? fallback,
  }) {
    if (isAuthenticated) {
      return fallback ?? const SizedBox.shrink();
    }
    return child;
  }
}