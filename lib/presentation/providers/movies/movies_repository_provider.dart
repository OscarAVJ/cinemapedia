import 'package:cinemapedia/infraestructure/datasources/moviedb_datasource.dart';
import 'package:cinemapedia/infraestructure/respositories/movie_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//este repositorio es inmutable
final movieRepositoryImplProvider = Provider((ref) {
  return MovieRepositoryImpl(MoviedbDatasource());
});
