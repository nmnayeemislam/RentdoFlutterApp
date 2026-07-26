import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/otp_field.dart';
import '../../../shared/widgets/phone_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../widgets/auth_header.dart';

/// Two-step phone-OTP registration wired to [AuthViewModel].
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

  String? get _errorMessage => ref.read(authViewModelProvider).error?.message;

  Future<void> _sendOtp() async {
    if (!_collectFormKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final result = await ref
        .read(authViewModelProvider.notifier)
        .startRegister(
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
          _errorMessage ?? context.l10n.somethingWentWrong,
          error: true,
        );
    }
  }

  Future<void> _verify() async {
    if (!_verifyFormKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final result = await ref
        .read(authViewModelProvider.notifier)
        .verifyRegister(
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
          _errorMessage ?? context.l10n.somethingWentWrong,
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

  void _handleBack() {
    FocusScope.of(context).unfocus();
    if (_otpStep) {
      _backToDetails();
      return;
    }
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting = ref.watch(
      authViewModelProvider.select((s) => s.isSubmitting),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: _handleBack,
        ),
      ),
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
          AuthHeader(
            title: context.l10n.createAccount,
            subtitle: context.l10n.authJoinRentdoDesc,
            logoSize: 110,
            logoPadding: 16,
          ),
          AppSpacing.vGapXxl,
          AppTextField(
            label: context.l10n.fullName,
            hint: context.l10n.authFullNameHint,
            controller: _name,
            prefixIcon: Icons.person_outline_rounded,
            textInputAction: TextInputAction.next,
            validator: (v) =>
                Validators.required(v, context.l10n, field: context.l10n.fullName),
          ),
          AppSpacing.vGapLg,
          AppTextField(
            label: context.l10n.email,
            hint: 'you@example.com',
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.mail_outline_rounded,
            textInputAction: TextInputAction.next,
            validator: (v) => Validators.email(v, context.l10n),
          ),
          AppSpacing.vGapLg,
          PhoneField(
            label: context.l10n.phone,
            hint: '1711 223344',
            controller: _phone,
            textInputAction: TextInputAction.next,
            validator: (v) => Validators.phone(v, context.l10n),
          ),
          AppSpacing.vGapLg,
          AppTextField(
            label: context.l10n.password,
            hint: '••••••••',
            controller: _password,
            obscure: true,
            prefixIcon: Icons.lock_outline_rounded,
            textInputAction: TextInputAction.done,
            validator: (v) => Validators.password(v, context.l10n),
          ),
          AppSpacing.vGapXl,
          PrimaryButton(
            label: context.l10n.sendOtp,
            isLoading: isSubmitting,
            onPressed: _sendOtp,
          ),
          AppSpacing.vGapLg,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                context.l10n.alreadyHaveAccount,
                style: AppTextStyles.bodyMd,
              ),
              TextButton(
                onPressed: () => context.go(AppRoutes.login),
                child: Text(context.l10n.login),
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
          AuthHeader(
            title: context.l10n.createAccount,
            subtitle: context.l10n.authEnterCodeDesc,
            logoSize: 110,
            logoPadding: 16,
          ),
          AppSpacing.vGapXl,
          Text(
            context.l10n.authVerifyingPhone(_phone.text.trim()),
            style: AppTextStyles.titleSm,
          ),
          AppSpacing.vGapLg,
          OtpField(controller: _otp),
          AppSpacing.vGapXl,
          PrimaryButton(
            label: context.l10n.createAccountCta,
            isLoading: isSubmitting,
            onPressed: _verify,
          ),
          AppSpacing.vGapSm,
          TextButton(
            onPressed: isSubmitting ? null : _sendOtp,
            child: Text(context.l10n.resendOtp),
          ),
          TextButton(
            onPressed: isSubmitting ? null : _backToDetails,
            child: Text(context.l10n.changeDetails),
          ),
        ],
      ),
    );
  }
}
