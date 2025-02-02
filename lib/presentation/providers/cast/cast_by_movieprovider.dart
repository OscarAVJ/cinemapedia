import 'package:cinemapedia/domain/entities/cast.dart';
import 'package:cinemapedia/presentation/providers/cast/cast_repository_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final actorsByMovieProvider =
    StateNotifierProvider<ActorsByMovieProvider, Map<String, List<CastEntity>>>(
  (ref) {
    final actorsRepository = ref.watch(actorRepositoryProvider);
    return ActorsByMovieProvider(getActors: actorsRepository.getActorsByMovie);
  },
);

//Definimos niuestra funcion
typedef GetActorsCallBack = Future<List<CastEntity>> Function(String movieId);

class ActorsByMovieProvider
    extends StateNotifier<Map<String, List<CastEntity>>> {
  final GetActorsCallBack getActors;
  ActorsByMovieProvider({
    required this.getActors,
  }) : super({});

  Future<void> loadActors(String movieId) async {
    // Si ya se cargaron actores para esta película, no hacer nada.
    if (state[movieId] != null) return;

    // Intentar obtener los actores
    final actors = await getActors(movieId);

    // Si no se encuentran actores, no actualizar el estado
    if (actors.isEmpty) {
      return;
    }

    // Actualizar el estado con los actores encontrados
    state = {...state, movieId: actors};
  }
}
