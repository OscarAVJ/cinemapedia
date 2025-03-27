import 'package:cinemapedia/presentation/providers/storage/favorite_movies_provider.dart';
import 'package:cinemapedia/presentation/screens/widgets/movies/movie_masonry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FavoritesView extends ConsumerStatefulWidget {
  static const name = 'favorites_view';

  const FavoritesView({super.key});

  @override
  FavoritesViewState createState() => FavoritesViewState();
}

class FavoritesViewState extends ConsumerState<FavoritesView> {
  bool isLoading = false;
  bool isLastPage = false;
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ///Inicializamos el favoriteMoviesProvider para que nos traiga datos de base
      loadNextPage();
    });
  }

  void loadNextPage() async {
    if (isLoading || isLastPage) return;
    isLoading = true;
    final movies =
        await ref.read(favoriteMoviesProvider.notifier).loadNextPage();
    isLoading = false;
    if (movies.isEmpty) {
      isLastPage = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    /// Convertimos el Map<int, Movie> a List<Movie> para usarlo con ListView.builder
    final movies = ref.watch(favoriteMoviesProvider).values.toList();

    if (movies.isEmpty) {
      final colors = Theme.of(context).colorScheme;
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_outline_sharp,
              size: 60,
              color: colors.primary,
            ),
            Text(
              'Ohh NO!!!!',
              style: TextStyle(fontSize: 30, color: colors.primary),
            ),
            Text(
              'No tienes peliculas favoritas',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            FilledButton(
              onPressed: () {
                context.go('/');
              },
              child: Text('Inicio'),
            ),
          ],
        ),
      );
    }
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: MovieMasonry(
          movies: movies,
          loadNextPage: loadNextPage,
        ),
      ),
    );
  }
}
