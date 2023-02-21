import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/utilities/constants.dart';
import '/utilities/theme_provider.dart';
import 'header.dart';

import '/screens/songs/songs_body.dart';
import '/screens/categories/cat_body.dart';
import '/screens/authors/aut_body.dart';
import '/screens/favorites/fav_body.dart';

Widget buildPage(context, currentIndex) {
  final themeProvider = Provider.of<ThemeProvider>(context);
  final mediaQuery = MediaQuery.of(context);
  Orientation orientation = mediaQuery.orientation;
  return orientation == Orientation.portrait
      ? NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: mediaQuery.size.height * 0.25,
                floating: false,
                pinned: false,
                toolbarHeight: 0.0,
                collapsedHeight: 0.0,
                automaticallyImplyLeading: false,
                backgroundColor:
                    themeProvider.isDarkMode ? kGrey : kPrimaryColor,
                flexibleSpace: FlexibleSpaceBar(
                  background: buildHeader(pageHeaders[currentIndex]),
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
              child: buildHeader(pageHeaders[currentIndex]),
            ),
            Expanded(
              child: pageBodies[currentIndex],
            ),
          ],
        );
}

final List<String> pageHeaders = [
  'lib/assets/images/songs_header.png',
  'lib/assets/images/cat_header.png',
  'lib/assets/images/aut_header.png',
  'lib/assets/images/fav_header.png',
];

final List<Widget> pageBodies = [
  const SongsBody(),
  const CatBody(),
  const AutBody(),
  const FavBody(),
];
