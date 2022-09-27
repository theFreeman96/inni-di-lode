import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '/theme/theme_provider.dart';
import '/theme/constants.dart';

import 'songs/songs_header.dart';
import 'songs/songs_body.dart';
import 'categories/cat_header.dart';
import 'categories/cat_body.dart';
import 'authors/aut_header.dart';
import 'authors/aut_body.dart';
import 'favorites/fav_header.dart';
import 'favorites/fav_body.dart';
import 'drawer.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Widget> pageHeaders = [
    const SongsHeader(),
    const CatHeader(),
    const AutHeader(),
    const FavHeader(),
  ];
  final List<Widget> pageBodies = [
    const SongsBody(),
    const CatBody(),
    const AutBody(),
    const FavBody(),
  ];

  int currentIndex = 0;
  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: false,
      drawer: const HamburgerMenu(),
      body: _buildPage(context),
      floatingActionButton: Builder(
        builder: (BuildContext context) {
          return FloatingActionButton(
            tooltip: 'Menu',
            child: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        elevation: 0.0,
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        clipBehavior: Clip.antiAlias,
        color: themeProvider.isDarkMode ? kGrey : kPrimaryColor,
        child: Padding(
          padding: const EdgeInsets.only(right: kDefaultPadding * 4),
          child: BottomNavigationBar(
            elevation: 0.0,
            landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
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
                backgroundColor:
                    themeProvider.isDarkMode ? kGrey : kPrimaryColor,
              ),
              BottomNavigationBarItem(
                icon: const FaIcon(FontAwesomeIcons.tags, size: 18),
                label: 'Categorie',
                backgroundColor:
                    themeProvider.isDarkMode ? kGrey : kPrimaryColor,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.people_alt),
                label: 'Autori',
                backgroundColor:
                    themeProvider.isDarkMode ? kGrey : kPrimaryColor,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.favorite),
                label: 'Preferiti',
                backgroundColor:
                    themeProvider.isDarkMode ? kGrey : kPrimaryColor,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    Orientation orientation = mediaQuery.orientation;
    return orientation == Orientation.portrait
        ? NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: mediaQuery.size.height * 0.25,
                  floating: false,
                  pinned: false,
                  toolbarHeight: 0.0,
                  collapsedHeight: 0.0,
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: FlexibleSpaceBar(
                    background: pageHeaders[currentIndex],
                  ),
                ),
              ];
            },
            body: pageBodies[currentIndex],
          )
        : Row(
            children: <Widget>[
              SizedBox(
                width: mediaQuery.size.width * 0.35,
                height: mediaQuery.size.height,
                child: pageHeaders[currentIndex],
              ),
              Expanded(
                child: pageBodies[currentIndex],
              ),
            ],
          );
  }
}
