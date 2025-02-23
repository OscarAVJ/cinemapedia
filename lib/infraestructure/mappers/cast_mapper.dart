import 'package:cinemapedia/domain/entities/cast.dart';
import 'package:cinemapedia/infraestructure/models/moviedb/credits_response.dart';

class CastMapper {
  static CastEntity castToEntity(Cast cast) => CastEntity(
        id: cast.id,
        name: cast.name,
        profilePath: cast.profilePath != null
            ? 'https://image.tmdb.org/t/p/w500${cast.profilePath}'
            : 'https://demofree.sirv.com/nope-not-here.jpg',
        character: cast.character,
      );
}
