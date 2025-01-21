import 'package:flutter/material.dart';

class CustomScreenLoading extends StatelessWidget {
  const CustomScreenLoading({super.key});

  Stream<String> loadingMessages() {
    final messages = <String>[
      'Buscando palomitas',
      'Cargando anuncios',
      'Buscando peliculas',
      'Llamando a mi ex',
      'Cargando peliculas',
      'Ey, esto esta tardando mas de lo normal :('
    ];
    return Stream.periodic(const Duration(milliseconds: 1200), (step) {
      return messages[step];
    }).take(messages.length);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Cargando...'),
          SizedBox(
            height: 10,
          ),
          CircularProgressIndicator(),
          SizedBox(
            height: 10,
          ),
          StreamBuilder(
            stream: loadingMessages(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Text('Cargando');
              return Text(snapshot.data!);
            },
          )
        ],
      ),
    );
  }
}
