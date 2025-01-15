//Es abtracta por que no queremos crear instancias de esta clase
//Aca definimos los metodos que seran usados y sera nuestro origen de datos
import 'package:cinemapedia/domain/entities/movie.dart';

abstract class MovieDatasource {
  Future<List<Movie>> getNowPlaying({int page = 1});
}
