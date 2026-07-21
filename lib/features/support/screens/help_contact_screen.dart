import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../config/providers/config_providers.dart';
import '../models/cms_page.dart';
import '../providers/support_providers.dart';

/// Help & Contact: reach-us channels (from bootstrap site info), a contact-us
/// form that posts to `POST /contact`, and an FAQ accordion.
class HelpContactScreen extends ConsumerStatefulWidget {
  const HelpContactScreen({super.key});

  @override
  ConsumerState<HelpContactScreen> createState() => _HelpContactScreenState();
}

class _HelpContactScreenState extends ConsumerState<HelpContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _subject = TextEditingController();
  final _message = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _subject.dispose();
    _message.dispose();
    super.dispose();
  }

  Future<void> _launch(Uri uri) async {
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) context.showSnack('Could not open ${uri.scheme}', error: true);
    }
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _submitting = true);
    try {
      await ref.read(supportRepositoryProvider).sendContactMessage(
            name: _name.text.trim(),
            email: _email.text.trim(),
            subject: _subject.text.trim(),
            message: _message.text.trim(),
          );
      if (!mounted) return;
      _formKey.currentState?.reset();
      _name.clear();
      _email.clear();
      _subject.clear();
      _message.clear();
      context.showSnack("Thanks for reaching out. We'll get back to you shortly.");
    } catch (_) {
      if (mounted) {
        context.showSnack('Could not send your message. Please try again.',
            error: true);
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final site = ref.watch(bootstrapProvider).valueOrNull?.siteInfo;
    final faqs = ref.watch(faqsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Help & Contact')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            const Text('Get in touch', style: AppTextStyles.headingMd),
            const SizedBox(height: 4),
            Text(
              'We usually respond within one business day.',
              style:
                  AppTextStyles.bodySm.copyWith(color: AppColors.textSecondary),
            ),
            AppSpacing.vGapLg,

            // ── Reach-us channels ────────────────────────────────────────────
            if (site?.email != null && site!.email!.isNotEmpty)
              _ContactTile(
                icon: Icons.email_outlined,
                title: 'Email us',
                subtitle: site.email!,
                onTap: () => _launch(Uri(scheme: 'mailto', path: site.email)),
              ),
            if (site?.phone != null && site!.phone!.isNotEmpty)
              _ContactTile(
                icon: Icons.call_outlined,
                title: 'Call us',
                subtitle: site.phone!,
                onTap: () => _launch(Uri(scheme: 'tel', path: site.phone)),
              ),
            if (site?.address != null && site!.address!.isNotEmpty)
              _ContactTile(
                icon: Icons.location_on_outlined,
                title: 'Visit us',
                subtitle: site.address!,
              ),

            AppSpacing.vGapXl,

            // ── Contact form ─────────────────────────────────────────────────
            const Text('Send us a message', style: AppTextStyles.titleMd),
            AppSpacing.vGapMd,
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _name,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Your name'),
                    validator: (v) => Validators.required(v, field: 'Name'),
                  ),
                  AppSpacing.vGapMd,
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: Validators.email,
                  ),
                  AppSpacing.vGapMd,
                  TextFormField(
                    controller: _subject,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Subject'),
                    validator: (v) => Validators.required(v, field: 'Subject'),
                  ),
                  AppSpacing.vGapMd,
                  TextFormField(
                    controller: _message,
                    minLines: 4,
                    maxLines: 8,
                    decoration: const InputDecoration(
                      labelText: 'Message',
                      alignLabelWithHint: true,
                    ),
                    validator: (v) => Validators.required(v, field: 'Message'),
                  ),
                  AppSpacing.vGapLg,
                  PrimaryButton(
                    label: 'Send message',
                    icon: Icons.send_rounded,
                    isLoading: _submitting,
                    onPressed: _submit,
                  ),
                ],
              ),
            ),

            AppSpacing.vGapXl,

            // ── FAQ ──────────────────────────────────────────────────────────
            faqs.maybeWhen(
              data: (sections) => sections.isEmpty
                  ? const SizedBox.shrink()
                  : _FaqBlock(sections: sections),
              orElse: () => const SizedBox.shrink(),
            ),

            AppSpacing.vGapXl,
            const Divider(),
            AppSpacing.vGapSm,
            TextButton(
              onPressed: () => context.push(AppRoutes.privacyPolicy),
              child: const Text('Privacy Policy'),
            ),
            TextButton(
              onPressed: () => context.push(AppRoutes.termsConditions),
              child: const Text('Terms & Conditions'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: AppRadius.brLg,
        border: Border.all(color: context.colors.outline),
      ),
      child: ListTile(
        leading: Container(
          height: 38,
          width: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            borderRadius: AppRadius.brSm,
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        title: Text(title, style: AppTextStyles.titleSm),
        subtitle: Text(subtitle, style: AppTextStyles.bodySm),
        trailing: onTap == null
            ? null
            : const Icon(Icons.chevron_right_rounded,
                color: AppColors.textTertiary),
        onTap: onTap,
      ),
    );
  }
}

class _FaqBlock extends StatelessWidget {
  const _FaqBlock({required this.sections});

  final List<FaqSection> sections;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Frequently asked questions', style: AppTextStyles.titleMd),
        AppSpacing.vGapMd,
        Container(
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: AppRadius.brLg,
            border: Border.all(color: context.colors.outline),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (final section in sections)
                for (final item in section.items)
                  ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                    childrenPadding:
                        const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    iconColor: AppColors.primary,
                    title: Text(item.question, style: AppTextStyles.titleSm),
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(item.answer, style: AppTextStyles.bodyMd),
                      ),
                    ],
                  ),
            ],
          ),
        ),
      ],
    );
  }
}
