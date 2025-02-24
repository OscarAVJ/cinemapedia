import 'package:cinemapedia/domain/entities/movie.dart';
import '../../providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchMovieProvider = StateProvider<String>((ref) => '');

final savedMoviesProvider =
    StateNotifierProvider<SearchedMoviesNotifier, List<Movie>>((ref) {
  ///Aca accedemos a nuestro movieRepository
  final movieRepository = ref.read(movieRepositoryImplProvider);

  ///Aca retornamos el ref y el searchedMovies el cual es = a nuestro movieRepo.searchMovies el cual es el que esta conectado al datasource
  return SearchedMoviesNotifier(
    ref: ref,
    searchedMovies: movieRepository.searchMovies,
  );
});

///Creamos nuestra funcion la cual sera de tipo Future con una lista de peliculas y tendra como parametros un String query
typedef SearchedMoviesCllBack = Future<List<Movie>> Function(String query);

///Creamos nuestra clase que esta extendiendo de un StateNotifier y tiene como objeto una lista de peliculas
class SearchedMoviesNotifier extends StateNotifier<List<Movie>> {
  ///Llamamos a nuestra funcion
  final SearchedMoviesCllBack searchedMovies;
  final Ref ref;
  SearchedMoviesNotifier({
    required this.searchedMovies,
    required this.ref,
  }) : super([]);

  ///Creamos nuestra funcion la cual tiene la misma estructura que la que creamos con typeDef
  Future<List<Movie>> searchedMoviesSave(String query) async {
    ///Hacemos un await para poder esperar a que nuestro widget nos mande la lista de peliculas
    final List<Movie> savedMovies = await searchedMovies(query);

    ///Aca lo que hacemos es que acualizamos nuestro provider en base a l query que nos pase nuestro widget
    ref.read(searchMovieProvider.notifier).update((state) => query);

    ///Las guardamos en nuestro estado
    state = savedMovies;

    ///Las retornamos
    return savedMovies;
  }
}
