import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:system_settings/system_settings.dart';

import '/assets/theme/provider.dart';
import '/assets/theme/constants.dart';

import '/screens/songs/songs_detail.dart';
import '/screens/info/info_page.dart';

class HamburgerMenu extends StatefulWidget {
  @override
  _HamburgerMenuState createState() => _HamburgerMenuState();
}

class _HamburgerMenuState extends State<HamburgerMenu> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          createDrawerHeader(),
          Consumer<ThemeProvider>(
            builder: (context, ThemeProvider provider, child) {
              return SwitchListTile(
                secondary: Icon(
                  themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                ),
                title: const Text('Tema'),
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  final provider =
                      Provider.of<ThemeProvider>(context, listen: false);
                  provider.toggleTheme(value);
                },
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: const Text('Cantico casuale'),
            onTap: () {
              FocusScope.of(context).unfocus();
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SongsDetail();
                  },
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
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
          Divider(),
          ListTile(
            title: Text('Informazioni app'),
            onTap: () {
              /*
              FocusScope.of(context).unfocus();
              Navigator.pop(context);
              SystemSettings.app();
              */
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
    decoration: BoxDecoration(
      image: DecorationImage(
        fit: BoxFit.fill,
        image: AssetImage('lib/assets/images/menu.png'),
      ),
    ),
    child: Stack(
      children: <Widget>[
        Positioned(
          bottom: 12.0,
          left: 16.0,
          child: Text(
            'Menu',
            style: TextStyle(
                color: kWhite, fontSize: 20.0, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    ),
  );
}
