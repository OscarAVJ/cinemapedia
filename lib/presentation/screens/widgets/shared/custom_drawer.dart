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
        Row(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(28, hasNotch ? 10 : 20, 16, 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  'https://media.4-paws.org/9/c/9/7/9c97c38666efa11b79d94619cc1db56e8c43d430/Molly_006-2829x1886-2726x1886-1920x1328.jpg',
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              'Oscar',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 16, 28, 10),
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
        const Spacer(),
        NavigationDrawerDestination(
          icon: Icon(cinemapediaMenuItems[3].icons),
          label: Text(cinemapediaMenuItems[3].title),
        ),
      ],
    );
  }
}
