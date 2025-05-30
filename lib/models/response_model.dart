import 'package:json_annotation/json_annotation.dart';
import '../constants/api_constants.dart';

part 'response_model.g.dart';

/// Generic API response wrapper model
/// Provides consistent structure for all API responses
@JsonSerializable(genericArgumentFactories: true)
class ResponseModel<T> {
  /// Response data of generic type T
  @JsonKey(name: ApiConstants.data)
  final T? data;

  /// Response message
  @JsonKey(name: ApiConstants.message)
  final String? message;

  /// Success status
  @JsonKey(name: ApiConstants.success)
  final bool success;

  /// HTTP status code
  @JsonKey(name: ApiConstants.code)
  final int? code;

  /// Error information
  @JsonKey(name: ApiConstants.error)
  final String? error;

  /// Validation errors (for form submissions)
  @JsonKey(name: ApiConstants.errors)
  final Map<String, dynamic>? errors;

  /// Additional metadata
  @JsonKey(name: ApiConstants.meta)
  final Map<String, dynamic>? meta;

  /// Pagination information
  @JsonKey(name: ApiConstants.pagination)
  final PaginationModel? pagination;

  /// Timestamp of the response
  final DateTime? timestamp;

  const ResponseModel({
    this.data,
    this.message,
    required this.success,
    this.code,
    this.error,
    this.errors,
    this.meta,
    this.pagination,
    this.timestamp,
  });

  /// Factory constructor for successful responses
  factory ResponseModel.success({
    T? data,
    String? message,
    int? code,
    Map<String, dynamic>? meta,
    PaginationModel? pagination,
  }) {
    return ResponseModel<T>(
      data: data,
      message: message ?? 'Success',
      success: true,
      code: code ?? ApiConstants.ok,
      meta: meta,
      pagination: pagination,
      timestamp: DateTime.now(),
    );
  }

  /// Factory constructor for error responses
  factory ResponseModel.error({
    String? message,
    String? error,
    int? code,
    Map<String, dynamic>? errors,
    Map<String, dynamic>? meta,
  }) {
    return ResponseModel<T>(
      message: message ?? 'An error occurred',
      error: error,
      success: false,
      code: code ?? ApiConstants.internalServerError,
      errors: errors,
      meta: meta,
      timestamp: DateTime.now(),
    );
  }

  /// Factory constructor for network errors
  factory ResponseModel.networkError([String? message]) {
    return ResponseModel<T>(
      message: message ?? 'Network error occurred',
      error: 'NETWORK_ERROR',
      success: false,
      code: 0,
      timestamp: DateTime.now(),
    );
  }

  /// Factory constructor for timeout errors
  factory ResponseModel.timeout([String? message]) {
    return ResponseModel<T>(
      message: message ?? 'Request timeout',
      error: 'TIMEOUT_ERROR',
      success: false,
      code: ApiConstants.gatewayTimeout,
      timestamp: DateTime.now(),
    );
  }

  /// Factory constructor for validation errors
  factory ResponseModel.validationError({
    String? message,
    Map<String, dynamic>? errors,
  }) {
    return ResponseModel<T>(
      message: message ?? 'Validation failed',
      error: ApiConstants.validationError,
      success: false,
      code: ApiConstants.unprocessableEntity,
      errors: errors,
      timestamp: DateTime.now(),
    );
  }

  /// Factory constructor for unauthorized errors
  factory ResponseModel.unauthorized([String? message]) {
    return ResponseModel<T>(
      message: message ?? 'Unauthorized access',
      error: ApiConstants.tokenExpired,
      success: false,
      code: ApiConstants.unauthorized,
      timestamp: DateTime.now(),
    );
  }

  /// Create from JSON
  factory ResponseModel.fromJson(
      Map<String, dynamic> json,
      T Function(Object? json) fromJsonT,
      ) =>
      _$ResponseModelFromJson(json, fromJsonT);

  /// Convert to JSON
  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ResponseModelToJson(this, toJsonT);

  /// Check if response indicates success
  bool get isSuccess => success && (code == null || ApiConstants.isSuccessful(code!));

  /// Check if response indicates error
  bool get isError => !success;

  /// Check if response indicates client error (4xx)
  bool get isClientError => code != null && ApiConstants.isClientError(code!);

  /// Check if response indicates server error (5xx)
  bool get isServerError => code != null && ApiConstants.isServerError(code!);

  /// Check if response indicates network error
  bool get isNetworkError => code == 0;

  /// Check if response indicates timeout
  bool get isTimeout => code == ApiConstants.gatewayTimeout;

  /// Check if response indicates unauthorized
  bool get isUnauthorized => code == ApiConstants.unauthorized;

  /// Check if response indicates validation error
  bool get isValidationError => code == ApiConstants.unprocessableEntity;

  /// Get error message (combines message and error fields)
  String get errorMessage {
    if (error != null && error!.isNotEmpty) {
      return error!;
    }
    if (message != null && message!.isNotEmpty) {
      return message!;
    }
    return 'Unknown error occurred';
  }

  /// Get success message
  String get successMessage => message ?? 'Operation completed successfully';

  /// Check if response has data
  bool get hasData => data != null;

  /// Check if response has pagination
  bool get hasPagination => pagination != null;

  /// Check if response has validation errors
  bool get hasValidationErrors => errors != null && errors!.isNotEmpty;

  /// Get validation error for specific field
  String? getValidationError(String field) {
    if (!hasValidationErrors) return null;

    final fieldError = errors![field];
    if (fieldError is String) return fieldError;
    if (fieldError is List && fieldError.isNotEmpty) return fieldError.first.toString();

    return null;
  }

  /// Get all validation errors as a list
  List<String> get allValidationErrors {
    if (!hasValidationErrors) return [];

    final errorList = <String>[];
    errors!.forEach((key, value) {
      if (value is String) {
        errorList.add(value);
      } else if (value is List) {
        errorList.addAll(value.map((e) => e.toString()));
      }
    });

    return errorList;
  }

  /// Copy with new values
  ResponseModel<T> copyWith({
    T? data,
    String? message,
    bool? success,
    int? code,
    String? error,
    Map<String, dynamic>? errors,
    Map<String, dynamic>? meta,
    PaginationModel? pagination,
    DateTime? timestamp,
  }) {
    return ResponseModel<T>(
      data: data ?? this.data,
      message: message ?? this.message,
      success: success ?? this.success,
      code: code ?? this.code,
      error: error ?? this.error,
      errors: errors ?? this.errors,
      meta: meta ?? this.meta,
      pagination: pagination ?? this.pagination,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  String toString() {
    return 'ResponseModel<$T>(success: $success, code: $code, message: $message, hasData: $hasData)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ResponseModel<T> &&
        other.data == data &&
        other.message == message &&
        other.success == success &&
        other.code == code &&
        other.error == error;
  }

  @override
  int get hashCode {
    return data.hashCode ^
    message.hashCode ^
    success.hashCode ^
    code.hashCode ^
    error.hashCode;
  }
}

/// Pagination model for paginated responses
@JsonSerializable()
class PaginationModel {
  /// Current page number
  @JsonKey(name: ApiConstants.page)
  final int currentPage;

  /// Total number of pages
  @JsonKey(name: ApiConstants.totalPages)
  final int totalPages;

  /// Total number of items
  @JsonKey(name: ApiConstants.totalItems)
  final int totalItems;

  /// Number of items per page
  @JsonKey(name: ApiConstants.limit)
  final int itemsPerPage;

  /// Whether there is a next page
  @JsonKey(name: ApiConstants.hasNext)
  final bool hasNextPage;

  /// Whether there is a previous page
  @JsonKey(name: ApiConstants.hasPrevious)
  final bool hasPreviousPage;

  const PaginationModel({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  /// Create from JSON
  factory PaginationModel.fromJson(Map<String, dynamic> json) =>
      _$PaginationModelFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$PaginationModelToJson(this);

  /// Check if this is the first page
  bool get isFirstPage => currentPage == 1;

  /// Check if this is the last page
  bool get isLastPage => currentPage == totalPages;

  /// Get next page number (null if no next page)
  int? get nextPage => hasNextPage ? currentPage + 1 : null;

  /// Get previous page number (null if no previous page)
  int? get previousPage => hasPreviousPage ? currentPage - 1 : null;

  /// Get starting item index for current page (1-based)
  int get startIndex => (currentPage - 1) * itemsPerPage + 1;

  /// Get ending item index for current page (1-based)
  int get endIndex {
    final calculatedEnd = currentPage * itemsPerPage;
    return calculatedEnd > totalItems ? totalItems : calculatedEnd;
  }

  /// Get page range for pagination UI
  List<int> getPageRange({int maxPages = 5}) {
    if (totalPages <= maxPages) {
      return List.generate(totalPages, (index) => index + 1);
    }

    final half = maxPages ~/ 2;
    int start = currentPage - half;
    int end = currentPage + half;

    if (start < 1) {
      start = 1;
      end = maxPages;
    } else if (end > totalPages) {
      end = totalPages;
      start = totalPages - maxPages + 1;
    }

    return List.generate(end - start + 1, (index) => start + index);
  }

  /// Copy with new values
  PaginationModel copyWith({
    int? currentPage,
    int? totalPages,
    int? totalItems,
    int? itemsPerPage,
    bool? hasNextPage,
    bool? hasPreviousPage,
  }) {
    return PaginationModel(
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
    );
  }

  @override
  String toString() {
    return 'PaginationModel(currentPage: $currentPage, totalPages: $totalPages, totalItems: $totalItems)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PaginationModel &&
        other.currentPage == currentPage &&
        other.totalPages == totalPages &&
        other.totalItems == totalItems &&
        other.itemsPerPage == itemsPerPage &&
        other.hasNextPage == hasNextPage &&
        other.hasPreviousPage == hasPreviousPage;
  }

  @override
  int get hashCode {
    return currentPage.hashCode ^
    totalPages.hashCode ^
    totalItems.hashCode ^
    itemsPerPage.hashCode ^
    hasNextPage.hashCode ^
    hasPreviousPage.hashCode;
  }
}

/// API error model for detailed error information
@JsonSerializable()
class ApiError {
  /// Error code
  final String code;

  /// Error message
  final String message;

  /// Error details
  final String? details;

  /// Field that caused the error (for validation errors)
  final String? field;

  /// Additional error data
  final Map<String, dynamic>? data;

  const ApiError({
    required this.code,
    required this.message,
    this.details,
    this.field,
    this.data,
  });

  /// Create from JSON
  factory ApiError.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$ApiErrorToJson(this);

  @override
  String toString() {
    return 'ApiError(code: $code, message: $message, field: $field)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ApiError &&
        other.code == code &&
        other.message == message &&
        other.field == field;
  }

  @override
  int get hashCode {
    return code.hashCode ^ message.hashCode ^ field.hashCode;
  }
}