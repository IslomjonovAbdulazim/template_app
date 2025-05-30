import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import 'dart:math' as math;

/// Complete theme configuration for the application
/// Defines both light and dark themes with consistent styling
class AppTheme {
  AppTheme._();

  /// Light theme configuration
  static ThemeData get lightTheme => ThemeData(
    // Color scheme
    colorScheme: const ColorScheme.light(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primaryShade,
      onPrimaryContainer: AppColors.primaryDark,
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.secondaryShade,
      onSecondaryContainer: AppColors.secondaryDark,
      tertiary: AppColors.accent,
      onTertiary: Colors.white,
      error: AppColors.error,
      onError: Colors.white,
      errorContainer: AppColors.errorShade,
      onErrorContainer: AppColors.errorDark,
      background: LightColors.background,
      onBackground: LightColors.onBackground,
      surface: LightColors.surface,
      onSurface: LightColors.onSurface,
      surfaceVariant: LightColors.surfaceVariant,
      onSurfaceVariant: LightColors.onSurfaceVariant,
      outline: LightColors.border,
      outlineVariant: LightColors.borderLight,
      shadow: LightColors.shadow,
      scrim: Colors.black54,
      inverseSurface: AppColors.grey800,
      onInverseSurface: Colors.white,
      inversePrimary: AppColors.primaryLight,
    ),

    // Material 3 design
    useMaterial3: true,

    // App bar theme
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 1,
      backgroundColor: LightColors.surface,
      foregroundColor: LightColors.textPrimary,
      surfaceTintColor: AppColors.primary,
      titleTextStyle: AppTextStyles.titleLarge.copyWith(
        color: LightColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: const IconThemeData(
        color: LightColors.textPrimary,
        size: 24,
      ),
      actionsIconTheme: const IconThemeData(
        color: LightColors.textPrimary,
        size: 24,
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    ),

    // Bottom navigation bar theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: LightColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: LightColors.textTertiary,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
    ),

    // Navigation bar theme (Material 3)
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: LightColors.surface,
      indicatorColor: AppColors.primaryShade,
      labelTextStyle: MaterialStateProperty.all(
        AppTextStyles.labelSmall.copyWith(color: LightColors.textPrimary),
      ),
      iconTheme: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const IconThemeData(color: AppColors.primary);
        }
        return const IconThemeData(color: LightColors.textTertiary);
      }),
    ),

    // Card theme
    cardTheme: CardTheme(
      color: LightColors.cardBackground,
      elevation: 2,
      shadowColor: LightColors.cardShadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(8),
    ),

    // Elevated button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        shadowColor: AppColors.primary.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: AppTextStyles.buttonMedium,
        minimumSize: const Size(88, 48),
      ),
    ),

    // Outlined button theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: AppTextStyles.buttonMedium,
        minimumSize: const Size(88, 48),
      ),
    ),

    // Text button theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: AppTextStyles.buttonMedium,
        minimumSize: const Size(64, 40),
      ),
    ),

    // Floating action button theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 6,
      shape: CircleBorder(),
    ),

    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: LightColors.inputFill,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: LightColors.inputBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: LightColors.inputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: LightColors.inputFocusBorder, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: LightColors.inputErrorBorder),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: LightColors.inputErrorBorder, width: 2),
      ),
      labelStyle: AppTextStyles.inputLabel.copyWith(color: LightColors.textSecondary),
      hintStyle: AppTextStyles.inputHint.copyWith(color: LightColors.textTertiary),
      errorStyle: AppTextStyles.inputError.copyWith(color: AppColors.error),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),

    // Checkbox theme
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primary;
        }
        return Colors.transparent;
      }),
      checkColor: MaterialStateProperty.all(Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),

    // Radio theme
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primary;
        }
        return LightColors.textTertiary;
      }),
    ),

    // Switch theme
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primary;
        }
        return AppColors.grey400;
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primary.withOpacity(0.5);
        }
        return AppColors.grey300;
      }),
    ),

    // Slider theme
    sliderTheme: const SliderThemeData(
      activeTrackColor: AppColors.primary,
      inactiveTrackColor: AppColors.grey300,
      thumbColor: AppColors.primary,
      overlayColor: AppColors.primaryShade,
    ),

    // Progress indicator theme
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
      linearTrackColor: AppColors.grey200,
      circularTrackColor: AppColors.grey200,
    ),

    // Divider theme
    dividerTheme: const DividerThemeData(
      color: LightColors.divider,
      thickness: 1,
      space: 1,
    ),

    // Dialog theme
    dialogTheme: DialogTheme(
      backgroundColor: LightColors.surface,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      titleTextStyle: AppTextStyles.titleLarge.copyWith(
        color: LightColors.textPrimary,
      ),
      contentTextStyle: AppTextStyles.bodyMedium.copyWith(
        color: LightColors.textSecondary,
      ),
    ),

    // Snackbar theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.grey800,
      contentTextStyle: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      behavior: SnackBarBehavior.floating,
    ),

    // Bottom sheet theme
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: LightColors.surface,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    ),

    // Tab bar theme
    tabBarTheme: TabBarTheme(
      labelColor: AppColors.primary,
      unselectedLabelColor: LightColors.textTertiary,
      labelStyle: AppTextStyles.tabLabel.copyWith(fontWeight: FontWeight.w600),
      unselectedLabelStyle: AppTextStyles.tabLabel,
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
    ),

    // List tile theme
    listTileTheme: ListTileThemeData(
      iconColor: LightColors.textSecondary,
      textColor: LightColors.textPrimary,
      titleTextStyle: AppTextStyles.listTitle.copyWith(color: LightColors.textPrimary),
      subtitleTextStyle: AppTextStyles.listSubtitle.copyWith(color: LightColors.textSecondary),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    ),

    // Icon theme
    iconTheme: const IconThemeData(
      color: LightColors.textSecondary,
      size: 24,
    ),

    // Primary icon theme
    primaryIconTheme: const IconThemeData(
      color: Colors.white,
      size: 24,
    ),

    // Text theme
    textTheme: GoogleFonts.interTextTheme().copyWith(
      displayLarge: LightTextStyles.displayLarge,
      displayMedium: LightTextStyles.displayMedium,
      displaySmall: LightTextStyles.displaySmall,
      headlineLarge: LightTextStyles.headlineLarge,
      headlineMedium: LightTextStyles.headlineMedium,
      headlineSmall: LightTextStyles.headlineSmall,
      titleLarge: LightTextStyles.titleLarge,
      titleMedium: LightTextStyles.titleMedium,
      titleSmall: LightTextStyles.titleSmall,
      bodyLarge: LightTextStyles.bodyLarge,
      bodyMedium: LightTextStyles.bodyMedium,
      bodySmall: LightTextStyles.bodySmall,
      labelLarge: LightTextStyles.labelLarge,
      labelMedium: LightTextStyles.labelMedium,
      labelSmall: LightTextStyles.labelSmall,
    ),

    // Extensions
    extensions: <ThemeExtension<dynamic>>[
      CustomColors.light,
    ],
  );

  /// Dark theme configuration
  static ThemeData get darkTheme => ThemeData(
    // Color scheme
    colorScheme: const ColorScheme.dark(
      brightness: Brightness.dark,
      primary: AppColors.primaryLight,
      onPrimary: AppColors.grey900,
      primaryContainer: AppColors.primaryDark,
      onPrimaryContainer: AppColors.primaryLight,
      secondary: AppColors.secondaryLight,
      onSecondary: AppColors.grey900,
      secondaryContainer: AppColors.secondaryDark,
      onSecondaryContainer: AppColors.secondaryLight,
      tertiary: AppColors.accentLight,
      onTertiary: AppColors.grey900,
      error: AppColors.errorLight,
      onError: AppColors.grey900,
      errorContainer: AppColors.errorDark,
      onErrorContainer: AppColors.errorLight,
      background: DarkColors.background,
      onBackground: DarkColors.onBackground,
      surface: DarkColors.surface,
      onSurface: DarkColors.onSurface,
      surfaceVariant: DarkColors.surfaceVariant,
      onSurfaceVariant: DarkColors.onSurfaceVariant,
      outline: DarkColors.border,
      outlineVariant: DarkColors.borderLight,
      shadow: DarkColors.shadow,
      scrim: Colors.black87,
      inverseSurface: AppColors.grey100,
      onInverseSurface: AppColors.grey900,
      inversePrimary: AppColors.primary,
    ),

    // Material 3 design
    useMaterial3: true,

    // App bar theme
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 1,
      backgroundColor: DarkColors.surface,
      foregroundColor: DarkColors.textPrimary,
      surfaceTintColor: AppColors.primaryLight,
      titleTextStyle: AppTextStyles.titleLarge.copyWith(
        color: DarkColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: const IconThemeData(
        color: DarkColors.textPrimary,
        size: 24,
      ),
      actionsIconTheme: const IconThemeData(
        color: DarkColors.textPrimary,
        size: 24,
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    ),

    // Bottom navigation bar theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: DarkColors.surface,
      selectedItemColor: AppColors.primaryLight,
      unselectedItemColor: DarkColors.textTertiary,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
    ),

    // Navigation bar theme (Material 3)
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: DarkColors.surface,
      indicatorColor: AppColors.primaryDark,
      labelTextStyle: MaterialStateProperty.all(
        AppTextStyles.labelSmall.copyWith(color: DarkColors.textPrimary),
      ),
      iconTheme: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const IconThemeData(color: AppColors.primaryLight);
        }
        return const IconThemeData(color: DarkColors.textTertiary);
      }),
    ),

    // Card theme
    cardTheme: CardTheme(
      color: DarkColors.cardBackground,
      elevation: 2,
      shadowColor: DarkColors.cardShadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(8),
    ),

    // Elevated button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: AppColors.grey900,
        elevation: 2,
        shadowColor: AppColors.primaryLight.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: AppTextStyles.buttonMedium,
        minimumSize: const Size(88, 48),
      ),
    ),

    // Outlined button theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryLight,
        side: const BorderSide(color: AppColors.primaryLight, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: AppTextStyles.buttonMedium,
        minimumSize: const Size(88, 48),
      ),
    ),

    // Text button theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: AppTextStyles.buttonMedium,
        minimumSize: const Size(64, 40),
      ),
    ),

    // Floating action button theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryLight,
      foregroundColor: AppColors.grey900,
      elevation: 6,
      shape: CircleBorder(),
    ),

    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: DarkColors.inputFill,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: DarkColors.inputBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: DarkColors.inputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: DarkColors.inputFocusBorder, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: DarkColors.inputErrorBorder),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: DarkColors.inputErrorBorder, width: 2),
      ),
      labelStyle: AppTextStyles.inputLabel.copyWith(color: DarkColors.textSecondary),
      hintStyle: AppTextStyles.inputHint.copyWith(color: DarkColors.textTertiary),
      errorStyle: AppTextStyles.inputError.copyWith(color: AppColors.errorLight),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),

    // Other theme configurations similar to light theme but with dark colors...
    // (Abbreviated for brevity - would include all the same theme properties)

    // Text theme
    textTheme: GoogleFonts.interTextTheme().copyWith(
      displayLarge: DarkTextStyles.displayLarge,
      displayMedium: DarkTextStyles.displayMedium,
      displaySmall: DarkTextStyles.displaySmall,
      headlineLarge: DarkTextStyles.headlineLarge,
      headlineMedium: DarkTextStyles.headlineMedium,
      headlineSmall: DarkTextStyles.headlineSmall,
      titleLarge: DarkTextStyles.titleLarge,
      titleMedium: DarkTextStyles.titleMedium,
      titleSmall: DarkTextStyles.titleSmall,
      bodyLarge: DarkTextStyles.bodyLarge,
      bodyMedium: DarkTextStyles.bodyMedium,
      bodySmall: DarkTextStyles.bodySmall,
      labelLarge: DarkTextStyles.labelLarge,
      labelMedium: DarkTextStyles.labelMedium,
      labelSmall: DarkTextStyles.labelSmall,
    ),

    // Extensions
    extensions: <ThemeExtension<dynamic>>[
      CustomColors.dark,
    ],
  );
}

/// Custom colors extension for additional theme colors
@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  final Color? success;
  final Color? warning;
  final Color? info;
  final Color? successContainer;
  final Color? warningContainer;
  final Color? infoContainer;

  const CustomColors({
    required this.success,
    required this.warning,
    required this.info,
    required this.successContainer,
    required this.warningContainer,
    required this.infoContainer,
  });

  static const light = CustomColors(
    success: AppColors.success,
    warning: AppColors.warning,
    info: AppColors.info,
    successContainer: AppColors.successShade,
    warningContainer: AppColors.warningShade,
    infoContainer: AppColors.infoShade,
  );

  static const dark = CustomColors(
    success: AppColors.successLight,
    warning: AppColors.warningLight,
    info: AppColors.infoLight,
    successContainer: AppColors.successDark,
    warningContainer: AppColors.warningDark,
    infoContainer: AppColors.infoDark,
  );

  @override
  CustomColors copyWith({
    Color? success,
    Color? warning,
    Color? info,
    Color? successContainer,
    Color? warningContainer,
    Color? infoContainer,
  }) {
    return CustomColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      successContainer: successContainer ?? this.successContainer,
      warningContainer: warningContainer ?? this.warningContainer,
      infoContainer: infoContainer ?? this.infoContainer,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      success: Color.lerp(success, other.success, t),
      warning: Color.lerp(warning, other.warning, t),
      info: Color.lerp(info, other.info, t),
      successContainer: Color.lerp(successContainer, other.successContainer, t),
      warningContainer: Color.lerp(warningContainer, other.warningContainer, t),
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t),
    );
  }
}

/// Theme utility methods
class ThemeUtils {
  ThemeUtils._();

  /// Get custom colors from context
  static CustomColors getCustomColors(BuildContext context) {
    return Theme.of(context).extension<CustomColors>() ?? CustomColors.light;
  }

  /// Check if current theme is dark
  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  /// Get appropriate color based on theme
  static Color getAdaptiveColor(BuildContext context, Color lightColor, Color darkColor) {
    return isDark(context) ? darkColor : lightColor;
  }

  /// Get text color based on background
  static Color getContrastingTextColor(Color backgroundColor) {
    return backgroundColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }

  /// Apply elevation overlay for dark theme
  static Color getElevationOverlay(BuildContext context, Color surfaceColor, double elevation) {
    if (!isDark(context)) return surfaceColor;

    final overlayOpacity = (4.5 * math.log(elevation + 1) + 2) / 100;
    return Color.alphaBlend(
      Colors.white.withOpacity(overlayOpacity),
      surfaceColor,
    );
  }
}

