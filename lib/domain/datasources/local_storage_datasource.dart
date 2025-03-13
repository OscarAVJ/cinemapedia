import 'package:cinemapedia/domain/entities/movie.dart';

abstract class LocalStorageDatasource {
  ///Cualquier base de datos local tiene que tener estos 3 metodos para ser considerado un datasource local
  Future<void> toogleFavorite(Movie movie);

  Future<bool> isMovieFavorite(int movieId);

  Future<List<Movie>> loadMovies({int limit = 20, offset = 0});
}
