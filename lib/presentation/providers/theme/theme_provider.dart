import 'package:cinemapedia/config/theme/theme_app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isDarkMode = StateProvider<bool>((ref) => false);

final themeNotifierProvider = StateNotifierProvider<ThemeNotifer, AppTheme>(
  (ref) => ThemeNotifer(),
);

class ThemeNotifer extends StateNotifier<AppTheme> {
  ThemeNotifer() : super(AppTheme());
  void toogleDarkMode() {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
  }
}
