import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';

/// Simple auth controller - just basic authentication
class AuthController extends GetxController {
  static AuthController get instance => Get.find<AuthController>();

  final AuthService _authService = AuthService.instance;

  // Simple reactive variables
  final _isLoading = false.obs;
  final _authError = ''.obs;

  // Getters
  bool get isLoggedIn => _authService.isLoggedIn;
  UserModel? get currentUser => _authService.currentUser;
  bool get isLoading => _isLoading.value;
  String get authError => _authError.value;
  bool get hasError => _authError.value.isNotEmpty;

  // User info getters
  String get userDisplayName => currentUser?.displayName ?? 'User';
  String get userEmail => currentUser?.email ?? '';

  @override
  void onInit() {
    super.onInit();
    log('AuthController initialized');
  }

  /// Simple login
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
        _showSuccess('Login successful!');
        Get.offAllNamed('/home');
      } else {
        _setError(response.errorMessage);
      }
    } catch (e) {
      log('Login error: $e');
      _setError('Login failed');
    } finally {
      _setLoading(false);
    }
  }

  /// Simple register
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
        _showSuccess('Registration successful!');
        Get.offAllNamed('/home');
      } else {
        _setError(response.errorMessage);
      }
    } catch (e) {
      log('Registration error: $e');
      _setError('Registration failed');
    } finally {
      _setLoading(false);
    }
  }

  /// Simple logout
  Future<void> logout() async {
    try {
      _setLoading(true);
      await _authService.logout();
      _showSuccess('Logged out successfully');
      Get.offAllNamed('/login');
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
        _showSuccess('Reset email sent!');
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

  /// Show logout confirmation
  Future<void> showLogoutConfirmation() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Logout'),
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

  // Helper methods
  void _setLoading(bool loading) => _isLoading.value = loading;
  void _setError(String error) => _authError.value = error;
  void _clearError() => _authError.value = '';

  void _showSuccess(String message) {
    Get.showSnackbar(GetSnackBar(
      title: 'Success',
      message: message,
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 2),
    ));
  }
}