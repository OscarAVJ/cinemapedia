import 'package:cinemapedia/presentation/providers/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:cinemapedia/config/router/router_app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  ///Gracias a el paquete flutterdotenv podemos acceder a nuestras variables de entorno
  await dotenv.load(fileName: '.env');
  //! Con el providerScope le damos acceso a todo el arbol de widgets a Riverpod
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, ref) {
    final themeProvider = ref.watch(themeNotifierProvider);
    return MaterialApp.router(
      //!Gracias a esto sabemos que nuestra primera ruta es el home_screen
      routerConfig: appRouter,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.getTheme(),
      // theme: AppTheme().getTheme(),
    );
  }
}
