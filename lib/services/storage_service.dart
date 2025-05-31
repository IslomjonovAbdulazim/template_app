import 'dart:convert';
import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/storage_keys.dart';

/// Simple storage service with GetX integration
class StorageService extends GetxService {
  static StorageService get instance => Get.find<StorageService>();

  late SharedPreferences _prefs;
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      sharedPreferencesName: 'template_app_secure_prefs',
      preferencesKeyPrefix: 'template_app_',
    ),
    iOptions: IOSOptions(
      groupId: 'group.com.example.template_app',
      accountName: 'template_app_keychain',
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeStorage();
    log('StorageService initialized');
  }

  /// Initialize SharedPreferences
  Future<void> _initializeStorage() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      log('SharedPreferences initialized successfully');
    } catch (e) {
      log('Failed to initialize SharedPreferences: $e');
      rethrow;
    }
  }

  // ==================== BASIC OPERATIONS ====================

  /// String operations
  Future<bool> setString(String key, String value) async {
    try {
      return await _prefs.setString(key, value);
    } catch (e) {
      log('Failed to save string for key $key: $e');
      return false;
    }
  }

  String? getString(String key, {String? defaultValue}) {
    try {
      return _prefs.getString(key) ?? defaultValue;
    } catch (e) {
      log('Failed to get string for key $key: $e');
      return defaultValue;
    }
  }

  /// Boolean operations
  Future<bool> setBool(String key, bool value) async {
    try {
      return await _prefs.setBool(key, value);
    } catch (e) {
      log('Failed to save bool for key $key: $e');
      return false;
    }
  }

  bool getBool(String key, {bool defaultValue = false}) {
    try {
      return _prefs.getBool(key) ?? defaultValue;
    } catch (e) {
      log('Failed to get bool for key $key: $e');
      return defaultValue;
    }
  }

  /// Integer operations
  Future<bool> setInt(String key, int value) async {
    try {
      return await _prefs.setInt(key, value);
    } catch (e) {
      log('Failed to save int for key $key: $e');
      return false;
    }
  }

  int? getInt(String key, {int? defaultValue}) {
    try {
      return _prefs.getInt(key) ?? defaultValue;
    } catch (e) {
      log('Failed to get int for key $key: $e');
      return defaultValue;
    }
  }

  /// Object operations (JSON)
  Future<bool> setObject(String key, Map<String, dynamic> value) async {
    try {
      final jsonString = json.encode(value);
      return await setString(key, jsonString);
    } catch (e) {
      log('Failed to save object for key $key: $e');
      return false;
    }
  }

  Map<String, dynamic>? getObject(String key) {
    try {
      final jsonString = getString(key);
      if (jsonString == null) return null;
      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      log('Failed to get object for key $key: $e');
      return null;
    }
  }

  // ==================== SECURE STORAGE ====================

  /// Save sensitive data securely
  Future<bool> setSecure(String key, String value) async {
    try {
      await _secureStorage.write(key: key, value: value);
      return true;
    } catch (e) {
      log('Failed to save secure data for key $key: $e');
      return false;
    }
  }

  /// Get sensitive data securely
  Future<String?> getSecure(String key) async {
    try {
      return await _secureStorage.read(key: key);
    } catch (e) {
      log('Failed to get secure data for key $key: $e');
      return null;
    }
  }

  /// Remove secure data
  Future<bool> removeSecure(String key) async {
    try {
      await _secureStorage.delete(key: key);
      return true;
    } catch (e) {
      log('Failed to remove secure data for key $key: $e');
      return false;
    }
  }

  // ==================== UTILITY OPERATIONS ====================

  /// Remove key
  Future<bool> remove(String key) async {
    try {
      return await _prefs.remove(key);
    } catch (e) {
      log('Failed to remove key $key: $e');
      return false;
    }
  }

  /// Clear all data
  Future<bool> clear() async {
    try {
      return await _prefs.clear();
    } catch (e) {
      log('Failed to clear storage: $e');
      return false;
    }
  }

  /// Clear all secure data
  Future<bool> clearSecure() async {
    try {
      await _secureStorage.deleteAll();
      return true;
    } catch (e) {
      log('Failed to clear secure storage: $e');
      return false;
    }
  }

  // ==================== APP-SPECIFIC HELPERS ====================

  /// Auth tokens
  Future<bool> setAccessToken(String token) =>
      setSecure(StorageKeys.accessToken, token);

  Future<String?> getAccessToken() => getSecure(StorageKeys.accessToken);

  Future<bool> setRefreshToken(String token) =>
      setSecure(StorageKeys.refreshToken, token);

  Future<String?> getRefreshToken() => getSecure(StorageKeys.refreshToken);

  Future<bool> clearTokens() async {
    final results = await Future.wait([
      removeSecure(StorageKeys.accessToken),
      removeSecure(StorageKeys.refreshToken),
      setBool(StorageKeys.isLoggedIn, false),
    ]);
    return results.every((result) => result == true);
  }

  /// User session
  Future<bool> setLoggedIn(bool isLoggedIn) =>
      setBool(StorageKeys.isLoggedIn, isLoggedIn);

  bool isLoggedIn() => getBool(StorageKeys.isLoggedIn, defaultValue: false);

  Future<bool> setUserId(String userId) =>
      setString(StorageKeys.userId, userId);

  String? getUserId() => getString(StorageKeys.userId);

  Future<bool> setUserEmail(String email) =>
      setString(StorageKeys.userEmail, email);

  String? getUserEmail() => getString(StorageKeys.userEmail);

  /// User preferences
  Future<bool> setDarkMode(bool isDarkMode) =>
      setBool(StorageKeys.isDarkMode, isDarkMode);

  bool isDarkMode() => getBool(StorageKeys.isDarkMode, defaultValue: false);

  Future<bool> setLanguage(String language) =>
      setString(StorageKeys.selectedLanguage, language);

  String getLanguage() =>
      getString(StorageKeys.selectedLanguage, defaultValue: 'en') ?? 'en';

  Future<bool> setNotificationsEnabled(bool enabled) =>
      setBool(StorageKeys.notificationsEnabled, enabled);

  bool isNotificationsEnabled() =>
      getBool(StorageKeys.notificationsEnabled, defaultValue: true);

  /// App state
  Future<bool> setFirstLaunch(bool isFirstLaunch) =>
      setBool(StorageKeys.isFirstLaunch, isFirstLaunch);

  bool isFirstLaunch() =>
      getBool(StorageKeys.isFirstLaunch, defaultValue: true);

  Future<bool> setOnboardingCompleted(bool completed) =>
      setBool(StorageKeys.onboardingCompleted, completed);

  bool isOnboardingCompleted() =>
      getBool(StorageKeys.onboardingCompleted, defaultValue: false);

  /// Device info
  Future<bool> setDeviceId(String deviceId) =>
      setString(StorageKeys.deviceId, deviceId);

  String? getDeviceId() => getString(StorageKeys.deviceId);

  Future<bool> setFCMToken(String token) =>
      setString(StorageKeys.fcmToken, token);

  String? getFCMToken() => getString(StorageKeys.fcmToken);
}
