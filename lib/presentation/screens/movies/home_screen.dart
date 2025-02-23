import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/screens/widgets/shared/custom_drawer.dart';
import 'package:cinemapedia/presentation/screens/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends StatelessWidget {
  ///Aca creamos el nombre de nuestro path
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

///Creamos nuestro statefull widget y luego lo pasamos a consumer para poder acceder a Riverpod
class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ///Aca iniciamos nuestros providers para que al cargar se ejecuten los metodos y peticiones respecitva
      ref.read(nowPlayinMoviesProvider.notifier).loadNextPage();
      ref.read(popularMoviesProvider.notifier).loadNextPage();
      ref.read(upcomingMoviesProvider.notifier).loadNextPage();
      ref.read(topRatedProvider.notifier).loadNextPage();
    });
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    ///Con este provider verificamos si todos los loading ya han cargado
    final bool isLoading = ref.watch(isLoadingScreenProvider);
    if (isLoading) return const CustomScreenLoading();

    ///Aca hacemos referencia a nuestros providers
    final nowPlayingMovies = ref.watch(nowPlayinMoviesProvider);
    final slideShowMovies = ref.watch(moviesSlideshowProvider);
    final getPopularProvider = ref.watch(popularMoviesProvider);
    final getUpcomingProvider = ref.watch(upcomingMoviesProvider);
    final getTopRatedProvider = ref.watch(topRatedProvider);

    ///Con el customScrollView usamos Slivers
    return Scaffold(
      drawer: CustomDrawer(
        scaffoldKey: scaffoldKey,
      ),
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            floating: true,
            title: CustomAppbar(),
          ),

          ///Creamos nuestra lista de sliders
          SliverList(
            ///Creamos el builder
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                ///Retornamos el widget
                return Column(
                  children: [
                    MoviesSlideshow(
                      movies: slideShowMovies,
                    ),
                    MovieHorizontalListview(
                      movies: nowPlayingMovies,
                      title: 'En cines',
                      subTitle: 'Lunes',
                      loadNextPage: () {
                        ref
                            .read(nowPlayinMoviesProvider.notifier)
                            .loadNextPage();
                      },
                    ),
                    MovieHorizontalListview(
                      movies: getPopularProvider,
                      title: 'Populares',
                      subTitle: 'Esta semana',
                      loadNextPage: () {
                        ref.read(popularMoviesProvider.notifier).loadNextPage();
                      },
                    ),
                    MovieHorizontalListview(
                      movies: getUpcomingProvider,
                      title: 'Proximamente',
                      subTitle: 'Hoy',
                      loadNextPage: () {
                        ref
                            .read(upcomingMoviesProvider.notifier)
                            .loadNextPage();
                      },
                    ),
                    MovieHorizontalListview(
                      movies: getTopRatedProvider,
                      title: 'Mejor calificadas',
                      subTitle: 'Este mes',
                      loadNextPage: () {
                        ref.read(topRatedProvider.notifier).loadNextPage();
                      },
                    ),
                  ],
                );
                //Definimos la canidad de veces que queremos que se repitan los widgets de nuestro return xxxs
              },
              childCount: 1,
            ),
          )
        ],
      ),
    );
  }
}
