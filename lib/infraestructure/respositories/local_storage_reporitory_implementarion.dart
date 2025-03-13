import 'package:cinemapedia/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/local_storage_reporitory.dart';

class LocalStorageReporitoryImplementarion extends LocalStorageReporitory {
  final LocalStorageDatasource datasource;

  LocalStorageReporitoryImplementarion(this.datasource);
  @override
  Future<bool> isMovieFavorite(int movieId) {
    return datasource.isMovieFavorite(movieId);
  }

  @override
  Future<void> toogleFavorite(Movie movie) {
    return datasource.toogleFavorite(movie);
  }

  @override
  Future<List<Movie>> loadMovies({int limit = 20, offset = 0}) {
    return datasource.loadMovies(offset: offset, limit: limit);
  }
}
