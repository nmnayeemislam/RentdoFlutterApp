import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/providers/theme_provider.dart';
import 'core/providers/theme_reveal_provider.dart';
import 'core/theme/app_theme.dart';
import 'features/config/providers/config_providers.dart';
import 'l10n/app_localizations.dart';
import 'routes/app_router.dart';

/// Root application widget. Wires the router, themes and theme mode.
class RentdoApp extends ConsumerStatefulWidget {
  const RentdoApp({super.key});

  /// Locales the UI can render. App copy is translated via [AppLocalizations]
  /// (see `lib/l10n/*.arb`); the selected code comes from
  /// [localeControllerProvider] and [_resolveLocale] maps it onto the closest
  /// entry here, falling back to English for anything not yet translated.
  static const List<Locale> supportedLocales =
      AppLocalizations.supportedLocales;

  static Locale _resolveLocale(Locale? locale, Iterable<Locale> supported) {
    if (locale != null) {
      for (final s in supported) {
        if (s.languageCode == locale.languageCode) return s;
      }
    }
    return const Locale('en');
  }

  @override
  ConsumerState<RentdoApp> createState() => _RentdoAppState();
}

class _RentdoAppState extends ConsumerState<RentdoApp>
    with SingleTickerProviderStateMixin {
  late final AnimationController _revealController;
  late final Animation<double> _revealAnimation;

  Offset? _revealCenter;
  Color? _revealColor;

  @override
  void initState() {
    super.initState();
    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _revealAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_revealController);
  }

  @override
  void dispose() {
    _revealController.dispose();
    super.dispose();
  }

  void _startThemeReveal(ThemeRevealRequest request) {
    setState(() {
      _revealCenter = request.center;
      _revealColor = request.targetMode == ThemeMode.dark
          ? Colors.black
          : Colors.white;
    });
    _revealController.forward(from: 0).then((_) {
      if (!mounted) return;
      setState(() {
        _revealCenter = null;
        _revealColor = null;
      });
      _revealController.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ThemeRevealRequest?>(themeRevealProvider, (previous, next) {
      if (next != null && previous?.id != next.id) {
        _startThemeReveal(next);
      }
    });

    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);
    final localeCode = ref.watch(
      localeControllerProvider.select((s) => s.locale),
    );

    // Warm the public app-config (currencies/locale/property types) once at
    // startup; it seeds the currency/locale sent on subsequent requests.
    ref.watch(bootstrapProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      locale: Locale(localeCode),
      supportedLocales: RentdoApp.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: RentdoApp._resolveLocale,
      routerConfig: router,
      builder: (context, child) {
        // Anchor the ambient text color to the theme's on-surface so the
        // color-agnostic text styles are legible in both light and dark mode.
        final theme = Theme.of(context);
        return DefaultTextStyle(
          style: (theme.textTheme.bodyMedium ?? const TextStyle()).copyWith(
            color: theme.colorScheme.onSurface,
          ),
          child: _ThemeRevealOverlay(
            center: _revealCenter,
            color: _revealColor,
            animation: _revealAnimation,
            child: _ResponsiveFrame(child: child ?? const SizedBox.shrink()),
          ),
        );
      },
    );
  }
}

class _ThemeRevealOverlay extends StatelessWidget {
  const _ThemeRevealOverlay({
    required this.child,
    required this.center,
    required this.color,
    required this.animation,
  });

  final Widget child;
  final Offset? center;
  final Color? color;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final revealCenter = center;
    final revealColor = color;

    return Stack(
      children: [
        child,
        if (revealCenter != null && revealColor != null)
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: animation,
                builder: (context, _) {
                  final screenSize = MediaQuery.sizeOf(context);
                  final maxRadius = math.sqrt(
                    math.pow(screenSize.width, 2) +
                        math.pow(screenSize.height, 2),
                  );

                  return ClipPath(
                    clipper: _CircleRevealClipper(
                      center: revealCenter,
                      fraction: animation.value,
                      maxRadius: maxRadius,
                    ),
                    child: ColoredBox(color: revealColor),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}

class _CircleRevealClipper extends CustomClipper<Path> {
  const _CircleRevealClipper({
    required this.center,
    required this.fraction,
    required this.maxRadius,
  });

  final Offset center;
  final double fraction;
  final double maxRadius;

  @override
  Path getClip(Size size) {
    return Path()
      ..addOval(Rect.fromCircle(center: center, radius: maxRadius * fraction));
  }

  @override
  bool shouldReclip(_CircleRevealClipper oldClipper) => true;
}

/// Presents the mobile-first UI as a centered, phone-width frame on wide
/// screens (web / desktop / tablet) so it never stretches edge-to-edge.
class _ResponsiveFrame extends StatelessWidget {
  const _ResponsiveFrame({required this.child});

  final Widget child;

  static const double _maxWidth = 460;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width <= _maxWidth + 24) return child;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backdrop = isDark ? const Color(0xFF0A0F0D) : const Color(0xFFDDE4E1);

    return ColoredBox(
      color: backdrop,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _maxWidth),
          child: DecoratedBox(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.16),
                  blurRadius: 32,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: MediaQuery(
              // Report the framed width so width-based layout inside is correct.
              data: MediaQuery.of(context).copyWith(
                size: Size(_maxWidth, MediaQuery.sizeOf(context).height),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
