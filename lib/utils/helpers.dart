import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_constants.dart';

/// General helper functions for common operations
class Helpers {
  Helpers._();

  // Random instance for generating random values
  static final Random _random = Random();

  /// Generate random string of specified length
  static String generateRandomString(int length, {bool includeNumbers = true, bool includeSpecialChars = false}) {
    const letters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numbers = '0123456789';
    const specialChars = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

    String chars = letters;
    if (includeNumbers) chars += numbers;
    if (includeSpecialChars) chars += specialChars;

    return List.generate(length, (index) => chars[_random.nextInt(chars.length)]).join();
  }

  /// Generate random number between min and max (inclusive)
  static int generateRandomNumber(int min, int max) {
    return min + _random.nextInt(max - min + 1);
  }

  /// Generate random double between min and max
  static double generateRandomDouble(double min, double max) {
    return min + _random.nextDouble() * (max - min);
  }

  /// Generate UUID v4
  static String generateUuid() {
    final bytes = Uint8List(16);
    for (int i = 0; i < 16; i++) {
      bytes[i] = _random.nextInt(256);
    }

    // Set version (4) and variant bits
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;

    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20, 32)}';
  }

  /// Debounce function calls
  static Timer? _debounceTimer;
  static void debounce(VoidCallback callback, {Duration delay = const Duration(milliseconds: 500)}) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(delay, callback);
  }

  /// Throttle function calls
  static DateTime? _lastThrottleTime;
  static void throttle(VoidCallback callback, {Duration duration = const Duration(milliseconds: 1000)}) {
    final now = DateTime.now();
    if (_lastThrottleTime == null || now.difference(_lastThrottleTime!) >= duration) {
      _lastThrottleTime = now;
      callback();
    }
  }

  /// Format file size in human readable format
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
  }

  /// Format currency with proper locale
  static String formatCurrency(double amount, {
    String locale = 'en_US',
    String symbol = AppConstants.currencySymbol,
    int decimalDigits = AppConstants.decimalPlaces,
  }) {
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: decimalDigits,
    );
    return formatter.format(amount);
  }

  /// Format number with thousand separators
  static String formatNumber(num number, {String locale = 'en_US'}) {
    final formatter = NumberFormat('#,##0', locale);
    return formatter.format(number);
  }

  /// Format percentage
  static String formatPercentage(double value, {int decimalPlaces = 1}) {
    return '${(value * 100).toStringAsFixed(decimalPlaces)}%';
  }

  /// Calculate percentage
  static double calculatePercentage(num value, num total) {
    if (total == 0) return 0;
    return (value / total) * 100;
  }

  /// Calculate percentage change
  static double calculatePercentageChange(num oldValue, num newValue) {
    if (oldValue == 0) return newValue > 0 ? 100 : 0;
    return ((newValue - oldValue) / oldValue) * 100;
  }

  /// Round double to specific decimal places
  static double roundToDecimalPlaces(double value, int decimalPlaces) {
    final factor = pow(10, decimalPlaces);
    return (value * factor).round() / factor;
  }

  /// Check if device is online (requires connectivity check)
  static bool isOnline = true; // This should be updated by connectivity service

  /// Copy text to clipboard
  static Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  /// Get text from clipboard
  static Future<String?> getFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    return data?.text;
  }

  /// Vibrate device
  static Future<void> vibrate({Duration duration = const Duration(milliseconds: 100)}) async {
    await HapticFeedback.lightImpact();
  }

  /// Hide keyboard
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  /// Show loading dialog
  static void showLoadingDialog(BuildContext context, {String? message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Text(message ?? 'Loading...'),
          ],
        ),
      ),
    );
  }

  /// Hide loading dialog
  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  /// Show confirmation dialog
  static Future<bool> showConfirmationDialog(
      BuildContext context, {
        required String title,
        required String message,
        String confirmText = 'Confirm',
        String cancelText = 'Cancel',
      }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Launch URL
  static Future<bool> launchURL(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Launch email
  static Future<bool> launchEmail(String email, {String? subject, String? body}) async {
    final uri = Uri(
      scheme: 'mailto',
      path: email,
      query: {
        if (subject != null) 'subject': subject,
        if (body != null) 'body': body,
      }.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&'),
    );

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Launch phone call
  static Future<bool> launchPhone(String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Launch SMS
  static Future<bool> launchSMS(String phoneNumber, {String? message}) async {
    final uri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: message != null ? {'body': message} : null,
    );

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Get app documents directory
  static Future<String> getAppDocumentsDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// Get app cache directory
  static Future<String> getAppCacheDirectory() async {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }

  /// Save string to file
  static Future<bool> saveStringToFile(String content, String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName');
      await file.writeAsString(content);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Read string from file
  static Future<String?> readStringFromFile(String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName');
      if (await file.exists()) {
        return await file.readAsString();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Delete file
  static Future<bool> deleteFile(String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName');
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Check if file exists
  static Future<bool> fileExists(String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName');
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

  /// Get file size
  static Future<int> getFileSize(String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName');
      if (await file.exists()) {
        return await file.length();
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }

  /// Convert JSON string to Map
  static Map<String, dynamic>? jsonStringToMap(String jsonString) {
    try {
      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// Convert Map to JSON string
  static String? mapToJsonString(Map<String, dynamic> map) {
    try {
      return json.encode(map);
    } catch (e) {
      return null;
    }
  }

  /// Check if string is valid JSON
  static bool isValidJson(String jsonString) {
    try {
      json.decode(jsonString);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get device type
  static String getDeviceType() {
    final data = MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.single);
    final shortestSide = data.size.shortestSide;

    if (shortestSide < 600) {
      return 'phone';
    } else if (shortestSide >= 600 && shortestSide < 900) {
      return 'tablet';
    } else {
      return 'desktop';
    }
  }

  /// Check if device is tablet
  static bool isTablet() {
    return getDeviceType() == 'tablet';
  }

  /// Check if device is phone
  static bool isPhone() {
    return getDeviceType() == 'phone';
  }

  /// Check if device is desktop
  static bool isDesktop() {
    return getDeviceType() == 'desktop';
  }

  /// Get platform name
  static String getPlatformName() {
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isLinux) return 'Linux';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isFuchsia) return 'Fuchsia';
    return 'Unknown';
  }

  /// Check if running on mobile
  static bool isMobile() {
    return Platform.isAndroid || Platform.isIOS;
  }

  /// Check if running on desktop
  static bool isDesktopPlatform() {
    return Platform.isLinux || Platform.isMacOS || Platform.isWindows;
  }

  /// Generate color from string (useful for avatars)
  static Color generateColorFromString(String input) {
    int hash = 0;
    for (int i = 0; i < input.length; i++) {
      hash = input.codeUnitAt(i) + ((hash << 5) - hash);
    }

    final r = (hash & 0xFF0000) >> 16;
    final g = (hash & 0x00FF00) >> 8;
    final b = hash & 0x0000FF;

    return Color.fromRGBO(r, g, b, 1.0);
  }

  /// Get initials from name
  static String getInitials(String name) {
    final words = name.trim().split(' ');
    if (words.isEmpty) return '';

    if (words.length == 1) {
      return words[0].isNotEmpty ? words[0][0].toUpperCase() : '';
    }

    return '${words.first[0]}${words.last[0]}'.toUpperCase();
  }

  /// Calculate distance between two points (Haversine formula)
  static double calculateDistance(
      double lat1, double lon1,
      double lat2, double lon2,
      ) {
    const double earthRadius = 6371; // Earth's radius in kilometers

    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) * cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) * sin(dLon / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  /// Convert degrees to radians
  static double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  /// Format distance in human readable format
  static String formatDistance(double distanceInKm) {
    if (distanceInKm < 1) {
      return '${(distanceInKm * 1000).round()}m';
    } else if (distanceInKm < 10) {
      return '${distanceInKm.toStringAsFixed(1)}km';
    } else {
      return '${distanceInKm.round()}km';
    }
  }

  /// Validate email format
  static bool isValidEmail(String email) {
    return RegExp(AppConstants.emailRegex).hasMatch(email);
  }

  /// Validate phone format
  static bool isValidPhone(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[\s-]'), '');
    return RegExp(AppConstants.phoneRegex).hasMatch(cleaned);
  }

  /// Clean phone number (remove formatting)
  static String cleanPhoneNumber(String phone) {
    return phone.replaceAll(RegExp(r'[^\d+]'), '');
  }

  /// Format phone number
  static String formatPhoneNumber(String phone) {
    final cleaned = cleanPhoneNumber(phone);
    if (cleaned.length == 10) {
      return '(${cleaned.substring(0, 3)}) ${cleaned.substring(3, 6)}-${cleaned.substring(6)}';
    }
    return phone;
  }

  /// Generate random color
  static Color generateRandomColor() {
    return Color.fromRGBO(
      _random.nextInt(256),
      _random.nextInt(256),
      _random.nextInt(256),
      1.0,
    );
  }

  /// Check if two dates are the same day
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Get age from date of birth
  static int calculateAge(DateTime dateOfBirth) {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;

    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }

    return age;
  }

  /// Delayed execution
  static Future<void> delay(Duration duration) async {
    await Future.delayed(duration);
  }

  /// Retry mechanism
  static Future<T> retry<T>(
      Future<T> Function() operation, {
        int maxAttempts = 3,
        Duration delay = const Duration(seconds: 1),
      }) async {
    int attempts = 0;

    while (attempts < maxAttempts) {
      try {
        return await operation();
      } catch (e) {
        attempts++;
        if (attempts >= maxAttempts) rethrow;
        await Future.delayed(delay);
      }
    }

    throw Exception('Max retry attempts reached');
  }
}