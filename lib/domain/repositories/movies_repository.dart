import 'package:cinemapedia/domain/entities/movie.dart';

//A traves del repositorio accedemos a nuestro datasource
abstract class MoviesRepository {
  Future<List<Movie>> getNowPlaying({int page = 1});
}
