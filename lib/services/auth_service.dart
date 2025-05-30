import 'dart:developer';
import 'package:get/get.dart';
import '../constants/api_constants.dart';
import '../constants/storage_keys.dart';
import '../models/response_model.dart';
import '../models/user_model.dart';
import 'api_service.dart';
import 'storage_service.dart';

/// Service for handling all authentication-related operations
class AuthService extends GetxService {
  static AuthService get instance => Get.find<AuthService>();

  final ApiService _apiService = ApiService.instance;
  final StorageService _storageService = StorageService.instance;

  // Reactive variables
  final _isLoggedIn = false.obs;
  final _currentUser = Rxn<UserModel>();
  final _isLoading = false.obs;

  // Getters
  bool get isLoggedIn => _isLoggedIn.value;
  UserModel? get currentUser => _currentUser.value;
  bool get isLoading => _isLoading.value;

  // Streams
  Stream<bool> get authStateStream => _isLoggedIn.stream;
  Stream<UserModel?> get userStream => _currentUser.stream;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeAuthState();
    log('AuthService initialized');
  }

  /// Initialize authentication state from stored data
  Future<void> _initializeAuthState() async {
    try {
      final token = await _storageService.getAccessToken();
      final isLoggedIn = _storageService.isLoggedIn();

      if (token != null && isLoggedIn) {
        _isLoggedIn.value = true;
        // Try to get cached user data
        await _loadUserFromCache();
        // Verify token is still valid
        await _verifyTokenValidity();
      } else {
        await logout(clearTokens: false);
      }
    } catch (e) {
      log('Failed to initialize auth state: $e');
      await logout(clearTokens: false);
    }
  }

  /// Load user data from cache
  Future<void> _loadUserFromCache() async {
    try {
      final userData = _storageService.getObject('cached_user');
      if (userData != null) {
        _currentUser.value = UserModel.fromJson(userData);
        log('User data loaded from cache');
      }
    } catch (e) {
      log('Failed to load user from cache: $e');
    }
  }

  /// Verify if current token is still valid
  Future<void> _verifyTokenValidity() async {
    try {
      final response = await _apiService.get<UserModel>(
        ApiUser.profile,
        fromJson: (json) => UserModel.fromJson(json as Map<String, dynamic>),
      );

      if (response.isSuccess && response.data != null) {
        _currentUser.value = response.data;
        await _cacheUserData(response.data!);
      } else if (response.isUnauthorized) {
        await logout();
      }
    } catch (e) {
      log('Token verification failed: $e');
    }
  }

  /// Cache user data locally
  Future<void> _cacheUserData(UserModel user) async {
    try {
      await _storageService.setObject('cached_user', user.toJson());
    } catch (e) {
      log('Failed to cache user data: $e');
    }
  }

  /// Login with email and password
  Future<ResponseModel<UserModel>> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      _isLoading.value = true;

      final response = await _apiService.post<Map<String, dynamic>>(
        ApiAuth.login,
        data: {
          'email': email,
          'password': password,
          'remember_me': rememberMe,
        },
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (response.isSuccess && response.data != null) {
        final data = response.data!;

        // Extract tokens
        final accessToken = data['access_token'] as String?;
        final refreshToken = data['refresh_token'] as String?;
        final userData = data['user'] as Map<String, dynamic>?;

        if (accessToken != null && userData != null) {
          // Store tokens
          await _storageService.setAccessToken(accessToken);
          if (refreshToken != null) {
            await _storageService.setRefreshToken(refreshToken);
          }

          // Store login state
          await _storageService.setLoggedIn(true);
          await _storageService.setUserEmail(email);

          // Create user model
          final user = UserModel.fromJson(userData);
          _currentUser.value = user;
          _isLoggedIn.value = true;

          // Cache user data
          await _cacheUserData(user);
          await _storageService.setUserId(user.id);

          log('Login successful for user: ${user.email}');

          return ResponseModel.success(
            data: user,
            message: 'Login successful',
          );
        }
      }

      return ResponseModel.error(
        message: response.errorMessage,
        code: response.code,
      );
    } catch (e) {
      log('Login error: $e');
      return ResponseModel.error(message: 'Login failed. Please try again.');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Register new user account
  Future<ResponseModel<UserModel>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    try {
      _isLoading.value = true;

      final response = await _apiService.post<Map<String, dynamic>>(
        ApiAuth.register,
        data: {
          'email': email,
          'password': password,
          'first_name': firstName,
          'last_name': lastName,
          if (phone != null) 'phone': phone,
        },
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (response.isSuccess && response.data != null) {
        final data = response.data!;

        // Check if auto-login after registration
        final accessToken = data['access_token'] as String?;
        final userData = data['user'] as Map<String, dynamic>?;

        if (accessToken != null && userData != null) {
          // Auto-login after registration
          await _storageService.setAccessToken(accessToken);
          await _storageService.setLoggedIn(true);
          await _storageService.setUserEmail(email);

          final user = UserModel.fromJson(userData);
          _currentUser.value = user;
          _isLoggedIn.value = true;

          await _cacheUserData(user);
          await _storageService.setUserId(user.id);

          log('Registration and auto-login successful for: ${user.email}');

          return ResponseModel.success(
            data: user,
            message: 'Registration successful',
          );
        } else if (userData != null) {
          // Registration successful but requires verification
          final user = UserModel.fromJson(userData);
          log('Registration successful, verification required for: ${user.email}');

          return ResponseModel.success(
            data: user,
            message: 'Registration successful. Please verify your email.',
          );
        }
      }

      return ResponseModel.error(
        message: response.errorMessage,
        code: response.code,
      );
    } catch (e) {
      log('Registration error: $e');
      return ResponseModel.error(message: 'Registration failed. Please try again.');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Logout user
  Future<ResponseModel<void>> logout({bool clearTokens = true}) async {
    try {
      _isLoading.value = true;

      if (clearTokens) {
        // Call logout API if we have a token
        final token = await _storageService.getAccessToken();
        if (token != null) {
          await _apiService.post(ApiAuth.logout);
        }
      }

      // Clear all stored data
      await _storageService.clearTokens();
      await _storageService.remove('cached_user');
      await _storageService.remove(StorageKeys.userId);
      await _storageService.remove(StorageKeys.userEmail);

      // Reset state
      _isLoggedIn.value = false;
      _currentUser.value = null;

      log('Logout successful');

      return ResponseModel.success(message: 'Logout successful');
    } catch (e) {
      log('Logout error: $e');
      return ResponseModel.error(message: 'Logout failed');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Forgot password
  Future<ResponseModel<void>> forgotPassword(String email) async {
    try {
      _isLoading.value = true;

      final response = await _apiService.post(
        ApiAuth.forgotPassword,
        data: {'email': email},
      );

      if (response.isSuccess) {
        log('Password reset email sent to: $email');
        return ResponseModel.success(
          message: 'Password reset email sent successfully',
        );
      }

      return ResponseModel.error(
        message: response.errorMessage,
        code: response.code,
      );
    } catch (e) {
      log('Forgot password error: $e');
      return ResponseModel.error(message: 'Failed to send reset email');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Reset password with token
  Future<ResponseModel<void>> resetPassword({
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      _isLoading.value = true;

      final response = await _apiService.post(
        ApiAuth.resetPassword,
        data: {
          'token': token,
          'password': newPassword,
          'password_confirmation': confirmPassword,
        },
      );

      if (response.isSuccess) {
        log('Password reset successful');
        return ResponseModel.success(message: 'Password reset successful');
      }

      return ResponseModel.error(
        message: response.errorMessage,
        code: response.code,
      );
    } catch (e) {
      log('Reset password error: $e');
      return ResponseModel.error(message: 'Password reset failed');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Change password for logged-in user
  Future<ResponseModel<void>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      _isLoading.value = true;

      final response = await _apiService.post(
        ApiConstants.changePassword,
        data: {
          'current_password': currentPassword,
          'password': newPassword,
          'password_confirmation': confirmPassword,
        },
        requiresAuth: true,
      );

      if (response.isSuccess) {
        log('Password changed successfully');
        return ResponseModel.success(message: 'Password changed successfully');
      }

      return ResponseModel.error(
        message: response.errorMessage,
        code: response.code,
      );
    } catch (e) {
      log('Change password error: $e');
      return ResponseModel.error(message: 'Password change failed');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Verify OTP
  Future<ResponseModel<UserModel>> verifyOtp({
    required String email,
    required String otp,
    required String type, // 'email_verification', 'password_reset', etc.
  }) async {
    try {
      _isLoading.value = true;

      final response = await _apiService.post<Map<String, dynamic>>(
        ApiAuth.verifyOtp,
        data: {
          'email': email,
          'otp': otp,
          'type': type,
        },
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (response.isSuccess && response.data != null) {
        final data = response.data!;
        final userData = data['user'] as Map<String, dynamic>?;

        if (userData != null) {
          final user = UserModel.fromJson(userData);

          // Update current user if logged in
          if (_isLoggedIn.value) {
            _currentUser.value = user;
            await _cacheUserData(user);
          }

          log('OTP verification successful for: $email');

          return ResponseModel.success(
            data: user,
            message: 'OTP verification successful',
          );
        }
      }

      return ResponseModel.error(
        message: response.errorMessage,
        code: response.code,
      );
    } catch (e) {
      log('OTP verification error: $e');
      return ResponseModel.error(message: 'OTP verification failed');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Resend OTP
  Future<ResponseModel<void>> resendOtp({
    required String email,
    required String type,
  }) async {
    try {
      _isLoading.value = true;

      final response = await _apiService.post(
        ApiConstants.resendOtp,
        data: {
          'email': email,
          'type': type,
        },
      );

      if (response.isSuccess) {
        log('OTP resent to: $email');
        return ResponseModel.success(message: 'OTP sent successfully');
      }

      return ResponseModel.error(
        message: response.errorMessage,
        code: response.code,
      );
    } catch (e) {
      log('Resend OTP error: $e');
      return ResponseModel.error(message: 'Failed to send OTP');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Social login (Google, Facebook, Apple)
  Future<ResponseModel<UserModel>> socialLogin({
    required String provider, // 'google', 'facebook', 'apple'
    required String accessToken,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      _isLoading.value = true;

      String endpoint;
      switch (provider.toLowerCase()) {
        case 'google':
          endpoint = ApiConstants.googleAuth;
          break;
        case 'facebook':
          endpoint = ApiConstants.facebookAuth;
          break;
        case 'apple':
          endpoint = ApiConstants.appleAuth;
          break;
        default:
          return ResponseModel.error(message: 'Unsupported social provider');
      }

      final response = await _apiService.post<Map<String, dynamic>>(
        endpoint,
        data: {
          'access_token': accessToken,
          ...?additionalData,
        },
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (response.isSuccess && response.data != null) {
        final data = response.data!;
        final appAccessToken = data['access_token'] as String?;
        final refreshToken = data['refresh_token'] as String?;
        final userData = data['user'] as Map<String, dynamic>?;

        if (appAccessToken != null && userData != null) {
          // Store tokens
          await _storageService.setAccessToken(appAccessToken);
          if (refreshToken != null) {
            await _storageService.setRefreshToken(refreshToken);
          }

          // Store login state
          await _storageService.setLoggedIn(true);

          // Create user model
          final user = UserModel.fromJson(userData);
          _currentUser.value = user;
          _isLoggedIn.value = true;

          // Cache user data
          await _cacheUserData(user);
          await _storageService.setUserId(user.id);
          await _storageService.setUserEmail(user.email);

          log('Social login successful for user: ${user.email}');

          return ResponseModel.success(
            data: user,
            message: 'Social login successful',
          );
        }
      }

      return ResponseModel.error(
        message: response.errorMessage,
        code: response.code,
      );
    } catch (e) {
      log('Social login error: $e');
      return ResponseModel.error(message: 'Social login failed');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Get current user profile
  Future<ResponseModel<UserModel>> getUserProfile() async {
    try {
      _isLoading.value = true;

      final response = await _apiService.get<UserModel>(
        ApiUser.profile,
        fromJson: (json) => UserModel.fromJson(json as Map<String, dynamic>),
        requiresAuth: true,
      );

      if (response.isSuccess && response.data != null) {
        _currentUser.value = response.data;
        await _cacheUserData(response.data!);

        log('User profile fetched successfully');
        return response;
      }

      return ResponseModel.error(
        message: response.errorMessage,
        code: response.code,
      );
    } catch (e) {
      log('Get user profile error: $e');
      return ResponseModel.error(message: 'Failed to fetch user profile');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Update user profile
  Future<ResponseModel<UserModel>> updateUserProfile(Map<String, dynamic> data) async {
    try {
      _isLoading.value = true;

      final response = await _apiService.put<UserModel>(
        ApiUser.updateProfile,
        data: data,
        fromJson: (json) => UserModel.fromJson(json as Map<String, dynamic>),
        requiresAuth: true,
      );

      if (response.isSuccess && response.data != null) {
        _currentUser.value = response.data;
        await _cacheUserData(response.data!);

        log('User profile updated successfully');
        return response;
      }

      return ResponseModel.error(
        message: response.errorMessage,
        code: response.code,
      );
    } catch (e) {
      log('Update user profile error: $e');
      return ResponseModel.error(message: 'Failed to update profile');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Delete user account
  Future<ResponseModel<void>> deleteAccount(String password) async {
    try {
      _isLoading.value = true;

      final response = await _apiService.delete(
        ApiConstants.deleteAccount,
        data: {'password': password},
        requiresAuth: true,
      );

      if (response.isSuccess) {
        await logout(clearTokens: false);
        log('Account deleted successfully');

        return ResponseModel.success(message: 'Account deleted successfully');
      }

      return ResponseModel.error(
        message: response.errorMessage,
        code: response.code,
      );
    } catch (e) {
      log('Delete account error: $e');
      return ResponseModel.error(message: 'Failed to delete account');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Check if user has specific permission
  bool hasPermission(String permission) {
    final user = _currentUser.value;
    if (user == null) return false;

    // Check based on user role
    switch (user.role) {
      case UserRole.admin:
      case UserRole.superAdmin:
        return true; // Admins have all permissions
      case UserRole.moderator:
      // Define moderator permissions
        const moderatorPermissions = [
          'view_users',
          'moderate_content',
          'manage_reports',
        ];
        return moderatorPermissions.contains(permission);
      case UserRole.user:
      default:
      // Define user permissions
        const userPermissions = [
          'view_profile',
          'edit_profile',
          'create_content',
        ];
        return userPermissions.contains(permission);
    }
  }

  /// Check if user is admin
  bool get isAdmin => _currentUser.value?.isAdmin ?? false;

  /// Check if user is moderator
  bool get isModerator => _currentUser.value?.isModerator ?? false;

  /// Check if user profile is complete
  bool get isProfileComplete => _currentUser.value?.isProfileComplete ?? false;

  /// Check if user is verified
  bool get isVerified => _currentUser.value?.isFullyVerified ?? false;

  /// Get user display name
  String get userDisplayName => _currentUser.value?.displayName ?? 'User';

  /// Get user initials
  String get userInitials => _currentUser.value?.initials ?? 'U';

  /// Force refresh user data
  Future<void> refreshUserData() async {
    if (_isLoggedIn.value) {
      await getUserProfile();
    }
  }

  /// Check authentication status
  Future<bool> checkAuthStatus() async {
    final token = await _storageService.getAccessToken();
    final isLoggedIn = _storageService.isLoggedIn();

    if (token == null || !isLoggedIn) {
      await logout(clearTokens: false);
      return false;
    }

    return true;
  }
}