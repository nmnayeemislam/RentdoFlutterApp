import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/providers/theme_provider.dart';
import 'core/theme/app_theme.dart';
import 'features/config/providers/config_providers.dart';
import 'l10n/app_localizations.dart';
import 'routes/app_router.dart';

/// Root application widget. Wires the router, themes and theme mode.
class RentdoApp extends ConsumerWidget {
  const RentdoApp({super.key});

  /// Locales the UI can render. App copy is translated via [AppLocalizations]
  /// (see `lib/l10n/*.arb`); the selected code comes from
  /// [localeControllerProvider] and [_resolveLocale] maps it onto the closest
  /// entry here, falling back to English for anything not yet translated.
  static const List<Locale> supportedLocales = AppLocalizations.supportedLocales;

  static Locale _resolveLocale(Locale? locale, Iterable<Locale> supported) {
    if (locale != null) {
      for (final s in supported) {
        if (s.languageCode == locale.languageCode) return s;
      }
    }
    return const Locale('en');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);
    final localeCode =
        ref.watch(localeControllerProvider.select((s) => s.locale));

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
      supportedLocales: supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: _resolveLocale,
      routerConfig: router,
      builder: (context, child) {
        // Anchor the ambient text color to the theme's on-surface so the
        // color-agnostic text styles are legible in both light and dark mode.
        final theme = Theme.of(context);
        return DefaultTextStyle(
          style: (theme.textTheme.bodyMedium ?? const TextStyle())
              .copyWith(color: theme.colorScheme.onSurface),
          child: _ResponsiveFrame(child: child ?? const SizedBox.shrink()),
        );
      },
    );
  }
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
