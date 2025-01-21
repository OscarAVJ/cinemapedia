import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleMedium;
    return SafeArea(
      bottom: false,
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            Icon(
              Icons.movie_filter_outlined,
              color: colors.primary,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Cinemapedia',
              style: titleStyle,
            ),
            //Spacer hace que tome todo el espado dentro del contenedor hasta el final para poner
            const Spacer(),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.search,
                  color: colors.primary,
                ))
          ],
        ),
      ),
    );
  }
}
