import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_format.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef SeachMoviesCallBack = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SeachMoviesCallBack searchMovies;
  StreamController<List<Movie>> debounceMovies = StreamController.broadcast();
  //El timer sirve para determinar periodos de tiempo, asi como limpiarlo y cancelarlo
  Timer? debounceTimer;
  SearchMovieDelegate({
    required this.searchMovies,
  });

  void _onQueryChange(String query) {
    //Aca especificamos que mientras no se deje de escribir y pasen 500 milisegundos no se ejecuta la peticion
    if (debounceTimer?.isActive ?? false) debounceTimer!.cancel();
    //Aca ya establecemos el tiempo
    debounceTimer = Timer(
      const Duration(seconds: 1),
      () async {
        if (query.isEmpty) {
          debounceMovies.add([]);
          return;
        }
        final movies = await searchMovies(query);
        debounceMovies.add(movies);
      },
    );
  }

  @override
  String get searchFieldLabel => 'Buscar pelicula';
  @override
  //Aca construimos las acciones
  List<Widget>? buildActions(Object context) {
    //query es el que tiene el valor del texbox
    return [
      FadeIn(
        animate: query.isNotEmpty,
        child: IconButton(
          onPressed: () => query = '',
          icon: Icon(
            Icons.clear,
          ),
        ),
      ),
    ];
  }

  @override
  //Aca construimos lo que saldria a la izquierda
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: Icon(Icons.arrow_back_ios_new_outlined),
    );
  }

  @override
  //Aca serian los resultado de la busqueda
  Widget buildResults(BuildContext context) {
    return Text('BuildResults');
  }

  @override
  //Y aca que sugerencias
  Widget buildSuggestions(BuildContext context) {
    //Aca llamamos al metodo y le pasamos el valor del textbox
    _onQueryChange(query);
    return StreamBuilder(
      //aca iniciamos el seachMovies y le pasamos el parametro
      // future: searchMovies(query),
      //!Ahora como es un stream, pues ponemos el controllador de streams que hemos creado
      stream: debounceMovies.stream,
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return _MovieSearchItem(
              movie: movie,
              onMovieSelected: close,
            );
          },
        );
      },
    );
  }
}

class _MovieSearchItem extends ConsumerWidget {
  const _MovieSearchItem({
    required this.movie,
    required this.onMovieSelected,
  });

  final Movie movie;
  final Function onMovieSelected;

  @override
  Widget build(BuildContext context, ref) {
    bool isDarkMode = ref.watch(themeNotifierProvider).isDarkMode;
    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        onMovieSelected(context, movie);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Container(
          decoration: BoxDecoration(
            color: isDarkMode
                ? const Color.fromARGB(255, 50, 50, 50)
                : colors.secondary,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Imagen del póster
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                child: Image.network(
                  movie.posterPath,
                  width: size.width * 0.4,
                  height: 180,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) =>
                      FadeIn(child: child),
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: size.width * 0.35,
                      height: 180,
                      color: Colors.grey.shade800,
                      child: const Icon(
                        Icons.error,
                        size: 40,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),

              // Información de la película
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Título
                      Text(
                        movie.title,
                        style: textStyle.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),

                      // Descripción
                      Text(
                        movie.overview.length > 100
                            ? '${movie.overview.substring(0, 100)}...'
                            : movie.overview,
                        style: textStyle.bodyMedium?.copyWith(
                          color:
                              isDarkMode ? Colors.white : Colors.grey.shade400,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),

                      // Puntuación
                      Row(
                        children: [
                          Icon(
                            Icons.star_rate_rounded,
                            color: Colors.amber.shade400,
                            size: 20,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            HumanFormat.number(movie.voteAverage, 1),
                            style: textStyle.titleMedium?.copyWith(
                              color: Colors.amber.shade400,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
