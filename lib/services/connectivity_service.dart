import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Service for monitoring network connectivity status
/// Provides real-time connectivity updates and connection testing
class ConnectivityService extends GetxService {
  static ConnectivityService get instance => Get.find<ConnectivityService>();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  // Reactive variables
  final _connectionStatus = ConnectivityResult.none.obs;
  final _isConnected = false.obs;
  final _connectionType = ''.obs;
  final _connectionQuality = ConnectionQuality.unknown.obs;

  // Controllers for stream broadcasting
  final _connectionController = StreamController<bool>.broadcast();
  final _statusController = StreamController<ConnectivityResult>.broadcast();

  // Connection test configuration
  static const String _testHost = 'google.com';
  static const int _testPort = 443;
  static const Duration _testTimeout = Duration(seconds: 10);
  static const Duration _checkInterval = Duration(seconds: 30);

  Timer? _periodicCheck;
  DateTime? _lastConnectedTime;
  DateTime? _lastDisconnectedTime;
  int _reconnectAttempts = 0;

  // Getters for reactive values
  ConnectivityResult get connectionStatus => _connectionStatus.value;
  bool get isConnected => _isConnected.value;
  String get connectionType => _connectionType.value;
  ConnectionQuality get connectionQuality => _connectionQuality.value;

  // Streams for external listening
  Stream<bool> get connectionStream => _connectionController.stream;
  Stream<ConnectivityResult> get statusStream => _statusController.stream;

  // Connection statistics
  Duration? get timeSinceLastConnection {
    if (_lastConnectedTime == null) return null;
    return DateTime.now().difference(_lastConnectedTime!);
  }

  Duration? get timeSinceLastDisconnection {
    if (_lastDisconnectedTime == null) return null;
    return DateTime.now().difference(_lastDisconnectedTime!);
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeConnectivity();
    _startConnectivityListener();
    _startPeriodicCheck();
    log('ConnectivityService initialized');
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    _periodicCheck?.cancel();
    _connectionController.close();
    _statusController.close();
    super.onClose();
  }

  /// Initialize connectivity status
  Future<void> _initializeConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      await _updateConnectionStatus(results);
    } catch (e) {
      log('Failed to initialize connectivity: $e');
      await _updateConnectionStatus([ConnectivityResult.none]);
    }
  }

  /// Start listening to connectivity changes
  void _startConnectivityListener() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
          (List<ConnectivityResult> results) async {
        await _updateConnectionStatus(results);
      },
      onError: (error) {
        log('Connectivity stream error: $error');
      },
    );
  }

  /// Start periodic connectivity check
  void _startPeriodicCheck() {
    _periodicCheck = Timer.periodic(_checkInterval, (timer) async {
      if (_connectionStatus.value != ConnectivityResult.none) {
        // Just verify connection, don't update status here since we only want to check internet
        await _verifyInternetConnection();
      }
    });
  }

  /// Update connection status and notify listeners
  Future<void> _updateConnectionStatus(List<ConnectivityResult> results) async {
    final wasConnected = _isConnected.value;

    // Get the primary connection result (prioritize non-none results)
    final primaryResult = _getPrimaryConnectionResult(results);
    _connectionStatus.value = primaryResult;

    // Update connection type
    _connectionType.value = _getConnectionTypeString(primaryResult);

    // Verify actual internet connectivity
    final hasInternet = await _verifyInternetConnection();
    _isConnected.value = hasInternet;

    // Update connection quality
    if (hasInternet) {
      _connectionQuality.value = await _measureConnectionQuality();
    } else {
      _connectionQuality.value = ConnectionQuality.none;
    }

    // Track connection state changes
    if (!wasConnected && _isConnected.value) {
      _lastConnectedTime = DateTime.now();
      _reconnectAttempts = 0;
      log('Internet connection established: ${_connectionType.value}');
    } else if (wasConnected && !_isConnected.value) {
      _lastDisconnectedTime = DateTime.now();
      log('Internet connection lost');
    }

    // Broadcast changes
    _connectionController.add(_isConnected.value);
    _statusController.add(primaryResult);

    // Update helper class
    ConnectivityHelper.updateStatus(_isConnected.value);
  }

  /// Get primary connection result from list (prioritize non-none results)
  ConnectivityResult _getPrimaryConnectionResult(List<ConnectivityResult> results) {
    if (results.isEmpty) return ConnectivityResult.none;

    // Prioritize connections in order: wifi, ethernet, mobile, vpn, bluetooth, other
    const priority = [
      ConnectivityResult.wifi,
      ConnectivityResult.ethernet,
      ConnectivityResult.mobile,
      ConnectivityResult.vpn,
      ConnectivityResult.bluetooth,
      ConnectivityResult.other,
    ];

    for (final preferredResult in priority) {
      if (results.contains(preferredResult)) {
        return preferredResult;
      }
    }

    // If none of the preferred results are found, return the first result
    return results.first;
  }

  /// Verify actual internet connectivity by attempting to connect to a host
  Future<bool> _verifyInternetConnection() async {
    if (_connectionStatus.value == ConnectivityResult.none) {
      return false;
    }

    try {
      final stopwatch = Stopwatch()..start();
      final socket = await Socket.connect(_testHost, _testPort, timeout: _testTimeout);
      socket.destroy();
      stopwatch.stop();

      // Log connection test time for quality assessment
      final responseTime = stopwatch.elapsedMilliseconds;
      log('Internet connectivity verified in ${responseTime}ms');

      return true;
    } catch (e) {
      log('Internet connectivity test failed: $e');
      return false;
    }
  }

  /// Measure connection quality based on response time
  Future<ConnectionQuality> _measureConnectionQuality() async {
    if (!_isConnected.value) return ConnectionQuality.none;

    try {
      final stopwatch = Stopwatch()..start();
      final socket = await Socket.connect(_testHost, _testPort, timeout: _testTimeout);
      socket.destroy();
      stopwatch.stop();

      final responseTime = stopwatch.elapsedMilliseconds;

      if (responseTime < 100) {
        return ConnectionQuality.excellent;
      } else if (responseTime < 300) {
        return ConnectionQuality.good;
      } else if (responseTime < 1000) {
        return ConnectionQuality.fair;
      } else {
        return ConnectionQuality.poor;
      }
    } catch (e) {
      log('Connection quality test failed: $e');
      return ConnectionQuality.unknown;
    }
  }

  /// Get human-readable connection type string
  String _getConnectionTypeString(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return 'WiFi';
      case ConnectivityResult.mobile:
        return 'Mobile Data';
      case ConnectivityResult.ethernet:
        return 'Ethernet';
      case ConnectivityResult.bluetooth:
        return 'Bluetooth';
      case ConnectivityResult.vpn:
        return 'VPN';
      case ConnectivityResult.other:
        return 'Other';
      case ConnectivityResult.none:
      default:
        return 'No Connection';
    }
  }

  /// Manual connectivity check
  Future<bool> checkConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      await _updateConnectionStatus(results);
      return _isConnected.value;
    } catch (e) {
      log('Manual connectivity check failed: $e');
      return false;
    }
  }

  /// Wait for internet connection
  Future<bool> waitForConnection({Duration? timeout}) async {
    if (_isConnected.value) return true;

    final completer = Completer<bool>();
    late StreamSubscription subscription;
    Timer? timeoutTimer;

    subscription = connectionStream.listen((isConnected) {
      if (isConnected) {
        subscription.cancel();
        timeoutTimer?.cancel();
        if (!completer.isCompleted) {
          completer.complete(true);
        }
      }
    });

    if (timeout != null) {
      timeoutTimer = Timer(timeout, () {
        subscription.cancel();
        if (!completer.isCompleted) {
          completer.complete(false);
        }
      });
    }

    return completer.future;
  }

  /// Retry connection with exponential backoff
  Future<bool> retryConnection({int maxAttempts = 3}) async {
    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      _reconnectAttempts = attempt;

      log('Reconnection attempt $attempt/$maxAttempts');

      final isConnected = await checkConnectivity();
      if (isConnected) {
        log('Reconnection successful on attempt $attempt');
        return true;
      }

      if (attempt < maxAttempts) {
        // Exponential backoff: 2^attempt seconds
        final delay = Duration(seconds: (2 * attempt));
        log('Waiting ${delay.inSeconds}s before next attempt');
        await Future.delayed(delay);
      }
    }

    log('Reconnection failed after $maxAttempts attempts');
    return false;
  }

  /// Get detailed connection information
  Map<String, dynamic> getConnectionInfo() {
    return {
      'isConnected': _isConnected.value,
      'connectionType': _connectionType.value,
      'connectionStatus': _connectionStatus.value.toString(),
      'connectionQuality': _connectionQuality.value.toString(),
      'lastConnectedTime': _lastConnectedTime?.toIso8601String(),
      'lastDisconnectedTime': _lastDisconnectedTime?.toIso8601String(),
      'timeSinceLastConnection': timeSinceLastConnection?.inSeconds,
      'timeSinceLastDisconnection': timeSinceLastDisconnection?.inSeconds,
      'reconnectAttempts': _reconnectAttempts,
    };
  }

  /// Check if connection type is mobile data
  bool get isMobileData => _connectionStatus.value == ConnectivityResult.mobile;

  /// Check if connection type is WiFi
  bool get isWiFi => _connectionStatus.value == ConnectivityResult.wifi;

  /// Check if connection is metered (mobile data or limited)
  bool get isMeteredConnection => isMobileData;

  /// Check if connection quality is good enough for heavy operations
  bool get isGoodQuality => _connectionQuality.value == ConnectionQuality.excellent ||
      _connectionQuality.value == ConnectionQuality.good;

  /// Show connection status message
  void showConnectionStatus() {
    if (_isConnected.value) {
      Get.showSnackbar(GetSnackBar(
        title: 'Connected',
        message: 'Internet connection restored via ${_connectionType.value}',
        icon: const Icon(Icons.wifi, color: Colors.white),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ));
    } else {
      Get.showSnackbar(GetSnackBar(
        title: 'No Internet',
        message: 'Please check your internet connection',
        icon: const Icon(Icons.wifi_off, color: Colors.white),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ));
    }
  }
}

/// Connection quality enumeration
enum ConnectionQuality {
  none,
  poor,
  fair,
  good,
  excellent,
  unknown,
}

/// Helper class for accessing connectivity status globally
class ConnectivityHelper {
  static bool _isConnected = false;

  /// Update connection status (called by ConnectivityService)
  static void updateStatus(bool isConnected) {
    _isConnected = isConnected;
  }

  /// Check if device is connected to internet
  static bool get isConnected => _isConnected;

  /// Check if device is offline
  static bool get isOffline => !_isConnected;

  /// Get connectivity service instance
  static ConnectivityService get service => ConnectivityService.instance;

  /// Quick connectivity check
  static Future<bool> checkConnection() async {
    return await service.checkConnectivity();
  }

  /// Execute function only if connected
  static Future<T?> executeIfConnected<T>(Future<T> Function() function) async {
    if (isConnected) {
      return await function();
    }
    return null;
  }

  /// Execute function with connectivity requirement
  static Future<T?> executeWithConnectivity<T>(
      Future<T> Function() function, {
        Duration? timeout,
        bool showMessage = true,
      }) async {
    if (isConnected) {
      return await function();
    }

    if (showMessage) {
      Get.showSnackbar(const GetSnackBar(
        title: 'No Internet',
        message: 'This feature requires an internet connection',
        icon: Icon(Icons.wifi_off, color: Colors.white),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 3),
      ));
    }

    // Wait for connection if timeout is specified
    if (timeout != null) {
      final hasConnection = await service.waitForConnection(timeout: timeout);
      if (hasConnection) {
        return await function();
      }
    }

    return null;
  }
}

/// Mixin for widgets that need connectivity awareness
mixin ConnectivityMixin {
  late StreamSubscription _connectivitySubscription;

  /// Initialize connectivity listener
  void initConnectivityListener({
    Function(bool isConnected)? onConnectionChanged,
    bool showSnackbars = true,
  }) {
    _connectivitySubscription = ConnectivityService.instance.connectionStream.listen(
          (isConnected) {
        if (showSnackbars) {
          ConnectivityService.instance.showConnectionStatus();
        }
        onConnectionChanged?.call(isConnected);
      },
    );
  }

  /// Dispose connectivity listener
  void disposeConnectivityListener() {
    _connectivitySubscription.cancel();
  }

  /// Check if connected before executing function
  Future<T?> executeIfConnected<T>(Future<T> Function() function) async {
    return await ConnectivityHelper.executeIfConnected(function);
  }
}