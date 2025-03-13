import 'package:cinemapedia/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarDatasource extends LocalStorageDatasource {
  late Future<Isar> db;
  IsarDatasource() {
    db = openDB();
  }
  Future<Isar> openDB() async {
    final dir = await getApplicationCacheDirectory();

    ///En caso de que no tengamos una instancia creada retornamos Isar.Open para abrir nuestra db, el Esquema de nuestra entidad, el inspector y el directorio
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [MovieSchema],

        ///Inspector lo que hace es permitir tener un servicio para poder saber como esta la base de datos en el dispositivo
        inspector: true,
        directory: dir.path,
      );
    }

    ///Si ya hay una instancia pues retornamos esa instancia
    return Future.value(Isar.getInstance());
  }

  @override
  Future<bool> isMovieFavorite(int movieId) async {
    final isar = await db;
    final Movie? isFvoriteMovie =

        ///Este query busca las colecciones que contengan el mismo ID y busca el primero unicamente
        await isar.movies.filter().idEqualTo(movieId).findFirst();
    return isFvoriteMovie != null;
  }

  @override
  Future<List<Movie>> loadMovies({int limit = 20, offset = 0}) async {
    final isar = await db;

    ///Con este query buscamos las movies que se encuentren dentro de los limites que hemos establecido
    return isar.movies.where().offset(offset).limit(limit).findAll();
  }

  @override
  Future<void> toogleFavorite(Movie movie) async {
    final isar = await db;

    ///Encontrar el id
    final favoriteMovie =
        await isar.movies.filter().idEqualTo(movie.id).findFirst();

    ///Eliminarlo
    if (favoriteMovie != null) {
      isar.writeTxnSync(() => isar.movies.deleteSync(favoriteMovie.isarId!));
      return;
    }

    ///Insertar
    isar.writeTxnSync(() => isar.movies.putSync(movie));
  }
}
