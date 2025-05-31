import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../services/storage_service.dart';

/// Simple theme controller for managing app appearance
class ThemeController extends GetxController {
  static ThemeController get instance => Get.find<ThemeController>();

  final StorageService _storageService = StorageService.instance;

  // Theme modes
  static const String light = 'light';
  static const String dark = 'dark';
  static const String system = 'system';

  // Reactive variables
  final _themeMode = system.obs;
  final _isDarkMode = false.obs;

  // Getters
  String get themeMode => _themeMode.value;
  bool get isDarkMode => _isDarkMode.value;
  bool get isLightMode => !_isDarkMode.value;
  bool get isSystemMode => _themeMode.value == system;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _loadTheme();
    _listenToSystemTheme();
    log('ThemeController initialized');
  }

  /// Load saved theme
  Future<void> _loadTheme() async {
    try {
      final savedTheme = _storageService.getString('theme_mode', defaultValue: system);
      _themeMode.value = savedTheme ?? system;
      _updateDarkMode();
      log('Theme loaded: ${_themeMode.value}');
    } catch (e) {
      log('Failed to load theme: $e');
    }
  }

  /// Listen to system theme changes
  void _listenToSystemTheme() {
    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    _updateDarkMode();

    // Listen for system theme changes
    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged = () {
      if (_themeMode.value == system) {
        _updateDarkMode();
        _updateSystemUI();
      }
    };
  }

  /// Update dark mode based on current theme setting
  void _updateDarkMode() {
    switch (_themeMode.value) {
      case light:
        _isDarkMode.value = false;
        break;
      case dark:
        _isDarkMode.value = true;
        break;
      case system:
      default:
        final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
        _isDarkMode.value = brightness == Brightness.dark;
        break;
    }
    _updateSystemUI();
  }

  /// Update system UI colors
  void _updateSystemUI() {
    final isDark = _isDarkMode.value;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: isDark ? Colors.grey[900] : Colors.white,
        systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
    );
  }

  /// Set theme mode
  Future<void> setThemeMode(String mode) async {
    if (!_isValidThemeMode(mode)) {
      log('Invalid theme mode: $mode');
      return;
    }

    try {
      _themeMode.value = mode;
      _updateDarkMode();

      // Save to storage
      await _storageService.setString('theme_mode', mode);

      // Update GetX theme
      Get.changeThemeMode(_getThemeMode());

      log('Theme changed to: $mode');
      _showThemeMessage();
    } catch (e) {
      log('Failed to set theme: $e');
    }
  }

  /// Toggle between light and dark
  Future<void> toggleTheme() async {
    final newMode = _isDarkMode.value ? light : dark;
    await setThemeMode(newMode);
  }

  /// Set to light theme
  Future<void> setLightTheme() async {
    await setThemeMode(light);
  }

  /// Set to dark theme
  Future<void> setDarkTheme() async {
    await setThemeMode(dark);
  }

  /// Set to system theme
  Future<void> setSystemTheme() async {
    await setThemeMode(system);
  }

  /// Get GetX ThemeMode
  ThemeMode _getThemeMode() {
    switch (_themeMode.value) {
      case light:
        return ThemeMode.light;
      case dark:
        return ThemeMode.dark;
      case system:
      default:
        return ThemeMode.system;
    }
  }

  /// Validate theme mode
  bool _isValidThemeMode(String mode) {
    return [light, dark, system].contains(mode);
  }

  /// Show theme change message
  void _showThemeMessage() {
    String message;
    IconData icon;

    switch (_themeMode.value) {
      case light:
        message = 'Light mode enabled';
        icon = Icons.light_mode;
        break;
      case dark:
        message = 'Dark mode enabled';
        icon = Icons.dark_mode;
        break;
      case system:
      default:
        message = 'System theme enabled';
        icon = Icons.auto_mode;
        break;
    }

    Get.showSnackbar(GetSnackBar(
      title: 'Theme',
      message: message,
      icon: Icon(icon, color: Colors.white),
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
    ));
  }

  /// Get theme display name
  String getThemeDisplayName(String mode) {
    switch (mode) {
      case light:
        return 'Light';
      case dark:
        return 'Dark';
      case system:
      default:
        return 'System';
    }
  }

  /// Get theme icon
  IconData getThemeIcon(String mode) {
    switch (mode) {
      case light:
        return Icons.light_mode;
      case dark:
        return Icons.dark_mode;
      case system:
      default:
        return Icons.auto_mode;
    }
  }

  /// Get available theme modes
  List<String> get availableThemes => [light, dark, system];

  /// Show theme selection dialog
  void showThemeDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Select Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: availableThemes.map((theme) {
            return ListTile(
              leading: Icon(getThemeIcon(theme)),
              title: Text(getThemeDisplayName(theme)),
              trailing: _themeMode.value == theme
                  ? const Icon(Icons.check, color: Colors.green)
                  : null,
              onTap: () {
                Get.back();
                setThemeMode(theme);
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  /// Get current theme display text
  String get themeDisplayText {
    final icon = getThemeIcon(_themeMode.value);
    final name = getThemeDisplayName(_themeMode.value);
    return '$name Theme';
  }
}