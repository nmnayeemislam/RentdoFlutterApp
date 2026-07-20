import 'package:dio/dio.dart';

import '../services/token_storage.dart';
import 'request_context.dart';

/// Attaches the Sanctum bearer token plus locale/currency headers to every
/// request. Sanctum tokens don't expire on a schedule, so on a `401` we simply
/// surface a session-expiry signal — there is no refresh flow to run.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenStorage, this._context);

  final TokenStorage _tokenStorage;
  final RequestContext _context;

  /// Called when the token is rejected so the app can force a logout.
  void Function()? onSessionExpired;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra['requiresAuth'] != false) {
      final token = await _tokenStorage.readAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    options.headers['Accept'] = 'application/json';
    options.headers['Accept-Language'] = _context.locale;
    options.headers['X-Currency'] = _context.currency;
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final requiresAuth = err.requestOptions.extra['requiresAuth'] != false;
    if (err.response?.statusCode == 401 && requiresAuth) {
      onSessionExpired?.call();
    }
    handler.next(err);
  }
}
