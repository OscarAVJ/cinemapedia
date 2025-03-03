import 'package:cinemapedia/presentation/screens/widgets/widgets.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  ///Aca creamos el nombre de nuestro path
  static const name = 'home_screen';

  //! Recibimos el objeto `StatefulNavigationShell` para manejar la navegación entre pestañas
  final StatefulNavigationShell navigationShell;

  const HomeScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///! Mostramos el contenido de la pestaña actual

      body: navigationShell,

      ///! Pasamos el `navigationShell` al BottomNavigationBar para gestionar cambios de pestaña

      bottomNavigationBar:
          CustomBottomNavigationbar(navigationShell: navigationShell),
    );
  }
}
