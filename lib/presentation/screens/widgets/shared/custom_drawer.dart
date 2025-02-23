import 'package:cinemapedia/config/items/menu_items.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomDrawer extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CustomDrawer({super.key, required this.scaffoldKey});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  int navDrawerIndex = 0;

  void navigationMenu(value) {
    final manuItem = cinemapediaMenuItems[value];
    context.push(manuItem.route);
  }

  @override
  Widget build(BuildContext context) {
    final hasNotch = MediaQuery.of(context).viewPadding.top > 35;
    return NavigationDrawer(
      selectedIndex: navDrawerIndex,
      onDestinationSelected: (value) {
        setState(() {
          navDrawerIndex = value;
          widget.scaffoldKey.currentState?.closeDrawer();
        });
        navigationMenu(value);
      },
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(28, hasNotch ? 10 : 20, 16, 10),
          child: Text('Side menu'),
        ),
        ...cinemapediaMenuItems.sublist(0, 3).map(
              (item) => NavigationDrawerDestination(
                icon: Icon(item.icons),
                label: Text(item.title),
              ),
            ),
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 16, 28, 10),
          child: Divider(),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(28, 10, 16, 10),
          child: Text('More options'),
        ),
      ],
    );
  }
}
