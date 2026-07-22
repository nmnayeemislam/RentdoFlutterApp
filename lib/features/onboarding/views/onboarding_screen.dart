import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../config/providers/config_providers.dart';
import '../providers/onboarding_provider.dart';

const _supportedLanguages = <(String code, String label)>[
  ('en', 'English'),
  ('bn', 'বাংলা'),
  ('ar', 'العربية'),
];

const _languageCodes = <String, String>{'en': 'EN', 'bn': 'BN', 'ar': 'AR'};

class _Slide {
  const _Slide(this.image, this.title, this.body);
  final String image;
  final String title;
  final String body;
}

List<_Slide> _slidesFor(BuildContext context) {
  final l10n = context.l10n;
  return [
    _Slide(
      'assets/images/onboarding/properties.png',
      l10n.onboardingSlide3Title,
      l10n.onboardingSlide3Body,
    ),
    _Slide(
      'assets/images/onboarding/manage_grow.png',
      l10n.onboardingSlide1Title,
      l10n.onboardingSlide1Body,
    ),
    _Slide(
      'assets/images/onboarding/tenants.png',
      l10n.onboardingSlide2Title,
      l10n.onboardingSlide2Body,
    ),
  ];
}

/// Three-step intro carousel. Reachable before login for first-time users.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  Future<void> _pickLanguage() async {
    final active = ref.read(localeControllerProvider).locale;
    final picked = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Material(
          color: Theme.of(sheetContext).colorScheme.surface,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              for (final (code, label) in _supportedLanguages)
                ListTile(
                  title: Text(label),
                  trailing: code == active
                      ? const Icon(
                          Icons.check_rounded,
                          color: AppColors.primary,
                        )
                      : null,
                  onTap: () => Navigator.pop(sheetContext, code),
                ),
            ],
          ),
        ),
      ),
    );
    if (picked != null && picked != active) {
      ref.read(localeControllerProvider.notifier).setLocale(picked);
    }
  }

  Future<void> _finish() async {
    await ref.read(onboardingSeenProvider.notifier).complete();
    if (mounted) context.go(AppRoutes.login);
  }

  void _next(List<_Slide> slides) {
    if (_index == slides.length - 1) {
      unawaited(_finish());
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slides = _slidesFor(context);
    final isLast = _index == slides.length - 1;
    final activeLanguage = ref.watch(
      localeControllerProvider.select((s) => s.locale),
    );
    final activeLanguageCode =
        _languageCodes[activeLanguage] ?? activeLanguage.toUpperCase();

    return Scaffold(
      backgroundColor: AppColors.scaffoldLight,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(
                  top: AppSpacing.sm,
                  end: AppSpacing.md,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: AppRadius.brPill,
                    onTap: _pickLanguage,
                    child: Container(
                      height: 36,
                      padding: const EdgeInsetsDirectional.only(
                        start: AppSpacing.sm,
                        end: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: AppRadius.brPill,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.language_rounded, size: 18),
                          const SizedBox(width: AppSpacing.xs),
                          Text(activeLanguageCode, style: AppTextStyles.label),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 18,
                            color: AppColors.textTertiary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: slides.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (_, i) => _SlideView(slide: slides[i]),
              ),
            ),
            _Dots(count: slides.length, index: _index),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                AppSpacing.xxl,
                AppSpacing.md,
                AppSpacing.xxl,
                AppSpacing.xxl,
              ),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () => unawaited(_finish()),
                    child: Text(
                      context.l10n.skip,
                      style: AppTextStyles.titleSm.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const Spacer(),
                  _NextButton(
                    label: isLast ? context.l10n.getStarted : context.l10n.next,
                    onPressed: () => _next(slides),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SlideView extends StatelessWidget {
  const _SlideView({required this.slide});

  final _Slide slide;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textBottom = constraints.maxHeight * 0.06;
        final titleFontSize = constraints.maxWidth < 360 ? 22.0 : 24.0;

        return Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: Image.asset(
                slide.image,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                filterQuality: FilterQuality.high,
              ),
            ),
            Positioned(
              left: AppSpacing.xxl,
              right: AppSpacing.xxl,
              bottom: textBottom,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    slide.title,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.headingXl.copyWith(
                      color: AppColors.navy,
                      fontSize: titleFontSize,
                    ),
                  ),
                  AppSpacing.vGapSm,
                  Text(
                    slide.body,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyLg.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _NextButton extends StatelessWidget {
  const _NextButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: AppRadius.brPill,
        boxShadow: AppShadows.raised,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppRadius.brPill,
          onTap: onPressed,
          child: Container(
            height: 52,
            constraints: const BoxConstraints(minWidth: 128),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.button.copyWith(color: Colors.white),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Icon(
                  Directionality.of(context) == TextDirection.rtl
                      ? Icons.arrow_back_ios_rounded
                      : Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.index});
  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 260),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 8,
            width: i == index ? 24 : 8,
            decoration: BoxDecoration(
              color: i == index ? AppColors.primary : AppColors.border,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
      ],
    );
  }
}
