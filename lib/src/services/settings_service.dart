import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A service that stores and retrieves user settings.
class SettingsService {
  /// Loads the User's preferred ThemeMode from local or remote storage.
  Future<ThemeMode> themeMode() async {
    final preferences = await SharedPreferences.getInstance();
    final themeString = preferences.getString('theme');
    if (themeString == null) {
      return ThemeMode.system;
    }
    final theme = ThemeMode.values.byName(themeString);
    return theme;
  }

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('theme', theme.name);
  }
}
