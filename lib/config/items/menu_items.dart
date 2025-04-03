import 'package:flutter/material.dart';

class MenuItems {
  final String title;
  final String subTitle;
  final String route;
  final IconData icons;

  const MenuItems(
      {required this.title,
      required this.subTitle,
      required this.route,
      required this.icons});
}

const cinemapediaMenuItems = <MenuItems>[
  MenuItems(
    title: 'Populares',
    subTitle: 'Config',
    route: '/popular',
    icons: Icons.star,
  ),
  MenuItems(
    title: 'Favoritos',
    subTitle: 'Config',
    route: '/favorites',
    icons: Icons.favorite,
  ),
  MenuItems(
    title: 'Configuración',
    subTitle: 'Config',
    route: '/config_screen',
    icons: Icons.settings,
  ),
  MenuItems(
    title: 'Log out',
    subTitle: 'Log out',
    route: '/config_screen',
    icons: Icons.logout_outlined,
  ),
];
