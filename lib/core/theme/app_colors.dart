import 'package:flutter/material.dart';

/// Centralized color system for Rentdo.
///
/// Uses a teal/green primary palette suited to a trusted real-estate brand.
/// Reference tokens are exposed as static consts so they are `const`-friendly
/// and never duplicated across the codebase.
abstract final class AppColors {
  AppColors._();

  // ---------------------------------------------------------------------------
  // Brand
  // ---------------------------------------------------------------------------
  static const Color primary = Color(0xFF0EA88A); // teal-green
  static const Color primaryDark = Color(0xFF0B7E68);
  static const Color primaryLight = Color(0xFF3FC3A8);
  static const Color primarySurface = Color(0xFFE6F7F2);

  static const Color accent = Color(0xFFF5A623); // amber accent (badges/prices)
  static const Color accentSurface = Color(0xFFFDF1DC);

  // ---------------------------------------------------------------------------
  // Neutrals
  // ---------------------------------------------------------------------------
  static const Color ink = Color(0xFF0F1E1A); // near-black text
  static const Color textPrimary = Color(0xFF14211D);
  static const Color textSecondary = Color(0xFF5B6B66);
  static const Color textTertiary = Color(0xFF8B9994);

  static const Color border = Color(0xFFE3E8E6);
  static const Color divider = Color(0xFFEDF1EF);

  // ---------------------------------------------------------------------------
  // Backgrounds / surfaces (light)
  // ---------------------------------------------------------------------------
  static const Color scaffoldLight = Color(0xFFF7F9F8);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceAltLight = Color(0xFFF1F5F3);

  // ---------------------------------------------------------------------------
  // Backgrounds / surfaces (dark)
  // ---------------------------------------------------------------------------
  static const Color scaffoldDark = Color(0xFF0E1512);
  static const Color surfaceDark = Color(0xFF161E1B);
  static const Color surfaceAltDark = Color(0xFF1E2825);
  static const Color borderDark = Color(0xFF2A342F);
  static const Color textPrimaryDark = Color(0xFFF1F5F3);
  static const Color textSecondaryDark = Color(0xFFA9B6B1);

  // ---------------------------------------------------------------------------
  // Semantic
  // ---------------------------------------------------------------------------
  static const Color success = Color(0xFF1FA971);
  static const Color warning = Color(0xFFEAA83B);
  static const Color error = Color(0xFFE0523E);
  static const Color info = Color(0xFF2F80ED);

  static const Color verified = Color(0xFF0EA88A);
  static const Color rating = Color(0xFFF5A623);

  // ---------------------------------------------------------------------------
  // Gradients
  // ---------------------------------------------------------------------------
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroOverlay = LinearGradient(
    colors: [Colors.transparent, Color(0xCC0F1E1A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
