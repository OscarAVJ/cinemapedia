import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/video.dart';
import 'package:flutter/material.dart';
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
  final fetchMoreMovies = ref.read(movieRepositoryImplProvider).getPupular;
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

final FutureProviderFamily<List<Video>, int> videosFromMovieProvider =
    FutureProvider.family((ref, int movieId) {
  final movieRepository = ref.watch(movieRepositoryImplProvider);
  return movieRepository.getYoutubeVideosById(movieId);
});

final similarMoviesProvider = FutureProvider.family((ref, int movieId) {
  final movieRepository = ref.watch(movieRepositoryImplProvider);
  return movieRepository.getSimilarMovies(movieId);
});
//Aca definimos el caso de uso
typedef MovieCallBack = Future<List<Movie>> Function({int page});

class MoviesNotifier extends StateNotifier<List<Movie>> {
  bool loading = false;
  bool hasMore = true;

  ///Encargado de evitar peticiones simultaneas
  int currentPage = 0;

  ///Encargado de llevar el control de la pagina
  MovieCallBack fetchMoreMovies;

  ///Encargado de definir la funcion que esta recibiendo, ya sea popular, nowPlaying, etc
  MoviesNotifier({required this.fetchMoreMovies}) : super([]);

  Future<void> loadNextPage() async {
    if (loading || !hasMore) {
      return; // ✅ Stop if already loading or no more movies
    }
    loading = true;
    currentPage++;

    try {
      final List<Movie> movies = await fetchMoreMovies(page: currentPage);
      if (movies.isEmpty) {
        hasMore = false; // ✅ No more movies to fetch
      } else {
        state = [...state, ...movies];
      }
    } catch (e) {
      debugPrint('Error loading movies: $e');
    } finally {
      loading = false;
    }
  }
}
