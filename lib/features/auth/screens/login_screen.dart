import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/otp_field.dart';
import '../../../shared/widgets/phone_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/segmented_control.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_header.dart';

/// Login screen supporting email/password and phone-OTP flows.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _phone = TextEditingController();
  final _otp = TextEditingController();

  bool _phoneMode = false;
  bool _otpSent = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _phone.dispose();
    _otp.dispose();
    super.dispose();
  }

  void _switchMode() {
    FocusScope.of(context).unfocus();
    setState(() {
      _phoneMode = !_phoneMode;
      _otpSent = false;
      _otp.clear();
    });
  }

  String? get _errorMessage => ref.read(authControllerProvider).error?.message;

  Future<void> _loginEmail() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final result = await ref
        .read(authControllerProvider.notifier)
        .loginWithEmail(_email.text.trim(), _password.text);
    if (!mounted) return;
    switch (result) {
      case AuthActionResult.success:
        context.go(AppRoutes.home);
      case AuthActionResult.otpSent:
      case AuthActionResult.failed:
        context.showSnack(
          _errorMessage ?? AppStrings.somethingWentWrong,
          error: true,
        );
    }
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final result = await ref
        .read(authControllerProvider.notifier)
        .startPhoneLogin(_phone.text.trim());
    if (!mounted) return;
    switch (result) {
      case AuthActionResult.otpSent:
      case AuthActionResult.success:
        setState(() => _otpSent = true);
      case AuthActionResult.failed:
        context.showSnack(
          _errorMessage ?? AppStrings.somethingWentWrong,
          error: true,
        );
    }
  }

  Future<void> _verifyOtp() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final result = await ref
        .read(authControllerProvider.notifier)
        .verifyPhoneLogin(_phone.text.trim(), _otp.text.trim());
    if (!mounted) return;
    switch (result) {
      case AuthActionResult.success:
        context.go(AppRoutes.home);
      case AuthActionResult.otpSent:
      case AuthActionResult.failed:
        context.showSnack(
          _errorMessage ?? AppStrings.somethingWentWrong,
          error: true,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting =
        ref.watch(authControllerProvider.select((s) => s.isSubmitting));

    return Scaffold(
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
                      title: AppStrings.welcomeBack,
                      subtitle: 'Log in to continue exploring properties.',
                    ),
                    AppSpacing.vGapXxl,
                    SegmentedControl(
                      labels: const ['Email', 'Phone'],
                      selected: _phoneMode ? 1 : 0,
                      onChanged: isSubmitting
                          ? (_) {}
                          : (i) {
                              if ((i == 1) != _phoneMode) _switchMode();
                            },
                    ),
                    AppSpacing.vGapXl,
                    if (_phoneMode)
                      ..._phoneFields(isSubmitting)
                    else
                      ..._emailFields(isSubmitting),
                    AppSpacing.vGapMd,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          AppStrings.dontHaveAccount,
                          style: AppTextStyles.bodyMd,
                        ),
                        TextButton(
                          onPressed: () => context.go(AppRoutes.register),
                          child: const Text(AppStrings.register),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () => context.go(AppRoutes.home),
                      child: const Text(AppStrings.continueAsGuest),
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
        textInputAction: TextInputAction.next,
        validator: Validators.email,
      ),
      AppSpacing.vGapLg,
      AppTextField(
        label: AppStrings.password,
        hint: '••••••••',
        controller: _password,
        obscure: true,
        prefixIcon: Icons.lock_outline_rounded,
        textInputAction: TextInputAction.done,
        validator: Validators.password,
      ),
      Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () => context.push(AppRoutes.forgotPassword),
          child: const Text(AppStrings.forgotPassword),
        ),
      ),
      AppSpacing.vGapMd,
      PrimaryButton(
        label: AppStrings.login,
        isLoading: isSubmitting,
        onPressed: _loginEmail,
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
          onPressed: _sendOtp,
        ),
      ] else ...[
        AppSpacing.vGapLg,
        OtpField(controller: _otp),
        AppSpacing.vGapLg,
        PrimaryButton(
          label: AppStrings.verifyAndContinue,
          isLoading: isSubmitting,
          onPressed: _verifyOtp,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: isSubmitting ? null : _sendOtp,
            child: const Text(AppStrings.resendOtp),
          ),
        ),
      ],
    ];
  }
}
