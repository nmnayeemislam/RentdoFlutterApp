import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/screen_loading_overlay.dart';
import '../../../shared/widgets/state_views.dart';
import '../models/bootstrap.dart';
import '../providers/config_providers.dart';

/// Language + currency picker. Both are sent on every request via the
/// `Accept-Language` / `X-Currency` headers, so changing them re-localizes
/// content and re-prices listings server-side.
class LanguageCurrencyScreen extends ConsumerStatefulWidget {
  const LanguageCurrencyScreen({super.key});

  @override
  ConsumerState<LanguageCurrencyScreen> createState() =>
      _LanguageCurrencyScreenState();
}

class _LanguageCurrencyScreenState
    extends ConsumerState<LanguageCurrencyScreen> {
  String? _busyLocale;
  String? _busyCurrency;

  Future<void> _setLocale(String code) async {
    setState(() => _busyLocale = code);
    await Future<void>.delayed(const Duration(milliseconds: 220));
    ref.read(localeControllerProvider.notifier).setLocale(code);
    if (mounted) setState(() => _busyLocale = null);
  }

  Future<void> _setCurrency(String code) async {
    setState(() => _busyCurrency = code);
    await Future<void>.delayed(const Duration(milliseconds: 220));
    ref.read(localeControllerProvider.notifier).setCurrency(code);
    if (mounted) setState(() => _busyCurrency = null);
  }

  @override
  Widget build(BuildContext context) {
    final bootstrap = ref.watch(bootstrapProvider);
    final active = ref.watch(localeControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.configLanguageCurrencyTitle)),
      body: ScreenLoadingOverlay(
        loading: _busyLocale != null || _busyCurrency != null,
        child: bootstrap.when(
          loading: () => const SizedBox.shrink(),
          error: (e, _) => AppErrorWidget(
            message: '$e',
            onRetry: () => ref.invalidate(bootstrapProvider),
          ),
          data: (config) {
            final languages = _languageOptions(config.languages);
            return ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                Text(
                  context.l10n.configLanguage,
                  style: AppTextStyles.headingMd,
                ),
                AppSpacing.vGapMd,
                _OptionCard(
                  children: [
                    for (final lang in languages)
                      _SelectableRow(
                        title: lang.nativeName ?? lang.name,
                        subtitle: lang.code.toUpperCase(),
                        selected: active.locale == lang.code,
                        onTap: _busyLocale == null
                            ? () => _setLocale(lang.code)
                            : () {},
                      ),
                  ],
                ),
                AppSpacing.vGapXl,
                Text(
                  context.l10n.configCurrency,
                  style: AppTextStyles.headingMd,
                ),
                AppSpacing.vGapMd,
                _OptionCard(
                  children: [
                    for (final c in config.currencies)
                      _SelectableRow(
                        title: '${c.code} — ${c.name}',
                        subtitle: c.symbol,
                        selected: active.currency == c.code,
                        onTap: _busyCurrency == null
                            ? () => _setCurrency(c.code)
                            : () {},
                      ),
                  ],
                ),
                AppSpacing.vGapLg,
                Text(
                  context.l10n.configPricesLocalizedDesc,
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<LanguageOption> _languageOptions(List<LanguageOption> serverLanguages) {
    if (serverLanguages.any((lang) => lang.code == 'ar')) {
      return serverLanguages;
    }
    return [
      ...serverLanguages,
      const LanguageOption(
        code: 'ar',
        name: 'Arabic',
        nativeName: 'العربية',
        isRtl: true,
      ),
    ];
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: AppRadius.brLg,
        border: Border.all(color: context.colors.outline),
      ),
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            children[i],
            if (i != children.length - 1)
              const Divider(height: 1, indent: 16, endIndent: 16),
          ],
        ],
      ),
    );
  }
}

class _SelectableRow extends StatelessWidget {
  const _SelectableRow({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(title, style: AppTextStyles.titleSm),
      subtitle: Text(subtitle, style: AppTextStyles.caption),
      trailing: selected
          ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
          : const Icon(Icons.circle_outlined, color: AppColors.textTertiary),
    );
  }
}
