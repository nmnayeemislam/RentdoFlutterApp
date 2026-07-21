import 'package:flutter/material.dart';

/// Centralized color system for Rentdo.
///
/// Brand is taken from the Rentdo logo: a deep **navy** ("Rent") used as the
/// dark/ink brand surface, and a vivid **indigo** ("do" + the search mark) used
/// as the interactive/action color (buttons, active states, links, price).
/// Reference tokens are exposed as static consts so they are `const`-friendly
/// and never duplicated across the codebase.
abstract final class AppColors {
  AppColors._();

  // ---------------------------------------------------------------------------
  // Brand
  // ---------------------------------------------------------------------------
  // Interactive / action color — the logo indigo. Used for CTAs, active tabs,
  // links, focus rings and price.
  static const Color primary = Color(0xFF4F52E8); // logo indigo
  static const Color primaryDark = Color(0xFF3A3DC4); // pressed / gradient end
  static const Color primaryLight = Color(0xFF8486F2);
  static const Color primarySurface = Color(0xFFECEDFD); // tinted container

  // Brand navy — the logo "Rent" ink. Used for dark surfaces, hero/header
  // backgrounds, splash and the dark-theme base.
  static const Color navy = Color(0xFF0F1A3C);
  static const Color navyLight = Color(0xFF1B2A54);

  static const Color accent = Color(0xFFF5A623); // amber accent (ratings/featured)
  static const Color accentSurface = Color(0xFFFDF1DC);

  // ---------------------------------------------------------------------------
  // Neutrals (cool-gray, rebased to sit under navy rather than green)
  // ---------------------------------------------------------------------------
  static const Color ink = Color(0xFF0E1424); // near-black navy text
  static const Color textPrimary = Color(0xFF131A2B);
  static const Color textSecondary = Color(0xFF5A6274);
  static const Color textTertiary = Color(0xFF8A92A6);

  static const Color border = Color(0xFFE6E8EF);
  static const Color divider = Color(0xFFEEF0F5);

  // ---------------------------------------------------------------------------
  // Backgrounds / surfaces (light)
  // ---------------------------------------------------------------------------
  static const Color scaffoldLight = Color(0xFFF6F7FB);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceAltLight = Color(0xFFF1F3F9);

  // ---------------------------------------------------------------------------
  // Backgrounds / surfaces (dark — navy based)
  // ---------------------------------------------------------------------------
  static const Color scaffoldDark = Color(0xFF0A1024);
  static const Color surfaceDark = Color(0xFF121A33);
  static const Color surfaceAltDark = Color(0xFF1B2545);
  static const Color borderDark = Color(0xFF29335A);
  static const Color textPrimaryDark = Color(0xFFEEF1F8);
  static const Color textSecondaryDark = Color(0xFFA6AEC4);

  // ---------------------------------------------------------------------------
  // Semantic
  // ---------------------------------------------------------------------------
  static const Color success = Color(0xFF12B76A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  static const Color verified = Color(0xFF2E90FA); // trust blue-check
  static const Color rating = Color(0xFFF5A623);

  // ---------------------------------------------------------------------------
  // Gradients
  // ---------------------------------------------------------------------------
  /// Indigo action gradient — buttons, accent tiles, chips.
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Navy brand gradient — hero/header backgrounds, splash, premium surfaces.
  static const LinearGradient brandGradient = LinearGradient(
    colors: [navy, navyLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Navy → indigo transition used for the home hero / feature banners.
  static const LinearGradient heroGradient = LinearGradient(
    colors: [navy, Color(0xFF2E307E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroOverlay = LinearGradient(
    colors: [Colors.transparent, Color(0xCC0A1024)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
