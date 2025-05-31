/// Generic response model for API responses with comprehensive error handling
class ResponseModel<T> {
  final bool success;
  final T? data;
  final String? message;
  final String? errorMessage;
  final int? code;
  final Map<String, dynamic>? meta;
  final List<String>? errors;

  ResponseModel._({
    required this.success,
    this.data,
    this.message,
    this.errorMessage,
    this.code,
    this.meta,
    this.errors,
  });

  /// Create a successful response
  factory ResponseModel.success({
    T? data,
    String? message,
    int? code,
    Map<String, dynamic>? meta,
  }) {
    return ResponseModel._(
      success: true,
      data: data,
      message: message,
      code: code ?? 200,
      meta: meta,
    );
  }

  /// Create an error response
  factory ResponseModel.error({
    String? message,
    int? code,
    List<String>? errors,
    Map<String, dynamic>? meta,
  }) {
    return ResponseModel._(
      success: false,
      errorMessage: message ?? 'An error occurred',
      code: code ?? 400,
      errors: errors,
      meta: meta,
    );
  }

  /// Create a network error response
  factory ResponseModel.networkError([String? message]) {
    return ResponseModel._(
      success: false,
      errorMessage: message ?? 'No internet connection',
      code: -1,
    );
  }

  /// Create a timeout error response
  factory ResponseModel.timeout([String? message]) {
    return ResponseModel._(
      success: false,
      errorMessage: message ?? 'Request timeout',
      code: 408,
    );
  }

  /// Create response from JSON
  factory ResponseModel.fromJson(
      Map<String, dynamic> json,
      T Function(dynamic)? fromJsonT,
      ) {
    try {
      final success = json['success'] as bool? ??
          json['status'] == 'success' ??
          (json['error'] == null);

      final message = json['message'] as String?;
      final code = json['code'] as int? ??
          json['status_code'] as int? ??
          json['statusCode'] as int?;

      if (success) {
        T? data;
        if (fromJsonT != null && json['data'] != null) {
          data = fromJsonT(json['data']);
        } else if (json['data'] != null) {
          data = json['data'] as T?;
        }

        return ResponseModel.success(
          data: data,
          message: message,
          code: code,
          meta: json['meta'] as Map<String, dynamic>?,
        );
      } else {
        final errorMessage = json['error'] as String? ??
            json['message'] as String? ??
            'Unknown error';

        final errors = (json['errors'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList();

        return ResponseModel.error(
          message: errorMessage,
          code: code,
          errors: errors,
          meta: json['meta'] as Map<String, dynamic>?,
        );
      }
    } catch (e) {
      return ResponseModel.error(
        message: 'Failed to parse response: $e',
        code: 500,
      );
    }
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      if (data != null) 'data': data,
      if (message != null) 'message': message,
      if (errorMessage != null) 'error': errorMessage,
      if (code != null) 'code': code,
      if (meta != null) 'meta': meta,
      if (errors != null) 'errors': errors,
    };
  }

  /// Getters for convenience
  bool get isSuccess => success;
  bool get isError => !success;
  bool get hasData => data != null;
  bool get hasMessage => message != null && message!.isNotEmpty;
  bool get hasErrorMessage => errorMessage != null && errorMessage!.isNotEmpty;
  bool get hasErrors => errors != null && errors!.isNotEmpty;

  /// Status code checks
  bool get isOk => code == 200;
  bool get isBadRequest => code == 400;
  bool get isUnauthorized => code == 401;
  bool get isForbidden => code == 403;
  bool get isNotFound => code == 404;
  bool get isConflict => code == 409;
  bool get isUnprocessableEntity => code == 422;
  bool get isInternalServerError => code == 500;
  bool get isBadGateway => code == 502;
  bool get isServiceUnavailable => code == 503;
  bool get isGatewayTimeout => code == 504;
  bool get isNetworkError => code == -1;
  bool get isTimeout => code == 408;

  /// Check if error is client-side (4xx)
  bool get isClientError => code != null && code! >= 400 && code! < 500;

  /// Check if error is server-side (5xx)
  bool get isServerError => code != null && code! >= 500;

  /// Get the appropriate error message
  String get displayMessage {
    if (hasErrorMessage) return errorMessage!;
    if (hasMessage) return message!;
    if (hasErrors) return errors!.join(', ');
    return success ? 'Success' : 'Something went wrong';
  }

  /// Get all error messages combined
  String get allErrorMessages {
    List<String> allErrors = [];

    if (hasErrorMessage) allErrors.add(errorMessage!);
    if (hasErrors) allErrors.addAll(errors!);

    return allErrors.join(', ');
  }

  /// Transform the data type
  ResponseModel<R> transform<R>(R Function(T) transformer) {
    if (isSuccess && data != null) {
      try {
        final transformedData = transformer(data as T);
        return ResponseModel.success(
          data: transformedData,
          message: message,
          code: code,
          meta: meta,
        );
      } catch (e) {
        return ResponseModel.error(
          message: 'Data transformation failed: $e',
          code: code,
        );
      }
    } else {
      return ResponseModel.error(
        message: errorMessage,
        code: code,
        errors: errors,
        meta: meta,
      );
    }
  }

  /// Map the data if present
  ResponseModel<R> map<R>(R Function(T) mapper) {
    if (isSuccess && data != null) {
      return transform(mapper);
    } else {
      return ResponseModel<R>.error(
        message: errorMessage,
        code: code,
        errors: errors,
        meta: meta,
      );
    }
  }

  /// Fold the response (handle both success and error cases)
  R fold<R>(
      R Function(String error) onError,
      R Function(T data) onSuccess,
      ) {
    if (isSuccess && data != null) {
      return onSuccess(data as T);
    } else {
      return onError(displayMessage);
    }
  }

  /// Execute function only if successful
  ResponseModel<T> onSuccess(void Function(T data) callback) {
    if (isSuccess && data != null) {
      callback(data as T);
    }
    return this;
  }

  /// Execute function only if error
  ResponseModel<T> onError(void Function(String error) callback) {
    if (isError) {
      callback(displayMessage);
    }
    return this;
  }

  /// Chain operations (similar to then)
  ResponseModel<R> then<R>(ResponseModel<R> Function(T data) next) {
    if (isSuccess && data != null) {
      return next(data as T);
    } else {
      return ResponseModel<R>.error(
        message: errorMessage,
        code: code,
        errors: errors,
        meta: meta,
      );
    }
  }

  /// Handle specific error codes
  ResponseModel<T> handleErrorCode(int errorCode, String Function() handler) {
    if (isError && code == errorCode) {
      return ResponseModel.error(
        message: handler(),
        code: code,
        errors: errors,
        meta: meta,
      );
    }
    return this;
  }

  /// Retry with fallback data
  ResponseModel<T> withFallback(T fallbackData) {
    if (isError) {
      return ResponseModel.success(
        data: fallbackData,
        message: 'Using fallback data',
      );
    }
    return this;
  }

  @override
  String toString() {
    if (isSuccess) {
      return 'ResponseModel.success(data: $data, message: $message, code: $code)';
    } else {
      return 'ResponseModel.error(message: $errorMessage, code: $code, errors: $errors)';
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ResponseModel<T> &&
        other.success == success &&
        other.data == data &&
        other.message == message &&
        other.errorMessage == errorMessage &&
        other.code == code;
  }

  @override
  int get hashCode {
    return success.hashCode ^
    data.hashCode ^
    message.hashCode ^
    errorMessage.hashCode ^
    code.hashCode;
  }
}

/// Extension for handling multiple responses
extension ResponseListExtension<T> on List<ResponseModel<T>> {
  /// Check if all responses are successful
  bool get allSuccessful => every((response) => response.isSuccess);

  /// Check if any response is successful
  bool get anySuccessful => any((response) => response.isSuccess);

  /// Get all successful data
  List<T> get successfulData =>
      where((response) => response.isSuccess && response.data != null)
          .map((response) => response.data!)
          .toList();

  /// Get all error messages
  List<String> get errorMessages =>
      where((response) => response.isError)
          .map((response) => response.displayMessage)
          .toList();

  /// Combine into single response
  ResponseModel<List<T>> combine() {
    if (allSuccessful) {
      return ResponseModel.success(
        data: successfulData,
        message: 'All operations completed successfully',
      );
    } else {
      return ResponseModel.error(
        message: 'Some operations failed',
        errors: errorMessages,
      );
    }
  }
}