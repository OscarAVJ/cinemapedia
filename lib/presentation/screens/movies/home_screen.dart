import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/screens/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home_screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _HomeView(),
      bottomNavigationBar: CustomBottomNavigationbar(),
    );
  }
}

//Creamos nuestro statefull widget y luego lo pasamos a consumer para poder acceder a Riverpod
class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {
  @override
  void initState() {
    ref.read(nowPlayinMoviesProvider.notifier).loadNextPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final nowPlayingMovies = ref.watch(nowPlayinMoviesProvider);
    final slideShowMovies = ref.watch(moviesSlideshowProvider);
    return SingleChildScrollView(
      child: Column(
        children: [
          const CustomAppbar(),
          //Expanded hace que ya una ves teniendo nuestro padre, envuelve esto listvie a la altura y anchura necesaria
          MoviesSlideshow(
            movies: slideShowMovies,
          ),
          MovieHorizontalListview(
            movies: nowPlayingMovies,
            title: 'En cines',
            subTitle: 'Lunes',
            loadNextPage: () {
              ref.read(nowPlayinMoviesProvider.notifier).loadNextPage();
            },
          ),
          MovieHorizontalListview(
            movies: nowPlayingMovies,
            title: 'En cines',
            subTitle: 'Lunes',
            loadNextPage: () {
              ref.read(nowPlayinMoviesProvider.notifier).loadNextPage();
            },
          ),
          MovieHorizontalListview(
            movies: nowPlayingMovies,
            title: 'En cines',
            subTitle: 'Lunes',
            loadNextPage: () {
              ref.read(nowPlayinMoviesProvider.notifier).loadNextPage();
            },
          ),
        ],
      ),
    );
  }
}
