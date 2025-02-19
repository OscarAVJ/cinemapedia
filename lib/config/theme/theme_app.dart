import 'package:flutter/material.dart';

class AppTheme {
  ///Aca definimos nuestro tema
  ThemeData getTheme() => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF2862F5),
      );
}
