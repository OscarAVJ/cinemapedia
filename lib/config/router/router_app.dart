import 'package:cinemapedia/presentation/views/home/popular_view.dart';
import 'package:cinemapedia/presentation/screens/screens.dart';
import 'package:cinemapedia/presentation/views/home/favorites_view.dart';
import 'package:cinemapedia/presentation/views/home/home_view.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  ///! Establecemos la pantalla inicial
  initialLocation: '/',

  routes: [
    ///! Definimos la estructura de navegación con `StatefulShellRoute`
    StatefulShellRoute.indexedStack(
      ///! `builder` indica que `HomeScreen` será el contenedor principal
      builder: (context, state, navigationShell) {
        return HomeScreen(navigationShell: navigationShell);
      },

      ///! Definimos las pestañas de navegación
      branches: [
        ///! Primera pestaña: HOME
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => const HomeView(),

            ///! Ruta hija: Ver detalles de una película
            routes: [
              GoRoute(
                path: 'movie/:id',
                name: 'movie_screen',
                builder: (context, state) {
                  ///! Extraemos el `id` de la película de los parámetros de la URL
                  final movieId = state.pathParameters['id'] ?? 'no-id-found';
                  return MovieScreen(movieId: movieId);
                },
              ),
            ],
          ),
        ]),

        ///! Segunda pestaña: CATEGORÍAS (Por ahora un placeholder)
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/popular',
            name: 'popular',
            builder: (context, state) => const PopularView(),
          ),
        ]),

        ///! Tercera pestaña: FAVORITOS
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/favorites',
            name: 'favorites',
            builder: (context, state) => const FavoritesView(),
          ),
        ]),
      ],
    ),

    ///! Ruta independiente para configuración
    GoRoute(
      path: '/config_screen',
      name: 'config_screen',
      builder: (context, state) => const ConfigScreen(),
    ),
  ],
);

//! Navegacion normal

// routes: [
//     GoRoute(
//       path: '/',
//       name: HomeScreen.name,
//       builder: (context, state) => HomeScreen(
//         childView: HomeView(),
//       ),

//       ///Definimos las rutas hijas, osea que desde el padre vamos a ellas
//       routes: [
//         GoRoute(
//           ///Con el /: definimos nuestro parametro, siempre sera String
//           ///Y no ponemos el / antes de movie por que el padre nos lo esta dando
//           path: 'movie/:id',
//           name: MovieScreen.name,
//           builder: (context, state) {
//             ///Aca nosotros definimos los parametros que necesitara el MovieScreen
//             final movieId = state.pathParameters['id'] ?? 'no-id-found';
//             return MovieScreen(
//               movieId: movieId,
//             );
//           },
//         ),
//       ],
//     ),
//     GoRoute(
//       path: '/config_screen',
//       name: ConfigScreen.name,
//       builder: (context, state) => ConfigScreen(),
//     )
//   ],
