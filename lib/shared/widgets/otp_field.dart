import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/utils/validators.dart';
import '../extensions/context_extensions.dart';
import 'app_text_field.dart';

/// Reusable 6-digit numeric verification-code field built on [AppTextField].
class OtpField extends StatelessWidget {
  const OtpField({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.textInputAction = TextInputAction.done,
    this.validator = Validators.otp,
  });

  final TextEditingController controller;
  final String? label;
  final String? hint;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: label ?? context.l10n.otpCode,
      hint: hint ?? context.l10n.otpHint,
      controller: controller,
      keyboardType: TextInputType.number,
      textInputAction: textInputAction,
      prefixIcon: Icons.sms_outlined,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(6),
      ],
      validator: validator,
    );
  }
}
