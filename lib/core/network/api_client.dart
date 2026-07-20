import 'package:dio/dio.dart';

import '../constants/app_config.dart';
import '../services/token_storage.dart';
import 'api_exception.dart';
import 'auth_interceptor.dart';
import 'request_context.dart';

/// Centralized HTTP client wrapping [Dio].
///
/// Every repository/service goes through this class so timeouts, auth headers,
/// logging, and error normalization live in exactly one place. All methods
/// throw [ApiException] on failure.
class ApiClient {
  ApiClient({
    required TokenStorage tokenStorage,
    required RequestContext requestContext,
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: AppConfig.apiBaseUrl,
            connectTimeout: AppConfig.connectTimeout,
            receiveTimeout: AppConfig.receiveTimeout,
            headers: {'Accept': 'application/json'},
          ),
        ) {
    authInterceptor = AuthInterceptor(tokenStorage, requestContext);
    _dio.interceptors.add(authInterceptor);
    if (AppConfig.enableLogging) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (o) => _log(o.toString()),
        ),
      );
    }
  }

  final Dio _dio;
  late final AuthInterceptor authInterceptor;

  Dio get raw => _dio;

  set onSessionExpired(void Function() cb) =>
      authInterceptor.onSessionExpired = cb;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? query,
    bool requiresAuth = true,
    CancelToken? cancelToken,
  }) =>
      _guard(() => _dio.get<T>(
            path,
            queryParameters: query,
            cancelToken: cancelToken,
            options: Options(extra: {'requiresAuth': requiresAuth}),
          ));

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? query,
    bool requiresAuth = true,
    CancelToken? cancelToken,
  }) =>
      _guard(() => _dio.post<T>(
            path,
            data: data,
            queryParameters: query,
            cancelToken: cancelToken,
            options: Options(extra: {'requiresAuth': requiresAuth}),
          ));

  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    bool requiresAuth = true,
    CancelToken? cancelToken,
  }) =>
      _guard(() => _dio.put<T>(
            path,
            data: data,
            cancelToken: cancelToken,
            options: Options(extra: {'requiresAuth': requiresAuth}),
          ));

  Future<Response<T>> patch<T>(
    String path, {
    Object? data,
    bool requiresAuth = true,
    CancelToken? cancelToken,
  }) =>
      _guard(() => _dio.patch<T>(
            path,
            data: data,
            cancelToken: cancelToken,
            options: Options(extra: {'requiresAuth': requiresAuth}),
          ));

  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    bool requiresAuth = true,
    CancelToken? cancelToken,
  }) =>
      _guard(() => _dio.delete<T>(
            path,
            data: data,
            cancelToken: cancelToken,
            options: Options(extra: {'requiresAuth': requiresAuth}),
          ));

  /// Multipart file upload for Laravel `Storage`/`request->file()` endpoints.
  Future<Response<T>> upload<T>(
    String path, {
    required FormData formData,
    ProgressCallback? onSendProgress,
    bool requiresAuth = true,
    CancelToken? cancelToken,
  }) =>
      _guard(() => _dio.post<T>(
            path,
            data: formData,
            onSendProgress: onSendProgress,
            cancelToken: cancelToken,
            options: Options(
              extra: {'requiresAuth': requiresAuth},
              contentType: 'multipart/form-data',
            ),
          ));

  Future<Response<T>> _guard<T>(Future<Response<T>> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  static void _log(String message) {
    // ignore: avoid_print
    print('[ApiClient] $message');
  }
}
