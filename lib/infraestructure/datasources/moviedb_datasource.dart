import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movie_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infraestructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infraestructure/models/moviedb/moviedb_response.dart';
import 'package:dio/dio.dart';

//Con dio hacemos peticiones http
class MoviedbDatasource extends MovieDatasource {
  //Aca lo que estamos diciendo es que nuestro dio siempre tendra su url precargada osea que solo seria de agregar lo que necesitemos en este caso el apiKey y el lenguaje
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
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response = await dio.get('/movie/now_playing', queryParameters: {
      'page': page,
    });
    final movieDbResponse = MovieDbResponse.fromJson(response.data);
    //Aca lo que hacemos es iterar dentro de la respuesta de nuestro dbResponse y de ahi lo que obtengamos lo mapeamos
    final List<Movie> movies = movieDbResponse.results
        //Con el where no mapeamos si la pelicula no tiene poster
        .where((moviedb) => moviedb.posterPath != 'no-poster')
        .map((moviedb) => MovieMapper.movieDBtoEntity(moviedb))
        .toList();
    return movies;
  }
}
