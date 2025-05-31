import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app/controllers/auth_controller.dart';
import 'app/controllers/connectivity_controller.dart';
import 'app/controllers/language_controller.dart';
import 'app/controllers/theme_controller.dart';
import 'app/translations/app_translations.dart';
import 'app/bindings/initial_binding.dart';
import 'app/routes/app_pages.dart';
import 'services/storage_service.dart';
import 'services/connectivity_service.dart';
import 'services/auth_service.dart';
import 'utils/app_theme.dart';
import 'constants/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize core services
  await _initializeServices();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

/// Initialize all required services
Future<void> _initializeServices() async {
  try {
    // Initialize storage service first
    await Get.putAsync(() => StorageService().init());

    // Initialize other services
    await Get.putAsync(() => ConnectivityService().init());
    await Get.putAsync(() => AuthService().init());

    // Initialize translation system
    AppTranslations.initialize();

    print('✅ All services initialized successfully');
  } catch (e) {
    print('❌ Error initializing services: $e');
  }
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // App configuration
      title: 'Template App',
      debugShowCheckedModeBanner: false,

      // Translations configuration
      translations: AppTranslations(),
      locale: AppTranslations.getDeviceLocale(),
      fallbackLocale: AppTranslations.fallbackLocale,

      // Localization delegates for flutter_localizations
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppTranslations.supportedLocales,

      // Theme configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      // Navigation configuration
      initialBinding: InitialBinding(),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,

      // Navigation settings
      enableLog: true,
      logWriterCallback: _logWriter,

      // Default transitions
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),

      // Error handling
      unknownRoute: AppPages.routes.last,

      // Builder for global configurations
      builder: (context, child) {
        return _AppWrapper(child: child);
      },
    );
  }

  /// Custom log writer for GetX
  void _logWriter(String text, {bool isError = false}) {
    if (isError) {
      print('🔴 GetX Error: $text');
    } else {
      print('🟢 GetX: $text');
    }
  }
}

/// App wrapper to handle global configurations
class _AppWrapper extends StatefulWidget {
  final Widget? child;

  const _AppWrapper({this.child});

  @override
  State<_AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<_AppWrapper> with WidgetsBindingObserver {
  late final ThemeController _themeController;
  late final LanguageController _languageController;
  late final ConnectivityController _connectivityController;
  late final AuthController _authController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _initializeControllers() {
    // Initialize controllers with proper error handling
    try {
      _themeController = Get.put(ThemeController(), permanent: true);
      _languageController = Get.put(LanguageController(), permanent: true);
      _connectivityController = Get.put(ConnectivityController(), permanent: true);
      _authController = Get.put(AuthController(), permanent: true);

      print('✅ Controllers initialized successfully');
    } catch (e) {
      print('❌ Error initializing controllers: $e');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
      // App is in foreground
        _connectivityController.checkConnectivity();
        break;
      case AppLifecycleState.paused:
      // App is in background
        break;
      case AppLifecycleState.inactive:
      // App is inactive
        break;
      case AppLifecycleState.detached:
      // App is detached
        break;
      case AppLifecycleState.hidden:
      // App is hidden (Android 14+)
        break;
    }
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    // Handle system theme changes
    _themeController.applyTheme();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return MediaQuery(
        // Apply font scaling from theme controller
        data: MediaQuery.of(context).copyWith(
          textScaleFactor: _themeController.getFontSizeScale(),
        ),
        child: Directionality(
          // Apply text direction based on current language
          textDirection: AppTranslations.getLanguageDirection(
            _languageController.currentLanguageCode,
          ),
          child: Stack(
            children: [
              // Main app content
              widget.child ?? const SizedBox.shrink(),

              // Global overlays
              _buildConnectivityBanner(),
            ],
          ),
        ),
      );
    });
  }

  /// Build connectivity banner for offline state
  Widget _buildConnectivityBanner() {
    return Obx(() {
      if (!_connectivityController.showOfflineBanner) {
        return const SizedBox.shrink();
      }

      return Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: SafeArea(
          bottom: false,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              margin: const EdgeInsets.all(8),
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
                  Expanded(
                    child: Text(
                      'No internet connection',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (_connectivityController.isRetrying)
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
                      onPressed: _connectivityController.retryConnection,
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
                    onPressed: _connectivityController.hideOfflineBanner,
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
        ),
      );
    });
  }
}