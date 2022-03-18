import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '/assets/theme/provider.dart';
import '/assets/theme/constants.dart';

import 'drawer.dart';
import '/screens/songs/songs_page.dart';
import '/screens/categories/cat_page.dart';
import '/screens/authors/aut_page.dart';
import '/screens/favorites/fav_page.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [SongsPage(), CatPage(), AutPage(), FavPage()];

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: false,
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: 'Menu',
            );
          },
        ),
        title: Text('Innario'),
      ),
      drawer: HamburgerMenu(),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        selectedItemColor: kWhite,
        unselectedItemColor: kWhite.withOpacity(0.6),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: 'Tutti i cantici',
            backgroundColor: themeProvider.isDarkMode ? kGrey : kPrimaryColor,
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.tags, size: 18),
            label: 'Categorie',
            backgroundColor: themeProvider.isDarkMode ? kGrey : kPrimaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt),
            label: 'Autori',
            backgroundColor: themeProvider.isDarkMode ? kGrey : kPrimaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Preferiti',
            backgroundColor: themeProvider.isDarkMode ? kGrey : kPrimaryColor,
          )
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
