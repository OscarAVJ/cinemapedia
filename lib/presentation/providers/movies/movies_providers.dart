import 'package:cinemapedia/domain/entities/movie.dart';
import '../../providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final nowPlayinMoviesProvider =

    ///En el stateNotifier el primero es el que controla, osea la clase y el segundo el objeto osea las peliculas
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryImplProvider).getNowPlaying;
  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});
final popularMoviesProvider =

    ///En el stateNotifier el primero es el que controla, osea la clase y el segundo el objeto osea las peliculas
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryImplProvider).getPupular;
  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});
final upcomingMoviesProvider =

    ///En el stateNotifier el primero es el que controla, osea la clase y el segundo el objeto osea las peliculas
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryImplProvider).getUpcoming;
  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});
final topRatedProvider =

    ///En el stateNotifier el primero es el que controla, osea la clase y el segundo el objeto osea las peliculas
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryImplProvider).getTopRated;
  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});
//Aca definimos el caso de uso
typedef MovieCallBack = Future<List<Movie>> Function({int page});

class MoviesNotifier extends StateNotifier<List<Movie>> {
  bool loading = false;

  ///Encargado de evitar peticiones simultaneas
  int currentPage = 0;

  ///Encargado de llevar el control de la pagina
  MovieCallBack fetchMoreMovies;

  ///Encargado de definir la funcion que esta recibiendo, ya sea popular, nowPlaying, etc
  MoviesNotifier({required this.fetchMoreMovies}) : super([]);
  Future<void> loadNextPage() async {
    ///Evitar peticiones simulataneas
    if (loading) return;
    loading = true;
    currentPage++;
    final List<Movie> movies = await fetchMoreMovies(page: currentPage);
    state = [...state, ...movies];
    await Future.delayed(const Duration(milliseconds: 300));
    loading = false;
  }
}
