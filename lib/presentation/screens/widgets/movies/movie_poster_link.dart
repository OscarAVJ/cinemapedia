import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MoviePosterLink extends StatelessWidget {
  final Movie movie;

  const MoviePosterLink({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      child: GestureDetector(
        onTap: () => context.push('/movie/${movie.id}'),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),

              /// Con aspecRatio agregamos un redondeado más sutil
              child: AspectRatio(
                aspectRatio: 2 / 3,

                ///Mantiene el formato vertical
                child: Image.network(
                  movie.posterPath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
