import 'package:cinemapedia/infraestructure/datasources/cast_moviedb_datasource.dart';
import 'package:cinemapedia/infraestructure/respositories/respository_implementation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final actorRepositoryProvider = Provider((ref) {
  return RespositoryImplementation(CastMoviedbDatasource());
});
