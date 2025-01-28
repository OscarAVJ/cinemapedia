import 'package:cinemapedia/domain/entities/cast.dart';

abstract class ActorsRepository {
  Future<List<CastEntity>> getActorsByMovie(String movie);
}
