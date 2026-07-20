import 'package:dio/dio.dart';

/// Normalized error type surfaced to repositories/controllers so the UI never
/// has to know about Dio internals.
class ApiException implements Exception {
  const ApiException({
    required this.message,
    this.statusCode,
    this.errors,
    this.type = ApiErrorType.unknown,
  });

  final String message;
  final int? statusCode;

  /// Laravel-style field validation errors: `{ "email": ["is required"] }`.
  final Map<String, List<String>>? errors;
  final ApiErrorType type;

  bool get isUnauthorized => statusCode == 401;
  bool get isValidation => statusCode == 422;

  /// First validation message, if any — handy for inline field errors.
  String? fieldError(String field) => errors?[field]?.first;

  factory ApiException.fromDio(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException(
          message: 'The connection timed out. Please try again.',
          type: ApiErrorType.timeout,
        );
      case DioExceptionType.connectionError:
        return const ApiException(
          message: 'No internet connection. Check your network and try again.',
          type: ApiErrorType.network,
        );
      case DioExceptionType.cancel:
        return const ApiException(
          message: 'Request cancelled.',
          type: ApiErrorType.cancel,
        );
      case DioExceptionType.badCertificate:
        return const ApiException(
          message: 'Secure connection failed.',
          type: ApiErrorType.network,
        );
      case DioExceptionType.badResponse:
        return ApiException._fromResponse(e);
      default:
        // `unknown`, `transformTimeout`, and any future Dio types. If the
        // server still returned a response, parse it; otherwise treat it as a
        // network/unknown failure rather than mislabeling it as a server error.
        return e.response != null
            ? ApiException._fromResponse(e)
            : const ApiException(
                message:
                    'Something went wrong. Check your connection and try again.',
              );
    }
  }

  factory ApiException._fromResponse(DioException e) {
    final int? code = e.response?.statusCode;
    final dynamic data = e.response?.data;

    String message = 'Something went wrong. Please try again.';
    Map<String, List<String>>? errors;

    if (data is Map<String, dynamic>) {
      if (data['message'] is String) {
        message = data['message'] as String;
      }
      final dynamic rawErrors = data['errors'];
      if (rawErrors is Map<String, dynamic>) {
        errors = rawErrors.map(
          (key, value) => MapEntry(
            key,
            (value is List) ? value.map((e) => '$e').toList() : ['$value'],
          ),
        );
        // Prefer the first validation message as the headline.
        final firstList = errors.values.isNotEmpty ? errors.values.first : null;
        if (firstList != null && firstList.isNotEmpty) message = firstList.first;
      }
    }

    return ApiException(
      message: message,
      statusCode: code,
      errors: errors,
      type: code == 401
          ? ApiErrorType.unauthorized
          : code == 422
              ? ApiErrorType.validation
              : ApiErrorType.server,
    );
  }

  @override
  String toString() => 'ApiException($statusCode): $message';
}

enum ApiErrorType {
  network,
  timeout,
  unauthorized,
  validation,
  server,
  cancel,
  unknown,
}
