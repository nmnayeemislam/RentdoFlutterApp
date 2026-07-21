import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Centralized typography. These styles are intentionally **color-agnostic** —
/// `Text` inherits the ambient on-surface color (set per-brightness by the
/// theme + the app-level [DefaultTextStyle]), so the same style is legible in
/// both light and dark mode. Widgets on colored backgrounds override the color
/// explicitly (e.g. `.copyWith(color: Colors.white)`).
abstract final class AppTextStyles {
  AppTextStyles._();

  /// Brand face. Loaded via `google_fonts` (Plus Jakarta Sans) in
  /// [AppTheme]; individual token styles carry no family and inherit it.
  static const String fontFamily = 'Plus Jakarta Sans';

  static const TextStyle displayLarge = TextStyle(
    fontSize: 34,
    height: 1.15,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
  );

  static const TextStyle headingXl = TextStyle(
    fontSize: 26,
    height: 1.2,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
  );

  static const TextStyle headingLg = TextStyle(
    fontSize: 22,
    height: 1.25,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle headingMd = TextStyle(
    fontSize: 18,
    height: 1.3,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle titleMd = TextStyle(
    fontSize: 16,
    height: 1.35,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle titleSm = TextStyle(
    fontSize: 14,
    height: 1.35,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle bodyLg = TextStyle(
    fontSize: 16,
    height: 1.5,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodyMd = TextStyle(
    fontSize: 14,
    height: 1.5,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodySm = TextStyle(
    fontSize: 12,
    height: 1.45,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle label = TextStyle(
    fontSize: 13,
    height: 1.2,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 11,
    height: 1.2,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
  );

  // Brand-colored, intentional regardless of theme.
  static const TextStyle price = TextStyle(
    fontSize: 18,
    height: 1.2,
    fontWeight: FontWeight.w800,
    color: AppColors.primary,
  );

  static const TextStyle button = TextStyle(
    fontSize: 15,
    height: 1.2,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
  );

  /// Builds a Material 3 [TextTheme] from these styles.
  static TextTheme textTheme(Color primary, Color secondary) {
    return TextTheme(
      displayLarge: displayLarge.copyWith(color: primary),
      headlineLarge: headingXl.copyWith(color: primary),
      headlineMedium: headingLg.copyWith(color: primary),
      headlineSmall: headingMd.copyWith(color: primary),
      titleLarge: titleMd.copyWith(color: primary),
      titleMedium: titleSm.copyWith(color: primary),
      titleSmall: label.copyWith(color: primary),
      bodyLarge: bodyLg.copyWith(color: secondary),
      bodyMedium: bodyMd.copyWith(color: secondary),
      bodySmall: bodySm.copyWith(color: secondary),
      labelLarge: button.copyWith(color: primary),
      labelMedium: caption.copyWith(color: secondary),
    );
  }
}
