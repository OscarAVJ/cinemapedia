import 'package:cinemapedia/infraestructure/datasources/isar_datasource.dart';
import 'package:cinemapedia/infraestructure/respositories/local_storage_reporitory_implementarion.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///Con este provider lo que hacemos es poder acceder a los metodos de nuestro datasource y asi poder usar los metodos que este tien
final localStorageProvider = Provider((ref) {
  return LocalStorageReporitoryImplementarion(IsarDatasource());
});

/// Proveedor que verifica si una película es favorita.
/// - Se ejecuta de forma asíncrona y retorna `true` o `false`.
/// - Usa `.family` para recibir un `movieId` como parámetro.
/// - Usa `.autoDispose` para liberar memoria cuando ya no se necesite.
final isMovieFavoriteProvider =
    FutureProvider.family.autoDispose((ref, int movieId) {
  /// Obtenemos la instancia del almacenamiento local.
  final localStorageProviderImpl = ref.watch(localStorageProvider);

  /// Consultamos si la película está marcada como favorita en la base de datos.
  return localStorageProviderImpl.isMovieFavorite(movieId);
});
