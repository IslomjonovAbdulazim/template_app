import 'dart:math' show pow;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

/// String extensions for common operations
extension StringExtensions on String {
  /// Check if string is empty or null
  bool get isEmptyOrNull => isEmpty;

  /// Check if string is not empty and not null
  bool get isNotEmptyAndNotNull => isNotEmpty;

  /// Capitalize first letter
  String get capitalizeFirstLetter => isEmpty ? this : '${this[0].toUpperCase()}${substring(1).toLowerCase()}';

  /// Capitalize each word
  String get capitalizeWords => split(' ').map((word) => word.capitalizeFirstLetter).join(' ');

  /// Remove extra whitespaces
  String get removeExtraSpaces => replaceAll(RegExp(r'\s+'), ' ').trim();

  /// Check if string is a valid email
  bool get isValidEmail => RegExp(AppConstants.emailRegex).hasMatch(this);

  /// Check if string is a valid phone number
  bool get isValidPhone {
    final cleaned = replaceAll(RegExp(r'[\s-]'), '');
    return RegExp(AppConstants.phoneRegex).hasMatch(cleaned);
  }

  /// Check if string is numeric
  bool get isNumeric => RegExp(r'^[0-9]+$').hasMatch(this);

  /// Check if string is alphabetic
  bool get isAlphabetic => RegExp(r'^[a-zA-Z]+$').hasMatch(this);

  /// Check if string is alphanumeric
  bool get isAlphanumeric => RegExp(r'^[a-zA-Z0-9]+$').hasMatch(this);

  /// Convert string to int safely
  int? get toIntOrNull => int.tryParse(this);

  /// Convert string to double safely
  double? get toDoubleOrNull => double.tryParse(this);

  /// Convert string to DateTime safely
  DateTime? get toDateTimeOrNull => DateTime.tryParse(this);

  /// Reverse string
  String get reverse => split('').reversed.join('');

  /// Check if string contains only digits
  bool get isDigitsOnly => RegExp(r'^\d+$').hasMatch(this);

  /// Remove all non-digits from string
  String get digitsOnly => replaceAll(RegExp(r'[^0-9]'), '');

  /// Remove all non-alphabetic characters
  String get lettersOnly => replaceAll(RegExp(r'[^a-zA-Z]'), '');

  /// Remove all non-alphanumeric characters
  String get alphanumericOnly => replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');

  /// Convert to snake_case
  String get toSnakeCase => replaceAllMapped(
    RegExp(r'[A-Z]'),
        (match) => '_${match.group(0)!.toLowerCase()}',
  ).replaceFirst(RegExp(r'^_'), '');

  /// Convert to camelCase
  String get toCamelCase {
    final words = split('_').where((word) => word.isNotEmpty);
    if (words.isEmpty) return this;

    return words.first.toLowerCase() +
        words.skip(1).map((word) => word.capitalizeFirstLetter).join('');
  }

  /// Convert to PascalCase
  String get toPascalCase => split('_')
      .where((word) => word.isNotEmpty)
      .map((word) => word.capitalizeFirstLetter)
      .join('');

  /// Truncate string with ellipsis
  String truncate(int maxLength, [String ellipsis = '...']) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - ellipsis.length)}$ellipsis';
  }

  /// Count occurrences of substring
  int countOccurrences(String substring) {
    if (substring.isEmpty) return 0;
    int count = 0;
    int index = 0;
    while ((index = indexOf(substring, index)) != -1) {
      count++;
      index += substring.length;
    }
    return count;
  }

  /// Check if string is a valid URL
  bool get isValidUrl => RegExp(
    r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
  ).hasMatch(this);

  /// Mask string (useful for phone numbers, emails)
  String mask(int visibleStart, int visibleEnd, [String maskChar = '*']) {
    if (length <= visibleStart + visibleEnd) return this;

    final start = substring(0, visibleStart);
    final end = substring(length - visibleEnd);
    final masked = maskChar * (length - visibleStart - visibleEnd);

    return '$start$masked$end';
  }

  /// Format as phone number (assumes 10-digit number)
  String get formatAsPhone {
    final digits = digitsOnly;
    if (digits.length == 10) {
      return '(${digits.substring(0, 3)}) ${digits.substring(3, 6)}-${digits.substring(6)}';
    }
    return this;
  }

  /// Format as currency
  String formatAsCurrency([String symbol = '\$', int decimalPlaces = 2]) {
    final number = toDoubleOrNull ?? 0.0;
    return '$symbol${number.toStringAsFixed(decimalPlaces)}';
  }
}

/// Nullable String extensions
extension NullableStringExtensions on String? {
  /// Check if string is null or empty
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Check if string is not null and not empty
  bool get isNotNullAndNotEmpty => this != null && this!.isNotEmpty;

  /// Get string or default value
  String orEmpty() => this ?? '';

  /// Get string or custom default
  String orDefault(String defaultValue) => this ?? defaultValue;
}

/// DateTime extensions
extension DateTimeExtensions on DateTime {
  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }

  /// Check if date is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year && month == tomorrow.month && day == tomorrow.day;
  }

  /// Check if date is in current week
  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  /// Check if date is in current month
  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }

  /// Check if date is in current year
  bool get isThisYear {
    final now = DateTime.now();
    return year == now.year;
  }

  /// Format date using app's default format
  String get formatDefault => DateFormat(AppConstants.dateFormat).format(this);

  /// Format time using app's default format
  String get formatTime => DateFormat(AppConstants.timeFormat).format(this);

  /// Format date and time using app's default format
  String get formatDateTime => DateFormat(AppConstants.dateTimeFormat).format(this);

  /// Format for API calls
  String get formatForApi => DateFormat(AppConstants.apiDateTimeFormat).format(this);

  /// Format as relative time (e.g., "2 hours ago")
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '${years}y ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '${months}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  /// Get start of day
  DateTime get startOfDay => DateTime(year, month, day);

  /// Get end of day
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  /// Get start of week (Monday)
  DateTime get startOfWeek => subtract(Duration(days: weekday - 1));

  /// Get end of week (Sunday)
  DateTime get endOfWeek => add(Duration(days: 7 - weekday));

  /// Get start of month
  DateTime get startOfMonth => DateTime(year, month, 1);

  /// Get end of month
  DateTime get endOfMonth => DateTime(year, month + 1, 0, 23, 59, 59, 999);

  /// Add business days (excluding weekends)
  DateTime addBusinessDays(int days) {
    DateTime result = this;
    int addedDays = 0;

    while (addedDays < days) {
      result = result.add(const Duration(days: 1));
      if (result.weekday != DateTime.saturday && result.weekday != DateTime.sunday) {
        addedDays++;
      }
    }

    return result;
  }

  /// Check if date is weekend
  bool get isWeekend => weekday == DateTime.saturday || weekday == DateTime.sunday;

  /// Check if date is weekday
  bool get isWeekday => !isWeekend;
}

/// BuildContext extensions
extension BuildContextExtensions on BuildContext {
  /// Get screen size
  Size get screenSize => MediaQuery.of(this).size;

  /// Get screen width
  double get screenWidth => screenSize.width;

  /// Get screen height
  double get screenHeight => screenSize.height;

  /// Check if device is in portrait mode
  bool get isPortrait => screenHeight > screenWidth;

  /// Check if device is in landscape mode
  bool get isLandscape => screenWidth > screenHeight;

  /// Get safe area padding
  EdgeInsets get safeAreaPadding => MediaQuery.of(this).padding;

  /// Get keyboard height
  double get keyboardHeight => MediaQuery.of(this).viewInsets.bottom;

  /// Check if keyboard is visible
  bool get isKeyboardVisible => keyboardHeight > 0;

  /// Get theme data
  ThemeData get theme => Theme.of(this);

  /// Get color scheme
  ColorScheme get colorScheme => theme.colorScheme;

  /// Get text theme
  TextTheme get textTheme => theme.textTheme;

  /// Check if dark mode is enabled
  bool get isDarkMode => theme.brightness == Brightness.dark;

  /// Check if light mode is enabled
  bool get isLightMode => theme.brightness == Brightness.light;

  /// Get device pixel ratio
  double get pixelRatio => MediaQuery.of(this).devicePixelRatio;

  /// Check if device is tablet
  bool get isTablet => screenWidth >= 768;

  /// Check if device is phone
  bool get isPhone => screenWidth < 768;

  /// Show snackbar
  void showSnackBar(String message, {
    Duration? duration,
    Color? backgroundColor,
    Color? textColor,
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: textColor),
        ),
        duration: duration ?? AppConstants.snackBarDuration,
        backgroundColor: backgroundColor,
        action: action,
      ),
    );
  }

  /// Hide keyboard
  void hideKeyboard() {
    FocusScope.of(this).unfocus();
  }

  /// Request focus
  void requestFocus(FocusNode focusNode) {
    FocusScope.of(this).requestFocus(focusNode);
  }
}

/// List extensions
extension ListExtensions<T> on List<T> {
  /// Get random element
  T? get randomElement {
    if (isEmpty) return null;
    return this[(length * (DateTime.now().millisecond / 1000)).floor()];
  }

  /// Check if list is null or empty
  bool get isNullOrEmpty => isEmpty;

  /// Check if list is not null and not empty
  bool get isNotNullAndNotEmpty => isNotEmpty;

  /// Get element at index safely
  T? elementAtOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }

  /// Remove duplicates while preserving order
  List<T> get unique {
    final seen = <T>{};
    return where((element) => seen.add(element)).toList();
  }

  /// Chunk list into smaller lists
  List<List<T>> chunk(int size) {
    final chunks = <List<T>>[];
    for (int i = 0; i < length; i += size) {
      chunks.add(sublist(i, (i + size > length) ? length : i + size));
    }
    return chunks;
  }
}

/// Nullable List extensions
extension NullableListExtensions<T> on List<T>? {
  /// Check if list is null or empty
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Check if list is not null and not empty
  bool get isNotNullAndNotEmpty => this != null && this!.isNotEmpty;

  /// Get list or empty list
  List<T> orEmpty() => this ?? <T>[];
}

/// Double extensions
extension DoubleExtensions on double {
  /// Format as currency
  String toCurrency([String symbol = '\$', int decimalPlaces = 2]) {
    return '$symbol${toStringAsFixed(decimalPlaces)}';
  }

  /// Format as percentage
  String toPercentage([int decimalPlaces = 1]) {
    return '${(this * 100).toStringAsFixed(decimalPlaces)}%';
  }

  /// Round to specific decimal places
  double roundToDecimalPlaces(int decimalPlaces) {
    final factor = pow(10, decimalPlaces) as int;
    return (this * factor).round() / factor;
  }
}

/// Integer extensions
extension IntExtensions on int {
  /// Convert to duration in milliseconds
  Duration get milliseconds => Duration(milliseconds: this);

  /// Convert to duration in seconds
  Duration get seconds => Duration(seconds: this);

  /// Convert to duration in minutes
  Duration get minutes => Duration(minutes: this);

  /// Convert to duration in hours
  Duration get hours => Duration(hours: this);

  /// Convert to duration in days
  Duration get days => Duration(days: this);

  /// Check if number is even
  bool get isEven => this % 2 == 0;

  /// Check if number is odd
  bool get isOdd => this % 2 != 0;

  /// Format as file size
  String get formatAsFileSize {
    if (this < 1024) return '${this}B';
    if (this < 1024 * 1024) return '${(this / 1024).toStringAsFixed(1)}KB';
    if (this < 1024 * 1024 * 1024) return '${(this / (1024 * 1024)).toStringAsFixed(1)}MB';
    return '${(this / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
  }
}

/// Duration extensions
extension DurationExtensions on Duration {
  /// Format duration as human readable string
  String get formatHumanReadable {
    if (inDays > 0) {
      return '${inDays}d ${inHours.remainder(24)}h';
    } else if (inHours > 0) {
      return '${inHours}h ${inMinutes.remainder(60)}m';
    } else if (inMinutes > 0) {
      return '${inMinutes}m ${inSeconds.remainder(60)}s';
    } else {
      return '${inSeconds}s';
    }
  }

  /// Format as MM:SS
  String get formatMinutesSeconds {
    final minutes = inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  /// Format as HH:MM:SS
  String get formatHoursMinutesSeconds {
    final hours = inHours.toString().padLeft(2, '0');
    final minutes = inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }
}

