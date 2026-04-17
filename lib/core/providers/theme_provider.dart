// Theme switching — Riverpod + SharedPreferences
// Runbook Override 2: Light is default. Persisted as 'light' | 'dark' | 'system'.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kThemeKey = 'theme_mode';

// Exposed to the rest of the app
final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(
  ThemeNotifier.new,
);

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    // Default to light per Override 2. Actual persisted value loaded asynchronously.
    _loadPersistedTheme();
    return ThemeMode.light;
  }

  Future<void> _loadPersistedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_kThemeKey);
    if (saved != null) {
      state = _fromString(saved);
    }
  }

  Future<void> setTheme(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kThemeKey, _toString(mode));
  }

  static ThemeMode _fromString(String value) => switch (value) {
        'dark' => ThemeMode.dark,
        'system' => ThemeMode.system,
        _ => ThemeMode.light, // default: light
      };

  static String _toString(ThemeMode mode) => switch (mode) {
        ThemeMode.dark => 'dark',
        ThemeMode.system => 'system',
        _ => 'light',
      };
}
