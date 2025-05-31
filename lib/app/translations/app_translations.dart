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
  static const Locale fallbackLocale = Locale('en', 'US');

  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      // Common translations
      ...commonEn,
      // Auth translations
      ...loginEn,
      ...registerEn,
      ...forgotPasswordEn,
      ...resetPasswordEn,
      ...verifyEmailEn,
    },
    'ru_RU': {
      // Common translations
      ...commonRu,
      // Auth translations
      ...loginRu,
      ...registerRu,
      ...forgotPasswordRu,
      ...resetPasswordRu,
      ...verifyEmailRu,
    },
    'uz_UZ': {
      // Common translations
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

// Common translations that are used throughout the app
const Map<String, String> commonEn = {
  // Navigation
  'home': 'Home',
  'profile': 'Profile',
  'settings': 'Settings',
  'back': 'Back',
  'next': 'Next',
  'done': 'Done',
  'cancel': 'Cancel',
  'save': 'Save',
  'delete': 'Delete',
  'edit': 'Edit',
  'search': 'Search',
  'filter': 'Filter',
  'sort': 'Sort',
  'refresh': 'Refresh',
  'retry': 'Retry',
  'loading': 'Loading...',
  'error': 'Error',
  'success': 'Success',
  'warning': 'Warning',
  'info': 'Information',

  // Actions
  'ok': 'OK',
  'yes': 'Yes',
  'no': 'No',
  'confirm': 'Confirm',
  'submit': 'Submit',
  'continue': 'Continue',
  'skip': 'Skip',
  'close': 'Close',
  'open': 'Open',
  'share': 'Share',
  'copy': 'Copy',
  'paste': 'Paste',
  'select': 'Select',
  'select_all': 'Select All',
  'clear': 'Clear',
  'reset': 'Reset',

  // Time & Date
  'today': 'Today',
  'yesterday': 'Yesterday',
  'tomorrow': 'Tomorrow',
  'now': 'Now',
  'recently': 'Recently',

  // Status
  'online': 'Online',
  'offline': 'Offline',
  'connected': 'Connected',
  'disconnected': 'Disconnected',
  'available': 'Available',
  'unavailable': 'Unavailable',
  'active': 'Active',
  'inactive': 'Inactive',

  // Empty states
  'no_data': 'No data available',
  'no_results': 'No results found',
  'empty': 'Empty',
  'not_found': 'Not found',

  // Language & Settings
  'language': 'Language',
  'select_language': 'Select Language',
  'theme': 'Theme',
  'dark_mode': 'Dark Mode',
  'light_mode': 'Light Mode',
  'system_theme': 'System Theme',

  // Connectivity
  'no_internet': 'No Internet',
  'check_internet_connection': 'Please check your internet connection',
  'connection_restored': 'Connection restored',
  'connecting': 'Connecting...',
  'connection_failed': 'Connection failed',
  'please_try_again_later': 'Please try again later',
  'feature_requires_internet': 'This feature requires an internet connection',
  'waiting_for_connection': 'Waiting for connection...',

  // Validation
  'required_field': 'This field is required',
  'invalid_format': 'Invalid format',
  'too_short': 'Too short',
  'too_long': 'Too long',

  // General
  'or': 'or',
  'and': 'and',
  'with': 'with',
  'without': 'without',
  'for': 'for',
  'in': 'in',
  'on': 'on',
  'at': 'at',
  'by': 'by',
  'from': 'from',
  'to': 'to',
};

const Map<String, String> commonRu = {
  // Navigation
  'home': 'Главная',
  'profile': 'Профиль',
  'settings': 'Настройки',
  'back': 'Назад',
  'next': 'Далее',
  'done': 'Готово',
  'cancel': 'Отмена',
  'save': 'Сохранить',
  'delete': 'Удалить',
  'edit': 'Редактировать',
  'search': 'Поиск',
  'filter': 'Фильтр',
  'sort': 'Сортировка',
  'refresh': 'Обновить',
  'retry': 'Повторить',
  'loading': 'Загрузка...',
  'error': 'Ошибка',
  'success': 'Успешно',
  'warning': 'Предупреждение',
  'info': 'Информация',

  // Actions
  'ok': 'ОК',
  'yes': 'Да',
  'no': 'Нет',
  'confirm': 'Подтвердить',
  'submit': 'Отправить',
  'continue': 'Продолжить',
  'skip': 'Пропустить',
  'close': 'Закрыть',
  'open': 'Открыть',
  'share': 'Поделиться',
  'copy': 'Копировать',
  'paste': 'Вставить',
  'select': 'Выбрать',
  'select_all': 'Выбрать всё',
  'clear': 'Очистить',
  'reset': 'Сбросить',

  // Time & Date
  'today': 'Сегодня',
  'yesterday': 'Вчера',
  'tomorrow': 'Завтра',
  'now': 'Сейчас',
  'recently': 'Недавно',

  // Status
  'online': 'В сети',
  'offline': 'Не в сети',
  'connected': 'Подключено',
  'disconnected': 'Отключено',
  'available': 'Доступно',
  'unavailable': 'Недоступно',
  'active': 'Активный',
  'inactive': 'Неактивный',

  // Empty states
  'no_data': 'Нет данных',
  'no_results': 'Результаты не найдены',
  'empty': 'Пусто',
  'not_found': 'Не найдено',

  // Language & Settings
  'language': 'Язык',
  'select_language': 'Выберите язык',
  'theme': 'Тема',
  'dark_mode': 'Темная тема',
  'light_mode': 'Светлая тема',
  'system_theme': 'Системная тема',

  // Connectivity
  'no_internet': 'Нет интернета',
  'check_internet_connection': 'Проверьте подключение к интернету',
  'connection_restored': 'Соединение восстановлено',
  'connecting': 'Подключение...',
  'connection_failed': 'Ошибка подключения',
  'please_try_again_later': 'Попробуйте позже',
  'feature_requires_internet': 'Эта функция требует подключения к интернету',
  'waiting_for_connection': 'Ожидание соединения...',

  // Validation
  'required_field': 'Обязательное поле',
  'invalid_format': 'Неверный формат',
  'too_short': 'Слишком короткий',
  'too_long': 'Слишком длинный',

  // General
  'or': 'или',
  'and': 'и',
  'with': 'с',
  'without': 'без',
  'for': 'для',
  'in': 'в',
  'on': 'на',
  'at': 'в',
  'by': 'от',
  'from': 'из',
  'to': 'в',
};

const Map<String, String> commonUz = {
  // Navigation
  'home': 'Bosh sahifa',
  'profile': 'Profil',
  'settings': 'Sozlamalar',
  'back': 'Orqaga',
  'next': 'Keyingi',
  'done': 'Tayyor',
  'cancel': 'Bekor qilish',
  'save': 'Saqlash',
  'delete': 'O\'chirish',
  'edit': 'Tahrirlash',
  'search': 'Qidirish',
  'filter': 'Filter',
  'sort': 'Saralash',
  'refresh': 'Yangilash',
  'retry': 'Qayta urinish',
  'loading': 'Yuklanmoqda...',
  'error': 'Xatolik',
  'success': 'Muvaffaqiyatli',
  'warning': 'Ogohlantirish',
  'info': 'Ma\'lumot',

  // Actions
  'ok': 'OK',
  'yes': 'Ha',
  'no': 'Yo\'q',
  'confirm': 'Tasdiqlash',
  'submit': 'Yuborish',
  'continue': 'Davom etish',
  'skip': 'O\'tkazib yuborish',
  'close': 'Yopish',
  'open': 'Ochish',
  'share': 'Ulashish',
  'copy': 'Nusxalash',
  'paste': 'Qo\'yish',
  'select': 'Tanlash',
  'select_all': 'Hammasini tanlash',
  'clear': 'Tozalash',
  'reset': 'Qayta o\'rnatish',

  // Time & Date
  'today': 'Bugun',
  'yesterday': 'Kecha',
  'tomorrow': 'Ertaga',
  'now': 'Hozir',
  'recently': 'Yaqinda',

  // Status
  'online': 'Onlayn',
  'offline': 'Oflayn',
  'connected': 'Ulangan',
  'disconnected': 'Uzilgan',
  'available': 'Mavjud',
  'unavailable': 'Mavjud emas',
  'active': 'Faol',
  'inactive': 'Nofaol',

  // Empty states
  'no_data': 'Ma\'lumot yo\'q',
  'no_results': 'Natija topilmadi',
  'empty': 'Bo\'sh',
  'not_found': 'Topilmadi',

  // Language & Settings
  'language': 'Til',
  'select_language': 'Tilni tanlang',
  'theme': 'Mavzu',
  'dark_mode': 'Qorong\'u rejim',
  'light_mode': 'Yorug\' rejim',
  'system_theme': 'Tizim mavzusi',

  // Connectivity
  'no_internet': 'Internet yo\'q',
  'check_internet_connection': 'Internet ulanishini tekshiring',
  'connection_restored': 'Ulanish tiklandi',
  'connecting': 'Ulanmoqda...',
  'connection_failed': 'Ulanish xatoligi',
  'please_try_again_later': 'Keyinroq qayta urinib ko\'ring',
  'feature_requires_internet': 'Bu xususiyat internet talab qiladi',
  'waiting_for_connection': 'Ulanishni kutmoqda...',

  // Validation
  'required_field': 'Majburiy maydon',
  'invalid_format': 'Noto\'g\'ri format',
  'too_short': 'Juda qisqa',
  'too_long': 'Juda uzun',

  // General
  'or': 'yoki',
  'and': 'va',
  'with': 'bilan',
  'without': 'siz',
  'for': 'uchun',
  'in': 'ichida',
  'on': 'ustida',
  'at': 'da',
  'by': 'tomonidan',
  'from': 'dan',
  'to': 'ga',
};

// Extension for easy translation access
extension StringTranslation on String {
  String get tr => Get.find<AppTranslations>().keys[Get.locale.toString()]?[this] ?? this;
}