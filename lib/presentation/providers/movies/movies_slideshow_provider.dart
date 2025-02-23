import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final moviesSlideshowProvider = Provider<List<Movie>>((ref) {
  ///Aca hacemos referencia a nuestro nowPlayingMoviesProvider para poder estar atentos a las peliculas de nowPlaying
  final nowPlayingMovies = ref.watch(nowPlayinMoviesProvider);

  ///En caso de que nowPlaying sea null retornamos un array vacio
  if (nowPlayingMovies.isEmpty) return [];

  ///Y como nowPlayingMovies de por si ya esta retornando una lista, lo que hacemos es crear una sublista desde el elemento 12 hasta el siguiente
  return nowPlayingMovies.sublist(12, 17);
});
