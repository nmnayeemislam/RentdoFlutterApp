import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/otp_field.dart';
import '../../../shared/widgets/phone_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/screen_loading_overlay.dart';
import '../../../shared/widgets/segmented_control.dart';
import '../../config/providers/config_providers.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../widgets/auth_header.dart';

/// Languages the UI can actually render (matches the translated `.arb` files).
const _supportedLanguages = <(String code, String label)>[
  ('en', 'English'),
  ('bn', 'বাংলা'),
  ('ar', 'العربية'),
];

const _languageCodes = <String, String>{'en': 'EN', 'bn': 'BN', 'ar': 'AR'};

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
  bool _guestLoading = false;
  bool _languageChanging = false;

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

  String? get _errorMessage => ref.read(authViewModelProvider).error?.message;

  Future<void> _pickLanguage() async {
    final active = ref.read(localeControllerProvider).locale;
    final picked = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Material(
          color: Theme.of(sheetContext).colorScheme.surface,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              for (final (code, label) in _supportedLanguages)
                ListTile(
                  title: Text(label),
                  trailing: code == active
                      ? const Icon(
                          Icons.check_rounded,
                          color: AppColors.primary,
                        )
                      : null,
                  onTap: () => Navigator.pop(sheetContext, code),
                ),
            ],
          ),
        ),
      ),
    );
    if (picked != null && picked != active) {
      setState(() => _languageChanging = true);
      await Future<void>.delayed(const Duration(milliseconds: 220));
      ref.read(localeControllerProvider.notifier).setLocale(picked);
      if (mounted) setState(() => _languageChanging = false);
    }
  }

  Future<void> _continueAsGuest() async {
    setState(() => _guestLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 220));
    if (mounted) context.go(AppRoutes.home);
  }

  Future<void> _loginEmail() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final result = await ref
        .read(authViewModelProvider.notifier)
        .loginWithEmail(_email.text.trim(), _password.text);
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

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final result = await ref
        .read(authViewModelProvider.notifier)
        .startPhoneLogin(_phone.text.trim());
    if (!mounted) return;
    switch (result) {
      case AuthActionResult.otpSent:
      case AuthActionResult.success:
        setState(() => _otpSent = true);
      case AuthActionResult.failed:
        context.showSnack(
          _errorMessage ?? context.l10n.somethingWentWrong,
          error: true,
        );
    }
  }

  Future<void> _verifyOtp() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final result = await ref
        .read(authViewModelProvider.notifier)
        .verifyPhoneLogin(_phone.text.trim(), _otp.text.trim());
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

  @override
  Widget build(BuildContext context) {
    final isSubmitting = ref.watch(
      authViewModelProvider.select((s) => s.isSubmitting),
    );
    final activeLanguage = ref.watch(
      localeControllerProvider.select((s) => s.locale),
    );
    final activeLanguageCode =
        _languageCodes[activeLanguage] ?? activeLanguage.toUpperCase();
    final loading = isSubmitting || _guestLoading || _languageChanging;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: AppSpacing.md),
            child: Tooltip(
              message: context.l10n.configLanguage,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: AppRadius.brPill,
                  onTap: _pickLanguage,
                  child: Container(
                    height: 36,
                    padding: const EdgeInsetsDirectional.only(
                      start: AppSpacing.sm,
                      end: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: context.colors.surface,
                      borderRadius: AppRadius.brPill,
                      border: Border.all(color: context.colors.outline),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.language_rounded, size: 18),
                        const SizedBox(width: AppSpacing.xs),
                        Text(activeLanguageCode, style: AppTextStyles.label),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 18,
                          color: AppColors.textTertiary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ScreenLoadingOverlay(
        loading: loading,
        child: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xxl,
                AppSpacing.sm,
                AppSpacing.xxl,
                AppSpacing.xxl,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AuthHeader(
                        title: context.l10n.welcomeBack,
                        subtitle: context.l10n.authContinueLoginDesc,
                        logoSize: 86,
                        logoPadding: 14,
                      ),
                      AppSpacing.vGapXxl,
                      SegmentedControl(
                        labels: [context.l10n.email, context.l10n.phone],
                        selected: _phoneMode ? 1 : 0,
                        onChanged: loading
                            ? (_) {}
                            : (i) {
                                if ((i == 1) != _phoneMode) _switchMode();
                              },
                      ),
                      AppSpacing.vGapXl,
                      if (_phoneMode)
                        ..._phoneFields(loading)
                      else
                        ..._emailFields(loading),
                      AppSpacing.vGapMd,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            context.l10n.dontHaveAccount,
                            style: AppTextStyles.bodyMd,
                          ),
                          TextButton(
                            onPressed: loading
                                ? null
                                : () => context.go(AppRoutes.register),
                            child: Text(context.l10n.register),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: loading ? null : _continueAsGuest,
                        child: Text(context.l10n.continueAsGuest),
                      ),
                    ],
                  ),
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
        label: context.l10n.email,
        hint: 'you@example.com',
        controller: _email,
        keyboardType: TextInputType.emailAddress,
        prefixIcon: Icons.mail_outline_rounded,
        textInputAction: TextInputAction.next,
        validator: Validators.email,
      ),
      AppSpacing.vGapLg,
      AppTextField(
        label: context.l10n.password,
        hint: '••••••••',
        controller: _password,
        obscure: true,
        prefixIcon: Icons.lock_outline_rounded,
        textInputAction: TextInputAction.done,
        validator: Validators.password,
      ),
      Align(
        alignment: AlignmentDirectional.centerEnd,
        child: TextButton(
          onPressed: isSubmitting
              ? null
              : () => context.push(AppRoutes.forgotPassword),
          child: Text(context.l10n.forgotPassword),
        ),
      ),
      AppSpacing.vGapMd,
      PrimaryButton(
        label: context.l10n.login,
        isLoading: isSubmitting,
        onPressed: _loginEmail,
      ),
    ];
  }

  List<Widget> _phoneFields(bool isSubmitting) {
    return [
      PhoneField(
        label: context.l10n.phone,
        hint: '1711 223344',
        controller: _phone,
        enabled: !_otpSent,
        textInputAction: TextInputAction.next,
        validator: Validators.phone,
      ),
      if (!_otpSent) ...[
        AppSpacing.vGapLg,
        PrimaryButton(
          label: context.l10n.sendOtp,
          isLoading: isSubmitting,
          onPressed: _sendOtp,
        ),
      ] else ...[
        AppSpacing.vGapLg,
        OtpField(controller: _otp),
        AppSpacing.vGapLg,
        PrimaryButton(
          label: context.l10n.verifyAndContinue,
          isLoading: isSubmitting,
          onPressed: _verifyOtp,
        ),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: TextButton(
            onPressed: isSubmitting ? null : _sendOtp,
            child: Text(context.l10n.resendOtp),
          ),
        ),
      ],
    ];
  }
}
