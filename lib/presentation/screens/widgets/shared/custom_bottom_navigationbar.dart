import 'package:flutter/material.dart';

class CustomBottomNavigationbar extends StatelessWidget {
  const CustomBottomNavigationbar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
