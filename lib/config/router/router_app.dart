import 'package:cinemapedia/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: HomeScreen.name,
      builder: (context, state) => HomeScreen(),

      ///Definimos las rutas hijas, osea que desde el padre vamos a ellas
      routes: [
        GoRoute(
          ///Con el /: definimos nuestro parametro, siempre sera String
          ///Y no ponemos el / antes de movie por que el padre nos lo esta dando
          path: 'movie/:id',
          name: MovieScreen.name,
          builder: (context, state) {
            ///Aca nosotros definimos los parametros que necesitara el MovieScreen
            final movieId = state.pathParameters['id'] ?? 'no-id-found';
            return MovieScreen(
              movieId: movieId,
            );
          },
        ),
      ],
    ),
  ],
);
