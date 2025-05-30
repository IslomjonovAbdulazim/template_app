import 'package:flutter/material.dart';

/// Application color palette for light and dark themes
/// Centralized color definitions to maintain consistency across the app
class AppColors {
  AppColors._();

  // Primary Brand Colors
  static const Color primary = Color(0xFF3B82F6); // Blue-500
  static const Color primaryLight = Color(0xFF60A5FA); // Blue-400
  static const Color primaryDark = Color(0xFF1D4ED8); // Blue-700
  static const Color primaryShade = Color(0xFFEBF4FF); // Blue-50

  // Secondary Colors
  static const Color secondary = Color(0xFF6366F1); // Indigo-500
  static const Color secondaryLight = Color(0xFF818CF8); // Indigo-400
  static const Color secondaryDark = Color(0xFF4338CA); // Indigo-700
  static const Color secondaryShade = Color(0xFFEEF2FF); // Indigo-50

  // Accent Colors
  static const Color accent = Color(0xFF10B981); // Emerald-500
  static const Color accentLight = Color(0xFF34D399); // Emerald-400
  static const Color accentDark = Color(0xFF047857); // Emerald-700

  // Neutral Colors (Light Theme)
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey50 = Color(0xFFF9FAFB);
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey500 = Color(0xFF6B7280);
  static const Color grey600 = Color(0xFF4B5563);
  static const Color grey700 = Color(0xFF374151);
  static const Color grey800 = Color(0xFF1F2937);
  static const Color grey900 = Color(0xFF111827);

  // Status Colors
  static const Color success = Color(0xFF10B981); // Emerald-500
  static const Color successLight = Color(0xFF34D399); // Emerald-400
  static const Color successDark = Color(0xFF047857); // Emerald-700
  static const Color successShade = Color(0xFFECFDF5); // Emerald-50

  static const Color warning = Color(0xFFF59E0B); // Amber-500
  static const Color warningLight = Color(0xFFFBBF24); // Amber-400
  static const Color warningDark = Color(0xFFD97706); // Amber-600
  static const Color warningShade = Color(0xFFFFFBEB); // Amber-50

  static const Color error = Color(0xFFEF4444); // Red-500
  static const Color errorLight = Color(0xFFF87171); // Red-400
  static const Color errorDark = Color(0xFFDC2626); // Red-600
  static const Color errorShade = Color(0xFFFEF2F2); // Red-50

  static const Color info = Color(0xFF3B82F6); // Blue-500
  static const Color infoLight = Color(0xFF60A5FA); // Blue-400
  static const Color infoDark = Color(0xFF1D4ED8); // Blue-700
  static const Color infoShade = Color(0xFFEBF4FF); // Blue-50

  // Social Colors
  static const Color google = Color(0xFF4285F4);
  static const Color facebook = Color(0xFF1877F2);
  static const Color apple = Color(0xFF000000);
  static const Color twitter = Color(0xFF1DA1F2);
  static const Color linkedin = Color(0xFF0A66C2);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [success, successDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

/// Light theme colors
class LightColors {
  static const Color background = AppColors.white;
  static const Color surface = AppColors.white;
  static const Color surfaceVariant = AppColors.grey50;
  static const Color onBackground = AppColors.grey900;
  static const Color onSurface = AppColors.grey900;
  static const Color onSurfaceVariant = AppColors.grey600;

  // Text colors
  static const Color textPrimary = AppColors.grey900;
  static const Color textSecondary = AppColors.grey600;
  static const Color textTertiary = AppColors.grey400;
  static const Color textDisabled = AppColors.grey300;

  // Border colors
  static const Color border = AppColors.grey200;
  static const Color borderLight = AppColors.grey100;
  static const Color borderDark = AppColors.grey300;

  // Shadow colors
  static const Color shadow = Color(0x1A000000);
  static const Color shadowLight = Color(0x0D000000);
  static const Color shadowDark = Color(0x26000000);

  // Input colors
  static const Color inputFill = AppColors.grey50;
  static const Color inputBorder = AppColors.grey200;
  static const Color inputFocusBorder = AppColors.primary;
  static const Color inputErrorBorder = AppColors.error;

  // Card colors
  static const Color cardBackground = AppColors.white;
  static const Color cardShadow = Color(0x1A000000);

  // Divider colors
  static const Color divider = AppColors.grey200;
  static const Color dividerLight = AppColors.grey100;
}

/// Dark theme colors
class DarkColors {
  static const Color background = AppColors.grey900;
  static const Color surface = AppColors.grey800;
  static const Color surfaceVariant = AppColors.grey700;
  static const Color onBackground = AppColors.white;
  static const Color onSurface = AppColors.white;
  static const Color onSurfaceVariant = AppColors.grey300;

  // Text colors
  static const Color textPrimary = AppColors.white;
  static const Color textSecondary = AppColors.grey300;
  static const Color textTertiary = AppColors.grey500;
  static const Color textDisabled = AppColors.grey600;

  // Border colors
  static const Color border = AppColors.grey600;
  static const Color borderLight = AppColors.grey700;
  static const Color borderDark = AppColors.grey500;

  // Shadow colors
  static const Color shadow = Color(0x33000000);
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowDark = Color(0x4D000000);

  // Input colors
  static const Color inputFill = AppColors.grey800;
  static const Color inputBorder = AppColors.grey600;
  static const Color inputFocusBorder = AppColors.primaryLight;
  static const Color inputErrorBorder = AppColors.errorLight;

  // Card colors
  static const Color cardBackground = AppColors.grey800;
  static const Color cardShadow = Color(0x33000000);

  // Divider colors
  static const Color divider = AppColors.grey600;
  static const Color dividerLight = AppColors.grey700;
}

/// Color utilities
class ColorUtils {
  ColorUtils._();

  /// Get color with opacity
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  /// Darken a color by percentage
  static Color darken(Color color, [double percent = 10]) {
    assert(1 <= percent && percent <= 100);
    final f = 1 - percent / 100;
    return Color.fromARGB(
      color.alpha,
      (color.red * f).round(),
      (color.green * f).round(),
      (color.blue * f).round(),
    );
  }

  /// Lighten a color by percentage
  static Color lighten(Color color, [double percent = 10]) {
    assert(1 <= percent && percent <= 100);
    final f = percent / 100;
    return Color.fromARGB(
      color.alpha,
      (color.red + ((255 - color.red) * f)).round(),
      (color.green + ((255 - color.green) * f)).round(),
      (color.blue + ((255 - color.blue) * f)).round(),
    );
  }

  /// Get status color based on status string
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'success':
      case 'completed':
      case 'active':
        return AppColors.success;
      case 'warning':
      case 'pending':
        return AppColors.warning;
      case 'error':
      case 'failed':
      case 'inactive':
        return AppColors.error;
      case 'info':
      case 'processing':
        return AppColors.info;
      default:
        return AppColors.grey500;
    }
  }

  /// Convert hex string to Color
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Convert Color to hex string
  static String toHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  /// Get contrasting text color (black or white) for a given background color
  static Color getContrastingTextColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? AppColors.black : AppColors.white;
  }
}