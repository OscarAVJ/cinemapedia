import 'package:animate_do/animate_do.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MoviesSlideshow extends StatelessWidget {
  final List<Movie> movies;
  const MoviesSlideshow({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      height: 210,
      width: double.infinity,
      child: Swiper(
        //Con esto vemos un poco antes del slide
        viewportFraction: 0.8,
        //Aca la transision
        scale: 0.9,
        //Que cambie auto
        autoplay: true,
        pagination: SwiperPagination(
          margin: const EdgeInsets.only(top: 0),
          builder: DotSwiperPaginationBuilder(
            activeColor: colors.primary,
            color: colors.secondary,
          ),
        ),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return _Slide(
            movie: movie,
          );
        },
      ),
    );
  }
}

class _Slide extends ConsumerWidget {
  final Movie movie;
  const _Slide({required this.movie});

  @override
  Widget build(BuildContext context, ref) {
    bool isDarkMode = ref.watch(themeNotifierProvider).isDarkMode;
    final decoration =
        BoxDecoration(borderRadius: BorderRadius.circular(20), boxShadow: [
      if (isDarkMode)
        BoxShadow(
          color: const Color.fromARGB(255, 37, 37, 37),
          blurRadius: 10,
          offset: Offset(0, 10),
        )
      else
        BoxShadow(
          color: Colors.grey,
          blurRadius: 10,
          offset: Offset(0, 10),
        )
    ]);

    return Padding(
      padding: EdgeInsets.only(
        bottom: 30,
      ),
      child: DecoratedBox(
        decoration: decoration,
        //Nos permite agregar border radius
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            movie.backdropPath,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress != null) {
                return const DecoratedBox(
                    decoration: BoxDecoration(color: Colors.black));
              }
              return FadeIn(child: child);
            },
          ),
        ),
      ),
    );
  }
}
