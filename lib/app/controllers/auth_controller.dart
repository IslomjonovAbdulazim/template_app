import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/storage_service.dart';

/// Simple auth controller for managing user authentication
class AuthController extends GetxController {
  static AuthController get instance => Get.find<AuthController>();

  final AuthService _authService = AuthService.instance;
  final StorageService _storageService = StorageService.instance;

  // Reactive variables
  final _isLoggedIn = false.obs;
  final _currentUser = Rxn<UserModel>();
  final _isLoading = false.obs;
  final _authError = ''.obs;

  // Stream subscriptions
  StreamSubscription<bool>? _authStateSubscription;
  StreamSubscription<UserModel?>? _userSubscription;

  // Getters
  bool get isLoggedIn => _isLoggedIn.value;
  bool get isGuest => !_isLoggedIn.value;
  UserModel? get currentUser => _currentUser.value;
  bool get isLoading => _isLoading.value;
  String get authError => _authError.value;

  // User info getters
  String get userDisplayName => _currentUser.value?.displayName ?? 'Guest';
  String get userEmail => _currentUser.value?.email ?? '';
  String get userInitials => _currentUser.value?.initials ?? 'G';
  bool get isEmailVerified => _currentUser.value?.emailVerified ?? false;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeAuth();
    _setupListeners();
    log('AuthController initialized');
  }

  @override
  void onClose() {
    _authStateSubscription?.cancel();
    _userSubscription?.cancel();
    super.onClose();
  }

  /// Initialize authentication
  Future<void> _initializeAuth() async {
    try {
      _isLoading.value = true;
      _isLoggedIn.value = _authService.isLoggedIn;
      _currentUser.value = _authService.currentUser;
    } catch (e) {
      log('Failed to initialize auth: $e');
      _authError.value = 'Initialization failed';
    } finally {
      _isLoading.value = false;
    }
  }

  /// Setup auth listeners
  void _setupListeners() {
    // Listen to auth state changes
    _authStateSubscription = _authService.authStateStream.listen(
          (isLoggedIn) {
        _isLoggedIn.value = isLoggedIn;
        if (isLoggedIn) {
          _navigateToHome();
        } else {
          _currentUser.value = null;
          _navigateToLogin();
        }
      },
      onError: (error) {
        log('Auth state error: $error');
        _authError.value = error.toString();
      },
    );

    // Listen to user changes
    _userSubscription = _authService.userStream.listen(
          (user) {
        _currentUser.value = user;
        if (user != null) {
          _clearError();
        }
      },
      onError: (error) {
        log('User stream error: $error');
      },
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
      _clearError();

      final response = await _authService.login(
        email: email,
        password: password,
        rememberMe: rememberMe,
      );

      if (response.isSuccess) {
        _showSuccess('Login successful!');
      } else {
        _setError(response.errorMessage);
      }
    } catch (e) {
      log('Login error: $e');
      _setError('Login failed. Please try again.');
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
      _clearError();

      final response = await _authService.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
      );

      if (response.isSuccess) {
        _showSuccess('Registration successful!');
      } else {
        _setError(response.errorMessage);
      }
    } catch (e) {
      log('Registration error: $e');
      _setError('Registration failed. Please try again.');
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
        _showSuccess('Logged out successfully');
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
      _clearError();

      final response = await _authService.forgotPassword(email);

      if (response.isSuccess) {
        _showSuccess('Password reset email sent!');
      } else {
        _setError(response.errorMessage);
      }
    } catch (e) {
      log('Forgot password error: $e');
      _setError('Failed to send reset email');
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
      _clearError();

      final response = await _authService.resetPassword(
        token: token,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      if (response.isSuccess) {
        _showSuccess('Password reset successful!');
        _navigateToLogin();
      } else {
        _setError(response.errorMessage);
      }
    } catch (e) {
      log('Reset password error: $e');
      _setError('Password reset failed');
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
      _clearError();

      final response = await _authService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      if (response.isSuccess) {
        _showSuccess('Password changed successfully!');
      } else {
        _setError(response.errorMessage);
      }
    } catch (e) {
      log('Change password error: $e');
      _setError('Failed to change password');
    } finally {
      _setLoading(false);
    }
  }

  /// Update user profile
  Future<void> updateProfile(Map<String, dynamic> data) async {
    try {
      _setLoading(true);
      _clearError();

      final response = await _authService.updateUserProfile(data);

      if (response.isSuccess) {
        _showSuccess('Profile updated successfully!');
      } else {
        _setError(response.errorMessage);
      }
    } catch (e) {
      log('Update profile error: $e');
      _setError('Failed to update profile');
    } finally {
      _setLoading(false);
    }
  }

  /// Show logout confirmation
  Future<void> showLogoutConfirmation() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await logout();
    }
  }

  /// Navigate to login
  void _navigateToLogin() {
    Get.offAllNamed('/login');
  }

  /// Navigate to home
  void _navigateToHome() {
    Get.offAllNamed('/home');
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading.value = loading;
  }

  /// Set error message
  void _setError(String error) {
    _authError.value = error;
  }

  /// Clear error
  void _clearError() {
    _authError.value = '';
  }

  /// Show success message
  void _showSuccess(String message) {
    Get.showSnackbar(GetSnackBar(
      title: 'Success',
      message: message,
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
    ));
  }

  /// Show error message
  void _showError(String message) {
    Get.showSnackbar(GetSnackBar(
      title: 'Error',
      message: message,
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.BOTTOM,
    ));
  }

  /// Check if user has error
  bool get hasError => _authError.value.isNotEmpty;

  /// Get user status summary
  String get userStatusSummary {
    if (isGuest) return 'Guest User';
    if (!isEmailVerified) return 'Email not verified';
    return 'Verified User';
  }
}