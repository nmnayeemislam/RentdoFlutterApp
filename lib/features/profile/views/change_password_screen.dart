import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../viewmodels/profile_viewmodel.dart';

/// Change the account password (`PUT /me/password`).
class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _current = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _current.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final ok = await ref
        .read(profileViewModelProvider.notifier)
        .changePassword(_current.text, _password.text);
    if (!mounted) return;
    if (ok) {
      context.showSnack(context.l10n.profilePasswordChanged);
      context.pop();
    } else {
      context.showSnack(
        ref.read(profileViewModelProvider).error?.message ??
            context.l10n.profileCouldNotChangePassword,
        error: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting =
        ref.watch(profileViewModelProvider.select((s) => s.isSubmitting));

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.profileChangePassword)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppTextField(
                      label: context.l10n.profileCurrentPassword,
                      controller: _current,
                      obscure: true,
                      prefixIcon: Icons.lock_outline_rounded,
                      textInputAction: TextInputAction.next,
                      validator: (v) => Validators.required(
                        v,
                        context.l10n,
                        field: context.l10n.profileCurrentPassword,
                      ),
                    ),
                    AppSpacing.vGapLg,
                    AppTextField(
                      label: context.l10n.newPassword,
                      controller: _password,
                      obscure: true,
                      prefixIcon: Icons.lock_reset_rounded,
                      textInputAction: TextInputAction.next,
                      validator: (v) => Validators.password(v, context.l10n),
                    ),
                    AppSpacing.vGapLg,
                    AppTextField(
                      label: context.l10n.profileConfirmNewPassword,
                      controller: _confirm,
                      obscure: true,
                      prefixIcon: Icons.lock_reset_rounded,
                      textInputAction: TextInputAction.done,
                      validator: (v) =>
                          Validators.confirm(v, _password.text, context.l10n),
                    ),
                    AppSpacing.vGapXxl,
                    PrimaryButton(
                      label: context.l10n.profileUpdatePassword,
                      isLoading: isSubmitting,
                      onPressed: _submit,
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
}
