import 'package:flutter/material.dart';
import 'package:cinemapedia/config/router/router_app.dart';
import 'package:cinemapedia/config/theme/theme_app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  //Gracias a el paquete flutterdotenv podemos acceder a nuestras variables de entorno
  await dotenv.load(fileName: '.env');
  //! Con el providerScope le damos acceso a todo el arbol de widgets a Riverpod
  runApp(ProviderScope(child: MyApp()));
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
