import 'package:flutter/material.dart';

class AppTheme {
  final bool isDarkMode;

  AppTheme({this.isDarkMode = false});

  ///Aca definimos nuestro tema
  ThemeData getTheme() => ThemeData(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF2862F5),
      );
  AppTheme copyWith({
    ///Aca ponemos como argumento selected color y isDarkMode con la posibilidad de que sean nulos
    bool? isDarkMode,
  }) =>
      AppTheme(
        ///Aca si recibimos el valor le ponemos el valor y si no el que viene por defecto en la clase
        isDarkMode: isDarkMode ?? this.isDarkMode,
      );
}
