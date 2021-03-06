import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/theme/provider.dart';
import '/theme/constants.dart';

import '/screens/songs/songs_detail.dart';
import '/screens/info/info_page.dart';

class HamburgerMenu extends StatefulWidget {
  @override
  _HamburgerMenuState createState() => _HamburgerMenuState();
}

class _HamburgerMenuState extends State<HamburgerMenu> {
  int get songId => 1;
  String get songTitle => 'Titolo cantico casuale';
  String get songText => 'Testo cantico casuale';

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Drawer(
      child: ListView(
        physics: const ScrollPhysics(),
        padding: EdgeInsets.zero,
        children: <Widget>[
          createDrawerHeader(),
          SwitchListTile(
            secondary: Icon(
              themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            ),
            title: const Text('Tema'),
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              final themeProvider =
                  Provider.of<ThemeProvider>(context, listen: false);
              themeProvider.toggleTheme(value);
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Cantico casuale'),
            onTap: () {
              FocusScope.of(context).unfocus();
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SongsDetail(songId, songTitle, songText);
                  },
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Contatti'),
            onTap: () {
              FocusScope.of(context).unfocus();
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return InfoPage();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

Widget createDrawerHeader() {
  return DrawerHeader(
    margin: EdgeInsets.zero,
    padding: EdgeInsets.zero,
    decoration: const BoxDecoration(
      image: DecorationImage(
        fit: BoxFit.cover,
        image: AssetImage('lib/assets/images/drawer_header.png'),
      ),
    ),
    child: Stack(
      children: <Widget>[
        Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.clear,
                color: kWhite,
              ),
              onPressed: () {
                FocusScope.of(context).unfocus();
                Navigator.of(context).pop();
              },
              tooltip: 'Chiudi',
            );
          },
        ),
        const Positioned(
          bottom: 12.0,
          left: 16.0,
          child: Text(
            'Menu',
            style: TextStyle(
              color: kWhite,
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}
