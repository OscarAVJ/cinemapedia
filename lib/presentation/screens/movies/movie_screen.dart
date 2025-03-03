import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieScreen extends ConsumerStatefulWidget {
  static const name = 'movie-screen';
  final String movieId;
  const MovieScreen({
    super.key,
    required this.movieId,
  });

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(movieInfoProvider.notifier).loadMovie(
          widget.movieId,
        );
    ref.read(actorsByMovieProvider.notifier).loadActors(
          widget.movieId,
        );
  }

  @override
  Widget build(BuildContext context) {
    //Despues del watch, tenemos el mapa y de ahi pedimos que busque el movieid
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];

    if (movie == null) {
      return const Center(
        child: CircularProgressIndicator(
          strokeWidth: 3,
        ),
      );
    }
    return Scaffold(
      body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppBar(
            movie: movie,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _MovieDetails(
                movie: movie,
              ),
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _MovieDetails extends StatelessWidget {
  final Movie movie;
  const _MovieDetails({required this.movie});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Información básica de la película
        _BasicMovieInfo(movie: movie, textStyles: textStyles),

        /// Géneros
        _GendersTitle(textStyles: textStyles),
        _Genders(movie: movie),

        /// Actores
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            'Actores',
          ),
        ),
        _ActorsByMovie(
          movieId: movie.id.toString(),
        ),
      ],
    );
  }
}

class _BasicMovieInfo extends ConsumerWidget {
  const _BasicMovieInfo({
    required this.movie,
    required this.textStyles,
  });

  final Movie movie;
  final TextTheme textStyles;

  @override
  Widget build(BuildContext context, ref) {
    bool isDarkMode = ref.watch(themeNotifierProvider).isDarkMode;
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          color:
              isDarkMode ? const Color.fromARGB(255, 31, 31, 31) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título de la película
            Text(
              movie.title,
              style: textStyles.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            // Descripción
            Text(
              movie.overview,
              style: textStyles.bodySmall?.copyWith(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}

class _GendersTitle extends ConsumerWidget {
  const _GendersTitle({
    required this.textStyles,
  });

  final TextTheme textStyles;

  @override
  Widget build(BuildContext context, ref) {
    bool isDarkMode = ref.watch(themeNotifierProvider).isDarkMode;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Text(
        'Géneros',
        style: textStyles.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}

class _Genders extends StatelessWidget {
  const _Genders({
    required this.movie,
  });

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Wrap(
        spacing: 10,
        runSpacing: 8,
        children: movie.genreIds.map((genre) {
          return Chip(
            label: Text(
              genre,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.blueGrey.shade700,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ActorsByMovie extends ConsumerWidget {
  final String movieId;
  const _ActorsByMovie({required this.movieId});

  @override
  Widget build(BuildContext context, ref) {
    final actorsByMovie = ref.watch(actorsByMovieProvider);

    // Si no hay datos para esta película, mostrar indicador de carga
    if (actorsByMovie[movieId] == null) {
      return const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    final actors = actorsByMovie[movieId];

    // Si la lista de actores está vacía, mostramos el siguiente mensaje
    if (actors == null || actors.isEmpty) {
      return const Center(
        child: Text(
          'No se encontraron actores para esta película.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    // Mostrar lista de actores
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        itemBuilder: (context, index) {
          final actor = actors[index];
          return Container(
            padding: const EdgeInsets.all(8.0),
            width: 135,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: FadeInRight(
                    child: Image.network(
                      actor.profilePath,
                      height: 130,
                      width: 135,
                      fit: BoxFit.cover,
                      //!Con error builder manejamos las imagenes que no tengan un path valido
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.error,
                          size: 130,
                          color: Colors.grey,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  actor.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CustomSliverAppBar extends StatelessWidget {
  final Movie movie;
  const _CustomSliverAppBar({
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.favorite_rounded,
            color: Colors.red,
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) return const SizedBox();
                  return FadeIn(child: child);
                },
              ),
            ),
            _CustomGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              startC: Colors.transparent,
              endC: Colors.black87,
              stop1: 0.7,
              stop2: 1.0,
            ),
            _CustomGradient(
              begin: Alignment.topLeft,
              startC: Colors.black87,
              endC: Colors.transparent,
              stop1: 0.0,
              stop2: 0.3,
            ),
            _CustomGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              startC: Color.fromARGB(221, 63, 61, 61),
              endC: Colors.transparent,
              stop1: 0.0,
              stop2: 0.3,
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomGradient extends StatelessWidget {
  final AlignmentGeometry begin;
  final AlignmentGeometry? end;
  final Color startC;
  final Color endC;
  final double stop1;
  final double stop2;

  const _CustomGradient(
      {required this.begin,
      this.end,
      required this.startC,
      required this.endC,
      required this.stop1,
      required this.stop2});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: end != null
              ? LinearGradient(
                  begin: begin,
                  end: end!, //! Si tiene un valor, lo usa
                  stops: [stop1, stop2],
                  colors: [startC, endC],
                )
              : LinearGradient(
                  begin: begin,
                  stops: [stop1, stop2],
                  colors: [startC, endC],
                ), //! Si no hay end se crea un degradado sin ese parámetro
        ),
      ),
    );
  }
}
