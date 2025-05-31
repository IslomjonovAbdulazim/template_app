import 'package:get/get.dart';
import 'package:flutter/material.dart';

// Import all auth translation files
import 'auth/forgot_password_tr.dart';
import 'auth/login_tr.dart';
import 'auth/register_tr.dart';
import 'auth/reset_password_tr.dart';
import 'auth/verify_email_tr.dart';

class AppTranslations extends Translations {

  // Supported languages
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('ru', 'RU'),
    Locale('uz', 'UZ'),
  ];

  static const Locale defaultLocale = Locale('en', 'US');

  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      ...loginEn,
      ...registerEn,
      ...forgotPasswordEn,
      ...resetPasswordEn,
      ...verifyEmailEn,
    },
    'ru_RU': {
      ...loginRu,
      ...registerRu,
      ...forgotPasswordRu,
      ...resetPasswordRu,
      ...verifyEmailRu,
    },
    'uz_UZ': {
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

  // Simple helper methods
  static String getCurrentLanguage() {
    return Get.locale?.languageCode ?? 'en';
  }

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

  static List<Map<String, String>> getLanguageList() {
    return [
      {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
      {'code': 'ru', 'name': 'Русский', 'flag': '🇷🇺'},
      {'code': 'uz', 'name': 'O\'zbekcha', 'flag': '🇺🇿'},
    ];
  }
}

// Simple extension for translations
extension StringTranslation on String {
  String get tr => Get.find<AppTranslations>().keys[Get.locale.toString()]?[this] ?? this;
}