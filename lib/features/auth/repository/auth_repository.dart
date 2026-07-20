import '../../../core/services/token_storage.dart';
import '../models/auth_request.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

/// Outcome of an auth call that may either complete a session or ask the client
/// to collect an OTP first.
sealed class AuthOutcome {
  const AuthOutcome();
}

/// Server sent an OTP; the client must collect it and call the verify step.
class OtpSent extends AuthOutcome {
  const OtpSent();
}

/// A session was established: token persisted, user returned.
class Authenticated extends AuthOutcome {
  const Authenticated(this.user);
  final UserModel user;
}

/// Bridges the API service and token storage, exposing a clean domain API to
/// the controller. Persists the Sanctum token on success.
class AuthRepository {
  AuthRepository({
    required this._service,
    required TokenStorage tokenStorage,
  })  : _tokens = tokenStorage;

  final AuthService _service;
  final TokenStorage _tokens;

  Future<AuthOutcome> registerStart(RegisterStartRequest r) async {
    await _service.registerStart(r);
    return const OtpSent();
  }

  Future<AuthOutcome> registerVerify(RegisterVerifyRequest r) =>
      _persist(_service.registerVerify(r));

  Future<AuthOutcome> login(LoginRequest r) async {
    final data = await _service.login(r);
    if (data['otp_sent'] == true) return const OtpSent();
    return _fromAuthData(data);
  }

  Future<AuthOutcome> social(String provider, String token) =>
      _persist(_service.social(provider, token));

  Future<void> forgot(ForgotPasswordRequest r) => _service.forgot(r);
  Future<void> reset(ResetPasswordRequest r) => _service.reset(r);

  Future<UserModel> currentUser() async =>
      UserModel.fromJson(await _service.me());

  Future<void> logout() async {
    try {
      await _service.logout();
    } finally {
      await _tokens.clear();
    }
  }

  Future<bool> hasSession() => _tokens.hasSession;

  Future<AuthOutcome> _persist(Future<Map<String, dynamic>> call) async =>
      _fromAuthData(await call);

  Future<AuthOutcome> _fromAuthData(Map<String, dynamic> data) async {
    final token = data['access_token'] as String?;
    if (token != null && token.isNotEmpty) {
      await _tokens.saveToken(token);
    }
    final userJson = (data['user'] as Map<String, dynamic>?) ?? const {};
    return Authenticated(UserModel.fromJson(userJson));
  }
}
