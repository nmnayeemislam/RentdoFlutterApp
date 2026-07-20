import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../controllers/profile_controller.dart';

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
        .read(profileControllerProvider.notifier)
        .changePassword(_current.text, _password.text);
    if (!mounted) return;
    if (ok) {
      context.showSnack('Password changed');
      context.pop();
    } else {
      context.showSnack(
        ref.read(profileControllerProvider).error?.message ??
            'Could not change password',
        error: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting =
        ref.watch(profileControllerProvider.select((s) => s.isSubmitting));

    return Scaffold(
      appBar: AppBar(title: const Text('Change Password')),
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
                      label: 'Current password',
                      controller: _current,
                      obscure: true,
                      prefixIcon: Icons.lock_outline_rounded,
                      textInputAction: TextInputAction.next,
                      validator: (v) =>
                          Validators.required(v, field: 'Current password'),
                    ),
                    AppSpacing.vGapLg,
                    AppTextField(
                      label: 'New password',
                      controller: _password,
                      obscure: true,
                      prefixIcon: Icons.lock_reset_rounded,
                      textInputAction: TextInputAction.next,
                      validator: Validators.password,
                    ),
                    AppSpacing.vGapLg,
                    AppTextField(
                      label: 'Confirm new password',
                      controller: _confirm,
                      obscure: true,
                      prefixIcon: Icons.lock_reset_rounded,
                      textInputAction: TextInputAction.done,
                      validator: (v) => Validators.confirm(v, _password.text),
                    ),
                    AppSpacing.vGapXxl,
                    PrimaryButton(
                      label: 'Update password',
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
