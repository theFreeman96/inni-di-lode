import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '/theme/provider.dart';
import '/theme/constants.dart';

import 'drawer.dart';
import '/screens/songs/songs_page.dart';
import '/screens/categories/cat_page.dart';
import '/screens/authors/aut_page.dart';
import '/screens/favorites/fav_page.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;
  final List<Widget> children = [SongsPage(), CatPage(), AutPage(), FavPage()];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: false,
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: 'Menu',
            );
          },
        ),
        title: const Text('Innario'),
      ),
      drawer: HamburgerMenu(),
      body: children[currentIndex],
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          backgroundColor: themeProvider.isDarkMode ? kGrey : kPrimaryColor,
          currentIndex: currentIndex,
          onTap: onTabTapped,
          selectedItemColor: kWhite,
          unselectedItemColor: kWhite.withOpacity(0.6),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.library_music),
              label: 'Cantici',
              backgroundColor: themeProvider.isDarkMode ? kGrey : kPrimaryColor,
            ),
            BottomNavigationBarItem(
              icon: const FaIcon(FontAwesomeIcons.tags, size: 18),
              label: 'Categorie',
              backgroundColor: themeProvider.isDarkMode ? kGrey : kPrimaryColor,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.people_alt),
              label: 'Autori',
              backgroundColor: themeProvider.isDarkMode ? kGrey : kPrimaryColor,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.favorite),
              label: 'Preferiti',
              backgroundColor: themeProvider.isDarkMode ? kGrey : kPrimaryColor,
            )
          ],
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }
}
