import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import '../constants/api_constants.dart';
import '../constants/app_constants.dart';
import '../models/response_model.dart';
import 'connectivity_service.dart';
import 'storage_service.dart';

/// Service for handling all HTTP requests with comprehensive error handling
class ApiService extends getx.GetxService {
  static ApiService get instance => getx.Get.find<ApiService>();

  late Dio _dio;
  final CancelToken _cancelToken = CancelToken();

  // Request queue for offline support
  final List<QueuedRequest> _requestQueue = [];
  bool _isProcessingQueue = false;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeDio();
    _setupInterceptors();
    log('ApiService initialized');
  }

  @override
  void onClose() {
    _cancelToken.cancel();
    _dio.close();
    super.onClose();
  }

  /// Initialize Dio with base configuration
  Future<void> _initializeDio() async {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.currentBaseUrl,
      connectTimeout: const Duration(milliseconds: AppConstants.connectionTimeout),
      receiveTimeout: const Duration(milliseconds: AppConstants.receiveTimeout),
      sendTimeout: const Duration(milliseconds: AppConstants.sendTimeout),
      headers: ApiConstants.getDefaultHeaders(),
      responseType: ResponseType.json,
      followRedirects: true,
      maxRedirects: 3,
    ));
  }

  /// Setup Dio interceptors for logging, auth, and error handling
  void _setupInterceptors() {
    // Request interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add authorization token if available
        final token = await StorageService.instance.getAccessToken();
        if (token != null) {
          options.headers[ApiConstants.authorization] = ApiConstants.getBearerToken(token);
        }

        // Add device information
        final deviceId = StorageService.instance.getDeviceId();
        if (deviceId != null) {
          options.headers[ApiConstants.deviceId] = deviceId;
        }

        // Add app version
        options.headers[ApiConstants.appVersionHeader] = AppConstants.appVersion;

        // Add language
        final language = StorageService.instance.getLanguage();
        options.headers[ApiConstants.language] = language;

        log('API Request: ${options.method} ${options.uri}');
        if (AppConstants.enableLogging) {
          log('Headers: ${options.headers}');
          if (options.data != null) log('Data: ${options.data}');
        }

        handler.next(options);
      },

      onResponse: (response, handler) {
        log('API Response: ${response.statusCode} ${response.requestOptions.uri}');
        if (AppConstants.enableLogging) {
          log('Response Data: ${response.data}');
        }
        handler.next(response);
      },

      onError: (error, handler) async {
        log('API Error: ${error.message}');

        // Handle token refresh for 401 errors
        if (error.response?.statusCode == ApiConstants.unauthorized) {
          final refreshed = await _handleTokenRefresh(error.requestOptions);
          if (refreshed != null) {
            return handler.resolve(refreshed);
          }
        }

        handler.next(error);
      },
    ));

    // Logging interceptor (only in debug mode)
    if (AppConstants.enableLogging) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        logPrint: (object) => log(object.toString()),
      ));
    }
  }

  /// Handle token refresh for expired tokens
  Future<Response?> _handleTokenRefresh(RequestOptions requestOptions) async {
    try {
      final refreshToken = await StorageService.instance.getRefreshToken();
      if (refreshToken == null) {
        await _handleLogout();
        return null;
      }

      // Create new Dio instance to avoid interceptor conflicts
      final refreshDio = Dio();
      final response = await refreshDio.post(
        ApiConstants.getFullUrl(ApiConstants.refreshToken),
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == ApiConstants.ok) {
        final newToken = response.data['access_token'] as String?;
        if (newToken != null) {
          await StorageService.instance.setAccessToken(newToken);

          // Retry original request with new token
          requestOptions.headers[ApiConstants.authorization] = ApiConstants.getBearerToken(newToken);
          return await _dio.fetch(requestOptions);
        }
      }
    } catch (e) {
      log('Token refresh failed: $e');
      await _handleLogout();
    }

    return null;
  }

  /// Handle logout when token refresh fails
  Future<void> _handleLogout() async {
    await StorageService.instance.clearTokens();
    // Navigate to login - this would be handled by AuthController
    // getx.Get.offAllNamed('/login');
  }

  /// Generic GET request
  Future<ResponseModel<T>> get<T>(
      String endpoint, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        T Function(dynamic)? fromJson,
        bool requiresAuth = true,
        bool queueIfOffline = false,
      }) async {
    try {
      // Check connectivity if required
      if (!ConnectivityHelper.isConnected) {
        if (queueIfOffline) {
          _queueRequest('GET', endpoint, queryParameters: queryParameters);
          return ResponseModel.networkError('Request queued for when connection is restored');
        }
        return ResponseModel.networkError();
      }

      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options,
        cancelToken: _cancelToken,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleDioError<T>(e);
    } catch (e) {
      log('Unexpected error in GET request: $e');
      return ResponseModel.error(message: 'Unexpected error occurred');
    }
  }

  /// Generic POST request
  Future<ResponseModel<T>> post<T>(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        T Function(dynamic)? fromJson,
        bool requiresAuth = true,
        bool queueIfOffline = false,
      }) async {
    try {
      // Check connectivity if required
      if (!ConnectivityHelper.isConnected) {
        if (queueIfOffline) {
          _queueRequest('POST', endpoint, data: data, queryParameters: queryParameters);
          return ResponseModel.networkError('Request queued for when connection is restored');
        }
        return ResponseModel.networkError();
      }

      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: _cancelToken,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleDioError<T>(e);
    } catch (e) {
      log('Unexpected error in POST request: $e');
      return ResponseModel.error(message: 'Unexpected error occurred');
    }
  }

  /// Generic PUT request
  Future<ResponseModel<T>> put<T>(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        T Function(dynamic)? fromJson,
        bool requiresAuth = true,
        bool queueIfOffline = false,
      }) async {
    try {
      // Check connectivity if required
      if (!ConnectivityHelper.isConnected) {
        if (queueIfOffline) {
          _queueRequest('PUT', endpoint, data: data, queryParameters: queryParameters);
          return ResponseModel.networkError('Request queued for when connection is restored');
        }
        return ResponseModel.networkError();
      }

      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: _cancelToken,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleDioError<T>(e);
    } catch (e) {
      log('Unexpected error in PUT request: $e');
      return ResponseModel.error(message: 'Unexpected error occurred');
    }
  }

  /// Generic DELETE request
  Future<ResponseModel<T>> delete<T>(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        T Function(dynamic)? fromJson,
        bool requiresAuth = true,
        bool queueIfOffline = false,
      }) async {
    try {
      // Check connectivity if required
      if (!ConnectivityHelper.isConnected) {
        if (queueIfOffline) {
          _queueRequest('DELETE', endpoint, data: data, queryParameters: queryParameters);
          return ResponseModel.networkError('Request queued for when connection is restored');
        }
        return ResponseModel.networkError();
      }

      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: _cancelToken,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleDioError<T>(e);
    } catch (e) {
      log('Unexpected error in DELETE request: $e');
      return ResponseModel.error(message: 'Unexpected error occurred');
    }
  }

  /// Upload file with progress tracking
  Future<ResponseModel<T>> uploadFile<T>(
      String endpoint,
      File file, {
        String fieldName = 'file',
        Map<String, dynamic>? additionalData,
        ProgressCallback? onSendProgress,
        T Function(dynamic)? fromJson,
      }) async {
    try {
      if (!ConnectivityHelper.isConnected) {
        return ResponseModel.networkError();
      }

      final fileName = file.path.split('/').last;
      final formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(file.path, filename: fileName),
        ...?additionalData,
      });

      final response = await _dio.post(
        endpoint,
        data: formData,
        options: Options(
          headers: {ApiConstants.contentType: ApiConstants.multipartFormData},
        ),
        onSendProgress: onSendProgress,
        cancelToken: _cancelToken,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleDioError<T>(e);
    } catch (e) {
      log('Unexpected error in file upload: $e');
      return ResponseModel.error(message: 'File upload failed');
    }
  }

  /// Download file with progress tracking
  Future<ResponseModel<String>> downloadFile(
      String url,
      String savePath, {
        ProgressCallback? onReceiveProgress,
        CancelToken? cancelToken,
      }) async {
    try {
      if (!ConnectivityHelper.isConnected) {
        return ResponseModel.networkError();
      }

      await _dio.download(
        url,
        savePath,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken ?? _cancelToken,
      );

      return ResponseModel.success(data: savePath, message: 'File downloaded successfully');
    } on DioException catch (e) {
      return _handleDioError<String>(e);
    } catch (e) {
      log('Unexpected error in file download: $e');
      return ResponseModel.error(message: 'File download failed');
    }
  }

  /// Request with retry mechanism
  Future<ResponseModel<T>> requestWithRetry<T>(
      Future<ResponseModel<T>> Function() request, {
        int maxRetries = AppConstants.maxRetryAttempts,
        Duration delay = const Duration(milliseconds: AppConstants.retryDelay),
      }) async {
    int attempts = 0;

    while (attempts < maxRetries) {
      try {
        final result = await request();

        // If successful or client error (4xx), don't retry
        if (result.isSuccess || result.isClientError) {
          return result;
        }

        attempts++;
        if (attempts < maxRetries) {
          log('Request failed, retrying in ${delay.inMilliseconds}ms (attempt $attempts/$maxRetries)');
          await Future.delayed(delay);
          // Exponential backoff
          delay = Duration(milliseconds: (delay.inMilliseconds * 1.5).round());
        }
      } catch (e) {
        attempts++;
        if (attempts >= maxRetries) {
          log('Max retry attempts reached: $e');
          return ResponseModel.error(message: 'Request failed after $maxRetries attempts');
        }
        await Future.delayed(delay);
      }
    }

    return ResponseModel.error(message: 'Request failed after $maxRetries attempts');
  }

  /// Handle successful response
  ResponseModel<T> _handleResponse<T>(Response response, T Function(dynamic)? fromJson) {
    try {
      final data = response.data;

      // If response is already in our ResponseModel format
      if (data is Map<String, dynamic> && data.containsKey(ApiConstants.success)) {
        return ResponseModel.fromJson(data, (json) {
          if (fromJson != null && json != null) {
            return fromJson(json);
          }
          return json as T;
        });
      }

      // If response is direct data
      final responseData = fromJson != null ? fromJson(data) : data as T;
      return ResponseModel.success(
        data: responseData,
        code: response.statusCode,
        message: 'Request successful',
      );
    } catch (e) {
      log('Error parsing response: $e');
      return ResponseModel.error(
        message: 'Failed to parse response',
        code: response.statusCode,
      );
    }
  }

  /// Handle Dio errors and convert to ResponseModel
  ResponseModel<T> _handleDioError<T>(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ResponseModel.timeout('Request timeout. Please try again.');

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 0;
        final responseData = error.response?.data;

        // Try to parse error response
        if (responseData != null && responseData is Map<String, dynamic>) {
          return ResponseModel<T>.fromJson(responseData, (json) {
            // For error responses, we don't expect valid data, so return null as T
            return null as T;
          });
        }

        return ResponseModel.error(
          message: _getErrorMessage(statusCode),
          code: statusCode,
        );

      case DioExceptionType.cancel:
        return ResponseModel.error(message: 'Request cancelled');

      case DioExceptionType.connectionError:
        return ResponseModel.networkError('Connection error. Please check your internet connection.');

      case DioExceptionType.badCertificate:
        return ResponseModel.error(message: 'Security certificate error');

      case DioExceptionType.unknown:
      default:
        if (error.error is SocketException) {
          return ResponseModel.networkError();
        }
        return ResponseModel.error(message: error.message ?? 'Unknown error occurred');
    }
  }

  /// Get error message based on status code
  String _getErrorMessage(int statusCode) {
    switch (statusCode) {
      case ApiConstants.badRequest:
        return 'Invalid request. Please check your input.';
      case ApiConstants.unauthorized:
        return 'Session expired. Please login again.';
      case ApiConstants.forbidden:
        return 'Access denied. You don\'t have permission.';
      case ApiConstants.notFound:
        return 'Requested resource not found.';
      case ApiConstants.methodNotAllowed:
        return 'Operation not allowed.';
      case ApiConstants.conflict:
        return 'Conflict occurred. Please try again.';
      case ApiConstants.unprocessableEntity:
        return 'Invalid data provided.';
      case ApiConstants.tooManyRequests:
        return 'Too many requests. Please try again later.';
      case ApiConstants.internalServerError:
        return 'Server error. Please try again later.';
      case ApiConstants.badGateway:
        return 'Service unavailable. Please try again later.';
      case ApiConstants.serviceUnavailable:
        return 'Service temporarily unavailable.';
      case ApiConstants.gatewayTimeout:
        return 'Server timeout. Please try again.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }

  /// Queue request for offline execution
  void _queueRequest(
      String method,
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
      }) {
    _requestQueue.add(QueuedRequest(
      method: method,
      endpoint: endpoint,
      data: data,
      queryParameters: queryParameters,
      timestamp: DateTime.now(),
    ));

    log('Request queued: $method $endpoint (Queue size: ${_requestQueue.length})');
  }

  /// Process queued requests when connection is restored
  Future<void> processQueuedRequests() async {
    if (_isProcessingQueue || _requestQueue.isEmpty) return;

    _isProcessingQueue = true;
    log('Processing ${_requestQueue.length} queued requests');

    final requestsToProcess = List<QueuedRequest>.from(_requestQueue);
    _requestQueue.clear();

    for (final request in requestsToProcess) {
      try {
        switch (request.method) {
          case 'GET':
            await get(request.endpoint, queryParameters: request.queryParameters);
            break;
          case 'POST':
            await post(request.endpoint, data: request.data, queryParameters: request.queryParameters);
            break;
          case 'PUT':
            await put(request.endpoint, data: request.data, queryParameters: request.queryParameters);
            break;
          case 'DELETE':
            await delete(request.endpoint, data: request.data, queryParameters: request.queryParameters);
            break;
        }
        log('Processed queued request: ${request.method} ${request.endpoint}');
      } catch (e) {
        log('Failed to process queued request: ${request.method} ${request.endpoint} - $e');
      }
    }

    _isProcessingQueue = false;
    log('Finished processing queued requests');
  }

  /// Cancel all ongoing requests
  void cancelRequests() {
    _cancelToken.cancel('Requests cancelled');
    log('All ongoing requests cancelled');
  }

  /// Update base URL
  void updateBaseUrl(String newBaseUrl) {
    _dio.options.baseUrl = newBaseUrl;
    log('Base URL updated to: $newBaseUrl');
  }

  /// Get current configuration info
  Map<String, dynamic> getConfigInfo() {
    return {
      'baseUrl': _dio.options.baseUrl,
      'connectTimeout': _dio.options.connectTimeout?.inMilliseconds,
      'receiveTimeout': _dio.options.receiveTimeout?.inMilliseconds,
      'sendTimeout': _dio.options.sendTimeout?.inMilliseconds,
      'queuedRequests': _requestQueue.length,
      'isProcessingQueue': _isProcessingQueue,
    };
  }
}

/// Model for queued requests
class QueuedRequest {
  final String method;
  final String endpoint;
  final dynamic data;
  final Map<String, dynamic>? queryParameters;
  final DateTime timestamp;

  QueuedRequest({
    required this.method,
    required this.endpoint,
    this.data,
    this.queryParameters,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'QueuedRequest(method: $method, endpoint: $endpoint, timestamp: $timestamp)';
  }
}