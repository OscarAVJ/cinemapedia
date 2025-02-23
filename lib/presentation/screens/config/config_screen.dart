import 'package:cinemapedia/presentation/providers/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfigScreen extends ConsumerWidget {
  static const name = 'config_screen';

  const ConfigScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuracion'),
      ),
      body: _IsDarkMode(),
    );
  }
}

class _IsDarkMode extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ref) {
    final isDarkMode = ref.watch(themeNotifierProvider).isDarkMode;
    return Column(
      children: [
        SwitchListTile(
            title: const Text('Modo oscuro'),
            subtitle: const Text('Controles adicionales'),
            value: isDarkMode,
            onChanged: (value) =>
                ref.read(themeNotifierProvider.notifier).toogleDarkMode()),
      ],
    );
  }
}
