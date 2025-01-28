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
    if (state[movieId] != null) return;
    final actors = await getActors(movieId);
    state = {...state, movieId: actors};
  }
}
