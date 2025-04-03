import 'package:cinemapedia/presentation/providers/movies/movies_providers.dart';
import 'package:cinemapedia/presentation/screens/widgets/movies/movie_masonry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PopularView extends ConsumerStatefulWidget {
  static const name = 'popular';
  const PopularView({super.key});

  @override
  PopularViewState createState() => PopularViewState();
}

class PopularViewState extends ConsumerState<PopularView> {
  @override
  Widget build(BuildContext context) {
    final getPopular = ref.watch(popularMoviesProvider);
    final moviesNotifier = ref.read(popularMoviesProvider.notifier);

    return Scaffold(
      appBar: AppBar(),
      body: MovieMasonry(
        movies: getPopular,
        loadNextPage: moviesNotifier.hasMore
            ? () {
                ref.read(popularMoviesProvider.notifier).loadNextPage();
              }
            : null,
      ),
    );
  }
}
