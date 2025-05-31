import 'package:get/get.dart';
import 'package:flutter/material.dart';

// Import all translation files
import 'auth/forgot_password_tr.dart';
import 'auth/login_tr.dart';
import 'auth/register_tr.dart';
import 'auth/reset_password_tr.dart';
import 'auth/verify_email_tr.dart';
import 'general/common_tr.dart'; // Import the separate common translations file

class AppTranslations extends Translations {
  // Supported languages
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('ru', 'RU'),
    Locale('uz', 'UZ'),
  ];

  static const Locale defaultLocale = Locale('en', 'US');
  static const Locale fallbackLocale = Locale('en', 'US');

  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      // Common translations from separate file
      ...commonEn,
      // Auth translations
      ...loginEn,
      ...registerEn,
      ...forgotPasswordEn,
      ...resetPasswordEn,
      ...verifyEmailEn,
    },
    'ru_RU': {
      // Common translations from separate file
      ...commonRu,
      // Auth translations
      ...loginRu,
      ...registerRu,
      ...forgotPasswordRu,
      ...resetPasswordRu,
      ...verifyEmailRu,
    },
    'uz_UZ': {
      // Common translations from separate file
      ...commonUz,
      // Auth translations
      ...loginUz,
      ...registerUz,
      ...forgotPasswordUz,
      ...resetPasswordUz,
      ...verifyEmailUz,
    },
  };

  // Language names
  static const Map<String, String> languageNames = {
    'en': 'English',
    'ru': 'Русский',
    'uz': 'O\'zbekcha',
  };

  // Language flags
  static const Map<String, String> languageFlags = {
    'en': '🇺🇸',
    'ru': '🇷🇺',
    'uz': '🇺🇿',
  };

  // RTL languages
  static const List<String> rtlLanguages = ['ar', 'fa', 'ur', 'he'];

  /// Initialize translations (can be called from main.dart)
  static void initialize() {
    // Any initialization logic if needed
    // For now, just log that translations are ready
    print('🌍 AppTranslations initialized');
  }

  /// Get device locale or fallback
  static Locale getDeviceLocale() {
    final deviceLocale = Get.deviceLocale;

    if (deviceLocale == null) {
      return fallbackLocale;
    }

    // Check if device locale is supported
    final isSupported = supportedLocales.any(
          (locale) => locale.languageCode == deviceLocale.languageCode,
    );

    if (isSupported) {
      // Return the full locale if we support it
      return supportedLocales.firstWhere(
            (locale) => locale.languageCode == deviceLocale.languageCode,
        orElse: () => fallbackLocale,
      );
    }

    return fallbackLocale;
  }

  /// Get text direction for a language
  static TextDirection getLanguageDirection(String languageCode) {
    return rtlLanguages.contains(languageCode)
        ? TextDirection.rtl
        : TextDirection.ltr;
  }

  /// Get current language code
  static String getCurrentLanguage() {
    return Get.locale?.languageCode ?? 'en';
  }

  /// Change app language
  static void changeLanguage(String languageCode) {
    Locale locale;
    switch (languageCode) {
      case 'ru':
        locale = const Locale('ru', 'RU');
        break;
      case 'uz':
        locale = const Locale('uz', 'UZ');
        break;
      default:
        locale = const Locale('en', 'US');
    }
    Get.updateLocale(locale);
  }

  /// Get list of available languages
  static List<Map<String, String>> getLanguageList() {
    return [
      {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
      {'code': 'ru', 'name': 'Русский', 'flag': '🇷🇺'},
      {'code': 'uz', 'name': 'O\'zbekcha', 'flag': '🇺🇿'},
    ];
  }

  /// Check if language is supported
  static bool isLanguageSupported(String languageCode) {
    return supportedLocales.any(
          (locale) => locale.languageCode == languageCode,
    );
  }

  /// Get language name by code
  static String getLanguageName(String languageCode) {
    return languageNames[languageCode] ?? 'Unknown';
  }

  /// Get language flag by code
  static String getLanguageFlag(String languageCode) {
    return languageFlags[languageCode] ?? '🏳️';
  }
}

// Extension for easy translation access
extension StringTranslation on String {
  String get tr => Get.find<AppTranslations>().keys[Get.locale.toString()]?[this] ?? this;
}