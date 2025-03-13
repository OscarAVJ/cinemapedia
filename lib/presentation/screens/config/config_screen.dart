import 'package:cinemapedia/presentation/providers/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

class ConfigScreen extends ConsumerWidget {
  static const name = 'config_screen';

  const ConfigScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuracion'),
      ),
      body: _ConfigItems(),
    );
  }
}

class _ConfigItems extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ref) {
    final isDarkMode = ref.watch(themeNotifierProvider).isDarkMode;
    return Column(
      children: [
        _DarkMode(isDarkMode: isDarkMode),
        _LanguajeMode(),
      ],
    );
  }
}

class _LanguajeMode extends ConsumerStatefulWidget {
  const _LanguajeMode();

  @override
  _LanguajeModeState createState() => _LanguajeModeState();
}

class _LanguajeModeState extends ConsumerState<_LanguajeMode> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: DropdownButton<String>(
        value: dropdownValue,
        isExpanded: true,
        icon: const Icon(Icons.arrow_downward),
        elevation: 16,
        style: const TextStyle(color: Colors.blue),
        underline: Container(height: 2, color: colors.primary),
        onChanged: (String? value) {
          // This is called when the user selects an item.
          setState(() {
            dropdownValue = value!;
          });
        },
        items: list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
      ),
    );
  }
}

class _DarkMode extends ConsumerWidget {
  const _DarkMode({
    required this.isDarkMode,
  });

  final bool isDarkMode;

  @override
  Widget build(BuildContext context, ref) {
    return SwitchListTile(
        title: const Text('Modo oscuro'),
        subtitle: const Text('Controles adicionales'),
        value: isDarkMode,
        onChanged: (value) =>
            ref.read(themeNotifierProvider.notifier).toogleDarkMode());
  }
}
