import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../models/auth_request.dart';

/// Thin API layer for auth endpoints. Returns the envelope `data` map; the
/// repository maps it into domain models. Keeps HTTP concerns isolated.
class AuthService {
  AuthService(this._api);

  final ApiClient _api;

  Future<Map<String, dynamic>> _postData(
    String path,
    Map<String, dynamic> body,
  ) async {
    final res = await _api.post<Map<String, dynamic>>(
      path,
      data: body,
      requiresAuth: false,
    );
    return (res.data?['data'] as Map<String, dynamic>?) ?? const {};
  }

  Future<Map<String, dynamic>> registerStart(RegisterStartRequest r) =>
      _postData(ApiEndpoints.registerStart, r.toJson());

  Future<Map<String, dynamic>> registerVerify(RegisterVerifyRequest r) =>
      _postData(ApiEndpoints.registerVerify, r.toJson());

  Future<Map<String, dynamic>> login(LoginRequest r) =>
      _postData(ApiEndpoints.login, r.toJson());

  Future<Map<String, dynamic>> social(String provider, String token) =>
      _postData(ApiEndpoints.social, {'provider': provider, 'token': token});

  Future<void> forgot(ForgotPasswordRequest r) =>
      _postData(ApiEndpoints.forgotPassword, r.toJson());

  Future<void> reset(ResetPasswordRequest r) =>
      _postData(ApiEndpoints.resetPassword, r.toJson());

  Future<Map<String, dynamic>> me() async {
    final res = await _api.get<Map<String, dynamic>>(ApiEndpoints.me);
    return (res.data?['data'] as Map<String, dynamic>?) ?? const {};
  }

  Future<void> logout() => _api.post<dynamic>(ApiEndpoints.logout);
}
