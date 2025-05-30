import 'dart:convert';
import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/storage_keys.dart';

/// Service for handling all local storage operations
/// Provides unified interface for SharedPreferences and secure storage
class StorageService {
  static StorageService? _instance;
  static StorageService get instance => _instance ??= StorageService._();

  StorageService._();

  SharedPreferences? _prefs;
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

  /// Initialize storage service
  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      log('StorageService initialized successfully');
    } catch (e) {
      log('Failed to initialize StorageService: $e');
      rethrow;
    }
  }

  /// Check if storage is initialized
  bool get isInitialized => _prefs != null;

  /// Ensure storage is initialized
  void _ensureInitialized() {
    if (!isInitialized) {
      throw Exception('StorageService not initialized. Call init() first.');
    }
  }

  // ==================== STRING OPERATIONS ====================

  /// Save string value
  Future<bool> setString(String key, String value) async {
    try {
      _ensureInitialized();
      return await _prefs!.setString(key, value);
    } catch (e) {
      log('Failed to save string for key $key: $e');
      return false;
    }
  }

  /// Get string value
  String? getString(String key, {String? defaultValue}) {
    try {
      _ensureInitialized();
      return _prefs!.getString(key) ?? defaultValue;
    } catch (e) {
      log('Failed to get string for key $key: $e');
      return defaultValue;
    }
  }

  // ==================== INTEGER OPERATIONS ====================

  /// Save integer value
  Future<bool> setInt(String key, int value) async {
    try {
      _ensureInitialized();
      return await _prefs!.setInt(key, value);
    } catch (e) {
      log('Failed to save int for key $key: $e');
      return false;
    }
  }

  /// Get integer value
  int? getInt(String key, {int? defaultValue}) {
    try {
      _ensureInitialized();
      return _prefs!.getInt(key) ?? defaultValue;
    } catch (e) {
      log('Failed to get int for key $key: $e');
      return defaultValue;
    }
  }

  // ==================== DOUBLE OPERATIONS ====================

  /// Save double value
  Future<bool> setDouble(String key, double value) async {
    try {
      _ensureInitialized();
      return await _prefs!.setDouble(key, value);
    } catch (e) {
      log('Failed to save double for key $key: $e');
      return false;
    }
  }

  /// Get double value
  double? getDouble(String key, {double? defaultValue}) {
    try {
      _ensureInitialized();
      return _prefs!.getDouble(key) ?? defaultValue;
    } catch (e) {
      log('Failed to get double for key $key: $e');
      return defaultValue;
    }
  }

  // ==================== BOOLEAN OPERATIONS ====================

  /// Save boolean value
  Future<bool> setBool(String key, bool value) async {
    try {
      _ensureInitialized();
      return await _prefs!.setBool(key, value);
    } catch (e) {
      log('Failed to save bool for key $key: $e');
      return false;
    }
  }

  /// Get boolean value
  bool getBool(String key, {bool defaultValue = false}) {
    try {
      _ensureInitialized();
      return _prefs!.getBool(key) ?? defaultValue;
    } catch (e) {
      log('Failed to get bool for key $key: $e');
      return defaultValue;
    }
  }

  // ==================== LIST OPERATIONS ====================

  /// Save string list
  Future<bool> setStringList(String key, List<String> value) async {
    try {
      _ensureInitialized();
      return await _prefs!.setStringList(key, value);
    } catch (e) {
      log('Failed to save string list for key $key: $e');
      return false;
    }
  }

  /// Get string list
  List<String>? getStringList(String key, {List<String>? defaultValue}) {
    try {
      _ensureInitialized();
      return _prefs!.getStringList(key) ?? defaultValue;
    } catch (e) {
      log('Failed to get string list for key $key: $e');
      return defaultValue;
    }
  }

  // ==================== JSON OPERATIONS ====================

  /// Save object as JSON
  Future<bool> setObject(String key, Map<String, dynamic> value) async {
    try {
      final jsonString = json.encode(value);
      return await setString(key, jsonString);
    } catch (e) {
      log('Failed to save object for key $key: $e');
      return false;
    }
  }

  /// Get object from JSON
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

  /// Save list of objects as JSON
  Future<bool> setObjectList(String key, List<Map<String, dynamic>> value) async {
    try {
      final jsonString = json.encode(value);
      return await setString(key, jsonString);
    } catch (e) {
      log('Failed to save object list for key $key: $e');
      return false;
    }
  }

  /// Get list of objects from JSON
  List<Map<String, dynamic>>? getObjectList(String key) {
    try {
      final jsonString = getString(key);
      if (jsonString == null) return null;
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.cast<Map<String, dynamic>>();
    } catch (e) {
      log('Failed to get object list for key $key: $e');
      return null;
    }
  }

  // ==================== SECURE STORAGE OPERATIONS ====================

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

  /// Save secure object as JSON
  Future<bool> setSecureObject(String key, Map<String, dynamic> value) async {
    try {
      final jsonString = json.encode(value);
      return await setSecure(key, jsonString);
    } catch (e) {
      log('Failed to save secure object for key $key: $e');
      return false;
    }
  }

  /// Get secure object from JSON
  Future<Map<String, dynamic>?> getSecureObject(String key) async {
    try {
      final jsonString = await getSecure(key);
      if (jsonString == null) return null;
      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      log('Failed to get secure object for key $key: $e');
      return null;
    }
  }

  // ==================== UTILITY OPERATIONS ====================

  /// Check if key exists
  bool hasKey(String key) {
    try {
      _ensureInitialized();
      return _prefs!.containsKey(key);
    } catch (e) {
      log('Failed to check key existence for $key: $e');
      return false;
    }
  }

  /// Check if secure key exists
  Future<bool> hasSecureKey(String key) async {
    try {
      final value = await _secureStorage.read(key: key);
      return value != null;
    } catch (e) {
      log('Failed to check secure key existence for $key: $e');
      return false;
    }
  }

  /// Remove key
  Future<bool> remove(String key) async {
    try {
      _ensureInitialized();
      return await _prefs!.remove(key);
    } catch (e) {
      log('Failed to remove key $key: $e');
      return false;
    }
  }

  /// Get all keys
  Set<String> getAllKeys() {
    try {
      _ensureInitialized();
      return _prefs!.getKeys();
    } catch (e) {
      log('Failed to get all keys: $e');
      return <String>{};
    }
  }

  /// Get all secure keys
  Future<Set<String>> getAllSecureKeys() async {
    try {
      final Map<String, String> allSecureData = await _secureStorage.readAll();
      return allSecureData.keys.toSet();
    } catch (e) {
      log('Failed to get all secure keys: $e');
      return <String>{};
    }
  }

  /// Clear all data
  Future<bool> clear() async {
    try {
      _ensureInitialized();
      return await _prefs!.clear();
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

  /// Clear all data (both regular and secure)
  Future<bool> clearAll() async {
    try {
      final results = await Future.wait([
        clear(),
        clearSecure(),
      ]);
      return results.every((result) => result == true);
    } catch (e) {
      log('Failed to clear all storage: $e');
      return false;
    }
  }

  // ==================== APP-SPECIFIC STORAGE METHODS ====================

  /// Authentication token operations
  Future<bool> setAccessToken(String token) async {
    return await setSecure(StorageKeys.accessToken, token);
  }

  Future<String?> getAccessToken() async {
    return await getSecure(StorageKeys.accessToken);
  }

  Future<bool> setRefreshToken(String token) async {
    return await setSecure(StorageKeys.refreshToken, token);
  }

  Future<String?> getRefreshToken() async {
    return await getSecure(StorageKeys.refreshToken);
  }

  Future<bool> clearTokens() async {
    final results = await Future.wait([
      removeSecure(StorageKeys.accessToken),
      removeSecure(StorageKeys.refreshToken),
      setBool(StorageKeys.isLoggedIn, false),
    ]);
    return results.every((result) => result == true);
  }

  /// User session operations
  Future<bool> setLoggedIn(bool isLoggedIn) async {
    return await setBool(StorageKeys.isLoggedIn, isLoggedIn);
  }

  bool isLoggedIn() {
    return getBool(StorageKeys.isLoggedIn, defaultValue: false);
  }

  Future<bool> setUserId(String userId) async {
    return await setString(StorageKeys.userId, userId);
  }

  String? getUserId() {
    return getString(StorageKeys.userId);
  }

  Future<bool> setUserEmail(String email) async {
    return await setString(StorageKeys.userEmail, email);
  }

  String? getUserEmail() {
    return getString(StorageKeys.userEmail);
  }

  /// User preferences operations
  Future<bool> setDarkMode(bool isDarkMode) async {
    return await setBool(StorageKeys.isDarkMode, isDarkMode);
  }

  bool isDarkMode() {
    return getBool(StorageKeys.isDarkMode, defaultValue: false);
  }

  Future<bool> setLanguage(String language) async {
    return await setString(StorageKeys.selectedLanguage, language);
  }

  String getLanguage() {
    return getString(StorageKeys.selectedLanguage, defaultValue: 'en') ?? 'en';
  }

  Future<bool> setNotificationsEnabled(bool enabled) async {
    return await setBool(StorageKeys.notificationsEnabled, enabled);
  }

  bool isNotificationsEnabled() {
    return getBool(StorageKeys.notificationsEnabled, defaultValue: true);
  }

  /// App state operations
  Future<bool> setFirstLaunch(bool isFirstLaunch) async {
    return await setBool(StorageKeys.isFirstLaunch, isFirstLaunch);
  }

  bool isFirstLaunch() {
    return getBool(StorageKeys.isFirstLaunch, defaultValue: true);
  }

  Future<bool> setOnboardingCompleted(bool completed) async {
    return await setBool(StorageKeys.onboardingCompleted, completed);
  }

  bool isOnboardingCompleted() {
    return getBool(StorageKeys.onboardingCompleted, defaultValue: false);
  }

  /// Security operations
  Future<bool> setBiometricEnabled(bool enabled) async {
    return await setBool(StorageKeys.biometricEnabled, enabled);
  }

  bool isBiometricEnabled() {
    return getBool(StorageKeys.biometricEnabled, defaultValue: false);
  }

  Future<bool> setPinCode(String pin) async {
    return await setSecure(StorageKeys.pinCode, pin);
  }

  Future<String?> getPinCode() async {
    return await getSecure(StorageKeys.pinCode);
  }

  Future<bool> setPinEnabled(bool enabled) async {
    return await setBool(StorageKeys.pinEnabled, enabled);
  }

  bool isPinEnabled() {
    return getBool(StorageKeys.pinEnabled, defaultValue: false);
  }

  /// Device operations
  Future<bool> setDeviceId(String deviceId) async {
    return await setString(StorageKeys.deviceId, deviceId);
  }

  String? getDeviceId() {
    return getString(StorageKeys.deviceId);
  }

  Future<bool> setFCMToken(String token) async {
    return await setString(StorageKeys.fcmToken, token);
  }

  String? getFCMToken() {
    return getString(StorageKeys.fcmToken);
  }

  /// Cache operations with expiration
  Future<bool> setCacheWithExpiry(String key, Map<String, dynamic> data, {Duration? expiry}) async {
    try {
      final expiryTime = DateTime.now().add(expiry ?? const Duration(hours: 24));
      final cacheData = {
        'data': data,
        'expiry': expiryTime.millisecondsSinceEpoch,
      };
      return await setObject(key, cacheData);
    } catch (e) {
      log('Failed to set cache with expiry for key $key: $e');
      return false;
    }
  }

  Map<String, dynamic>? getCacheWithExpiry(String key) {
    try {
      final cacheData = getObject(key);
      if (cacheData == null) return null;

      final expiryTime = DateTime.fromMillisecondsSinceEpoch(cacheData['expiry'] as int);
      if (DateTime.now().isAfter(expiryTime)) {
        // Cache expired, remove it
        remove(key);
        return null;
      }

      return cacheData['data'] as Map<String, dynamic>;
    } catch (e) {
      log('Failed to get cache with expiry for key $key: $e');
      return null;
    }
  }

  /// Bulk operations
  Future<bool> setBulk(Map<String, dynamic> data) async {
    try {
      final futures = <Future<bool>>[];

      for (final entry in data.entries) {
        final key = entry.key;
        final value = entry.value;

        if (value is String) {
          futures.add(setString(key, value));
        } else if (value is int) {
          futures.add(setInt(key, value));
        } else if (value is double) {
          futures.add(setDouble(key, value));
        } else if (value is bool) {
          futures.add(setBool(key, value));
        } else if (value is List<String>) {
          futures.add(setStringList(key, value));
        } else if (value is Map<String, dynamic>) {
          futures.add(setObject(key, value));
        }
      }

      final results = await Future.wait(futures);
      return results.every((result) => result == true);
    } catch (e) {
      log('Failed to set bulk data: $e');
      return false;
    }
  }

  /// Storage info
  Map<String, dynamic> getStorageInfo() {
    try {
      _ensureInitialized();
      final keys = getAllKeys();
      final totalKeys = keys.length;

      // Calculate approximate storage size (rough estimate)
      int approximateSize = 0;
      for (final key in keys) {
        final value = _prefs!.get(key);
        if (value is String) {
          approximateSize += value.length * 2; // UTF-16 encoding
        } else if (value is List<String>) {
          approximateSize += value.join().length * 2;
        }
      }

      return {
        'totalKeys': totalKeys,
        'approximateSizeBytes': approximateSize,
        'approximateSizeKB': (approximateSize / 1024).toStringAsFixed(2),
        'keys': keys.toList(),
      };
    } catch (e) {
      log('Failed to get storage info: $e');
      return {};
    }
  }
}