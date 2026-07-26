import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/state_views.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../viewmodels/technician_viewmodel.dart';

/// Application form for users who want to join as a technician.
class BecomeTechnicianScreen extends ConsumerStatefulWidget {
  const BecomeTechnicianScreen({super.key});

  @override
  ConsumerState<BecomeTechnicianScreen> createState() =>
      _BecomeTechnicianScreenState();
}

class _BecomeTechnicianScreenState
    extends ConsumerState<BecomeTechnicianScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bio = TextEditingController();
  final _skills = TextEditingController();
  final _experience = TextEditingController();
  final _hourlyRate = TextEditingController();
  int? _categoryId;
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

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final categoryId = _categoryId;
    if (categoryId == null) {
      context.showSnack(context.l10n.technicianChooseCategory, error: true);
      return;
    }
    final bio = _bio.text.trim();
    setState(() => _submitting = true);
    try {
      await ref.read(technicianServiceProvider).apply(
            categoryId: categoryId,
            bio: bio.isEmpty ? null : bio,
            skills: _parsedSkills,
            experienceYears: int.tryParse(_experience.text.trim()),
            hourlyRate: num.tryParse(_hourlyRate.text.trim()),
          );
      if (!mounted) return;
      context.showSnack(context.l10n.technicianApplicationSubmitted);
      context.pop();
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
      appBar: AppBar(title: Text(context.l10n.technicianBecomeTitle)),
      body: !isAuthed ? const _GuestPrompt() : _buildForm(),
    );
  }

  Widget _buildForm() {
    final categories = ref.watch(technicianCategoriesProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              context.l10n.technicianTellUsTitle,
              style: AppTextStyles.headingMd,
            ),
            AppSpacing.vGapSm,
            Text(
              context.l10n.technicianReviewDesc,
              style: AppTextStyles.bodySm,
            ),
            AppSpacing.vGapXl,
            categories.when(
              loading: () => const SizedBox.shrink(),
              error: (e, _) => AppErrorWidget(
                message: '$e',
                onRetry: () => ref.invalidate(technicianCategoriesProvider),
              ),
              data: (items) => DropdownButtonFormField<int>(
                initialValue: _categoryId,
                decoration: InputDecoration(labelText: context.l10n.category),
                items: [
                  for (final c in items)
                    DropdownMenuItem(value: c.id, child: Text(c.name)),
                ],
                validator: (v) =>
                    v == null ? context.l10n.technicianChooseCategory : null,
                onChanged: (v) => setState(() => _categoryId = v),
              ),
            ),
            AppSpacing.vGapLg,
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
            AppSpacing.vGapXxl,
            PrimaryButton(
              label: context.l10n.technicianSubmitApplication,
              isLoading: _submitting,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

class _GuestPrompt extends StatelessWidget {
  const _GuestPrompt();

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.handyman_outlined,
      title: context.l10n.technicianSignInToApply,
      subtitle: context.l10n.technicianLogInToApply,
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
