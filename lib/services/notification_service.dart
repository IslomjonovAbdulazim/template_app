import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import '../constants/app_constants.dart';
import '../models/response_model.dart';
import 'api_service.dart';
import 'storage_service.dart';

/// Service for handling push notifications and local notifications
class NotificationService extends GetxService {
  static NotificationService get instance => Get.find<NotificationService>();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  final ApiService _apiService = ApiService.instance;
  final StorageService _storageService = StorageService.instance;

  // Reactive variables
  final _isInitialized = false.obs;
  final _fcmToken = ''.obs;
  final _notificationPermissionGranted = false.obs;
  final _unreadCount = 0.obs;

  // Notification channels
  static const String _defaultChannelId = AppConstants.notificationChannelId;
  static const String _defaultChannelName = AppConstants.notificationChannelName;
  static const String _defaultChannelDescription = AppConstants.notificationChannelDesc;

  // Getters
  bool get isInitialized => _isInitialized.value;
  String get fcmToken => _fcmToken.value;
  bool get hasPermission => _notificationPermissionGranted.value;
  int get unreadCount => _unreadCount.value;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeNotifications();
    log('NotificationService initialized');
  }

  /// Initialize notification service
  Future<void> _initializeNotifications() async {
    try {
      // Initialize timezone for scheduled notifications
      await _initializeTimezone();

      // Initialize local notifications
      await _initializeLocalNotifications();

      // Initialize Firebase messaging
      await _initializeFirebaseMessaging();

      // Request permissions
      await _requestPermissions();

      // Setup message handlers
      _setupMessageHandlers();

      // Get and store FCM token
      await _getFCMToken();

      _isInitialized.value = true;
      log('Notifications initialized successfully');
    } catch (e) {
      log('Failed to initialize notifications: $e');
    }
  }

  /// Initialize timezone for scheduled notifications
  Future<void> _initializeTimezone() async {
    try {
      // Note: You might need to initialize timezone data
      // tz.initializeTimeZones();
      // For now, we'll use the local timezone
      log('Timezone initialized');
    } catch (e) {
      log('Failed to initialize timezone: $e');
    }
  }

  /// Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channels for Android
    if (Platform.isAndroid) {
      await _createNotificationChannels();
    }
  }

  /// Create notification channels for Android
  Future<void> _createNotificationChannels() async {
    const AndroidNotificationChannel defaultChannel = AndroidNotificationChannel(
      _defaultChannelId,
      _defaultChannelName,
      description: _defaultChannelDescription,
      importance: Importance.high,
      enableVibration: true,
      enableLights: true,
      ledColor: Color(0xFF3B82F6),
    );

    const AndroidNotificationChannel highPriorityChannel = AndroidNotificationChannel(
      'high_priority',
      'High Priority Notifications',
      description: 'Important notifications that require immediate attention',
      importance: Importance.max,
      enableVibration: true,
      enableLights: true,
      playSound: true,
    );

    const AndroidNotificationChannel silentChannel = AndroidNotificationChannel(
      'silent',
      'Silent Notifications',
      description: 'Notifications without sound or vibration',
      importance: Importance.low,
      enableVibration: false,
      enableLights: false,
      playSound: false,
    );

    final androidPlugin = _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(defaultChannel);
      await androidPlugin.createNotificationChannel(highPriorityChannel);
      await androidPlugin.createNotificationChannel(silentChannel);
    }
  }

  /// Initialize Firebase messaging
  Future<void> _initializeFirebaseMessaging() async {
    // Configure Firebase messaging settings
    await _firebaseMessaging.setAutoInitEnabled(true);

    // Set foreground notification presentation options for iOS
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// Request notification permissions
  Future<void> _requestPermissions() async {
    try {
      // Request notification permission
      final permission = await Permission.notification.request();
      _notificationPermissionGranted.value = permission.isGranted;

      // Request Firebase messaging permission
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        log('Notification permissions granted');
        _notificationPermissionGranted.value = true;
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        log('Provisional notification permissions granted');
        _notificationPermissionGranted.value = true;
      } else {
        log('Notification permissions denied');
        _notificationPermissionGranted.value = false;
      }
    } catch (e) {
      log('Failed to request notification permissions: $e');
      _notificationPermissionGranted.value = false;
    }
  }

  /// Setup message handlers
  void _setupMessageHandlers() {
    // Handle messages when app is in foreground
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle messages when app is opened from background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    // Handle messages when app is opened from terminated state
    _handleInitialMessage();
  }

  /// Handle foreground messages
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    log('Received foreground message: ${message.messageId}');

    // Show local notification for foreground messages
    await _showLocalNotification(message);

    // Update unread count
    _incrementUnreadCount();

    // Handle message data
    _handleMessageData(message);
  }

  /// Handle message when app is opened from background
  Future<void> _handleMessageOpenedApp(RemoteMessage message) async {
    log('App opened from background notification: ${message.messageId}');

    // Handle navigation based on message data
    _handleNotificationNavigation(message);

    // Mark as read
    _decrementUnreadCount();
  }

  /// Handle initial message when app is opened from terminated state
  Future<void> _handleInitialMessage() async {
    final RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();

    if (initialMessage != null) {
      log('App opened from terminated state: ${initialMessage.messageId}');
      _handleNotificationNavigation(initialMessage);
    }
  }

  /// Handle notification data
  void _handleMessageData(RemoteMessage message) {
    final data = message.data;

    // Handle different types of notifications
    final type = data['type'] as String?;

    switch (type) {
      case 'chat_message':
        _handleChatMessage(data);
        break;
      case 'friend_request':
        _handleFriendRequest(data);
        break;
      case 'system_update':
        _handleSystemUpdate(data);
        break;
      default:
        log('Unknown notification type: $type');
    }
  }

  /// Handle chat message notification
  void _handleChatMessage(Map<String, dynamic> data) {
    // Implementation for chat message handling
    log('Handling chat message notification');
  }

  /// Handle friend request notification
  void _handleFriendRequest(Map<String, dynamic> data) {
    // Implementation for friend request handling
    log('Handling friend request notification');
  }

  /// Handle system update notification
  void _handleSystemUpdate(Map<String, dynamic> data) {
    // Implementation for system update handling
    log('Handling system update notification');
  }

  /// Handle notification navigation
  void _handleNotificationNavigation(RemoteMessage message) {
    final data = message.data;
    final route = data['route'] as String?;
    final arguments = data['arguments'] as String?;

    if (route != null) {
      Map<String, dynamic>? args;
      if (arguments != null) {
        try {
          args = json.decode(arguments) as Map<String, dynamic>;
        } catch (e) {
          log('Failed to parse notification arguments: $e');
        }
      }

      // Navigate to specified route
      Get.toNamed(route, arguments: args);
      log('Navigated to: $route');
    }
  }

  /// Show local notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    const androidDetails = AndroidNotificationDetails(
      _defaultChannelId,
      _defaultChannelName,
      channelDescription: _defaultChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
      enableVibration: true,
      enableLights: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      message.hashCode,
      notification.title,
      notification.body,
      notificationDetails,
      payload: json.encode(message.data),
    );
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    final payload = response.payload;
    if (payload != null) {
      try {
        final data = json.decode(payload) as Map<String, dynamic>;
        final route = data['route'] as String?;

        if (route != null) {
          Get.toNamed(route, arguments: data);
        }

        _decrementUnreadCount();
      } catch (e) {
        log('Failed to handle notification tap: $e');
      }
    }
  }

  /// Get FCM token
  Future<void> _getFCMToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      if (token != null) {
        _fcmToken.value = token;
        await _storageService.setFCMToken(token);
        log('FCM Token: $token');

        // Register token with backend
        await _registerTokenWithBackend(token);
      }

      // Listen for token refresh
      _firebaseMessaging.onTokenRefresh.listen((newToken) async {
        _fcmToken.value = newToken;
        await _storageService.setFCMToken(newToken);
        await _registerTokenWithBackend(newToken);
        log('FCM Token refreshed: $newToken');
      });
    } catch (e) {
      log('Failed to get FCM token: $e');
    }
  }

  /// Register FCM token with backend
  Future<void> _registerTokenWithBackend(String token) async {
    try {
      final response = await _apiService.post(
        '/notifications/register',
        data: {
          'fcm_token': token,
          'platform': Platform.isIOS ? 'ios' : 'android',
          'app_version': AppConstants.appVersion,
        },
        requiresAuth: true,
      );

      if (response.isSuccess) {
        log('FCM token registered with backend');
      } else {
        log('Failed to register FCM token: ${response.errorMessage}');
      }
    } catch (e) {
      log('Error registering FCM token: $e');
    }
  }

  /// Send local notification
  Future<void> sendLocalNotification({
    required String title,
    required String body,
    String? payload,
    String channelId = _defaultChannelId,
    NotificationPriority priority = NotificationPriority.normal,
  }) async {
    if (!_notificationPermissionGranted.value) {
      log('Notification permission not granted');
      return;
    }

    Importance importance;
    Priority androidPriority;

    switch (priority) {
      case NotificationPriority.low:
        importance = Importance.low;
        androidPriority = Priority.low;
        break;
      case NotificationPriority.high:
        importance = Importance.high;
        androidPriority = Priority.high;
        break;
      case NotificationPriority.max:
        importance = Importance.max;
        androidPriority = Priority.max;
        break;
      case NotificationPriority.normal:
      default:
        importance = Importance.defaultImportance;
        androidPriority = Priority.defaultPriority;
    }

    final androidDetails = AndroidNotificationDetails(
      channelId,
      _defaultChannelName,
      channelDescription: _defaultChannelDescription,
      importance: importance,
      priority: androidPriority,
      enableVibration: true,
      enableLights: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      notificationDetails,
      payload: payload,
    );

    _incrementUnreadCount();
  }

  /// Schedule local notification
  Future<void> scheduleLocalNotification({
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    String channelId = _defaultChannelId,
  }) async {
    if (!_notificationPermissionGranted.value) {
      log('Notification permission not granted');
      return;
    }

    const androidDetails = AndroidNotificationDetails(
      _defaultChannelId,
      _defaultChannelName,
      channelDescription: _defaultChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Convert DateTime to TZDateTime
    final tz.TZDateTime scheduledTZDate = tz.TZDateTime.from(scheduledDate, tz.local);

    await _localNotifications.zonedSchedule(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      scheduledTZDate,
      notificationDetails,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );

    log('Notification scheduled for: $scheduledDate');
  }

  /// Cancel notification
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
    _unreadCount.value = 0;
  }

  /// Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _localNotifications.pendingNotificationRequests();
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      log('Subscribed to topic: $topic');
    } catch (e) {
      log('Failed to subscribe to topic $topic: $e');
    }
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      log('Unsubscribed from topic: $topic');
    } catch (e) {
      log('Failed to unsubscribe from topic $topic: $e');
    }
  }

  /// Update notification preferences
  Future<ResponseModel<void>> updateNotificationPreferences({
    required bool pushEnabled,
    required bool emailEnabled,
    required bool smsEnabled,
    required bool marketingEnabled,
    required bool soundEnabled,
    required bool vibrationEnabled,
  }) async {
    try {
      final response = await _apiService.put(
        '/notifications/settings',
        data: {
          'push_enabled': pushEnabled,
          'email_enabled': emailEnabled,
          'sms_enabled': smsEnabled,
          'marketing_enabled': marketingEnabled,
          'sound_enabled': soundEnabled,
          'vibration_enabled': vibrationEnabled,
        },
        requiresAuth: true,
      );

      if (response.isSuccess) {
        // Store preferences locally
        await _storageService.setBool('push_notifications_enabled', pushEnabled);
        await _storageService.setBool('notification_sound_enabled', soundEnabled);
        await _storageService.setBool('notification_vibration_enabled', vibrationEnabled);

        log('Notification preferences updated');
        return ResponseModel.success(message: 'Preferences updated successfully');
      }

      return ResponseModel.error(
        message: response.errorMessage,
        code: response.code,
      );
    } catch (e) {
      log('Failed to update notification preferences: $e');
      return ResponseModel.error(message: 'Failed to update preferences');
    }
  }

  /// Check if notifications are enabled locally
  bool get areNotificationsEnabled {
    return _storageService.getBool('push_notifications_enabled', defaultValue: true);
  }

  /// Check if notification sound is enabled
  bool get isSoundEnabled {
    return _storageService.getBool('notification_sound_enabled', defaultValue: true);
  }

  /// Check if notification vibration is enabled
  bool get isVibrationEnabled {
    return _storageService.getBool('notification_vibration_enabled', defaultValue: true);
  }

  /// Increment unread count
  void _incrementUnreadCount() {
    _unreadCount.value++;
  }

  /// Decrement unread count
  void _decrementUnreadCount() {
    if (_unreadCount.value > 0) {
      _unreadCount.value--;
    }
  }

  /// Reset unread count
  void resetUnreadCount() {
    _unreadCount.value = 0;
  }

  /// Get notification settings info
  Map<String, dynamic> getNotificationInfo() {
    return {
      'isInitialized': _isInitialized.value,
      'hasPermission': _notificationPermissionGranted.value,
      'fcmToken': _fcmToken.value,
      'unreadCount': _unreadCount.value,
      'notificationsEnabled': areNotificationsEnabled,
      'soundEnabled': isSoundEnabled,
      'vibrationEnabled': isVibrationEnabled,
    };
  }

  /// Request permission manually
  Future<bool> requestPermission() async {
    await _requestPermissions();
    return _notificationPermissionGranted.value;
  }

  /// Open notification settings
  Future<void> openNotificationSettings() async {
    await openAppSettings();
  }
}

/// Notification priority levels
enum NotificationPriority {
  low,
  normal,
  high,
  max,
}

/// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log('Handling background message: ${message.messageId}');

  // Handle background message processing here
  // Note: You cannot use GetX or other context-dependent features here
}