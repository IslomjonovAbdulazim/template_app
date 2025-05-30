import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'keys.dart';
import 'en_us.dart';
import 'ru_ru.dart';
import 'uz_uz.dart';

/// Translation manager for the application
/// Manages all supported languages and provides translation utilities
class AppTranslations extends Translations {
  // Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'), // English (United States)
    Locale('ru', 'RU'), // Russian (Russia)
    Locale('uz', 'UZ'), // Uzbek (Uzbekistan)
  ];

  // Default locale
  static const Locale defaultLocale = Locale('en', 'US');

  // Fallback locale
  static const Locale fallbackLocale = Locale('en', 'US');

  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUS,
    'ru_RU': ruRU,
    'uz_UZ': uzUZ,
  };

  /// Get supported language codes
  static List<String> get supportedLanguageCodes {
    return supportedLocales.map((locale) => locale.languageCode).toList();
  }

  /// Get supported language names in their native language
  static Map<String, String> get supportedLanguageNames => {
    'en': 'English',
    'ru': 'Русский',
    'uz': 'O\'zbekcha',
  };

  /// Get supported language names in English
  static Map<String, String> get supportedLanguageNamesInEnglish => {
    'en': 'English',
    'ru': 'Russian',
    'uz': 'Uzbek',
  };

  /// Get locale from language code
  static Locale getLocaleFromLanguageCode(String languageCode) {
    switch (languageCode) {
      case 'en':
        return const Locale('en', 'US');
      case 'ru':
        return const Locale('ru', 'RU');
      case 'uz':
        return const Locale('uz', 'UZ');
      default:
        return defaultLocale;
    }
  }

  /// Get language code from locale
  static String getLanguageCodeFromLocale(Locale locale) {
    return locale.languageCode;
  }

  /// Check if language is supported
  static bool isLanguageSupported(String languageCode) {
    return supportedLanguageCodes.contains(languageCode);
  }

  /// Check if locale is supported
  static bool isLocaleSupported(Locale locale) {
    return supportedLocales.any((supportedLocale) =>
    supportedLocale.languageCode == locale.languageCode &&
        supportedLocale.countryCode == locale.countryCode);
  }

  /// Get device locale if supported, otherwise return default
  static Locale getDeviceLocale() {
    final deviceLocale = Get.deviceLocale;
    if (deviceLocale != null && isLocaleSupported(deviceLocale)) {
      return deviceLocale;
    }

    // Check if language code is supported even if country code doesn't match
    if (deviceLocale != null && isLanguageSupported(deviceLocale.languageCode)) {
      return getLocaleFromLanguageCode(deviceLocale.languageCode);
    }

    return defaultLocale;
  }

  /// Get language direction (LTR or RTL)
  static TextDirection getLanguageDirection(String languageCode) {
    // All currently supported languages are LTR
    switch (languageCode) {
      case 'en':
      case 'ru':
      case 'uz':
        return TextDirection.ltr;
      default:
        return TextDirection.ltr;
    }
  }

  /// Check if language is RTL
  static bool isRTL(String languageCode) {
    return getLanguageDirection(languageCode) == TextDirection.rtl;
  }

  /// Get current language code
  static String get currentLanguageCode {
    return Get.locale?.languageCode ?? defaultLocale.languageCode;
  }

  /// Get current locale
  static Locale get currentLocale {
    return Get.locale ?? defaultLocale;
  }

  /// Change language
  static Future<void> changeLanguage(String languageCode) async {
    if (!isLanguageSupported(languageCode)) {
      throw ArgumentError('Language code $languageCode is not supported');
    }

    final locale = getLocaleFromLanguageCode(languageCode);
    await Get.updateLocale(locale);
  }

  /// Change locale
  static Future<void> changeLocale(Locale locale) async {
    if (!isLocaleSupported(locale)) {
      throw ArgumentError('Locale ${locale.toString()} is not supported');
    }

    await Get.updateLocale(locale);
  }

  /// Get language flag emoji
  static String getLanguageFlag(String languageCode) {
    switch (languageCode) {
      case 'en':
        return '🇺🇸';
      case 'ru':
        return '🇷🇺';
      case 'uz':
        return '🇺🇿';
      default:
        return '🌐';
    }
  }

  /// Get formatted language display name with flag
  static String getLanguageDisplayName(String languageCode) {
    final flag = getLanguageFlag(languageCode);
    final name = supportedLanguageNames[languageCode] ?? languageCode;
    return '$flag $name';
  }

  /// Get all languages with their display names
  static List<LanguageModel> getAllLanguages() {
    return supportedLanguageCodes.map((code) {
      return LanguageModel(
        code: code,
        name: supportedLanguageNames[code] ?? code,
        englishName: supportedLanguageNamesInEnglish[code] ?? code,
        flag: getLanguageFlag(code),
        locale: getLocaleFromLanguageCode(code),
        isRTL: isRTL(code),
      );
    }).toList();
  }

  /// Get translation for key with fallback
  static String translate(String key, {Map<String, String>? params}) {
    String translation = key.tr;

    // If translation is the same as key, it means no translation was found
    if (translation == key) {
      // Try fallback locale
      final fallbackTranslation = _getTranslationFromLocale(key, fallbackLocale);
      if (fallbackTranslation != key) {
        translation = fallbackTranslation;
      }
    }

    // Replace parameters if provided
    if (params != null) {
      params.forEach((paramKey, paramValue) {
        translation = translation.replaceAll('{$paramKey}', paramValue);
      });
    }

    return translation;
  }

  /// Get translation from specific locale
  static String _getTranslationFromLocale(String key, Locale locale) {
    final localeKey = '${locale.languageCode}_${locale.countryCode}';
    final translations = AppTranslations().keys[localeKey];
    return translations?[key] ?? key;
  }

  /// Initialize translations
  static void initialize() {
    // Set up GetX translations
    Get.addTranslations(AppTranslations().keys);
  }
}

/// Language model for UI display
class LanguageModel {
  final String code;
  final String name;
  final String englishName;
  final String flag;
  final Locale locale;
  final bool isRTL;

  const LanguageModel({
    required this.code,
    required this.name,
    required this.englishName,
    required this.flag,
    required this.locale,
    required this.isRTL,
  });

  @override
  String toString() => '$flag $name';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LanguageModel && other.code == code;
  }

  @override
  int get hashCode => code.hashCode;
}

/// Translation helper class to avoid extension conflicts
class AppLocalizations {
  AppLocalizations._();

  /// Get translation for a key with parameters
  static String translate(String key, {Map<String, String>? params}) {
    return AppTranslations.translate(key, params: params);
  }

  /// Get translation using the built-in GetX .tr
  static String tr(String key) {
    return key.tr;
  }

  /// Safe translation that handles missing keys
  static String safeTranslate(String key, {String? fallback, Map<String, String>? params}) {
    final translation = key.tr;
    if (translation == key && fallback != null) {
      return fallback;
    }

    if (params != null) {
      String result = translation;
      params.forEach((paramKey, paramValue) {
        result = result.replaceAll('{$paramKey}', paramValue);
      });
      return result;
    }

    return translation;
  }

  /// Check if a translation key exists
  static bool hasTranslation(String key) {
    return key.tr != key;
  }

  /// Get all available translations for debugging
  static Map<String, Map<String, String>> getAllTranslations() {
    return AppTranslations().keys;
  }

  /// Get current language info
  static LanguageModel? getCurrentLanguage() {
    final currentCode = AppTranslations.currentLanguageCode;
    return AppTranslations.getAllLanguages()
        .where((lang) => lang.code == currentCode)
        .firstOrNull;
  }
}

/// Extension method for easier string translation
extension StringTranslationExtension on String {
  /// Get translation with parameters
  String trParams([Map<String, String>? params]) {
    if (params == null) return tr;

    String result = tr;
    params.forEach((key, value) {
      result = result.replaceAll('{$key}', value);
    });
    return result;
  }

  /// Safe translation with fallback
  String trSafe([String? fallback]) {
    final translation = tr;
    if (translation == this && fallback != null) {
      return fallback;
    }
    return translation;
  }
}

/// Validation for translation completeness
class TranslationValidator {
  TranslationValidator._();

  /// Check if all languages have the same keys
  static Map<String, List<String>> validateTranslations() {
    final translations = AppTranslations().keys;
    final allKeys = <String>{};
    final missingKeys = <String, List<String>>{};

    // Collect all keys from all languages
    translations.forEach((locale, keys) {
      allKeys.addAll(keys.keys);
    });

    // Check for missing keys in each language
    translations.forEach((locale, keys) {
      final missing = allKeys.where((key) => !keys.containsKey(key)).toList();
      if (missing.isNotEmpty) {
        missingKeys[locale] = missing;
      }
    });

    return missingKeys;
  }

  /// Get translation coverage statistics
  static Map<String, double> getTranslationCoverage() {
    final translations = AppTranslations().keys;
    final coverage = <String, double>{};

    if (translations.isEmpty) return coverage;

    final maxKeys = translations.values
        .map((keys) => keys.length)
        .reduce((a, b) => a > b ? a : b);

    translations.forEach((locale, keys) {
      coverage[locale] = keys.length / maxKeys;
    });

    return coverage;
  }

  /// Check for unused translation keys
  static List<String> findUnusedKeys(List<String> usedKeys) {
    final allTranslationKeys = AppTranslations().keys['en_US']?.keys.toList() ?? [];
    return allTranslationKeys.where((key) => !usedKeys.contains(key)).toList();
  }
}