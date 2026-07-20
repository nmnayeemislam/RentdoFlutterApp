import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Holds the app's [ThemeMode]. Defaults to following the system setting,
/// persists the user's manual choice, and restores it on the next launch.
class ThemeModeController extends Notifier<ThemeMode> {
  static const _prefsKey = 'theme_mode';

  @override
  ThemeMode build() {
    // The UI is light-first (the design tokens bake in light-mode text colors),
    // so default to light rather than following a system dark setting that the
    // theme doesn't yet fully support. A stored preference still wins.
    unawaited(_restore());
    return ThemeMode.light;
  }

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_prefsKey);
    if (stored == null) return;
    state = ThemeMode.values.firstWhere(
      (m) => m.name == stored,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> _persist(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, mode.name);
  }

  void set(ThemeMode mode) {
    state = mode;
    unawaited(_persist(mode));
  }

  /// Flips between light and dark, resolving the current system brightness when
  /// the mode is [ThemeMode.system] so the toggle always visibly changes.
  void toggle() {
    final bool isDark = switch (state) {
      ThemeMode.dark => true,
      ThemeMode.light => false,
      ThemeMode.system =>
        WidgetsBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark,
    };
    set(isDark ? ThemeMode.light : ThemeMode.dark);
  }
}

final themeModeProvider =
    NotifierProvider<ThemeModeController, ThemeMode>(ThemeModeController.new);
