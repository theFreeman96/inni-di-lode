import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/utilities/constants.dart';
import '/utilities/theme_provider.dart';

Widget buildBottom(context, currentIndex, onTabTapped) {
  final themeProvider = Provider.of<ThemeProvider>(context);
  return BottomAppBar(
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
            backgroundColor: themeProvider.isDarkMode ? kGrey : kPrimaryColor,
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: kDefaultPadding * 1.2,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(Icons.sell_outlined, size: 20),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.sell,
                      size: 20,
                      color: themeProvider.isDarkMode ? kGrey : kPrimaryColor,
                    ),
                  ),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.sell, size: 20),
                  ),
                ],
              ),
            ),
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
