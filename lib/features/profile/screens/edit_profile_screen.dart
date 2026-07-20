import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../config/providers/config_providers.dart';
import '../controllers/profile_controller.dart';

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

  static const _visibilityOptions = <String, String>{
    'everyone': 'Everyone',
    'registered': 'Registered users',
    'none': 'Nobody',
  };

  @override
  void initState() {
    super.initState();
    final user = ref.read(authControllerProvider).user;
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
    final user = ref.read(authControllerProvider).user;

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
      context.showSnack('Nothing to update');
      return;
    }

    final ok =
        await ref.read(profileControllerProvider.notifier).updateProfile(changes);
    if (!mounted) return;
    if (ok) {
      context.showSnack('Profile updated');
      context.pop();
    } else {
      context.showSnack(
        ref.read(profileControllerProvider).error?.message ?? 'Update failed',
        error: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting =
        ref.watch(profileControllerProvider.select((s) => s.isSubmitting));
    final currencies = ref.watch(currencyOptionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
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
                    const Center(child: _AvatarPicker()),
                    AppSpacing.vGapXl,
                    AppTextField(
                      label: 'Full name',
                      controller: _name,
                      prefixIcon: Icons.person_outline_rounded,
                      textInputAction: TextInputAction.next,
                      validator: (v) => Validators.required(v, field: 'Name'),
                    ),
                    AppSpacing.vGapLg,
                    AppTextField(
                      label: 'Email',
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
                      label: 'Phone',
                      hint: '+1 415 555 0100',
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
                        initialValue: currencies.any((c) => c.code == _currency)
                            ? _currency
                            : null,
                        decoration: const InputDecoration(labelText: 'Currency'),
                        items: [
                          for (final c in currencies)
                            DropdownMenuItem(
                              value: c.code,
                              child: Text('${c.code} — ${c.name}'),
                            ),
                        ],
                        onChanged: (v) => setState(() => _currency = v),
                      ),
                    ],
                    AppSpacing.vGapLg,
                    DropdownButtonFormField<String>(
                      initialValue: _visibilityOptions.containsKey(_visibility)
                          ? _visibility
                          : null,
                      decoration:
                          const InputDecoration(labelText: 'Who can see my phone'),
                      items: [
                        for (final e in _visibilityOptions.entries)
                          DropdownMenuItem(value: e.key, child: Text(e.value)),
                      ],
                      onChanged: (v) => setState(() => _visibility = v),
                    ),
                    AppSpacing.vGapXxl,
                    PrimaryButton(
                      label: 'Save changes',
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
    final ok =
        await ref.read(profileControllerProvider.notifier).uploadPhoto(picked.path);
    if (!mounted) return;
    setState(() => _uploading = false);
    context.showSnack(ok
        ? 'Photo updated'
        : ref.read(profileControllerProvider).error?.message ?? 'Upload failed',
        error: !ok);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider.select((s) => s.user));
    final avatarUrl = user?.avatarUrl;

    return Stack(
      children: [
        CircleAvatar(
          radius: 44,
          backgroundColor: AppColors.primarySurface,
          backgroundImage:
              avatarUrl != null ? CachedNetworkImageProvider(avatarUrl) : null,
          child: avatarUrl == null
              ? Text(user?.initials ?? '?',
                  style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary))
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
                  : const Icon(Icons.camera_alt_rounded,
                      size: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
