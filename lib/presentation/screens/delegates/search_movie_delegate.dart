import 'dart:async';
import '../../providers/providers.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_format.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef SeachMoviesCallBack = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SeachMoviesCallBack searchMovies;
  StreamController<List<Movie>> debounceMovies = StreamController.broadcast();
  StreamController<bool> isLoadingText = StreamController.broadcast();

  List<Movie> initialMovies;
  //El timer sirve para determinar periodos de tiempo, asi como limpiarlo y cancelarlo
  Timer? debounceTimer;
  SearchMovieDelegate({
    this.initialMovies = const [],
    required this.searchMovies,
  });

  ///Con este metodo limpiamos nuestros streams asi no se quedan en el aire
  void clearStreams() {
    debounceMovies.close();
  }

  void _onQueryChange(String query) {
    ///Aca manejamos el loading de nuestro action
    isLoadingText.add(true);

    /// Si ya hay un Timer activo, lo cancelamos para reiniciar la espera
    if (debounceTimer?.isActive ?? false) debounceTimer!.cancel();

    /// Creamos un nuevo Timer que esperará 1 segundo antes de ejecutar la búsqueda
    debounceTimer = Timer(
      const Duration(seconds: 1),
      () async {
        /// Si el campo de búsqueda está vacío, limpiamos la lista de resultados y salimos
        if (query.isEmpty) {
          if (!debounceMovies.isClosed) {
            debounceMovies
                .add([]); // Aseguramos que el StreamController esté abierto
          }
          return;
        }

        /// Llamamos a la función `searchMovies` para obtener las películas basadas en la consulta
        final movies = await searchMovies(query);
        initialMovies = movies;

        /// Verificamos si el StreamController sigue abierto antes de agregar los resultados
        if (!debounceMovies.isClosed) debounceMovies.add(movies);

        ///Aca lo pasamos a false
        isLoadingText.add(false);
      },
    );
  }

  //! Este metodo es el que tiene toda la logica de las sugerencias y respuestas
  Widget resultAndSuggestions() {
    return StreamBuilder(
      //aca iniciamos el seachMovies y le pasamos el parametro
      // future: searchMovies(query),
      ///Aca colocamos la data inicial que seria lo que esta en nuestro provider enviado desde el appBar
      //!Ahora como es un stream, pues ponemos el controllador de streams que hemos creado
      initialData: initialMovies,
      stream: debounceMovies.stream,
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return _MovieSearchItem(
              movie: movie,
              onMovieSelected: (context, movie) {
                clearStreams();
                close(context, movie);
              },
            );
          },
        );
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
      StreamBuilder(
        ///Iniciamos nuestra data como false
        initialData: false,

        ///Vinculamos nuestro stream
        stream: isLoadingText.stream,
        builder: (context, snapshot) {
          ///Si nuestro stream es falso osea que si se esta escribiendo
          if (snapshot.data ?? false) {
            ///Si el query esta vacio
            if (query.isNotEmpty) {
              return SpinPerfect(
                duration: Duration(seconds: 2),
                infinite: true,
                child: IconButton(
                  onPressed: () => query = '',
                  icon: Icon(
                    Icons.refresh_outlined,
                  ),
                ),
              );
            }
          }

          ///Si el stream es true osea, que ya no se esta escribiendo
          return FadeIn(
            animate: query.isNotEmpty,
            child: IconButton(
              onPressed: () => query = '',
              icon: Icon(
                Icons.clear,
              ),
            ),
          );
        },
      ),
    ];
  }

  @override
  //Aca construimos lo que saldria a la izquierda
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        clearStreams();
        close(context, null);
      },
      icon: Icon(Icons.arrow_back_ios_new_outlined),
    );
  }

  @override
  //Aca serian los resultado de la busqueda
  Widget buildResults(BuildContext context) {
    return resultAndSuggestions();
  }

  @override
  //Y aca que sugerencias
  Widget buildSuggestions(BuildContext context) {
    //Aca llamamos al metodo y le pasamos el valor del textbox
    _onQueryChange(query);
    return resultAndSuggestions();
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
