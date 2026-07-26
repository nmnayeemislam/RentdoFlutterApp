import '../../l10n/app_localizations.dart';

/// Form validation helpers returning a message or `null` when valid.
abstract final class Validators {
  Validators._();

  static final RegExp _emailRe =
      RegExp(r'^[\w.\-+]+@([\w\-]+\.)+[\w\-]{2,}$');

  static final RegExp _phoneRe = RegExp(r'^\+?[0-9]{7,20}$');
  static final RegExp _otpRe = RegExp(r'^[0-9]{6}$');

  static String? required(String? value, AppLocalizations l10n, {required String field}) {
    if (value == null || value.trim().isEmpty) {
      return l10n.validatorRequired(field);
    }
    return null;
  }

  static String? email(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) return l10n.validatorEmailRequired;
    if (!_emailRe.hasMatch(value.trim())) return l10n.validatorEmailInvalid;
    return null;
  }

  static String? password(String? value, AppLocalizations l10n, {int min = 4}) {
    if (value == null || value.isEmpty) return l10n.validatorPasswordRequired;
    if (value.length < min) return l10n.validatorPasswordMinLength(min);
    return null;
  }

  static String? confirm(String? value, String other, AppLocalizations l10n) {
    if (value != other) return l10n.validatorPasswordMismatch;
    return null;
  }

  static String? phone(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) return l10n.validatorPhoneRequired;
    if (!_phoneRe.hasMatch(value.trim())) return l10n.validatorPhoneInvalid;
    return null;
  }

  static String? otp(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) return l10n.validatorCodeRequired;
    if (!_otpRe.hasMatch(value.trim())) return l10n.validatorCodeInvalid;
    return null;
  }
}
