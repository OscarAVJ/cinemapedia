import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/local_storage_reporitory.dart';
import 'package:cinemapedia/presentation/providers/storage/local_storage_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoriteMoviesProvider =
    StateNotifierProvider<FavoriteMoviesProvider, Map<int, Movie>>((ref) {
  final localStorageProviderImpl = ref.watch(localStorageProvider);
  return FavoriteMoviesProvider(
      localStorageReporitory: localStorageProviderImpl);
});

class FavoriteMoviesProvider extends StateNotifier<Map<int, Movie>> {
  int page = 0;

  final LocalStorageReporitory localStorageReporitory;

  FavoriteMoviesProvider({
    required this.localStorageReporitory,
  }) : super({}); // Se inicializa el estado con un mapa vacío.

  Future<List<Movie>> loadNextPage() async {
    /// Llama al método `loadMovies` en el repositorio para obtener 10 películas favoritas
    /// según el `offset` actual, lo que permite paginación.
    final movies =
        await localStorageReporitory.loadMovies(offset: page * 10, limit: 20);

    /// Creamos un mapa temporal para almacenar las películas obtenidas.
    final tempMovie = <int, Movie>{};

    /// Llenamos el mapa temporal con las peliculas obtenidas.
    /// - La clave es el `id` de la película.
    /// - El valor es el objeto `Movie` completo.
    for (final movie in movies) {
      tempMovie[movie.id] = movie;
    }

    /// Actualiza el estado agregando las nuevas películas a las existentes.
    /// - Se usa `...state` para mantener las películas ya cargadas.
    /// - Se usa `...tempMovie` para agregar las nuevas películas.
    state = {...state, ...tempMovie};
    page++;
    return movies;
  }

  Future<void> toogleFavorite(Movie movie) async {
    await localStorageReporitory.toogleFavorite(movie);
    final bool isMovieInFavorites = state[movie.id] != null;
    if (isMovieInFavorites) {
      state.remove(movie.id);
      state = {...state};
    } else {
      state = {...state, movie.id: movie};
    }
  }
}
