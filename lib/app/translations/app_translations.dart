import 'package:get/get.dart';
import 'package:flutter/material.dart';
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
        translation = translation.replaceAll('@$paramKey', paramValue);
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

  /// Get pluralized translation
  static String plural(String key, int count, {Map<String, String>? params}) {
    // Basic pluralization logic for supported languages
    String pluralKey = key;

    switch (currentLanguageCode) {
      case 'en':
        pluralKey = count == 1 ? '${key}_singular' : '${key}_plural';
        break;
      case 'ru':
      // Russian has complex pluralization rules
        if (count % 10 == 1 && count % 100 != 11) {
          pluralKey = '${key}_singular';
        } else if ([2, 3, 4].contains(count % 10) && ![12, 13, 14].contains(count % 100)) {
          pluralKey = '${key}_few';
        } else {
          pluralKey = '${key}_many';
        }
        break;
      case 'uz':
      // Uzbek doesn't have plural forms for nouns in the same way
        pluralKey = key;
        break;
    }

    // Try to get the pluralized version, fallback to original key
    String translation = pluralKey.tr;
    if (translation == pluralKey) {
      translation = key.tr;
    }

    // Replace count parameter
    final allParams = <String, String>{'count': count.toString()};
    if (params != null) allParams.addAll(params);

    allParams.forEach((paramKey, paramValue) {
      translation = translation.replaceAll('@$paramKey', paramValue);
    });

    return translation;
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

/// Translation utilities
class TranslationUtils {
  TranslationUtils._();

  /// Get localized date format
  static String getDateFormat(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'MM/dd/yyyy';
      case 'ru':
        return 'dd.MM.yyyy';
      case 'uz':
        return 'dd.MM.yyyy';
      default:
        return 'dd/MM/yyyy';
    }
  }

  /// Get localized time format
  static String getTimeFormat(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'h:mm a'; // 12-hour format
      case 'ru':
      case 'uz':
        return 'HH:mm'; // 24-hour format
      default:
        return 'HH:mm';
    }
  }

  /// Get localized number format
  static String formatNumber(double number, String languageCode) {
    switch (languageCode) {
      case 'en':
        return number.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
              (Match m) => '${m[1]},',
        );
      case 'ru':
      case 'uz':
        return number.toStringAsFixed(2).replaceAll('.', ',').replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
              (Match m) => '${m[1]} ',
        );
      default:
        return number.toString();
    }
  }

  /// Get localized currency format
  static String formatCurrency(double amount, String languageCode) {
    switch (languageCode) {
      case 'en':
        return '\$${formatNumber(amount, languageCode)}';
      case 'ru':
        return '${formatNumber(amount, languageCode)} ₽';
      case 'uz':
        return '${formatNumber(amount, languageCode)} so\'m';
      default:
        return formatNumber(amount, languageCode);
    }
  }
}

/// Extension methods for easy translation access
extension StringTranslation on String {
  /// Get translation for this string
  String get t => AppTranslations.translate(this);

  /// Get translation with parameters
  String tParams(Map<String, String> params) => AppTranslations.translate(this, params: params);

  /// Get pluralized translation
  String tPlural(int count, {Map<String, String>? params}) => AppTranslations.plural(this, count, params: params);
}

