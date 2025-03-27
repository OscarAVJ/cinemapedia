import 'package:flutter/material.dart';

class AppTheme {
  final bool isDarkMode;

  AppTheme({this.isDarkMode = false});

  /// Definimos nuestro tema
  ThemeData getTheme() => ThemeData(
        useMaterial3: true,
        brightness:
            isDarkMode ? Brightness.dark : Brightness.light, // 👈 Agregar esto
        colorSchemeSeed: const Color(0xFF2862F5),
      );

  /// Permite copiar el estado actual del tema con modificaciones
  AppTheme copyWith({
    bool? isDarkMode,
  }) =>
      AppTheme(
        isDarkMode: isDarkMode ?? this.isDarkMode,
      );
}
