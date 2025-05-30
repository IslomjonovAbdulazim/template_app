import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../services/storage_service.dart';
import '../../utils/app_theme.dart';

/// Controller for managing app theme and appearance settings
/// Handles dark/light mode switching and theme preferences
class ThemeController extends GetxController {
  static ThemeController get instance => Get.find<ThemeController>();

  final StorageService _storageService = StorageService.instance;

  // Theme modes
  static const String lightMode = 'light';
  static const String darkMode = 'dark';
  static const String systemMode = 'system';

  // Reactive variables
  final _currentThemeMode = systemMode.obs;
  final _isDarkMode = false.obs;
  final _isSystemDarkMode = false.obs;
  final _fontSize = 'medium'.obs;
  final _isHighContrast = false.obs;

  // Getters
  String get currentThemeMode => _currentThemeMode.value;
  bool get isDarkMode => _isDarkMode.value;
  bool get isLightMode => !_isDarkMode.value;
  bool get isSystemMode => _currentThemeMode.value == systemMode;
  bool get isSystemDarkMode => _isSystemDarkMode.value;
  String get fontSize => _fontSize.value;
  bool get isHighContrast => _isHighContrast.value;

  // Theme data getters
  ThemeData get lightTheme => AppTheme.lightTheme;
  ThemeData get darkTheme => AppTheme.darkTheme;
  ThemeData get currentTheme => _isDarkMode.value ? darkTheme : lightTheme;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _loadThemePreferences();
    _listenToSystemTheme();
    log('ThemeController initialized');
  }

  /// Load theme preferences from storage
  Future<void> _loadThemePreferences() async {
    try {
      // Load theme mode
      final savedThemeMode = _storageService.getString('theme_mode', defaultValue: systemMode);
      _currentThemeMode.value = savedThemeMode ?? systemMode;

      // Load font size
      final savedFontSize = _storageService.getString('font_size', defaultValue: 'medium');
      _fontSize.value = savedFontSize ?? 'medium';

      // Load high contrast
      final savedHighContrast = _storageService.getBool('high_contrast', defaultValue: false);
      _isHighContrast.value = savedHighContrast;

      // Initialize dark mode based on theme mode
      _updateDarkModeStatus();

      log('Theme preferences loaded: ${_currentThemeMode.value}');
    } catch (e) {
      log('Failed to load theme preferences: $e');
    }
  }

  /// Listen to system theme changes
  void _listenToSystemTheme() {
    // Get initial system theme
    _isSystemDarkMode.value = _getSystemBrightness() == Brightness.dark;

    // Listen to system theme changes
    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged = () {
      _isSystemDarkMode.value = _getSystemBrightness() == Brightness.dark;
      if (_currentThemeMode.value == systemMode) {
        _updateDarkModeStatus();
        _updateSystemUI();
      }
    };
  }

  /// Get system brightness
  Brightness _getSystemBrightness() {
    return WidgetsBinding.instance.platformDispatcher.platformBrightness;
  }

  /// Update dark mode status based on current theme mode
  void _updateDarkModeStatus() {
    switch (_currentThemeMode.value) {
      case lightMode:
        _isDarkMode.value = false;
        break;
      case darkMode:
        _isDarkMode.value = true;
        break;
      case systemMode:
      default:
        _isDarkMode.value = _isSystemDarkMode.value;
        break;
    }
    _updateSystemUI();
  }

  /// Update system UI overlay style
  void _updateSystemUI() {
    final isDark = _isDarkMode.value;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: isDark ? const Color(0xFF1F2937) : Colors.white,
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
      _currentThemeMode.value = mode;
      _updateDarkModeStatus();

      // Save to storage
      await _storageService.setString('theme_mode', mode);

      // Update GetX theme
      Get.changeThemeMode(_getThemeMode());

      log('Theme mode changed to: $mode');

      // Show feedback
      _showThemeChangeMessage();
    } catch (e) {
      log('Failed to set theme mode: $e');
    }
  }

  /// Toggle between light and dark mode
  Future<void> toggleTheme() async {
    final newMode = _isDarkMode.value ? lightMode : darkMode;
    await setThemeMode(newMode);
  }

  /// Set light theme
  Future<void> setLightTheme() async {
    await setThemeMode(lightMode);
  }

  /// Set dark theme
  Future<void> setDarkTheme() async {
    await setThemeMode(darkMode);
  }

  /// Set system theme
  Future<void> setSystemTheme() async {
    await setThemeMode(systemMode);
  }

  /// Set font size
  Future<void> setFontSize(String size) async {
    if (!_isValidFontSize(size)) {
      log('Invalid font size: $size');
      return;
    }

    try {
      _fontSize.value = size;

      // Save to storage
      await _storageService.setString('font_size', size);

      log('Font size changed to: $size');

      // Update theme with new font size
      _updateThemeWithFontSize();
    } catch (e) {
      log('Failed to set font size: $e');
    }
  }

  /// Toggle high contrast
  Future<void> toggleHighContrast() async {
    try {
      _isHighContrast.value = !_isHighContrast.value;

      // Save to storage
      await _storageService.setBool('high_contrast', _isHighContrast.value);

      log('High contrast ${_isHighContrast.value ? 'enabled' : 'disabled'}');

      // Show feedback
      Get.showSnackbar(GetSnackBar(
        title: 'high_contrast'.tr,
        message: _isHighContrast.value ? 'enabled'.tr : 'disabled'.tr,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
      ));
    } catch (e) {
      log('Failed to toggle high contrast: $e');
    }
  }

  /// Update theme with font size changes
  void _updateThemeWithFontSize() {
    // Force theme rebuild with new font size
    Get.forceAppUpdate();
  }

  /// Get GetX ThemeMode from string
  ThemeMode _getThemeMode() {
    switch (_currentThemeMode.value) {
      case lightMode:
        return ThemeMode.light;
      case darkMode:
        return ThemeMode.dark;
      case systemMode:
      default:
        return ThemeMode.system;
    }
  }

  /// Validate theme mode
  bool _isValidThemeMode(String mode) {
    return [lightMode, darkMode, systemMode].contains(mode);
  }

  /// Validate font size
  bool _isValidFontSize(String size) {
    return ['small', 'medium', 'large'].contains(size);
  }

  /// Show theme change message
  void _showThemeChangeMessage() {
    String message;
    IconData icon;

    switch (_currentThemeMode.value) {
      case lightMode:
        message = 'light_mode_enabled'.tr;
        icon = Icons.light_mode;
        break;
      case darkMode:
        message = 'dark_mode_enabled'.tr;
        icon = Icons.dark_mode;
        break;
      case systemMode:
      default:
        message = 'system_theme_enabled'.tr;
        icon = Icons.auto_mode;
        break;
    }

    Get.showSnackbar(GetSnackBar(
      title: 'theme'.tr,
      message: message,
      icon: Icon(icon, color: Colors.white),
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
    ));
  }

  /// Get theme mode display name
  String getThemeModeDisplayName(String mode) {
    switch (mode) {
      case lightMode:
        return 'light_mode'.tr;
      case darkMode:
        return 'dark_mode'.tr;
      case systemMode:
      default:
        return 'system_mode'.tr;
    }
  }

  /// Get font size display name
  String getFontSizeDisplayName(String size) {
    switch (size) {
      case 'small':
        return 'small'.tr;
      case 'medium':
        return 'medium'.tr;
      case 'large':
        return 'large'.tr;
      default:
        return size;
    }
  }

  /// Get theme mode icon
  IconData getThemeModeIcon(String mode) {
    switch (mode) {
      case lightMode:
        return Icons.light_mode;
      case darkMode:
        return Icons.dark_mode;
      case systemMode:
      default:
        return Icons.auto_mode;
    }
  }

  /// Get font size scale factor
  double getFontSizeScale() {
    switch (_fontSize.value) {
      case 'small':
        return 0.9;
      case 'large':
        return 1.1;
      case 'medium':
      default:
        return 1.0;
    }
  }

  /// Get all available theme modes
  List<String> get availableThemeModes => [lightMode, darkMode, systemMode];

  /// Get all available font sizes
  List<String> get availableFontSizes => ['small', 'medium', 'large'];

  /// Check if current theme is custom
  bool get isCustomTheme => false; // For future custom theme support

  /// Get theme info for debugging
  Map<String, dynamic> get themeInfo => {
    'currentThemeMode': _currentThemeMode.value,
    'isDarkMode': _isDarkMode.value,
    'isSystemDarkMode': _isSystemDarkMode.value,
    'fontSize': _fontSize.value,
    'fontSizeScale': getFontSizeScale(),
    'isHighContrast': _isHighContrast.value,
    'systemBrightness': _getSystemBrightness().toString(),
  };

  /// Reset theme to defaults
  Future<void> resetToDefaults() async {
    try {
      await setThemeMode(systemMode);
      await setFontSize('medium');
      _isHighContrast.value = false;
      await _storageService.setBool('high_contrast', false);

      Get.showSnackbar(GetSnackBar(
        title: 'theme'.tr,
        message: 'reset_to_defaults'.tr,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
      ));

      log('Theme reset to defaults');
    } catch (e) {
      log('Failed to reset theme: $e');
    }
  }

  /// Apply theme immediately
  void applyTheme() {
    Get.changeTheme(currentTheme);
    _updateSystemUI();
  }

  /// Preview theme (temporary change)
  void previewTheme(String mode) {
    if (!_isValidThemeMode(mode)) return;

    // Temporarily change theme without saving
    final tempDarkMode = mode == darkMode || (mode == systemMode && _isSystemDarkMode.value);

    Get.changeTheme(tempDarkMode ? darkTheme : lightTheme);
  }

  /// Cancel theme preview and restore current theme
  void cancelThemePreview() {
    applyTheme();
  }

  /// Get contrast ratio for accessibility
  double getContrastRatio(Color foreground, Color background) {
    final fgLuminance = foreground.computeLuminance();
    final bgLuminance = background.computeLuminance();

    final lighter = fgLuminance > bgLuminance ? fgLuminance : bgLuminance;
    final darker = fgLuminance > bgLuminance ? bgLuminance : fgLuminance;

    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Check if colors meet WCAG AA contrast requirements
  bool meetsContrastRequirements(Color foreground, Color background) {
    return getContrastRatio(foreground, background) >= 4.5;
  }

  /// Get adaptive color based on current theme
  Color getAdaptiveColor(Color lightColor, Color darkColor) {
    return _isDarkMode.value ? darkColor : lightColor;
  }

  /// Schedule theme change (for smooth transitions)
  Future<void> scheduleThemeChange(String mode, {Duration delay = const Duration(milliseconds: 300)}) async {
    await Future.delayed(delay);
    await setThemeMode(mode);
  }
}