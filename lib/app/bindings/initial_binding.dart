import 'dart:developer';
import 'package:get/get.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../services/connectivity_service.dart';
import '../../services/notification_service.dart';
import '../../services/storage_service.dart';
import '../controllers/auth_controller.dart';
import '../controllers/connectivity_controller.dart';
import '../controllers/language_controller.dart';
import '../controllers/theme_controller.dart';

/// Initial binding that sets up all core services and controllers
/// This is the entry point for dependency injection in the app
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    log('🚀 Starting InitialBinding - Setting up core dependencies');

    // Initialize services in the correct order
    _initializeServices();

    // Initialize controllers that depend on services
    _initializeControllers();

    log('✅ InitialBinding completed - All dependencies ready');
  }

  /// Initialize core services
  /// Services are initialized as permanent singletons using GetX service pattern
  void _initializeServices() {
    log('📦 Initializing core services...');

    try {
      // Storage Service - Must be first as other services depend on it
      if (!Get.isRegistered<StorageService>()) {
        Get.put(StorageService(), permanent: true);
        log('✅ StorageService registered');
      }

      // Connectivity Service - Network monitoring
      if (!Get.isRegistered<ConnectivityService>()) {
        Get.put(ConnectivityService(), permanent: true);
        log('✅ ConnectivityService registered');
      }

      // API Service - HTTP client
      if (!Get.isRegistered<ApiService>()) {
        Get.put(ApiService(), permanent: true);
        log('✅ ApiService registered');
      }

      // Auth Service - Authentication management
      if (!Get.isRegistered<AuthService>()) {
        Get.put(AuthService(), permanent: true);
        log('✅ AuthService registered');
      }

      // Notification Service - Push & local notifications
      if (!Get.isRegistered<NotificationService>()) {
        Get.put(NotificationService(), permanent: true);
        log('✅ NotificationService registered');
      }

      log('🎉 All core services initialized successfully');
    } catch (e) {
      log('❌ Error initializing services: $e');
      rethrow;
    }
  }

  /// Initialize controllers that manage UI state
  /// Controllers are initialized as permanent to persist across route changes
  void _initializeControllers() {
    log('🎮 Initializing core controllers...');

    try {
      // Theme Controller - App appearance management
      if (!Get.isRegistered<ThemeController>()) {
        Get.put(ThemeController(), permanent: true);
        log('✅ ThemeController registered');
      }

      // Language Controller - Internationalization
      if (!Get.isRegistered<LanguageController>()) {
        Get.put(LanguageController(), permanent: true);
        log('✅ LanguageController registered');
      }

      // Connectivity Controller - Network status UI management
      if (!Get.isRegistered<ConnectivityController>()) {
        Get.put(ConnectivityController(), permanent: true);
        log('✅ ConnectivityController registered');
      }

      // Auth Controller - Authentication UI management
      if (!Get.isRegistered<AuthController>()) {
        Get.put(AuthController(), permanent: true);
        log('✅ AuthController registered');
      }

      log('🎉 All core controllers initialized successfully');
    } catch (e) {
      log('❌ Error initializing controllers: $e');
      rethrow;
    }
  }

  /// Initialize services asynchronously
  /// This is called automatically by GetX when services are registered
  /// No manual .init() calls needed - GetX handles onInit() automatically
  static Future<void> initializeAsync() async {
    log('⚡ GetX services will initialize automatically via onInit()');

    try {
      // GetX automatically calls onInit() for all registered services
      // We just need to wait a moment for them to complete
      await Future.delayed(const Duration(milliseconds: 100));

      // Verify services are ready
      final storageService = Get.find<StorageService>();
      log('✅ StorageService ready');

      final connectivityService = Get.find<ConnectivityService>();
      log('✅ ConnectivityService ready');

      final authService = Get.find<AuthService>();
      log('✅ AuthService ready');

      log('🎉 All services initialized and ready');
    } catch (e) {
      log('❌ Error in service verification: $e');
      rethrow;
    }
  }

  /// Initialize connectivity service asynchronously
  static Future<void> _initializeConnectivityServiceAsync() async {
    try {
      final connectivityService = Get.find<ConnectivityService>();
      // GetX handles onInit automatically
      log('✅ ConnectivityService setup completed');
    } catch (e) {
      log('❌ ConnectivityService initialization failed: $e');
    }
  }

  /// Initialize notification service asynchronously
  static Future<void> _initializeNotificationServiceAsync() async {
    try {
      final notificationService = Get.find<NotificationService>();
      // GetX handles onInit automatically
      log('✅ NotificationService setup completed');
    } catch (e) {
      log('❌ NotificationService initialization failed: $e');
    }
  }

  /// Initialize auth service asynchronously
  static Future<void> _initializeAuthServiceAsync() async {
    try {
      final authService = Get.find<AuthService>();
      // GetX handles onInit automatically
      log('✅ AuthService setup completed');
    } catch (e) {
      log('❌ AuthService initialization failed: $e');
    }
  }

  /// Get initialization status for debugging
  static Map<String, bool> getInitializationStatus() {
    return {
      'StorageService': Get.isRegistered<StorageService>(),
      'ConnectivityService': Get.isRegistered<ConnectivityService>(),
      'ApiService': Get.isRegistered<ApiService>(),
      'AuthService': Get.isRegistered<AuthService>(),
      'NotificationService': Get.isRegistered<NotificationService>(),
      'ThemeController': Get.isRegistered<ThemeController>(),
      'LanguageController': Get.isRegistered<LanguageController>(),
      'ConnectivityController': Get.isRegistered<ConnectivityController>(),
      'AuthController': Get.isRegistered<AuthController>(),
    };
  }

  /// Check if all core dependencies are initialized
  static bool get isFullyInitialized {
    final status = getInitializationStatus();
    return status.values.every((isRegistered) => isRegistered);
  }

  /// Force re-initialization of a specific service
  static Future<void> reinitializeService<T>() async {
    log('🔄 Reinitializing service: ${T.toString()}');

    try {
      if (Get.isRegistered<T>()) {
        await Get.delete<T>(force: true);
        log('🗑️ Removed existing ${T.toString()} instance');
      }

      // Re-register based on type using proper GetX service pattern
      if (T == StorageService) {
        Get.put(StorageService(), permanent: true);
      } else if (T == ConnectivityService) {
        Get.put(ConnectivityService(), permanent: true);
      } else if (T == ApiService) {
        Get.put(ApiService(), permanent: true);
      } else if (T == AuthService) {
        Get.put(AuthService(), permanent: true);
      } else if (T == NotificationService) {
        Get.put(NotificationService(), permanent: true);
      }

      log('✅ ${T.toString()} reinitialized successfully');
    } catch (e) {
      log('❌ Failed to reinitialize ${T.toString()}: $e');
      rethrow;
    }
  }

  /// Clean up all dependencies
  static Future<void> cleanup() async {
    log('🧹 Cleaning up InitialBinding dependencies...');

    try {
      // Remove controllers first
      await Get.delete<AuthController>(force: true);
      await Get.delete<ConnectivityController>(force: true);
      await Get.delete<LanguageController>(force: true);
      await Get.delete<ThemeController>(force: true);

      // Remove services
      await Get.delete<NotificationService>(force: true);
      await Get.delete<AuthService>(force: true);
      await Get.delete<ApiService>(force: true);
      await Get.delete<ConnectivityService>(force: true);
      await Get.delete<StorageService>(force: true);

      log('✅ InitialBinding cleanup completed');
    } catch (e) {
      log('❌ Error during cleanup: $e');
    }
  }

  /// Debug method to print all registered dependencies
  static void printRegisteredDependencies() {
    log('📋 Currently registered dependencies:');
    final status = getInitializationStatus();

    status.forEach((service, isRegistered) {
      final icon = isRegistered ? '✅' : '❌';
      log('  $icon $service: $isRegistered');
    });

    log('📊 Total registered: ${status.values.where((v) => v).length}/${status.length}');
  }
}