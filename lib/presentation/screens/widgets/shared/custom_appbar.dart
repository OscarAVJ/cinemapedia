import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/searchDelegate/search_provider.dart';
import 'package:cinemapedia/presentation/screens/delegates/search_movie_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, ref) {
    ///Accedemos al color de nuestro tema
    final colors = Theme.of(context).colorScheme;

    ///Accedemos al color de nuestro texto
    final titleStyle = Theme.of(context).textTheme.titleMedium;

    ///Safe area lo que hace es que evita los espacios que ya vienen por defecto, en este caso el de bottom lo evitara
    return SafeArea(
      bottom: false,
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            SizedBox(
              height: 5,
            ),
            Text(
              'Cinemapedia',
              style: titleStyle,
            ),
            //Spacer hace que tome todo el espado dentro del contenedor hasta el final para poner
            const Spacer(),
            IconButton(
              onPressed: () {
                ///El movieRepository ya no lo usamos ya que como en nuestro savedMoviesProvider ya estamos haciendo referencia a el podemos utilizar el mismo provider y hacer referencia al metodo
                //! final movieRepository = ref.read(movieRepositoryImplProvider);
                final searchProvider = ref.read(searchMovieProvider);
                final savedMovies = ref.read(savedMoviesProvider);
                showSearch<Movie?>(
                  query: searchProvider,
                  context: context,

                  ///El delegate es el que se encargara de trabajar la busqueda
                  delegate: SearchMovieDelegate(
                    initialMovies: savedMovies,
                    searchMovies: ref
                        .read(savedMoviesProvider.notifier)
                        .searchedMoviesSave,
                  ),
                ).then(
                  (movie) {
                    if (movie == null) return;
                    // ignore: use_build_context_synchronously
                    context.push('/movie/${movie.id}');
                  },
                );
              },
              icon: Icon(
                Icons.search,
                color: colors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
