import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/validators.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/otp_field.dart';
import '../../../shared/widgets/phone_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../models/auth_request.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../widgets/auth_header.dart';

/// Password reset supporting email (link) and phone (OTP) flows.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _otp = TextEditingController();
  final _password = TextEditingController();

  bool _phoneMode = false;
  bool _otpSent = false;

  @override
  void dispose() {
    _email.dispose();
    _phone.dispose();
    _otp.dispose();
    _password.dispose();
    super.dispose();
  }

  String? get _errorMessage => ref.read(authViewModelProvider).error?.message;

  void _switchMode() {
    FocusScope.of(context).unfocus();
    setState(() {
      _phoneMode = !_phoneMode;
      _otpSent = false;
      _otp.clear();
      _password.clear();
    });
  }

  Future<void> _submitEmail() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final ok = await ref
        .read(authViewModelProvider.notifier)
        .forgot(ForgotPasswordRequest.email(_email.text.trim()));
    if (!mounted) return;
    if (ok) {
      context.showSnack(AppStrings.checkEmailForReset);
      context.pop();
    } else {
      context.showSnack(
        _errorMessage ?? AppStrings.somethingWentWrong,
        error: true,
      );
    }
  }

  Future<void> _requestPhoneOtp() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final ok = await ref
        .read(authViewModelProvider.notifier)
        .forgot(ForgotPasswordRequest.phone(_phone.text.trim()));
    if (!mounted) return;
    if (ok) {
      setState(() => _otpSent = true);
    } else {
      context.showSnack(
        _errorMessage ?? AppStrings.somethingWentWrong,
        error: true,
      );
    }
  }

  Future<void> _resetWithPhone() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final ok = await ref.read(authViewModelProvider.notifier).reset(
          ResetPasswordRequest.phone(
            phone: _phone.text.trim(),
            otp: _otp.text.trim(),
            password: _password.text,
          ),
        );
    if (!mounted) return;
    if (ok) {
      context.showSnack(AppStrings.passwordUpdated);
      context.go(AppRoutes.login);
    } else {
      context.showSnack(
        _errorMessage ?? AppStrings.somethingWentWrong,
        error: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting =
        ref.watch(authViewModelProvider.select((s) => s.isSubmitting));

    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AuthHeader(
                      title: AppStrings.forgotPasswordTitle,
                      subtitle: AppStrings.forgotPasswordSubtitle,
                    ),
                    AppSpacing.vGapXxl,
                    if (_phoneMode)
                      ..._phoneFields(isSubmitting)
                    else
                      ..._emailFields(isSubmitting),
                    AppSpacing.vGapMd,
                    TextButton(
                      onPressed: isSubmitting ? null : _switchMode,
                      child: Text(
                        _phoneMode
                            ? AppStrings.useEmailInstead
                            : AppStrings.usePhoneInstead,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _emailFields(bool isSubmitting) {
    return [
      AppTextField(
        label: AppStrings.email,
        hint: 'you@example.com',
        controller: _email,
        keyboardType: TextInputType.emailAddress,
        prefixIcon: Icons.mail_outline_rounded,
        textInputAction: TextInputAction.done,
        validator: Validators.email,
      ),
      AppSpacing.vGapLg,
      PrimaryButton(
        label: AppStrings.resetPassword,
        isLoading: isSubmitting,
        onPressed: _submitEmail,
      ),
    ];
  }

  List<Widget> _phoneFields(bool isSubmitting) {
    return [
      PhoneField(
        label: AppStrings.phone,
        hint: '1711 223344',
        controller: _phone,
        enabled: !_otpSent,
        textInputAction: TextInputAction.next,
        validator: Validators.phone,
      ),
      if (!_otpSent) ...[
        AppSpacing.vGapLg,
        PrimaryButton(
          label: AppStrings.sendOtp,
          isLoading: isSubmitting,
          onPressed: _requestPhoneOtp,
        ),
      ] else ...[
        AppSpacing.vGapLg,
        OtpField(
          controller: _otp,
          textInputAction: TextInputAction.next,
        ),
        AppSpacing.vGapLg,
        AppTextField(
          label: AppStrings.newPassword,
          hint: '••••••••',
          controller: _password,
          obscure: true,
          prefixIcon: Icons.lock_outline_rounded,
          textInputAction: TextInputAction.done,
          validator: Validators.password,
        ),
        AppSpacing.vGapLg,
        PrimaryButton(
          label: AppStrings.resetPassword,
          isLoading: isSubmitting,
          onPressed: _resetWithPhone,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: isSubmitting ? null : _requestPhoneOtp,
            child: const Text(AppStrings.resendOtp),
          ),
        ),
      ],
    ];
  }
}
