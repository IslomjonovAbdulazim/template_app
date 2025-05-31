import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/storage_service.dart';
import '../translations/app_translations.dart';

/// Simple language controller for managing app languages
class LanguageController extends GetxController {
  static LanguageController get instance => Get.find<LanguageController>();

  final StorageService _storageService = StorageService.instance;

  // Reactive variables
  final _currentLanguageCode = 'en'.obs;
  final _isChangingLanguage = false.obs;

  // Getters
  String get currentLanguageCode => _currentLanguageCode.value;
  bool get isChangingLanguage => _isChangingLanguage.value;

  String get currentLanguageName => AppTranslations.languageNames[_currentLanguageCode.value] ?? 'English';
  String get currentLanguageFlag => AppTranslations.languageFlags[_currentLanguageCode.value] ?? '🇺🇸';

  @override
  Future<void> onInit() async {
    super.onInit();
    await _loadLanguage();
    log('LanguageController initialized');
  }

  /// Load saved language
  Future<void> _loadLanguage() async {
    try {
      String savedLanguage = _storageService.getLanguage();

      // Use device language if no saved language
      if (savedLanguage.isEmpty) {
        final deviceLocale = Get.deviceLocale;
        if (deviceLocale != null && _isLanguageSupported(deviceLocale.languageCode)) {
          savedLanguage = deviceLocale.languageCode;
        } else {
          savedLanguage = 'en'; // fallback
        }
      }

      await _setLanguage(savedLanguage, saveToStorage: false);
      log('Language loaded: $savedLanguage');
    } catch (e) {
      log('Failed to load language: $e');
      await _setLanguage('en', saveToStorage: true);
    }
  }

  /// Set language internally
  Future<void> _setLanguage(String languageCode, {bool saveToStorage = true}) async {
    if (!_isLanguageSupported(languageCode)) {
      log('Unsupported language: $languageCode');
      return;
    }

    try {
      _currentLanguageCode.value = languageCode;

      // Update GetX locale
      AppTranslations.changeLanguage(languageCode);

      // Save to storage
      if (saveToStorage) {
        await _storageService.setLanguage(languageCode);
      }

      log('Language set to: $languageCode');
    } catch (e) {
      log('Failed to set language: $e');
    }
  }

  /// Change app language
  Future<void> changeLanguage(String languageCode) async {
    if (_isChangingLanguage.value) {
      log('Language change already in progress');
      return;
    }

    if (!_isLanguageSupported(languageCode)) {
      _showError('Language not supported');
      return;
    }

    if (_currentLanguageCode.value == languageCode) {
      log('Language already set to: $languageCode');
      return;
    }

    try {
      _isChangingLanguage.value = true;
      await _setLanguage(languageCode);
      _showSuccess('Language changed successfully');
      log('Language changed to: $languageCode');
    } catch (e) {
      log('Failed to change language: $e');
      _showError('Failed to change language');
    } finally {
      _isChangingLanguage.value = false;
    }
  }

  /// Check if language is supported
  bool _isLanguageSupported(String languageCode) {
    return ['en', 'ru', 'uz'].contains(languageCode);
  }

  /// Check if language is current
  bool isCurrentLanguage(String languageCode) {
    return _currentLanguageCode.value == languageCode;
  }

  /// Get all available languages
  List<Map<String, String>> get availableLanguages => AppTranslations.getLanguageList();

  /// Show language selection dialog
  void showLanguageDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('select_language'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: availableLanguages.map((lang) {
            final code = lang['code']!;
            final name = lang['name']!;
            final flag = lang['flag']!;

            return ListTile(
              leading: Text(flag, style: const TextStyle(fontSize: 24)),
              title: Text(name),
              trailing: isCurrentLanguage(code)
                  ? const Icon(Icons.check, color: Colors.green)
                  : null,
              onTap: () {
                Get.back();
                changeLanguage(code);
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
        ],
      ),
    );
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
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
    ));
  }

  /// Get current language display text
  String get languageDisplayText => '$currentLanguageFlag $currentLanguageName';
}