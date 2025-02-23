import 'package:cinemapedia/domain/entities/cast.dart';

abstract class ActorsDatasource {
  Future<List<CastEntity>> getActorsByMovie(String movie);
}
