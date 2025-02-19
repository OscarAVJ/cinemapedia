import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///Con esta variable lo que hacemos es ver si las peliculas estan cargadas para posteriormente mostrar nuestro homeView, caso contrario mostrariamos nuestro loading personalizado
final isLoadingScreenProvider = Provider<bool>((ref) {
  final nowPlayingMovies = ref.watch(nowPlayinMoviesProvider).isEmpty;
  final slideShowMovies = ref.watch(moviesSlideshowProvider).isEmpty;
  final getPopularProvider = ref.watch(popularMoviesProvider).isEmpty;
  final getUpcomingProvider = ref.watch(upcomingMoviesProvider).isEmpty;
  final getTopRatedProvider = ref.watch(topRatedProvider).isEmpty;
  if (nowPlayingMovies ||
      slideShowMovies ||
      getTopRatedProvider ||
      getUpcomingProvider ||
      getPopularProvider) {
    return true;
  }
  return false;
});
