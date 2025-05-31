import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Core imports
import 'app/controllers/auth_controller.dart';
import 'app/controllers/connectivity_controller.dart';
import 'app/controllers/language_controller.dart';
import 'app/controllers/theme_controller.dart';
import 'app/translations/app_translations.dart';
import 'app/bindings/initial_binding.dart';
import 'app/routes/app_pages.dart';
import 'utils/app_theme.dart';
import 'constants/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup system UI
  _setupSystemUI();

  // Initialize app translations
  AppTranslations.initialize();

  runApp(MyApp());
}

/// Setup system UI styling
void _setupSystemUI() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Template App',
      debugShowCheckedModeBanner: false,

      // Internationalization
      translations: AppTranslations(),
      locale: AppTranslations.getDeviceLocale(),
      fallbackLocale: AppTranslations.fallbackLocale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppTranslations.supportedLocales,

      // Theming
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      // Navigation & Dependency Injection
      initialBinding: InitialBinding(), // ← This handles ALL service initialization!
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,

      // Default transitions
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),

      // Global wrapper for UI features
      builder: (context, child) => AppWrapper(child: child),

      // Error handling
      unknownRoute: AppPages.routes.last,
    );
  }
}

/// Wrapper for global functionality
class AppWrapper extends StatefulWidget {
  final Widget? child;

  const AppWrapper({super.key, this.child});

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // No need to initialize controllers here - InitialBinding handles it!
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Handle app lifecycle changes
    switch (state) {
      case AppLifecycleState.resumed:
      // App came to foreground - check connectivity
        if (Get.isRegistered<ConnectivityController>()) {
          Get.find<ConnectivityController>().checkConnectivity();
        }
        break;
      case AppLifecycleState.paused:
      // App went to background
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    // Handle system theme changes
    if (Get.isRegistered<ThemeController>()) {
      final themeController = Get.find<ThemeController>();
      if (themeController.isSystemMode) {
        // Theme controller will automatically update
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      // Apply responsive font scaling
      data: MediaQuery.of(context).copyWith(
        textScaleFactor: _getFontScale(),
      ),
      child: Directionality(
        // Apply text direction based on current language
        textDirection: _getTextDirection(),
        child: Stack(
          children: [
            // Main app content
            widget.child ?? const SizedBox.shrink(),

            // Global overlays
            _buildOfflineBanner(),
          ],
        ),
      ),
    );
  }

  /// Get font scale factor
  double _getFontScale() {
    try {
      if (Get.isRegistered<ThemeController>()) {
        // You can add font scaling logic here
        return 1.0;
      }
    } catch (e) {
      // Controller not ready yet
    }
    return 1.0;
  }

  /// Get text direction based on language
  TextDirection _getTextDirection() {
    try {
      if (Get.isRegistered<LanguageController>()) {
        final languageController = Get.find<LanguageController>();
        return AppTranslations.getLanguageDirection(
          languageController.currentLanguageCode,
        );
      }
    } catch (e) {
      // Controller not ready yet
    }
    return TextDirection.ltr; // Default to LTR
  }

  /// Offline connection banner
  Widget _buildOfflineBanner() {
    return GetBuilder<ConnectivityController>(
      builder: (controller) {
        // Show banner only when offline
        if (controller.isConnected) return const SizedBox.shrink();

        return Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            bottom: false,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.wifi_off,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'No internet connection',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (controller.isRetrying)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  else
                    TextButton(
                      onPressed: controller.retryConnection,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      child: const Text(
                        'Retry',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  IconButton(
                    onPressed: controller.hideOfflineBanner,
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 18,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}