import 'dart:async';
import 'dart:developer';
import 'package:get/get.dart';
import '../../services/connectivity_service.dart';
import 'package:flutter/material.dart';

/// Controller for managing connectivity state in the UI
/// Provides reactive connectivity status and user-friendly methods
class ConnectivityController extends GetxController {
  static ConnectivityController get instance => Get.find<ConnectivityController>();

  late final ConnectivityService _connectivityService;

  // Reactive variables
  final _isConnected = false.obs;
  final _connectionType = ''.obs;
  final _connectionQuality = ConnectionQuality.unknown.obs;
  final _showOfflineBanner = false.obs;
  final _isRetrying = false.obs;

  // Stream subscriptions
  StreamSubscription<bool>? _connectionSubscription;
  Timer? _bannerTimer;

  // Getters
  bool get isConnected => _isConnected.value;
  String get connectionType => _connectionType.value;
  ConnectionQuality get connectionQuality => _connectionQuality.value;
  bool get showOfflineBanner => _showOfflineBanner.value;
  bool get isRetrying => _isRetrying.value;

  // UI helper getters
  bool get isOnline => _isConnected.value;
  bool get isOffline => !_isConnected.value;
  bool get hasGoodConnection => _connectionQuality.value == ConnectionQuality.excellent ||
      _connectionQuality.value == ConnectionQuality.good;
  bool get hasPoorConnection => _connectionQuality.value == ConnectionQuality.poor;

  @override
  Future<void> onInit() async {
    super.onInit();

    // Get connectivity service instance
    _connectivityService = ConnectivityService.instance;

    // Initialize with current state
    _updateFromService();

    // Listen to connectivity changes
    _setupConnectivityListener();

    log('ConnectivityController initialized');
  }

  @override
  void onClose() {
    _connectionSubscription?.cancel();
    _bannerTimer?.cancel();
    super.onClose();
  }

  /// Initialize connectivity state from service
  void _updateFromService() {
    _isConnected.value = _connectivityService.isConnected;
    _connectionType.value = _connectivityService.connectionType;
    _connectionQuality.value = _connectivityService.connectionQuality;
  }

  /// Setup connectivity listener
  void _setupConnectivityListener() {
    _connectionSubscription = _connectivityService.connectionStream.listen(
          (isConnected) {
        _handleConnectivityChange(isConnected);
      },
      onError: (error) {
        log('ConnectivityController stream error: $error');
      },
    );
  }

  /// Handle connectivity changes
  void _handleConnectivityChange(bool isConnected) {
    final wasConnected = _isConnected.value;

    // Update state
    _isConnected.value = isConnected;
    _connectionType.value = _connectivityService.connectionType;
    _connectionQuality.value = _connectivityService.connectionQuality;

    // Handle UI feedback
    if (!wasConnected && isConnected) {
      _handleConnectionRestored();
    } else if (wasConnected && !isConnected) {
      _handleConnectionLost();
    }

    log('Connectivity changed: $isConnected (${_connectionType.value})');
  }

  /// Handle connection restored
  void _handleConnectionRestored() {
    _hideOfflineBanner();
    _isRetrying.value = false;

    // Show success message
    Get.showSnackbar(GetSnackBar(
      title: 'connected'.tr,
      message: 'connection_restored'.tr,
      icon: const Icon(Icons.wifi, color: Colors.white),
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.TOP,
    ));
  }

  /// Handle connection lost
  void _handleConnectionLost() {
    _showOfflineBanner.value = true;

    // Auto-hide banner after 10 seconds
    _bannerTimer?.cancel();
    _bannerTimer = Timer(const Duration(seconds: 10), () {
      _hideOfflineBanner();
    });

    // Show error message
    Get.showSnackbar(GetSnackBar(
      title: 'no_internet'.tr,
      message: 'check_internet_connection'.tr,
      icon: const Icon(Icons.wifi_off, color: Colors.white),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.TOP,
    ));
  }

  /// Show offline banner manually
  void displayOfflineBanner() {
    if (!_isConnected.value) {
      _showOfflineBanner.value = true;
    }
  }

  /// Hide offline banner
  void _hideOfflineBanner() {
    _showOfflineBanner.value = false;
    _bannerTimer?.cancel();
  }

  /// Hide offline banner manually
  void hideOfflineBanner() {
    _hideOfflineBanner();
  }

  /// Retry connection
  Future<void> retryConnection() async {
    if (_isRetrying.value) return;

    try {
      _isRetrying.value = true;

      // Show loading message
      Get.showSnackbar(GetSnackBar(
        title: 'connecting'.tr,
        message: 'please_wait'.tr,
        icon: const Icon(Icons.wifi_find, color: Colors.white),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      ));

      // Attempt to reconnect using service
      final success = await _connectivityService.retryConnection();

      if (!success) {
        // Show retry failed message
        Get.showSnackbar(GetSnackBar(
          title: 'connection_failed'.tr,
          message: 'please_try_again_later'.tr,
          icon: const Icon(Icons.wifi_off, color: Colors.white),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.TOP,
        ));
      }
    } catch (e) {
      log('Retry connection error: $e');
    } finally {
      _isRetrying.value = false;
    }
  }

  /// Check connectivity manually
  Future<void> checkConnectivity() async {
    try {
      await _connectivityService.checkConnectivity();
      _updateFromService();
    } catch (e) {
      log('Check connectivity error: $e');
    }
  }

  /// Execute function only if connected
  Future<T?> executeIfConnected<T>(
      Future<T> Function() function, {
        bool showMessage = true,
        String? customMessage,
      }) async {
    if (_isConnected.value) {
      return await function();
    }

    if (showMessage) {
      Get.showSnackbar(GetSnackBar(
        title: 'no_internet'.tr,
        message: customMessage ?? 'feature_requires_internet'.tr,
        icon: const Icon(Icons.wifi_off, color: Colors.white),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.BOTTOM,
        mainButton: TextButton(
          onPressed: retryConnection,
          child: Text(
            'retry'.tr,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ));
    }

    return null;
  }

  /// Execute function with connectivity requirement and wait
  Future<T?> executeWithConnectivity<T>(
      Future<T> Function() function, {
        Duration? timeout,
        bool showMessage = true,
        String? customMessage,
      }) async {
    if (_isConnected.value) {
      return await function();
    }

    if (showMessage) {
      Get.showSnackbar(GetSnackBar(
        title: 'no_internet'.tr,
        message: customMessage ?? 'waiting_for_connection'.tr,
        icon: const Icon(Icons.wifi_find, color: Colors.white),
        backgroundColor: Colors.orange,
        duration: timeout ?? const Duration(seconds: 5),
        snackPosition: SnackPosition.BOTTOM,
      ));
    }

    // Wait for connection if timeout is specified
    if (timeout != null) {
      final hasConnection = await _connectivityService.waitForConnection(timeout: timeout);
      if (hasConnection) {
        return await function();
      }
    }

    return null;
  }

  /// Get connection status text
  String get connectionStatusText {
    if (_isConnected.value) {
      return '${'connected'.tr} (${_connectionType.value})';
    }
    return 'no_internet'.tr;
  }

  /// Get connection quality text
  String get connectionQualityText {
    switch (_connectionQuality.value) {
      case ConnectionQuality.excellent:
        return 'excellent'.tr;
      case ConnectionQuality.good:
        return 'good'.tr;
      case ConnectionQuality.fair:
        return 'fair'.tr;
      case ConnectionQuality.poor:
        return 'poor'.tr;
      case ConnectionQuality.none:
        return 'no_connection'.tr;
      case ConnectionQuality.unknown:
      default:
        return 'unknown'.tr;
    }
  }

  /// Get connection icon
  IconData get connectionIcon {
    if (!_isConnected.value) {
      return Icons.wifi_off;
    }

    switch (_connectionQuality.value) {
      case ConnectionQuality.excellent:
        return Icons.wifi;
      case ConnectionQuality.good:
        return Icons.wifi;
      case ConnectionQuality.fair:
        return Icons.wifi_2_bar;
      case ConnectionQuality.poor:
        return Icons.wifi_1_bar;
      default:
        return Icons.wifi_find;
    }
  }

  /// Get connection color
  Color get connectionColor {
    if (!_isConnected.value) {
      return Colors.red;
    }

    switch (_connectionQuality.value) {
      case ConnectionQuality.excellent:
      case ConnectionQuality.good:
        return Colors.green;
      case ConnectionQuality.fair:
        return Colors.orange;
      case ConnectionQuality.poor:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// Check if using mobile data
  bool get isMobileData => _connectivityService.isMobileData;

  /// Check if using WiFi
  bool get isWiFi => _connectivityService.isWiFi;

  /// Check if connection is metered
  bool get isMeteredConnection => _connectivityService.isMeteredConnection;

  /// Get detailed connection info
  Map<String, dynamic> get connectionInfo => {
    'isConnected': _isConnected.value,
    'connectionType': _connectionType.value,
    'connectionQuality': _connectionQuality.value.toString(),
    'qualityText': connectionQualityText,
    'statusText': connectionStatusText,
    'isMobileData': isMobileData,
    'isWiFi': isWiFi,
    'isMetered': isMeteredConnection,
    'isRetrying': _isRetrying.value,
    'showBanner': _showOfflineBanner.value,
  };

  /// Force refresh connectivity status
  Future<void> refreshStatus() async {
    await checkConnectivity();
  }

  /// Show connection details dialog
  void showConnectionDetails() {
    Get.dialog(
      AlertDialog(
        title: Text('connection_details'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('status'.tr, connectionStatusText),
            _buildDetailRow('quality'.tr, connectionQualityText),
            _buildDetailRow('type'.tr, _connectionType.value),
            if (isMobileData) _buildDetailRow('data_usage'.tr, 'metered'.tr),
            if (isWiFi) _buildDetailRow('network'.tr, 'wifi'.tr),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('close'.tr),
          ),
          if (!_isConnected.value)
            ElevatedButton(
              onPressed: () {
                Get.back();
                retryConnection();
              },
              child: Text('retry'.tr),
            ),
        ],
      ),
    );
  }

  /// Build detail row for dialog
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value),
        ],
      ),
    );
  }

  /// Get service statistics
  Map<String, dynamic> get serviceStatistics => _connectivityService.getConnectionInfo();
}

