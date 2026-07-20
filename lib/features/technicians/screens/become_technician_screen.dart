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
import '../../auth/controllers/auth_controller.dart';
import '../controllers/technician_controller.dart';

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
      context.showSnack('Choose a category', error: true);
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
      context.showSnack("Application submitted — we'll review it shortly");
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
        ref.watch(authControllerProvider.select((s) => s.isAuthenticated));

    return Scaffold(
      appBar: AppBar(title: const Text('Become a Technician')),
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
            const Text(
              'Tell us about your work',
              style: AppTextStyles.headingMd,
            ),
            AppSpacing.vGapSm,
            const Text(
              'We review every application before your profile goes live.',
              style: AppTextStyles.bodySm,
            ),
            AppSpacing.vGapXl,
            categories.when(
              loading: () => const LoadingWidget(),
              error: (e, _) => AppErrorWidget(
                message: '$e',
                onRetry: () => ref.invalidate(technicianCategoriesProvider),
              ),
              data: (items) => DropdownButtonFormField<int>(
                initialValue: _categoryId,
                decoration: const InputDecoration(labelText: 'Category'),
                items: [
                  for (final c in items)
                    DropdownMenuItem(value: c.id, child: Text(c.name)),
                ],
                validator: (v) => v == null ? 'Choose a category' : null,
                onChanged: (v) => setState(() => _categoryId = v),
              ),
            ),
            AppSpacing.vGapLg,
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
            AppSpacing.vGapXxl,
            PrimaryButton(
              label: 'Submit application',
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
      title: 'Sign in to apply',
      subtitle: 'Log in to send us your technician application.',
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
