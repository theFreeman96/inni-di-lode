import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/utilities/constants.dart';
import '/utilities/theme_provider.dart';

class HomeBottomBar extends StatelessWidget {
  const HomeBottomBar({
    Key? key,
    required this.currentIndex,
    required this.onTabTapped,
  }) : super(key: key);

  final int currentIndex;
  final Function(int) onTabTapped;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return BottomAppBar(
      elevation: 0.0,
      shape: const CircularNotchedRectangle(),
      notchMargin: 6,
      clipBehavior: Clip.antiAlias,
      color: themeProvider.isDarkMode ? kGrey : kPrimaryColor,
      child: Padding(
        padding: const EdgeInsets.only(right: kDefaultPadding * 4),
        child: NavigationBar(
          elevation: 0.0,
          selectedIndex: currentIndex,
          onDestinationSelected: onTabTapped,
          indicatorColor:
              themeProvider.isDarkMode ? kBlack : kWhite.withOpacity(0.3),
          backgroundColor: themeProvider.isDarkMode ? kGrey : kPrimaryColor,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.library_music_outlined),
              selectedIcon: Icon(Icons.library_music),
              label: 'Cantici',
              tooltip: 'Cantici',
            ),
            NavigationDestination(
              icon: Icon(Icons.sell_outlined),
              selectedIcon: Icon(Icons.sell),
              label: 'Categorie',
              tooltip: 'Categorie',
            ),
            NavigationDestination(
              icon: Icon(Icons.people_alt_outlined),
              selectedIcon: Icon(Icons.people_alt),
              label: 'Autori',
              tooltip: 'Autori',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_border),
              selectedIcon: Icon(Icons.favorite),
              label: 'Preferiti',
              tooltip: 'Preferiti',
            )
          ],
        ),
      ),
    );
  }
}
