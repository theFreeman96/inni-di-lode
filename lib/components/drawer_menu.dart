import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utilities/constants.dart';
import '/screens/editor/editor.dart';
import '/screens/info/info_page.dart';
import '/utilities/theme_provider.dart';
import 'drawer_header.dart';
import 'random_song.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Drawer(
      child: ListView(
        physics: const ScrollPhysics(),
        padding: EdgeInsets.zero,
        children: <Widget>[
          const MyDrawerHeader(),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return SwitchListTile(
                secondary: Icon(
                  themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                ),
                title: const Text('Tema'),
                onChanged: (value) {
                  themeProvider.toggleTheme();
                },
                value: themeProvider.isDarkMode,
              );
            },
          ),
          ListTile(
            leading: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.circle),
                Icon(
                  Icons.shuffle,
                  size: 15,
                  color: themeProvider.isDarkMode ? kBlack : kWhite,
                ),
              ],
            ),
            title: const Text('Cantico casuale'),
            onTap: () {
              FocusScope.of(context).unfocus();
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const RandomSong();
                  },
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_circle),
            title: const Text('Aggiungi cantico'),
            onTap: () {
              FocusScope.of(context).unfocus();
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const Editor();
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
                    return const InfoPage();
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
