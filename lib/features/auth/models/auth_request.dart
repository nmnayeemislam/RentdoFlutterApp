/// Request payloads for the authentication endpoints (serialize to JSON only).
///
/// The backend supports two flows:
///  - Email + password  (login)
///  - Phone + OTP        (register start/verify, login, reset)
library;

/// `POST /auth/register/start` — sends an OTP to the phone.
class RegisterStartRequest {
  const RegisterStartRequest({required this.phone, this.name, this.email});

  final String phone;
  final String? name;
  final String? email;

  Map<String, dynamic> toJson() => {
        'phone': phone,
        if (name != null && name!.isNotEmpty) 'name': name,
        if (email != null && email!.isNotEmpty) 'email': email,
      };
}

/// `POST /auth/register/verify` — verifies the OTP and creates the account.
class RegisterVerifyRequest {
  const RegisterVerifyRequest({
    required this.phone,
    required this.otp,
    required this.name,
    this.email,
    this.password,
  });

  final String phone;
  final String otp;
  final String name;
  final String? email;
  final String? password;

  Map<String, dynamic> toJson() => {
        'phone': phone,
        'otp': otp,
        'name': name,
        if (email != null && email!.isNotEmpty) 'email': email,
        if (password != null && password!.isNotEmpty) 'password': password,
      };
}

/// `POST /auth/login` — email+password, or phone (+ optional OTP).
class LoginRequest {
  const LoginRequest.email({required String this.email, required String this.password})
      : phone = null,
        otp = null;

  const LoginRequest.phone({required String this.phone, this.otp})
      : email = null,
        password = null;

  final String? email;
  final String? password;
  final String? phone;
  final String? otp;

  Map<String, dynamic> toJson() => {
        if (email != null) 'email': email,
        if (password != null) 'password': password,
        if (phone != null) 'phone': phone,
        if (otp != null && otp!.isNotEmpty) 'otp': otp,
      };
}

/// `POST /auth/forgot` — request a reset link (email) or OTP (phone).
class ForgotPasswordRequest {
  const ForgotPasswordRequest.email(String this.email)
      : phone = null;
  const ForgotPasswordRequest.phone(String this.phone)
      : email = null;

  final String? email;
  final String? phone;

  Map<String, dynamic> toJson() => {
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
      };
}

/// `POST /auth/reset` — email(token) or phone(otp) based password reset.
class ResetPasswordRequest {
  const ResetPasswordRequest.email({
    required String this.email,
    required String this.token,
    required this.password,
  })  : phone = null,
        otp = null;

  const ResetPasswordRequest.phone({
    required String this.phone,
    required String this.otp,
    required this.password,
  })  : email = null,
        token = null;

  final String? email;
  final String? token;
  final String? phone;
  final String? otp;
  final String password;

  Map<String, dynamic> toJson() => {
        if (email != null) 'email': email,
        if (token != null) 'token': token,
        if (phone != null) 'phone': phone,
        if (otp != null) 'otp': otp,
        'password': password,
        'password_confirmation': password,
      };
}
