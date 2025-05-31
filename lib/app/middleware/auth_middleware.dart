import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';

/// Middleware for handling authentication-related route protection
/// Provides comprehensive auth checks and redirects
class AuthMiddleware extends GetMiddleware {
  /// Whether this route requires authentication
  final bool requiresAuth;

  /// Whether to redirect if user is already authenticated
  final bool redirectIfAuthenticated;

  /// Whether email verification is required for this route
  final bool requiresEmailVerification;

  /// Whether to allow guest access
  final bool allowGuest;

  /// Custom redirect route when auth fails
  final String? customRedirectRoute;

  /// Minimum user role required (if any)
  final UserRole? minimumRole;

  AuthMiddleware({
    this.requiresAuth = false,
    this.redirectIfAuthenticated = false,
    this.requiresEmailVerification = false,
    this.allowGuest = true,
    this.customRedirectRoute,
    this.minimumRole,
  });

  @override
  int? get priority => 1; // High priority for auth checks

  @override
  RouteSettings? redirect(String? route) {
    try {
      // Get auth controller
      if (!Get.isRegistered<AuthController>()) {
        log('AuthMiddleware: AuthController not registered, allowing access');
        return null;
      }

      final authController = AuthController.instance;
      final isLoggedIn = authController.isLoggedIn;
      final currentUser = authController.currentUser;

      log('AuthMiddleware: Checking route: $route');
      log('AuthMiddleware: User logged in: $isLoggedIn');
      log('AuthMiddleware: Requirements - requiresAuth: $requiresAuth, redirectIfAuthenticated: $redirectIfAuthenticated');

      // 1. Handle redirect if already authenticated
      if (redirectIfAuthenticated && isLoggedIn) {
        log('AuthMiddleware: User already authenticated, redirecting to home');
        return const RouteSettings(name: Routes.HOME);
      }

      // 2. Handle routes that require authentication
      if (requiresAuth && !isLoggedIn) {
        log('AuthMiddleware: Authentication required but user not logged in, redirecting to login');
        return RouteSettings(
          name: customRedirectRoute ?? Routes.LOGIN,
          arguments: {'returnRoute': route}, // Store return route for after login
        );
      }

      // 3. Handle guest-only routes
      if (!allowGuest && !isLoggedIn) {
        log('AuthMiddleware: Guest access not allowed, redirecting to login');
        return RouteSettings(
          name: customRedirectRoute ?? Routes.LOGIN,
          arguments: {'returnRoute': route},
        );
      }

      // 4. Handle email verification requirement
      if (requiresEmailVerification && isLoggedIn && currentUser != null) {
        if (!currentUser.emailVerified) {
          log('AuthMiddleware: Email verification required, redirecting to verify email');
          return const RouteSettings(name: Routes.VERIFY_EMAIL);
        }
      }

      // 5. Handle role-based access
      if (minimumRole != null && isLoggedIn && currentUser != null) {
        if (!_hasRequiredRole(currentUser.role, minimumRole!)) {
          log('AuthMiddleware: Insufficient permissions, redirecting to home');
          return const RouteSettings(name: Routes.HOME);
        }
      }

      // 6. Special handling for specific routes
      final redirectRoute = _handleSpecialRoutes(route, isLoggedIn, currentUser);
      if (redirectRoute != null) {
        return redirectRoute;
      }

      log('AuthMiddleware: Access granted to route: $route');
      return null; // Allow access

    } catch (e) {
      log('AuthMiddleware: Error in redirect check: $e');
      // On error, allow access to prevent app breaking
      return null;
    }
  }

  @override
  GetPage? onPageCalled(GetPage? page) {
    log('AuthMiddleware: Page called: ${page?.name}');
    return super.onPageCalled(page);
  }

  @override
  List<Bindings>? onBindingsStart(List<Bindings>? bindings) {
    log('AuthMiddleware: Bindings starting for protected route');
    return super.onBindingsStart(bindings);
  }

  @override
  GetPageBuilder? onPageBuildStart(GetPageBuilder? page) {
    log('AuthMiddleware: Page build starting');
    return super.onPageBuildStart(page);
  }

  /// Check if user has required role
  bool _hasRequiredRole(UserRole userRole, UserRole requiredRole) {
    const roleHierarchy = {
      UserRole.user: 0,
      UserRole.moderator: 1,
      UserRole.admin: 2,
      UserRole.superAdmin: 3,
    };

    final userLevel = roleHierarchy[userRole] ?? 0;
    final requiredLevel = roleHierarchy[requiredRole] ?? 0;

    return userLevel >= requiredLevel;
  }

  /// Handle special route-specific logic
  RouteSettings? _handleSpecialRoutes(String? route, bool isLoggedIn, UserModel? currentUser) {
    switch (route) {
      case Routes.VERIFY_EMAIL:
      // If user is not logged in, redirect to login
        if (!isLoggedIn) {
          return const RouteSettings(name: Routes.LOGIN);
        }
        // If email is already verified, redirect to home
        if (currentUser?.emailVerified == true) {
          return const RouteSettings(name: Routes.HOME);
        }
        break;

      case Routes.HOME:
      // If user is logged in but email not verified, redirect to verification
        if (isLoggedIn && currentUser != null && !currentUser.emailVerified) {
          // Check if email verification is enforced
          if (_shouldEnforceEmailVerification()) {
            return const RouteSettings(name: Routes.VERIFY_EMAIL);
          }
        }
        break;

      case Routes.RESET_PASSWORD:
      // Check if reset token is provided
        final arguments = Get.arguments as Map<String, dynamic>?;
        if (arguments?['token'] == null) {
          return const RouteSettings(name: Routes.FORGOT_PASSWORD);
        }
        break;

      case Routes.SPLASH:
      // Handle splash screen logic
        return _handleSplashRedirect(isLoggedIn, currentUser);

      default:
        break;
    }

    return null;
  }

  /// Handle splash screen redirects
  RouteSettings? _handleSplashRedirect(bool isLoggedIn, UserModel? currentUser) {
    // This logic would typically be handled in the splash screen itself
    // But we can add checks here if needed
    return null;
  }

  /// Check if email verification should be enforced
  bool _shouldEnforceEmailVerification() {
    // Add your business logic here
    // For example, check app settings, user type, etc.
    return true; // Default: enforce email verification
  }
}

/// Convenience middleware classes for common use cases
class RequiresAuthMiddleware extends AuthMiddleware {
  RequiresAuthMiddleware({
    bool requiresEmailVerification = false,
    UserRole? minimumRole,
    String? customRedirectRoute,
  }) : super(
    requiresAuth: true,
    requiresEmailVerification: requiresEmailVerification,
    minimumRole: minimumRole,
    customRedirectRoute: customRedirectRoute,
  );
}

class GuestOnlyMiddleware extends AuthMiddleware {
  GuestOnlyMiddleware({
    String? customRedirectRoute,
  }) : super(
    redirectIfAuthenticated: true,
    customRedirectRoute: customRedirectRoute,
  );
}

class VerifiedEmailRequiredMiddleware extends AuthMiddleware {
  VerifiedEmailRequiredMiddleware({
    UserRole? minimumRole,
  }) : super(
    requiresAuth: true,
    requiresEmailVerification: true,
    minimumRole: minimumRole,
  );
}

class AdminOnlyMiddleware extends AuthMiddleware {
  AdminOnlyMiddleware() : super(
    requiresAuth: true,
    requiresEmailVerification: true,
    minimumRole: UserRole.admin,
  );
}

class ModeratorOnlyMiddleware extends AuthMiddleware {
  ModeratorOnlyMiddleware() : super(
    requiresAuth: true,
    requiresEmailVerification: true,
    minimumRole: UserRole.moderator,
  );
}

/// Auth helper class for manual checks
class AuthHelper {
  static AuthController get _authController => AuthController.instance;

  /// Check if user is authenticated
  static bool get isAuthenticated => _authController.isLoggedIn;

  /// Check if user is guest
  static bool get isGuest => !_authController.isLoggedIn;

  /// Check if user email is verified
  static bool get isEmailVerified => _authController.isEmailVerified;

  /// Check if user has specific role
  static bool hasRole(UserRole role) {
    final currentUser = _authController.currentUser;
    if (currentUser == null) return false;
    return currentUser.role == role;
  }

  /// Check if user has minimum role level
  static bool hasMinimumRole(UserRole minimumRole) {
    final currentUser = _authController.currentUser;
    if (currentUser == null) return false;

    const roleHierarchy = {
      UserRole.user: 0,
      UserRole.moderator: 1,
      UserRole.admin: 2,
      UserRole.superAdmin: 3,
    };

    final userLevel = roleHierarchy[currentUser.role] ?? 0;
    final requiredLevel = roleHierarchy[minimumRole] ?? 0;

    return userLevel >= requiredLevel;
  }

  /// Check if user can access route
  static bool canAccessRoute(String route) {
    // Add your route access logic here
    // This could check against a permissions system
    return true;
  }

  /// Require authentication for a function
  static T? requireAuth<T>(T Function() function) {
    if (!isAuthenticated) {
      Get.offAllNamed(Routes.LOGIN);
      return null;
    }
    return function();
  }

  /// Require email verification for a function
  static T? requireEmailVerification<T>(T Function() function) {
    if (!isAuthenticated) {
      Get.offAllNamed(Routes.LOGIN);
      return null;
    }

    if (!isEmailVerified) {
      Get.toNamed(Routes.VERIFY_EMAIL);
      return null;
    }

    return function();
  }

  /// Require specific role for a function
  static T? requireRole<T>(UserRole role, T Function() function) {
    if (!isAuthenticated) {
      Get.offAllNamed(Routes.LOGIN);
      return null;
    }

    if (!hasRole(role)) {
      Get.showSnackbar(GetSnackBar(
        title: 'Access Denied',
        message: 'You don\'t have permission to perform this action',
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ));
      return null;
    }

    return function();
  }

  /// Guard widget - shows content only if condition is met
  static Widget guard({
    required Widget child,
    Widget? fallback,
    bool requiresAuth = false,
    bool requiresEmailVerification = false,
    UserRole? minimumRole,
  }) {
    if (requiresAuth && !isAuthenticated) {
      return fallback ?? const SizedBox.shrink();
    }

    if (requiresEmailVerification && !isEmailVerified) {
      return fallback ?? const SizedBox.shrink();
    }

    if (minimumRole != null && !hasMinimumRole(minimumRole)) {
      return fallback ?? const SizedBox.shrink();
    }

    return child;
  }
}

/// Import this in your UserModel if you don't already have it
enum UserRole {
  user,
  moderator,
  admin,
  superAdmin,
}