import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// Ergonomic accessors for theme, media query and simple feedback.
extension BuildContextX on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get texts => Theme.of(this).textTheme;

  /// Translated strings for the active locale (see `lib/l10n/*.arb`).
  AppLocalizations get l10n => AppLocalizations.of(this);

  Size get screenSize => MediaQuery.sizeOf(this);
  double get width => MediaQuery.sizeOf(this).width;
  double get height => MediaQuery.sizeOf(this).height;
  EdgeInsets get viewPadding => MediaQuery.viewPaddingOf(this);
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  /// Simple responsive breakpoints.
  bool get isTablet => width >= 600;
  bool get isDesktop => width >= 1024;

  void showSnack(String message, {bool error = false}) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: error ? colors.error : null,
        ),
      );
  }
}
