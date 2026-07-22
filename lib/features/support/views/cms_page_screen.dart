import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/state_views.dart';
import '../providers/support_providers.dart';

/// Renders a published CMS page (privacy policy, terms of service, …) fetched
/// from the backend as sanitized HTML. Reused for every legal/info page by
/// passing a different [slug].
class CmsPageScreen extends ConsumerWidget {
  const CmsPageScreen({super.key, required this.slug, required this.title});

  final String slug;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(cmsPageProvider(slug));

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: page.when(
          loading: () => const LoadingWidget(),
          error: (_, _) => AppErrorWidget(
            message: context.l10n.supportCouldntLoadPage,
            onRetry: () => ref.invalidate(cmsPageProvider(slug)),
          ),
          data: (cms) => ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Text(
                cms.title.isEmpty ? title : cms.title,
                style: AppTextStyles.headingMd,
              ),
              if (cms.updatedAt != null) ...[
                const SizedBox(height: 4),
                Text(
                  context.l10n
                      .supportLastUpdated(_formatDate(context, cms.updatedAt!)),
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.textTertiary),
                ),
              ],
              AppSpacing.vGapLg,
              HtmlWidget(
                cms.content,
                textStyle: AppTextStyles.bodyMd
                    .copyWith(color: context.colors.onSurface, height: 1.55),
                onTapUrl: (url) async {
                  final uri = Uri.tryParse(url);
                  if (uri == null) return false;
                  return launchUrl(uri, mode: LaunchMode.externalApplication);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatDate(BuildContext context, DateTime d) {
    final locale = Localizations.localeOf(context).toString();
    return DateFormat.yMMMd(locale).format(d);
  }
}
