import 'dart:developer';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/storage_service.dart';
import '../translations/app_translations.dart';
import '../translations/keys.dart';

/// Controller for managing app language and localization
/// Handles language switching and locale preferences
class LanguageController extends GetxController {
  static LanguageController get instance => Get.find<LanguageController>();

  final StorageService _storageService = StorageService.instance;

  // Reactive variables
  final _currentLanguageCode = 'en'.obs;
  final _currentLocale = const Locale('en', 'US').obs;
  final _isRTL = false.obs;
  final _availableLanguages = <LanguageModel>[].obs;
  final _isChangingLanguage = false.obs;

  // Getters
  String get currentLanguageCode => _currentLanguageCode.value;

  Locale get currentLocale => _currentLocale.value;

  bool get isRTL => _isRTL.value;

  bool get isLTR => !_isRTL.value;

  List<LanguageModel> get availableLanguages => _availableLanguages;

  bool get isChangingLanguage => _isChangingLanguage.value;

  // Language info getters
  String get currentLanguageName =>
      AppTranslations.supportedLanguageNames[_currentLanguageCode.value] ??
          _currentLanguageCode.value;

  String get currentLanguageEnglishName =>
      AppTranslations.supportedLanguageNamesInEnglish[_currentLanguageCode.value] ??
          _currentLanguageCode.value;

  String get currentLanguageFlag =>
      AppTranslations.getLanguageFlag(_currentLanguageCode.value);

  String get currentLanguageDisplayName =>
      AppTranslations.getLanguageDisplayName(_currentLanguageCode.value);

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeLanguages();
    await _loadLanguagePreferences();
    log('LanguageController initialized');
  }

  /// Initialize available languages
  Future<void> _initializeLanguages() async {
    try {
      _availableLanguages.value = AppTranslations.getAllLanguages();
      log('Available languages loaded: ${_availableLanguages.length}');
    } catch (e) {
      log('Failed to initialize languages: $e');
    }
  }

  /// Load language preferences from storage
  Future<void> _loadLanguagePreferences() async {
    try {
      // Get saved language or device language
      String savedLanguage = _storageService.getLanguage();

      // If no saved language, try to use device language
      if (savedLanguage.isEmpty || savedLanguage == 'en') {
        final deviceLocale = _getDeviceLocale();
        if (AppTranslations.isLanguageSupported(deviceLocale.languageCode)) {
          savedLanguage = deviceLocale.languageCode;
        }
      }

      // Validate and set language
      if (AppTranslations.isLanguageSupported(savedLanguage)) {
        await _setLanguageInternal(savedLanguage, saveToStorage: false);
      } else {
        await _setLanguageInternal('en', saveToStorage: true);
      }

      log('Language preferences loaded: $savedLanguage');
    } catch (e) {
      log('Failed to load language preferences: $e');
      await _setLanguageInternal('en', saveToStorage: true);
    }
  }

  /// Get device locale
  Locale _getDeviceLocale() {
    return ui.PlatformDispatcher.instance.locale;
  }

  /// Set language internally
  Future<void> _setLanguageInternal(
      String languageCode, {
        bool saveToStorage = true,
      }) async {
    if (!AppTranslations.isLanguageSupported(languageCode)) {
      log('Unsupported language code: $languageCode');
      return;
    }

    try {
      // Update reactive variables
      _currentLanguageCode.value = languageCode;
      _currentLocale.value = AppTranslations.getLocaleFromLanguageCode(
        languageCode,
      );
      _isRTL.value = AppTranslations.isRTL(languageCode);

      // Update GetX locale
      await Get.updateLocale(_currentLocale.value);

      // Save to storage if requested
      if (saveToStorage) {
        await _storageService.setLanguage(languageCode);
      }

      log('Language set to: $languageCode (${_currentLocale.value})');
    } catch (e) {
      log('Failed to set language internally: $e');
    }
  }

  /// Change app language
  Future<void> changeLanguage(String languageCode) async {
    if (_isChangingLanguage.value) {
      log('Language change already in progress');
      return;
    }

    if (!AppTranslations.isLanguageSupported(languageCode)) {
      _showLanguageError(TranslationKeys.unknownError.tr);
      return;
    }

    if (_currentLanguageCode.value == languageCode) {
      log('Language already set to: $languageCode');
      return;
    }

    try {
      _isChangingLanguage.value = true;

      // Show loading message
      _showLanguageChanging();

      // Change language
      await _setLanguageInternal(languageCode);

      // Show success message
      _showLanguageChanged();

      log('Language changed successfully to: $languageCode');
    } catch (e) {
      log('Failed to change language: $e');
      _showLanguageError(TranslationKeys.unknownError.tr);
    } finally {
      _isChangingLanguage.value = false;
    }
  }

  /// Change language by locale
  Future<void> changeLocale(Locale locale) async {
    await changeLanguage(locale.languageCode);
  }

  /// Change language by language model
  Future<void> changeLanguageByModel(LanguageModel language) async {
    await changeLanguage(language.code);
  }

  /// Set to system language
  Future<void> setSystemLanguage() async {
    final deviceLocale = _getDeviceLocale();
    if (AppTranslations.isLanguageSupported(deviceLocale.languageCode)) {
      await changeLanguage(deviceLocale.languageCode);
    } else {
      _showLanguageError(TranslationKeys.systemLanguageNotSupported.tr);
    }
  }

  /// Get language model by code
  LanguageModel? getLanguageModelByCode(String languageCode) {
    try {
      return _availableLanguages.firstWhere(
            (lang) => lang.code == languageCode,
      );
    } catch (e) {
      return null;
    }
  }

  /// Get current language model
  LanguageModel? get currentLanguageModel =>
      getLanguageModelByCode(_currentLanguageCode.value);

  /// Check if language is current
  bool isCurrentLanguage(String languageCode) {
    return _currentLanguageCode.value == languageCode;
  }

  /// Get supported language codes
  List<String> get supportedLanguageCodes =>
      AppTranslations.supportedLanguageCodes;

  /// Get supported locales
  List<Locale> get supportedLocales => AppTranslations.supportedLocales;

  /// Show language changing message
  void _showLanguageChanging() {
    Get.showSnackbar(
      GetSnackBar(
        title: TranslationKeys.language.tr,
        message: TranslationKeys.changingLanguage.tr,
        icon: const Icon(Icons.language, color: Colors.white),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 1),
        snackPosition: SnackPosition.BOTTOM,
      ),
    );
  }

  /// Show language changed message
  void _showLanguageChanged() {
    Get.showSnackbar(
      GetSnackBar(
        title: TranslationKeys.language.tr,
        message: TranslationKeys.languageChanged.tr,
        icon: Text(currentLanguageFlag, style: const TextStyle(fontSize: 20)),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
      ),
    );
  }

  /// Show language error message
  void _showLanguageError(String message) {
    Get.showSnackbar(
      GetSnackBar(
        title: TranslationKeys.error.tr,
        message: message,
        icon: const Icon(Icons.error, color: Colors.white),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.BOTTOM,
      ),
    );
  }

  /// Show language selection dialog
  void showLanguageSelectionDialog() {
    Get.dialog(
      AlertDialog(
        title: Text(TranslationKeys.selectLanguage.tr),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _availableLanguages.map((language) {
              return ListTile(
                leading: Text(
                  language.flag,
                  style: const TextStyle(fontSize: 24),
                ),
                title: Text(language.name),
                subtitle: Text(language.englishName),
                trailing: isCurrentLanguage(language.code)
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () {
                  Get.back();
                  changeLanguageByModel(language);
                },
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(TranslationKeys.cancel.tr),
          ),
        ],
      ),
    );
  }

  /// Show language selection bottom sheet
  void showLanguageSelectionBottomSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(TranslationKeys.selectLanguage.tr, style: Get.textTheme.titleLarge),
            const SizedBox(height: 16),
            ..._availableLanguages.map((language) {
              return ListTile(
                leading: Text(
                  language.flag,
                  style: const TextStyle(fontSize: 24),
                ),
                title: Text(language.name),
                subtitle: Text(language.englishName),
                trailing: isCurrentLanguage(language.code)
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () {
                  Get.back();
                  changeLanguageByModel(language);
                },
              );
            }),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Get.back(),
                child: Text(TranslationKeys.cancel.tr),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
  }

  /// Get language statistics
  Map<String, dynamic> get languageStats => {
    'currentLanguageCode': _currentLanguageCode.value,
    'currentLanguageName': currentLanguageName,
    'currentLocale': _currentLocale.value.toString(),
    'isRTL': _isRTL.value,
    'availableLanguagesCount': _availableLanguages.length,
    'supportedLanguageCodes': supportedLanguageCodes,
    'deviceLocale': _getDeviceLocale().toString(),
    'isChangingLanguage': _isChangingLanguage.value,
  };

  /// Validate language code
  bool isValidLanguageCode(String languageCode) {
    return AppTranslations.isLanguageSupported(languageCode);
  }

  /// Get text direction for current language
  TextDirection get textDirection =>
      AppTranslations.getLanguageDirection(_currentLanguageCode.value);

  /// Get all language codes with names
  Map<String, String> get languageCodeToName {
    final Map<String, String> result = {};
    for (final language in _availableLanguages) {
      result[language.code] = language.name;
    }
    return result;
  }

  /// Get all language codes with english names
  Map<String, String> get languageCodeToEnglishName {
    final Map<String, String> result = {};
    for (final language in _availableLanguages) {
      result[language.code] = language.englishName;
    }
    return result;
  }

  /// Reset language to system default
  Future<void> resetToSystemLanguage() async {
    try {
      final deviceLocale = _getDeviceLocale();
      if (AppTranslations.isLanguageSupported(deviceLocale.languageCode)) {
        await changeLanguage(deviceLocale.languageCode);

        Get.showSnackbar(
          GetSnackBar(
            title: 'Language',
            message: 'Reset to system language',
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.BOTTOM,
          ),
        );
      } else {
        await changeLanguage('en');

        Get.showSnackbar(
          GetSnackBar(
            title: 'Language',
            message: 'Reset to default language',
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.BOTTOM,
          ),
        );
      }
    } catch (e) {
      log('Failed to reset language: $e');
      _showLanguageError('Failed to reset language');
    }
  }

  /// Refresh language settings
  Future<void> refreshLanguageSettings() async {
    await _initializeLanguages();
    await _loadLanguagePreferences();
  }

  /// Get language preference summary
  String get languagePreferenceSummary {
    return '$currentLanguageFlag $currentLanguageName ($currentLanguageCode)';
  }

  /// Check if device supports current language
  bool get isDeviceLanguageSupported {
    final deviceLocale = _getDeviceLocale();
    return AppTranslations.isLanguageSupported(deviceLocale.languageCode);
  }

  /// Get device language code
  String get deviceLanguageCode => _getDeviceLocale().languageCode;

  /// Get device language name
  String get deviceLanguageName {
    final deviceCode = deviceLanguageCode;
    return AppTranslations.supportedLanguageNames[deviceCode] ?? deviceCode;
  }
}