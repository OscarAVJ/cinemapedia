import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movie_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infraestructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infraestructure/models/moviedb/movie_details.dart';
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
  List<Movie> _jsonToMovies(Map<String, dynamic> json) {
    final movieDbResponse = MovieDbResponse.fromJson(json);
    //Aca lo que hacemos es iterar dentro de la respuesta de nuestro dbResponse y de ahi lo que obtengamos lo mapeamos
    final List<Movie> movies = movieDbResponse.results
        //Con el where no mapeamos si la pelicula no tiene poster
        .where((moviedb) => moviedb.posterPath != 'no-poster')
        .map((moviedb) => MovieMapper.movieDBtoEntity(moviedb))
        .toList();
    return movies;
  }

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response = await dio.get(
      '/movie/now_playing',
      queryParameters: {
        'page': page,
      },
    );
    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getPupular({int page = 1}) async {
    final response = await dio.get('/movie/popular', queryParameters: {
      'page': page,
    });

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {
    final response = await dio.get(
      '/movie/top_rated',
      queryParameters: {
        'page': page,
      },
    );
    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getUpcoming({int page = 1}) async {
    final response = await dio.get(
      '/movie/upcoming',
      queryParameters: {
        'page': page,
      },
    );
    return _jsonToMovies(response.data);
  }

  @override
  Future<Movie> getMovieById(String id) async {
    final response = await dio.get('/movie/$id');
    if (response.statusCode != 200) {
      throw Exception('Movie with id $id not founded');
    }
    final movieDetails = MovieDetails.fromJson(response.data);
    final Movie movieMapper = MovieMapper.movieDetailsToEntity(movieDetails);
    return movieMapper;
  }

  @override
  Future<List<Movie>> searchMovies(String query) async {
    if (query.isEmpty) return [];

    final response = await dio.get('/search/movie', queryParameters: {
      'query': query,
    });
    return _jsonToMovies(response.data);
  }
}
//upcoming
//top_rated
