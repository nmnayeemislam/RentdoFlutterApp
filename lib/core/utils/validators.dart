/// Form validation helpers returning a message or `null` when valid.
abstract final class Validators {
  Validators._();

  static final RegExp _emailRe =
      RegExp(r'^[\w.\-+]+@([\w\-]+\.)+[\w\-]{2,}$');

  static final RegExp _phoneRe = RegExp(r'^\+?[0-9]{7,20}$');
  static final RegExp _otpRe = RegExp(r'^[0-9]{6}$');

  static String? required(String? value, {String field = 'This field'}) {
    if (value == null || value.trim().isEmpty) return '$field is required';
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    if (!_emailRe.hasMatch(value.trim())) return 'Enter a valid email';
    return null;
  }

  static String? password(String? value, {int min = 4}) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < min) return 'Password must be at least $min characters';
    return null;
  }

  static String? confirm(String? value, String other) {
    if (value != other) return 'Passwords do not match';
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) return 'Phone is required';
    if (!_phoneRe.hasMatch(value.trim())) return 'Enter a valid phone number';
    return null;
  }

  static String? otp(String? value) {
    if (value == null || value.trim().isEmpty) return 'Code is required';
    if (!_otpRe.hasMatch(value.trim())) return 'Enter the 6-digit code';
    return null;
  }
}
