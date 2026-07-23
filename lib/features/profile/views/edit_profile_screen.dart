import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../../config/providers/config_providers.dart';
import '../viewmodels/profile_viewmodel.dart';

/// Edit the authenticated user's profile (`PUT /me`).
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _phone;

  String? _currency;
  String? _visibility;
  bool _saveOverlay = false;

  Map<String, String> _visibilityOptions(BuildContext context) => {
    'everyone': context.l10n.profileVisibilityEveryone,
    'registered': context.l10n.profileVisibilityRegistered,
    'none': context.l10n.profileVisibilityNobody,
  };

  @override
  void initState() {
    super.initState();
    final user = ref.read(authViewModelProvider).user;
    _name = TextEditingController(text: user?.name ?? '');
    _email = TextEditingController(text: user?.email ?? '');
    _phone = TextEditingController(text: user?.phone ?? '');
    _currency = user?.currency;
    _visibility = user?.phoneVisibility;
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final user = ref.read(authViewModelProvider).user;

    final changes = <String, dynamic>{};
    final name = _name.text.trim();
    final email = _email.text.trim();
    final phone = _phone.text.trim();
    if (name.isNotEmpty && name != user?.name) changes['name'] = name;
    if (email != (user?.email ?? '')) changes['email'] = email;
    if (phone != (user?.phone ?? '')) changes['phone'] = phone;
    if (_currency != null && _currency != user?.currency) {
      changes['currency'] = _currency;
    }
    if (_visibility != null && _visibility != user?.phoneVisibility) {
      changes['phone_visibility'] = _visibility;
    }

    if (changes.isEmpty) {
      context.showSnack(context.l10n.profileNothingToUpdate);
      return;
    }

    setState(() => _saveOverlay = true);
    final startedAt = DateTime.now();
    final ok = await ref
        .read(profileViewModelProvider.notifier)
        .updateProfile(changes);
    final elapsed = DateTime.now().difference(startedAt);
    const minVisible = Duration(milliseconds: 700);
    if (elapsed < minVisible) {
      await Future<void>.delayed(minVisible - elapsed);
    }
    if (!mounted) return;
    setState(() => _saveOverlay = false);
    if (ok) {
      context.showSnack(context.l10n.profileUpdated);
      context.pop();
      return;
    }
    context.showSnack(
      ref.read(profileViewModelProvider).error?.message ??
          context.l10n.profileUpdateFailed,
      error: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting = ref.watch(
      profileViewModelProvider.select((s) => s.isSubmitting),
    );
    final currencies = ref.watch(currencyOptionsProvider);

    final visibilityOptions = _visibilityOptions(context);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.profileEditProfile)),
      body: Stack(
        children: [
          SafeArea(
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
                        const Center(child: _AvatarPicker()),
                        AppSpacing.vGapXl,
                        AppTextField(
                          label: context.l10n.fullName,
                          controller: _name,
                          prefixIcon: Icons.person_outline_rounded,
                          textInputAction: TextInputAction.next,
                          validator: (v) =>
                              Validators.required(v, field: 'Name'),
                        ),
                        AppSpacing.vGapLg,
                        AppTextField(
                          label: context.l10n.email,
                          hint: 'you@example.com',
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.mail_outline_rounded,
                          textInputAction: TextInputAction.next,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? null
                              : Validators.email(v),
                        ),
                        AppSpacing.vGapLg,
                        AppTextField(
                          label: context.l10n.phone,
                          hint: context.l10n.profilePhoneHint,
                          controller: _phone,
                          keyboardType: TextInputType.phone,
                          prefixIcon: Icons.phone_outlined,
                          textInputAction: TextInputAction.done,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? null
                              : Validators.phone(v),
                        ),
                        if (currencies.isNotEmpty) ...[
                          AppSpacing.vGapLg,
                          DropdownButtonFormField<String>(
                            initialValue:
                                currencies.any((c) => c.code == _currency)
                                ? _currency
                                : null,
                            decoration: InputDecoration(
                              labelText: context.l10n.currency,
                            ),
                            items: [
                              for (final c in currencies)
                                DropdownMenuItem(
                                  value: c.code,
                                  child: Text(
                                    context.l10n.profileCurrencyOption(
                                      c.code,
                                      c.name,
                                    ),
                                  ),
                                ),
                            ],
                            onChanged: (v) => setState(() => _currency = v),
                          ),
                        ],
                        AppSpacing.vGapLg,
                        DropdownButtonFormField<String>(
                          initialValue:
                              visibilityOptions.containsKey(_visibility)
                              ? _visibility
                              : null,
                          decoration: InputDecoration(
                            labelText: context.l10n.profileWhoCanSeePhone,
                          ),
                          items: [
                            for (final e in visibilityOptions.entries)
                              DropdownMenuItem(
                                value: e.key,
                                child: Text(e.value),
                              ),
                          ],
                          onChanged: (v) => setState(() => _visibility = v),
                        ),
                        AppSpacing.vGapXxl,
                        PrimaryButton(
                          label: context.l10n.accountSaveChanges,
                          isLoading: isSubmitting,
                          onPressed: _save,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_saveOverlay || isSubmitting)
            Positioned.fill(
              child: AbsorbPointer(
                child: ColoredBox(
                  color: const Color(0x66000000),
                  child: Center(
                    child: LoadingAnimationWidget.dotsTriangle(
                      color: AppColors.primary,
                      size: 64,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Circular avatar with a tap-to-change camera badge that picks an image and
/// uploads it to `/me/photo`.
class _AvatarPicker extends ConsumerStatefulWidget {
  const _AvatarPicker();

  @override
  ConsumerState<_AvatarPicker> createState() => _AvatarPickerState();
}

class _AvatarPickerState extends ConsumerState<_AvatarPicker> {
  bool _uploading = false;

  Future<void> _pick() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      imageQuality: 85,
    );
    if (picked == null) return;
    setState(() => _uploading = true);
    final ok = await ref
        .read(profileViewModelProvider.notifier)
        .uploadPhoto(picked.path);
    if (!mounted) return;
    setState(() => _uploading = false);
    context.showSnack(
      ok
          ? context.l10n.profilePhotoUpdated
          : ref.read(profileViewModelProvider).error?.message ??
                context.l10n.profileUploadFailed,
      error: !ok,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authViewModelProvider.select((s) => s.user));
    final avatarUrl = user?.avatarUrl;

    return Stack(
      children: [
        CircleAvatar(
          radius: 44,
          backgroundColor: AppColors.primarySurface,
          backgroundImage: avatarUrl != null
              ? CachedNetworkImageProvider(avatarUrl)
              : null,
          child: avatarUrl == null
              ? Text(
                  user?.initials ?? '?',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                )
              : null,
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: InkResponse(
            onTap: _uploading ? null : _pick,
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary,
              child: _uploading
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : const Icon(
                      Icons.camera_alt_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
