import 'package:cinemapedia/config/theme/theme_app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final isDarkMode = StateProvider<bool>((ref) => false);

final themeNotifierProvider = StateNotifierProvider<ThemeNotifer, AppTheme>(
  (ref) => ThemeNotifer(),
);

final darkModeProvider =
    StateNotifierProvider<DarkModeNotifier, bool>((ref) => DarkModeNotifier());

class DarkModeNotifier extends StateNotifier<bool> {
  late SharedPreferences _prefs;

  DarkModeNotifier() : super(false) {
    _loadFromPrefs(); // Cargar el estado guardado al iniciar
  }

  /// Carga el estado guardado en SharedPreferences
  Future<void> _loadFromPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    state = _prefs.getBool("darkMode") ?? false;
  }

  /// Alternar entre modo oscuro y claro
  Future<void> toggleDarkMode() async {
    state = !state;
    await _prefs.setBool("darkMode", state);
  }
}

class ThemeNotifer extends StateNotifier<AppTheme> {
  ThemeNotifer() : super(AppTheme());
  void toogleDarkMode() {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
  }
}
