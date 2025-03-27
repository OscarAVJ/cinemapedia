import 'package:cinemapedia/config/theme/theme_app.dart';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(darkModeProvider);
    final theme = AppTheme(isDarkMode: isDarkMode); // 👈 Pasamos el estado

    return MaterialApp.router(
      routerConfig: appRouter,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: theme.getTheme(), // 👈 Usamos la función corregida
    );
  }
}
