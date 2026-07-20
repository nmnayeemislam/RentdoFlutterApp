import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/state_views.dart';
import '../providers/config_providers.dart';

/// Language + currency picker. Both are sent on every request via the
/// `Accept-Language` / `X-Currency` headers, so changing them re-localizes
/// content and re-prices listings server-side.
class LanguageCurrencyScreen extends ConsumerWidget {
  const LanguageCurrencyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bootstrap = ref.watch(bootstrapProvider);
    final active = ref.watch(localeControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Language & Currency')),
      body: bootstrap.when(
        loading: () => const LoadingWidget(),
        error: (e, _) => AppErrorWidget(
          message: '$e',
          onRetry: () => ref.invalidate(bootstrapProvider),
        ),
        data: (config) => ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            const Text('Language', style: AppTextStyles.headingMd),
            AppSpacing.vGapMd,
            _OptionCard(
              children: [
                for (final lang in config.languages)
                  _SelectableRow(
                    title: lang.nativeName ?? lang.name,
                    subtitle: lang.code.toUpperCase(),
                    selected: active.locale == lang.code,
                    onTap: () => ref
                        .read(localeControllerProvider.notifier)
                        .setLocale(lang.code),
                  ),
              ],
            ),
            AppSpacing.vGapXl,
            const Text('Currency', style: AppTextStyles.headingMd),
            AppSpacing.vGapMd,
            _OptionCard(
              children: [
                for (final c in config.currencies)
                  _SelectableRow(
                    title: '${c.code} — ${c.name}',
                    subtitle: c.symbol,
                    selected: active.currency == c.code,
                    onTap: () => ref
                        .read(localeControllerProvider.notifier)
                        .setCurrency(c.code),
                  ),
              ],
            ),
            AppSpacing.vGapLg,
            Text(
              'Prices are converted and content localized by the server using '
              'your selection.',
              style: AppTextStyles.bodySm
                  .copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
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
