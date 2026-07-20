import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/providers/core_providers.dart';
import '../models/auth_request.dart';
import '../models/user_model.dart';
import '../repository/auth_repository.dart';
import '../services/auth_service.dart';

// ---------------------------------------------------------------------------
// DI providers (service -> repository -> controller)
// ---------------------------------------------------------------------------
final authServiceProvider = Provider<AuthService>(
  (ref) => AuthService(ref.watch(apiClientProvider)),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(
    service: ref.watch(authServiceProvider),
    tokenStorage: ref.watch(tokenStorageProvider),
  ),
);

/// Auth status used by the router for redirect decisions.
enum AuthStatus { unknown, authenticated, unauthenticated }

/// What a submit action produced, so the UI can branch (navigate vs collect OTP).
enum AuthActionResult { success, otpSent, failed }

@immutable
class AuthState {
  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.isSubmitting = false,
    this.error,
  });

  final AuthStatus status;
  final UserModel? user;
  final bool isSubmitting;
  final ApiException? error;

  bool get isAuthenticated => status == AuthStatus.authenticated;

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    bool? isSubmitting,
    ApiException? error,
    bool clearError = false,
    bool clearUser = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Central authentication controller. Owns session bootstrap and every auth
/// flow (email login, phone OTP login, OTP registration, reset). UI watches
/// [authControllerProvider]; the router listens to it.
class AuthController extends Notifier<AuthState> {
  late final AuthRepository _repo = ref.read(authRepositoryProvider);

  @override
  AuthState build() {
    final ApiClient client = ref.read(apiClientProvider);
    client.onSessionExpired = _onSessionExpired;
    Future.microtask(bootstrap);
    return const AuthState();
  }

  /// Restores session on app start.
  Future<void> bootstrap() async {
    if (!await _repo.hasSession()) {
      state = state.copyWith(status: AuthStatus.unauthenticated);
      return;
    }
    try {
      final user = await _repo.currentUser();
      state = state.copyWith(status: AuthStatus.authenticated, user: user);
    } on ApiException {
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }

  // ── Login ──────────────────────────────────────────────────────────────
  Future<AuthActionResult> loginWithEmail(String email, String password) =>
      _run(() => _repo.login(LoginRequest.email(email: email, password: password)));

  Future<AuthActionResult> startPhoneLogin(String phone) =>
      _run(() => _repo.login(LoginRequest.phone(phone: phone)));

  Future<AuthActionResult> verifyPhoneLogin(String phone, String otp) =>
      _run(() => _repo.login(LoginRequest.phone(phone: phone, otp: otp)));

  // ── Register ─────────────────────────────────────────────────────────────
  Future<AuthActionResult> startRegister(
    String phone, {
    String? name,
    String? email,
  }) =>
      _run(() =>
          _repo.registerStart(RegisterStartRequest(phone: phone, name: name, email: email)));

  Future<AuthActionResult> verifyRegister({
    required String phone,
    required String otp,
    required String name,
    String? email,
    String? password,
  }) =>
      _run(() => _repo.registerVerify(RegisterVerifyRequest(
            phone: phone,
            otp: otp,
            name: name,
            email: email,
            password: password,
          )));

  // ── Password reset ───────────────────────────────────────────────────────
  Future<bool> forgot(ForgotPasswordRequest request) async {
    state = state.copyWith(isSubmitting: true, clearError: true);
    try {
      await _repo.forgot(request);
      state = state.copyWith(isSubmitting: false);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isSubmitting: false, error: e);
      return false;
    }
  }

  Future<bool> reset(ResetPasswordRequest request) async {
    state = state.copyWith(isSubmitting: true, clearError: true);
    try {
      await _repo.reset(request);
      state = state.copyWith(isSubmitting: false);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isSubmitting: false, error: e);
      return false;
    }
  }

  Future<void> logout() async {
    await _repo.logout();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  void clearError() => state = state.copyWith(clearError: true);

  /// Replaces the cached user after a profile update.
  void applyUser(UserModel user) => state = state.copyWith(user: user);

  /// Reloads the current user from `/me` (e.g. after an avatar change).
  Future<void> refreshUser() async {
    try {
      state = state.copyWith(user: await _repo.currentUser());
    } on ApiException {
      // Keep the existing cached user on failure.
    }
  }

  /// Runs an auth action that may return [OtpSent] or [Authenticated].
  Future<AuthActionResult> _run(Future<AuthOutcome> Function() action) async {
    state = state.copyWith(isSubmitting: true, clearError: true);
    try {
      final outcome = await action();
      switch (outcome) {
        case OtpSent():
          state = state.copyWith(isSubmitting: false);
          return AuthActionResult.otpSent;
        case Authenticated(:final user):
          state = state.copyWith(
            status: AuthStatus.authenticated,
            user: user,
            isSubmitting: false,
          );
          return AuthActionResult.success;
      }
    } on ApiException catch (e) {
      state = state.copyWith(isSubmitting: false, error: e);
      return AuthActionResult.failed;
    }
  }

  void _onSessionExpired() {
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);
