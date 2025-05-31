import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../constants/app_constants.dart';

/// Complete authentication controller with email verification and password reset
class AuthController extends GetxController {
  static AuthController get instance => Get.find<AuthController>();

  final AuthService _authService = AuthService.instance;

  // Loading states
  final _isLoading = false.obs;
  final _isVerificationLoading = false.obs;
  final _isResendingCode = false.obs;

  // Error states
  final _authError = ''.obs;
  final _verificationError = ''.obs;

  // Email verification state
  final _isEmailVerified = false.obs;
  final _verificationEmail = ''.obs;
  final _canResendCode = true.obs;
  final _resendCooldownSeconds = 0.obs;

  // Timer for resend cooldown
  Timer? _resendTimer;

  // Getters
  bool get isLoggedIn => _authService.isLoggedIn;
  UserModel? get currentUser => _authService.currentUser;
  bool get isLoading => _isLoading.value;
  bool get isVerificationLoading => _isVerificationLoading.value;
  bool get isResendingCode => _isResendingCode.value;

  String get authError => _authError.value;
  String get verificationError => _verificationError.value;
  bool get hasError => _authError.value.isNotEmpty;
  bool get hasVerificationError => _verificationError.value.isNotEmpty;

  bool get isEmailVerified => _isEmailVerified.value;
  String get verificationEmail => _verificationEmail.value;
  bool get canResendCode => _canResendCode.value;
  int get resendCooldownSeconds => _resendCooldownSeconds.value;

  // User info getters
  String get userDisplayName => currentUser?.displayName ?? 'User';
  String get userEmail => currentUser?.email ?? verificationEmail;

  @override
  void onInit() {
    super.onInit();
    log('AuthController initialized');
  }

  @override
  void onClose() {
    _resendTimer?.cancel();
    super.onClose();
  }

  /// Login with email and password
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final response = await _authService.login(
        email: email,
        password: password,
      );

      if (response.isSuccess) {
        _showSuccess('welcome_back'.tr);
        _navigateToHome();
      } else {
        _setError(response.errorMessage ?? "No Error");
      }
    } catch (e) {
      log('Login error: $e');
      _setError('login_failed'.tr);
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
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final response = await _authService.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );

      if (response.isSuccess) {
        _verificationEmail.value = email;

        // Check if user needs email verification
        final user = response.data;
        if (user != null && !user.isEmailVerified) {
          _showSuccess('registration_success'.tr);
          _navigateToEmailVerification();
        } else {
          _showSuccess('registration_success'.tr);
          _navigateToHome();
        }
      } else {
        _setError(response.errorMessage ?? "No Error");
      }
    } catch (e) {
      log('Registration error: $e');
      _setError('registration_failed'.tr);
    } finally {
      _setLoading(false);
    }
  }

  /// Forgot password
  Future<void> forgotPassword(String email) async {
    try {
      _setLoading(true);
      _clearError();

      final response = await _authService.forgotPassword(email);

      if (response.isSuccess) {
        _showSuccess('reset_link_sent'.tr);
        Get.back(); // Go back to login
      } else {
        _setError(response.errorMessage ?? "No Error");
      }
    } catch (e) {
      log('Forgot password error: $e');
      _setError('reset_failed'.tr);
    } finally {
      _setLoading(false);
    }
  }

  /// Reset password with token
  Future<void> resetPassword({
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      if (newPassword != confirmPassword) {
        _setError('password_mismatch'.tr);
        return;
      }

      final response = await _authService.resetPassword(
        token: token,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      if (response.isSuccess) {
        _showSuccess('reset_success'.tr);
        Get.offAllNamed('/login');
      } else {
        _setError(response.errorMessage ?? "No Error");
      }
    } catch (e) {
      log('Reset password error: $e');
      _setError('reset_failed'.tr);
    } finally {
      _setLoading(false);
    }
  }

  /// Verify email with OTP
  Future<void> verifyEmail(String otp) async {
    try {
      _setVerificationLoading(true);
      _clearVerificationError();

      final response = await _authService.verifyOtp(
        email: _verificationEmail.value,
        otp: otp,
        type: 'email_verification',
      );

      if (response.isSuccess) {
        _isEmailVerified.value = true;
        _showSuccess('email_verified'.tr);
        _navigateToHome();
      } else {
        _setVerificationError(response.errorMessage ?? "No Error");
      }
    } catch (e) {
      log('Email verification error: $e');
      _setVerificationError('verification_failed'.tr);
    } finally {
      _setVerificationLoading(false);
    }
  }

  /// Resend verification code
  Future<void> resendVerificationCode() async {
    if (!_canResendCode.value) return;

    try {
      _setResendingCode(true);
      _clearVerificationError();

      final response = await _authService.resendOtp(
        email: _verificationEmail.value,
        type: 'email_verification',
      );

      if (response.isSuccess) {
        _showSuccess('verification_code_sent'.tr);
        _startResendCooldown();
      } else {
        _setVerificationError(response.errorMessage ?? "No Error");
      }
    } catch (e) {
      log('Resend verification error: $e');
      _setVerificationError('resend_failed'.tr);
    } finally {
      _setResendingCode(false);
    }
  }

  /// Skip email verification (if allowed by business logic)
  Future<void> skipEmailVerification() async {
    // Only allow skipping if user is already logged in but not verified
    if (isLoggedIn && currentUser != null) {
      _navigateToHome();
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      _setLoading(true);
      await _authService.logout();
      _showSuccess('logout_successful'.tr);
      _clearAllState();
      Get.offAllNamed('/login');
    } catch (e) {
      log('Logout error: $e');
      _showError('logout_failed'.tr);
    } finally {
      _setLoading(false);
    }
  }

  /// Show logout confirmation dialog
  Future<void> showLogoutConfirmation() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: Text('logout'.tr),
        content: Text('logout_confirmation'.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('logout'.tr),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await logout();
    }
  }

  /// Clear verification error (public method for UI)
  void clearVerificationError() {
    _clearVerificationError();
  }

  /// Start resend cooldown timer
  void _startResendCooldown() {
    _canResendCode.value = false;
    _resendCooldownSeconds.value = 60; // 60 seconds cooldown

    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCooldownSeconds.value > 0) {
        _resendCooldownSeconds.value--;
      } else {
        _canResendCode.value = true;
        timer.cancel();
      }
    });
  }

  /// Navigation helpers
  void _navigateToHome() {
    Get.offAllNamed('/home');
  }

  void _navigateToEmailVerification() {
    Get.toNamed('/verify-email');
  }

  /// State management helpers
  void _setLoading(bool loading) => _isLoading.value = loading;
  void _setVerificationLoading(bool loading) => _isVerificationLoading.value = loading;
  void _setResendingCode(bool loading) => _isResendingCode.value = loading;

  void _setError(String error) => _authError.value = error;
  void _setVerificationError(String error) => _verificationError.value = error;

  void _clearError() => _authError.value = '';
  void _clearVerificationError() => _verificationError.value = '';

  void _clearAllState() {
    _clearError();
    _clearVerificationError();
    _isEmailVerified.value = false;
    _verificationEmail.value = '';
    _canResendCode.value = true;
    _resendCooldownSeconds.value = 0;
    _resendTimer?.cancel();
  }

  /// UI feedback helpers
  void _showSuccess(String message) {
    Get.showSnackbar(GetSnackBar(
      title: 'success'.tr,
      message: message,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.TOP,
    ));
  }

  void _showError(String message) {
    Get.showSnackbar(GetSnackBar(
      title: 'error'.tr,
      message: message,
      icon: const Icon(Icons.error, color: Colors.white),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.TOP,
    ));
  }
}