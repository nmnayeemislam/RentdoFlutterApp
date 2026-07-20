import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/state_views.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/technician_controller.dart';

/// Lets a signed-in technician edit their public profile and availability.
class TechnicianProfileScreen extends ConsumerStatefulWidget {
  const TechnicianProfileScreen({super.key});

  @override
  ConsumerState<TechnicianProfileScreen> createState() =>
      _TechnicianProfileScreenState();
}

class _TechnicianProfileScreenState
    extends ConsumerState<TechnicianProfileScreen> {
  final _bio = TextEditingController();
  final _skills = TextEditingController();
  final _experience = TextEditingController();
  final _hourlyRate = TextEditingController();
  bool _isAvailable = true;
  bool _submitting = false;

  @override
  void dispose() {
    _bio.dispose();
    _skills.dispose();
    _experience.dispose();
    _hourlyRate.dispose();
    super.dispose();
  }

  List<String> get _parsedSkills => _skills.text
      .split(',')
      .map((s) => s.trim())
      .where((s) => s.isNotEmpty)
      .toList(growable: false);

  Future<void> _save() async {
    final bio = _bio.text.trim();
    final skills = _parsedSkills;
    setState(() => _submitting = true);
    try {
      await ref.read(technicianServiceProvider).updateProfile(
            bio: bio.isEmpty ? null : bio,
            skills: skills.isEmpty ? null : skills,
            experienceYears: int.tryParse(_experience.text.trim()),
            hourlyRate: num.tryParse(_hourlyRate.text.trim()),
            isAvailable: _isAvailable,
          );
      if (!mounted) return;
      setState(() => _submitting = false);
      context.showSnack('Profile updated');
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      context.showSnack(e.message, error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAuthed =
        ref.watch(authControllerProvider.select((s) => s.isAuthenticated));

    return Scaffold(
      appBar: AppBar(title: const Text('My Technician Profile')),
      body: !isAuthed ? const _GuestPrompt() : _buildForm(),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Profile details', style: AppTextStyles.headingMd),
          AppSpacing.vGapSm,
          const Text(
            'Keep your details current so customers know what you offer.',
            style: AppTextStyles.bodySm,
          ),
          AppSpacing.vGapXl,
          AppTextField(
            label: 'Bio',
            hint: 'A short intro about your experience',
            controller: _bio,
            maxLines: 3,
          ),
          AppSpacing.vGapLg,
          AppTextField(
            label: 'Skills',
            hint: 'Comma separated, e.g. Plumbing, Wiring',
            controller: _skills,
          ),
          AppSpacing.vGapLg,
          AppTextField(
            label: 'Experience (years)',
            hint: 'e.g. 5',
            controller: _experience,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          AppSpacing.vGapLg,
          AppTextField(
            label: 'Hourly rate',
            hint: 'Your rate per hour',
            controller: _hourlyRate,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          AppSpacing.vGapSm,
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            value: _isAvailable,
            activeThumbColor: AppColors.primary,
            title: const Text(
              'Available for work',
              style: AppTextStyles.titleSm,
            ),
            subtitle: const Text(
              'Turn this off to pause new requests.',
              style: AppTextStyles.bodySm,
            ),
            onChanged: (v) => setState(() => _isAvailable = v),
          ),
          AppSpacing.vGapXl,
          PrimaryButton(
            label: 'Save changes',
            isLoading: _submitting,
            onPressed: _save,
          ),
        ],
      ),
    );
  }
}

class _GuestPrompt extends StatelessWidget {
  const _GuestPrompt();

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.badge_outlined,
      title: 'Sign in to manage your profile',
      subtitle: 'Log in to update your technician details.',
      action: SizedBox(
        width: 200,
        child: PrimaryButton(
          label: 'Log in',
          onPressed: () => context.push(AppRoutes.login),
        ),
      ),
    );
  }
}
