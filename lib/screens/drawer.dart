import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/theme/theme_provider.dart';
import '/theme/constants.dart';
import '/assets/data/queries.dart';

import '/screens/songs/songs_detail.dart';
import 'editor/new_song_page.dart';
import 'editor/new_song_page2.dart';
import '/screens/info/info_page.dart';

class HamburgerMenu extends StatefulWidget {
  const HamburgerMenu({Key? key}) : super(key: key);

  @override
  State<HamburgerMenu> createState() => _HamburgerMenuState();
}

class _HamburgerMenuState extends State<HamburgerMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        physics: const ScrollPhysics(),
        padding: EdgeInsets.zero,
        children: <Widget>[
          createDrawerHeader(),
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
            leading: const Icon(Icons.shuffle),
            title: const Text('Cantico casuale'),
            onTap: () {
              FocusScope.of(context).unfocus();
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return FutureBuilder<List?>(
                      future: QueryCtr().getAllSongs(),
                      initialData: const [],
                      builder: (context, snapshot) {
                        int randomSongId =
                            Random().nextInt(snapshot.data!.length);
                        return snapshot.hasData
                            ? SongsDetail(index: randomSongId, from: 'Drawer')
                            : const Padding(
                                padding: EdgeInsets.only(top: kDefaultPadding),
                                child: Center(
                                  child: Text(
                                    'Nessun cantico trovato',
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                ),
                              );
                      },
                    );
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
                    return const NewSongPage();
                  },
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_circle),
            title: const Text('Aggiungi cantico 2'),
            onTap: () {
              FocusScope.of(context).unfocus();
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const NewSongPage2();
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
            bottom: kDefaultPadding - 8.0,
            left: kDefaultPadding - 4.0,
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
}
