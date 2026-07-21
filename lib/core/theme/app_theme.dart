import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_text_styles.dart';

/// Builds the Material 3 light and dark [ThemeData] for Rentdo from the
/// centralized design tokens.
abstract final class AppTheme {
  AppTheme._();

  /// Built once and reused so toggling theme mode doesn't reconstruct both
  /// `ThemeData` objects on every `MaterialApp` rebuild.
  static final ThemeData light = _build(Brightness.light);
  static final ThemeData dark = _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;

    final Color scaffold =
        isDark ? AppColors.scaffoldDark : AppColors.scaffoldLight;
    final Color surface =
        isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final Color onSurface =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final Color onSurfaceVariant =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final Color outline = isDark ? AppColors.borderDark : AppColors.border;

    final ColorScheme scheme = ColorScheme(
      brightness: brightness,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primarySurface,
      onPrimaryContainer: AppColors.primaryDark,
      secondary: AppColors.accent,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.accentSurface,
      onSecondaryContainer: AppColors.ink,
      tertiary: AppColors.info,
      onTertiary: Colors.white,
      error: AppColors.error,
      onError: Colors.white,
      surface: surface,
      onSurface: onSurface,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outline,
    );

    // Apply the Plus Jakarta Sans brand face to the token text theme. This
    // registers the family globally so plain `AppTextStyles.*` usages (which
    // carry no family of their own) inherit it via the ambient text style too.
    final TextTheme textTheme = GoogleFonts.plusJakartaSansTextTheme(
      AppTextStyles.textTheme(onSurface, onSurfaceVariant),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffold,
      fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
      textTheme: textTheme,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: scaffold,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        foregroundColor: onSurface,
        titleTextStyle: AppTextStyles.headingMd.copyWith(color: onSurface),
        systemOverlayStyle:
            isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.brLg),
      ),
      dividerTheme: DividerThemeData(
        color: isDark ? AppColors.borderDark : AppColors.divider,
        thickness: 1,
        space: 1,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.4),
          elevation: 0,
          minimumSize: const Size.fromHeight(52),
          textStyle: AppTextStyles.button,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.brMd),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: onSurface,
          minimumSize: const Size.fromHeight(52),
          side: BorderSide(color: outline),
          textStyle: AppTextStyles.button,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.brMd),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.button,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppColors.surfaceAltDark : AppColors.surfaceAltLight,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: AppTextStyles.bodyMd.copyWith(color: AppColors.textTertiary),
        border: OutlineInputBorder(
          borderRadius: AppRadius.brMd,
          borderSide: BorderSide(color: outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.brMd,
          borderSide: BorderSide(color: outline),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppRadius.brMd,
          borderSide: BorderSide(color: AppColors.primary, width: 1.6),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: AppRadius.brMd,
          borderSide: BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: AppRadius.brMd,
          borderSide: BorderSide(color: AppColors.error, width: 1.6),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: isDark ? AppColors.surfaceAltDark : AppColors.surfaceAltLight,
        selectedColor: AppColors.primary,
        side: BorderSide.none,
        labelStyle: AppTextStyles.titleSm.copyWith(color: onSurface),
        secondaryLabelStyle:
            AppTextStyles.titleSm.copyWith(color: Colors.white),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.brPill),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.ink,
        contentTextStyle: AppTextStyles.bodyMd.copyWith(color: Colors.white),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.brSm),
      ),
      progressIndicatorTheme:
          const ProgressIndicatorThemeData(color: AppColors.primary),
    );
  }
}
