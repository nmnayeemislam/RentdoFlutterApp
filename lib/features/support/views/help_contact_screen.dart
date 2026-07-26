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
      if (mounted) {
        context.showSnack(context.l10n.supportCouldNotOpen(uri.scheme), error: true);
      }
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
      context.showSnack(context.l10n.supportThanksMessage);
    } catch (_) {
      if (mounted) {
        context.showSnack(context.l10n.supportCouldNotSend, error: true);
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
      appBar: AppBar(title: Text(context.l10n.helpContactTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text(context.l10n.supportGetInTouch, style: AppTextStyles.headingMd),
            const SizedBox(height: 4),
            Text(
              context.l10n.supportRespondDesc,
              style:
                  AppTextStyles.bodySm.copyWith(color: AppColors.textSecondary),
            ),
            AppSpacing.vGapLg,

            // ── Reach-us channels ────────────────────────────────────────────
            if (site?.email != null && site!.email!.isNotEmpty)
              _ContactTile(
                icon: Icons.email_outlined,
                title: context.l10n.supportEmailUs,
                subtitle: site.email!,
                onTap: () => _launch(Uri(scheme: 'mailto', path: site.email)),
              ),
            if (site?.phone != null && site!.phone!.isNotEmpty)
              _ContactTile(
                icon: Icons.call_outlined,
                title: context.l10n.supportCallUs,
                subtitle: site.phone!,
                onTap: () => _launch(Uri(scheme: 'tel', path: site.phone)),
              ),
            if (site?.address != null && site!.address!.isNotEmpty)
              _ContactTile(
                icon: Icons.location_on_outlined,
                title: context.l10n.supportVisitUs,
                subtitle: site.address!,
              ),

            AppSpacing.vGapXl,

            // ── Contact form ─────────────────────────────────────────────────
            Text(context.l10n.supportSendMessage, style: AppTextStyles.titleMd),
            AppSpacing.vGapMd,
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _name,
                    textInputAction: TextInputAction.next,
                    decoration:
                        InputDecoration(labelText: context.l10n.supportYourName),
                    validator: (v) => Validators.required(
                      v,
                      context.l10n,
                      field: context.l10n.supportYourName,
                    ),
                  ),
                  AppSpacing.vGapMd,
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(labelText: context.l10n.email),
                    validator: (v) => Validators.email(v, context.l10n),
                  ),
                  AppSpacing.vGapMd,
                  TextFormField(
                    controller: _subject,
                    textInputAction: TextInputAction.next,
                    decoration:
                        InputDecoration(labelText: context.l10n.supportSubject),
                    validator: (v) => Validators.required(
                      v,
                      context.l10n,
                      field: context.l10n.supportSubject,
                    ),
                  ),
                  AppSpacing.vGapMd,
                  TextFormField(
                    controller: _message,
                    minLines: 4,
                    maxLines: 8,
                    decoration: InputDecoration(
                      labelText: context.l10n.supportMessage,
                      alignLabelWithHint: true,
                    ),
                    validator: (v) => Validators.required(
                      v,
                      context.l10n,
                      field: context.l10n.supportMessage,
                    ),
                  ),
                  AppSpacing.vGapLg,
                  PrimaryButton(
                    label: context.l10n.supportSendMessageBtn,
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
              child: Text(context.l10n.profilePrivacyPolicy),
            ),
            TextButton(
              onPressed: () => context.push(AppRoutes.termsConditions),
              child: Text(context.l10n.profileTermsConditions),
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
        Text(context.l10n.supportFaqTitle, style: AppTextStyles.titleMd),
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
