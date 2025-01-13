import 'package:flutter/material.dart';
import 'package:cinemapedia/config/router/router_app.dart';
import 'package:cinemapedia/config/theme/theme_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      //!Gracias a esto sabemos que nuestra primera ruta es el home_screen
      routerConfig: appRouter,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
    );
  }
}
