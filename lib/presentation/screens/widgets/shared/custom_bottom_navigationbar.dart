import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigationbar extends StatelessWidget {
  ///! Recibimos el `navigationShell` para conocer el estado de navegación

  final StatefulNavigationShell navigationShell;

  const CustomBottomNavigationbar({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      ///! Indicamos la pestaña activa según `navigationShell`

      currentIndex: navigationShell.currentIndex,

      ///! Cambiamos de pestaña cuando el usuario toca un botón
      onTap: (index) => navigationShell.goBranch(index),
      elevation: 0,
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home_max,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.category_outlined,
          ),
          label: 'Categorias',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.favorite_outline_outlined,
          ),
          label: 'Favorites',
        ),
      ],
    );
  }
}
