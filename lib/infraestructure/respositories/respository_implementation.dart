import 'package:cinemapedia/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia/domain/entities/cast.dart';
import 'package:cinemapedia/domain/repositories/actors_repository.dart';

class RespositoryImplementation extends ActorsRepository {
  final ActorsDatasource datasource;

  RespositoryImplementation(this.datasource);
  @override
  Future<List<CastEntity>> getActorsByMovie(String movie) {
    return datasource.getActorsByMovie(movie);
  }
}
