import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//!Este archivo deberia de llamarse movie_info_provider
//!Este archivo es el encargado de las peliculas indiviudales

final movieInfoProvider =
    StateNotifierProvider<MovieMapNotifier, Map<String, Movie>>(
  (ref) {
    final movieRepository = ref.watch(movieRepositoryImplProvider);
    return MovieMapNotifier(getMovie: movieRepository.getMovieById);
  },
);

///Definimos nuestra funcion
typedef GetMovieCallBack = Future<Movie> Function(String movieId);

///Aca lo que hacemos es crear nuestra clase en la cual es un Mapa donde se estaran guardando las peliculas ya consultadas para evitar repetidas consultas a la API donde String es el id y Movie el objeto
class MovieMapNotifier extends StateNotifier<Map<String, Movie>> {
  final GetMovieCallBack getMovie;
  MovieMapNotifier({
    required this.getMovie,
  }) : super({});

  Future<void> loadMovie(String movieId) async {
    ///Como en el state es donde se estan guardando las peliculas ya consultadas si ese id es diferente de null encontes no haceos la peticion, caso contrario si la hacemos
    if (state[movieId] != null) return;
    final movie = await getMovie(movieId);

    ///Aca agregamos la nueva pelicula en al state
    state = {...state, movieId: movie};
  }
}
