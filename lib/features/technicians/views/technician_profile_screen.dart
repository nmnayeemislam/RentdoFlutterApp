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
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../viewmodels/technician_viewmodel.dart';

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
      context.showSnack(context.l10n.profileUpdated);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      context.showSnack(e.message, error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAuthed =
        ref.watch(authViewModelProvider.select((s) => s.isAuthenticated));

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.technicianProfileTitle)),
      body: !isAuthed ? const _GuestPrompt() : _buildForm(),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(context.l10n.technicianProfileDetails,
              style: AppTextStyles.headingMd),
          AppSpacing.vGapSm,
          Text(
            context.l10n.technicianKeepCurrentDesc,
            style: AppTextStyles.bodySm,
          ),
          AppSpacing.vGapXl,
          AppTextField(
            label: context.l10n.bio,
            hint: context.l10n.technicianBioHint,
            controller: _bio,
            maxLines: 3,
          ),
          AppSpacing.vGapLg,
          AppTextField(
            label: context.l10n.skills,
            hint: context.l10n.technicianSkillsHint,
            controller: _skills,
          ),
          AppSpacing.vGapLg,
          AppTextField(
            label: context.l10n.technicianExperienceYears,
            hint: context.l10n.technicianExperienceHint,
            controller: _experience,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          AppSpacing.vGapLg,
          AppTextField(
            label: context.l10n.technicianHourlyRate,
            hint: context.l10n.technicianRateHint,
            controller: _hourlyRate,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          AppSpacing.vGapSm,
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            value: _isAvailable,
            activeThumbColor: AppColors.primary,
            title: Text(
              context.l10n.technicianAvailableForWork,
              style: AppTextStyles.titleSm,
            ),
            subtitle: Text(
              context.l10n.technicianPauseDesc,
              style: AppTextStyles.bodySm,
            ),
            onChanged: (v) => setState(() => _isAvailable = v),
          ),
          AppSpacing.vGapXl,
          PrimaryButton(
            label: context.l10n.accountSaveChanges,
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
      title: context.l10n.technicianSignInToManage,
      subtitle: context.l10n.technicianLogInToUpdate,
      action: SizedBox(
        width: 200,
        child: PrimaryButton(
          label: context.l10n.login,
          onPressed: () => context.push(AppRoutes.login),
        ),
      ),
    );
  }
}
