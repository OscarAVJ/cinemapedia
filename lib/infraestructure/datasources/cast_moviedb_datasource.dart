import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia/domain/entities/cast.dart';
import 'package:cinemapedia/infraestructure/mappers/cast_mapper.dart';
import 'package:cinemapedia/infraestructure/models/moviedb/credits_response.dart';

import 'package:dio/dio.dart';

class CastMoviedbDatasource extends ActorsDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      //Aca establecemos los parametros de nuestra consulta
      queryParameters: {
        'api_key': Environment.movieDbKey,
        'language': 'es-MX',
      },
    ),
  );

  @override
  Future<List<CastEntity>> getActorsByMovie(String movie) async {
    final response = await dio.get('/movie/$movie/credits');
    final castResponse = CreditsResponse.fromJson(response.data);

    List<CastEntity> cast =
        castResponse.cast.map((cast) => CastMapper.castToEntity(cast)).toList();

    return cast;
  }
}
