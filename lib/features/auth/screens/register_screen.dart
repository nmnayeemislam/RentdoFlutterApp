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
import '../../../shared/widgets/primary_button.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_header.dart';

/// Two-step phone-OTP registration wired to [AuthController].
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _collectFormKey = GlobalKey<FormState>();
  final _verifyFormKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _otp = TextEditingController();

  bool _otpStep = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    _otp.dispose();
    super.dispose();
  }

  String? get _errorMessage => ref.read(authControllerProvider).error?.message;

  String? _optionalEmail(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return Validators.email(value);
  }

  String? _optionalPassword(String? value) {
    if (value == null || value.isEmpty) return null;
    return Validators.password(value);
  }

  Future<void> _sendOtp() async {
    if (!_collectFormKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final result =
        await ref.read(authControllerProvider.notifier).startRegister(
              _phone.text.trim(),
              name: _name.text.trim(),
              email: _email.text.trim(),
            );
    if (!mounted) return;
    switch (result) {
      case AuthActionResult.otpSent:
      case AuthActionResult.success:
        setState(() => _otpStep = true);
      case AuthActionResult.failed:
        context.showSnack(
          _errorMessage ?? AppStrings.somethingWentWrong,
          error: true,
        );
    }
  }

  Future<void> _verify() async {
    if (!_verifyFormKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final result =
        await ref.read(authControllerProvider.notifier).verifyRegister(
              phone: _phone.text.trim(),
              otp: _otp.text.trim(),
              name: _name.text.trim(),
              email: _email.text.trim(),
              password: _password.text,
            );
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

  void _backToDetails() {
    FocusScope.of(context).unfocus();
    setState(() {
      _otpStep = false;
      _otp.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting =
        ref.watch(authControllerProvider.select((s) => s.isSubmitting));

    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: _otpStep
                  ? _verifyStep(isSubmitting)
                  : _collectStep(isSubmitting),
            ),
          ),
        ),
      ),
    );
  }

  Widget _collectStep(bool isSubmitting) {
    return Form(
      key: _collectFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthHeader(
            title: AppStrings.createAccount,
            subtitle: 'Join Rentdo to save favorites and contact agents.',
          ),
          AppSpacing.vGapXxl,
          AppTextField(
            label: AppStrings.phone,
            hint: '+1 415 555 0100',
            controller: _phone,
            keyboardType: TextInputType.phone,
            prefixIcon: Icons.phone_outlined,
            textInputAction: TextInputAction.next,
            validator: Validators.phone,
          ),
          AppSpacing.vGapLg,
          AppTextField(
            label: AppStrings.fullName,
            hint: 'Jane Doe',
            controller: _name,
            prefixIcon: Icons.person_outline_rounded,
            textInputAction: TextInputAction.next,
            validator: (v) => Validators.required(v, field: 'Full name'),
          ),
          AppSpacing.vGapLg,
          AppTextField(
            label: '${AppStrings.email} (optional)',
            hint: 'you@example.com',
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.mail_outline_rounded,
            textInputAction: TextInputAction.next,
            validator: _optionalEmail,
          ),
          AppSpacing.vGapLg,
          AppTextField(
            label: '${AppStrings.password} (optional)',
            hint: '••••••••',
            controller: _password,
            obscure: true,
            prefixIcon: Icons.lock_outline_rounded,
            textInputAction: TextInputAction.done,
            validator: _optionalPassword,
          ),
          AppSpacing.vGapXl,
          PrimaryButton(
            label: AppStrings.sendOtp,
            isLoading: isSubmitting,
            onPressed: _sendOtp,
          ),
          AppSpacing.vGapLg,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                AppStrings.alreadyHaveAccount,
                style: AppTextStyles.bodyMd,
              ),
              TextButton(
                onPressed: () => context.go(AppRoutes.login),
                child: const Text(AppStrings.login),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _verifyStep(bool isSubmitting) {
    return Form(
      key: _verifyFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthHeader(
            title: AppStrings.createAccount,
            subtitle: 'Enter the code we sent to your phone.',
          ),
          AppSpacing.vGapXl,
          Text('Verifying ${_phone.text.trim()}', style: AppTextStyles.titleSm),
          AppSpacing.vGapLg,
          OtpField(controller: _otp),
          AppSpacing.vGapXl,
          PrimaryButton(
            label: AppStrings.createAccountCta,
            isLoading: isSubmitting,
            onPressed: _verify,
          ),
          AppSpacing.vGapSm,
          TextButton(
            onPressed: isSubmitting ? null : _sendOtp,
            child: const Text(AppStrings.resendOtp),
          ),
          TextButton(
            onPressed: isSubmitting ? null : _backToDetails,
            child: const Text(AppStrings.changeDetails),
          ),
        ],
      ),
    );
  }
}
