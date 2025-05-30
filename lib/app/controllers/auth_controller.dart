import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/storage_service.dart';

/// Controller for managing authentication state in the UI
/// Provides reactive authentication status and user management
class AuthController extends GetxController {
  static AuthController get instance => Get.find<AuthController>();

  final AuthService _authService = AuthService.instance;
  final StorageService _storageService = StorageService.instance;

  // Reactive variables
  final _isLoggedIn = false.obs;
  final _currentUser = Rxn<UserModel>();
  final _isLoading = false.obs;
  final _isInitialized = false.obs;
  final _authError = ''.obs;
  final _sessionTimeLeft = 0.obs;

  // Session management
  Timer? _sessionTimer;
  Timer? _autoLogoutTimer;
  StreamSubscription<bool>? _authStateSubscription;
  StreamSubscription<UserModel?>? _userSubscription;

  // Getters
  bool get isLoggedIn => _isLoggedIn.value;
  bool get isGuest => !_isLoggedIn.value;
  UserModel? get currentUser => _currentUser.value;
  bool get isLoading => _isLoading.value;
  bool get isInitialized => _isInitialized.value;
  String get authError => _authError.value;
  int get sessionTimeLeft => _sessionTimeLeft.value;

  // User info getters
  String get userDisplayName => _currentUser.value?.displayName ?? 'guest'.tr;
  String get userEmail => _currentUser.value?.email ?? '';
  String get userInitials => _currentUser.value?.initials ?? 'G';
  String? get userAvatarUrl => _currentUser.value?.avatarUrl;
  bool get isEmailVerified => _currentUser.value?.emailVerified ?? false;
  bool get isPhoneVerified => _currentUser.value?.phoneVerified ?? false;
  bool get isProfileComplete => _currentUser.value?.isProfileComplete ?? false;
  bool get isAdmin => _currentUser.value?.isAdmin ?? false;
  bool get isModerator => _currentUser.value?.isModerator ?? false;
  bool get isVerified => _currentUser.value?.isFullyVerified ?? false;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeAuth();
    _setupAuthListeners();
    _setupSessionManagement();
    log('AuthController initialized');
  }

  @override
  void onClose() {
    _authStateSubscription?.cancel();
    _userSubscription?.cancel();
    _sessionTimer?.cancel();
    _autoLogoutTimer?.cancel();
    super.onClose();
  }

  /// Initialize authentication state
  Future<void> _initializeAuth() async {
    try {
      _isLoading.value = true;

      // Get initial auth state from service
      _isLoggedIn.value = _authService.isLoggedIn;
      _currentUser.value = _authService.currentUser;

      _isInitialized.value = true;
      log('Auth state initialized: ${_isLoggedIn.value}');
    } catch (e) {
      log('Failed to initialize auth: $e');
      _authError.value = 'initialization_failed'.tr;
    } finally {
      _isLoading.value = false;
    }
  }

  /// Setup authentication listeners
  void _setupAuthListeners() {
    // Listen to auth state changes
    _authStateSubscription = _authService.authStateStream.listen(
          (isLoggedIn) {
        _handleAuthStateChange(isLoggedIn);
      },
      onError: (error) {
        log('Auth state stream error: $error');
        _authError.value = error.toString();
      },
    );

    // Listen to user changes
    _userSubscription = _authService.userStream.listen(
          (user) {
        _currentUser.value = user;
        if (user != null) {
          _clearAuthError();
        }
      },
      onError: (error) {
        log('User stream error: $error');
      },
    );
  }

  /// Handle authentication state changes
  void _handleAuthStateChange(bool isLoggedIn) {
    final wasLoggedIn = _isLoggedIn.value;
    _isLoggedIn.value = isLoggedIn;

    if (!wasLoggedIn && isLoggedIn) {
      _handleLogin();
    } else if (wasLoggedIn && !isLoggedIn) {
      _handleLogout();
    }
  }

  /// Handle successful login
  void _handleLogin() {
    _clearAuthError();
    _startSessionTimer();
    _navigateToHome();
    log('User logged in successfully');
  }

  /// Handle logout
  void _handleLogout() {
    _currentUser.value = null;
    _stopSessionTimer();
    _navigateToLogin();
    log('User logged out');
  }

  /// Setup session management
  void _setupSessionManagement() {
    if (_isLoggedIn.value) {
      _startSessionTimer();
    }
  }

  /// Start session timer
  void _startSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimeLeft.value = 30 * 60; // 30 minutes

    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_sessionTimeLeft.value > 0) {
        _sessionTimeLeft.value--;

        // Show warning at 5 minutes
        if (_sessionTimeLeft.value == 5 * 60) {
          _showSessionWarning();
        }

        // Show final warning at 1 minute
        if (_sessionTimeLeft.value == 60) {
          _showFinalSessionWarning();
        }
      } else {
        _handleSessionExpired();
      }
    });
  }

  /// Stop session timer
  void _stopSessionTimer() {
    _sessionTimer?.cancel();
    _autoLogoutTimer?.cancel();
    _sessionTimeLeft.value = 0;
  }

  /// Extend session
  void extendSession() {
    if (_isLoggedIn.value) {
      _sessionTimeLeft.value = 30 * 60; // Reset to 30 minutes
      log('Session extended');
    }
  }

  /// Show session warning
  void _showSessionWarning() {
    Get.dialog(
      AlertDialog(
        title: Text('session_warning'.tr),
        content: Text('session_expires_soon'.tr),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              logout();
            },
            child: Text('logout'.tr),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              extendSession();
            },
            child: Text('extend_session'.tr),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  /// Show final session warning
  void _showFinalSessionWarning() {
    Get.dialog(
      AlertDialog(
        title: Text('session_expiring'.tr),
        content: Text('session_expires_in_one_minute'.tr),
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.back();
              extendSession();
            },
            child: Text('extend_session'.tr),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  /// Handle session expired
  void _handleSessionExpired() {
    _stopSessionTimer();
    logout();

    Get.dialog(
      AlertDialog(
        title: Text('session_expired'.tr),
        content: Text('please_login_again'.tr),
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.back();
              _navigateToLogin();
            },
            child: Text('login'.tr),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  /// Login with email and password
  Future<void> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      _setLoading(true);
      _clearAuthError();

      final response = await _authService.login(
        email: email,
        password: password,
        rememberMe: rememberMe,
      );

      if (response.isSuccess) {
        _showSuccessMessage('login_successful'.tr);
      } else {
        _setAuthError(response.errorMessage);
      }
    } catch (e) {
      log('Login error: $e');
      _setAuthError('login_failed'.tr);
    } finally {
      _setLoading(false);
    }
  }

  /// Register new user
  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    try {
      _setLoading(true);
      _clearAuthError();

      final response = await _authService.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
      );

      if (response.isSuccess) {
        _showSuccessMessage('registration_successful'.tr);
      } else {
        _setAuthError(response.errorMessage);
      }
    } catch (e) {
      log('Registration error: $e');
      _setAuthError('registration_failed'.tr);
    } finally {
      _setLoading(false);
    }
  }

  /// Social login
  Future<void> socialLogin({
    required String provider,
    required String accessToken,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      _setLoading(true);
      _clearAuthError();

      final response = await _authService.socialLogin(
        provider: provider,
        accessToken: accessToken,
        additionalData: additionalData,
      );

      if (response.isSuccess) {
        _showSuccessMessage('login_successful'.tr);
      } else {
        _setAuthError(response.errorMessage);
      }
    } catch (e) {
      log('Social login error: $e');
      _setAuthError('social_login_failed'.tr);
    } finally {
      _setLoading(false);
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      _setLoading(true);

      final response = await _authService.logout();

      if (response.isSuccess) {
        _showSuccessMessage('logout_successful'.tr);
      }
    } catch (e) {
      log('Logout error: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Forgot password
  Future<void> forgotPassword(String email) async {
    try {
      _setLoading(true);
      _clearAuthError();

      final response = await _authService.forgotPassword(email);

      if (response.isSuccess) {
        _showSuccessMessage('password_reset_sent'.tr);
      } else {
        _setAuthError(response.errorMessage);
      }
    } catch (e) {
      log('Forgot password error: $e');
      _setAuthError('forgot_password_failed'.tr);
    } finally {
      _setLoading(false);
    }
  }

  /// Reset password
  Future<void> resetPassword({
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      _setLoading(true);
      _clearAuthError();

      final response = await _authService.resetPassword(
        token: token,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      if (response.isSuccess) {
        _showSuccessMessage('password_reset_successful'.tr);
        _navigateToLogin();
      } else {
        _setAuthError(response.errorMessage);
      }
    } catch (e) {
      log('Reset password error: $e');
      _setAuthError('password_reset_failed'.tr);
    } finally {
      _setLoading(false);
    }
  }

  /// Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      _setLoading(true);
      _clearAuthError();

      final response = await _authService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      if (response.isSuccess) {
        _showSuccessMessage('password_changed'.tr);
      } else {
        _setAuthError(response.errorMessage);
      }
    } catch (e) {
      log('Change password error: $e');
      _setAuthError('password_change_failed'.tr);
    } finally {
      _setLoading(false);
    }
  }

  /// Verify OTP
  Future<void> verifyOtp({
    required String email,
    required String otp,
    required String type,
  }) async {
    try {
      _setLoading(true);
      _clearAuthError();

      final response = await _authService.verifyOtp(
        email: email,
        otp: otp,
        type: type,
      );

      if (response.isSuccess) {
        _showSuccessMessage('otp_verified'.tr);
      } else {
        _setAuthError(response.errorMessage);
      }
    } catch (e) {
      log('OTP verification error: $e');
      _setAuthError('otp_verification_failed'.tr);
    } finally {
      _setLoading(false);
    }
  }

  /// Resend OTP
  Future<void> resendOtp({
    required String email,
    required String type,
  }) async {
    try {
      _setLoading(true);
      _clearAuthError();

      final response = await _authService.resendOtp(
        email: email,
        type: type,
      );

      if (response.isSuccess) {
        _showSuccessMessage('otp_sent'.tr);
      } else {
        _setAuthError(response.errorMessage);
      }
    } catch (e) {
      log('Resend OTP error: $e');
      _setAuthError('otp_resend_failed'.tr);
    } finally {
      _setLoading(false);
    }
  }

  /// Update user profile
  Future<void> updateProfile(Map<String, dynamic> data) async {
    try {
      _setLoading(true);
      _clearAuthError();

      final response = await _authService.updateUserProfile(data);

      if (response.isSuccess) {
        _showSuccessMessage('profile_updated'.tr);
      } else {
        _setAuthError(response.errorMessage);
      }
    } catch (e) {
      log('Update profile error: $e');
      _setAuthError('profile_update_failed'.tr);
    } finally {
      _setLoading(false);
    }
  }

  /// Refresh user data
  Future<void> refreshUserData() async {
    try {
      await _authService.refreshUserData();
    } catch (e) {
      log('Refresh user data error: $e');
    }
  }

  /// Delete account
  Future<void> deleteAccount(String password) async {
    try {
      _setLoading(true);
      _clearAuthError();

      final response = await _authService.deleteAccount(password);

      if (response.isSuccess) {
        _showSuccessMessage('account_deleted'.tr);
      } else {
        _setAuthError(response.errorMessage);
      }
    } catch (e) {
      log('Delete account error: $e');
      _setAuthError('account_deletion_failed'.tr);
    } finally {
      _setLoading(false);
    }
  }

  /// Check if user has permission
  bool hasPermission(String permission) {
    return _authService.hasPermission(permission);
  }

  /// Navigate to login screen
  void _navigateToLogin() {
    Get.offAllNamed('/login');
  }

  /// Navigate to home screen
  void _navigateToHome() {
    Get.offAllNamed('/home');
  }

  /// Navigate to profile screen
  void navigateToProfile() {
    if (_isLoggedIn.value) {
      Get.toNamed('/profile');
    }
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading.value = loading;
  }

  /// Set auth error
  void _setAuthError(String error) {
    _authError.value = error;
  }

  /// Clear auth error
  void _clearAuthError() {
    _authError.value = '';
  }

  /// Show success message
  void _showSuccessMessage(String message) {
    Get.showSnackbar(GetSnackBar(
      title: 'success'.tr,
      message: message,
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
    ));
  }

  /// Show confirmation dialog for logout
  Future<void> showLogoutConfirmation() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: Text('confirm_logout'.tr),
        content: Text('are_you_sure_logout'.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: Text('logout'.tr),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await logout();
    }
  }

  /// Get session time remaining formatted
  String get sessionTimeFormatted {
    final minutes = _sessionTimeLeft.value ~/ 60;
    final seconds = _sessionTimeLeft.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Get auth status summary
  Map<String, dynamic> get authStatusSummary => {
    'isLoggedIn': _isLoggedIn.value,
    'isLoading': _isLoading.value,
    'isInitialized': _isInitialized.value,
    'hasError': _authError.value.isNotEmpty,
    'userEmail': userEmail,
    'isVerified': isVerified,
    'isProfileComplete': isProfileComplete,
    'sessionTimeLeft': _sessionTimeLeft.value,
  };

  /// Check authentication status
  Future<bool> checkAuthStatus() async {
    return await _authService.checkAuthStatus();
  }

  /// Force authentication check
  Future<void> forceAuthCheck() async {
    final isValid = await checkAuthStatus();
    if (!isValid && _isLoggedIn.value) {
      await logout();
    }
  }
}