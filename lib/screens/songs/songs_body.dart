import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:number_paginator/number_paginator.dart';

import '/utilities/constants.dart';
import '/utilities/theme_provider.dart';
import '/components/searchbar.dart';
import '/components/list_main.dart';
import '/data/models.dart';
import '/data/queries.dart';

import 'songs_detail.dart';

class SongsBody extends StatefulWidget {
  const SongsBody({Key? key}) : super(key: key);

  @override
  State<SongsBody> createState() => _SongsBodyState();
}

class _SongsBodyState extends State<SongsBody> {
  final FocusNode myFocusNode = FocusNode();
  final QueryCtr query = QueryCtr();
  late int currentPage = 0;

  void onValueChanged(newValue) {
    setState(() {
      currentPage = newValue;
    });
  }

  late List<Future<List?>> songRange = [
    query.getSongsFromRange(1, 100),
    query.getSongsFromRange(101, 200),
    query.getSongsFromRange(201, 300),
    query.getSongsFromRange(301, 400),
    query.getSongsFromRange(401, 500),
    query.getSongsFromRange(501, 600),
    query.getSongsFromRange(601, 700),
    query.getSongsFromRange(701, 800),
  ];

  late Future<List?> future;
  bool isVisible = true;
  @override
  void initState() {
    future = songRange[currentPage];
    super.initState();
  }

  void runFilter(String keyword) {
    Future<List?> results;
    if (keyword.isEmpty) {
      results = future;

      setState(() {
        songRange[currentPage] = future;
        isVisible = true;
      });
    } else {
      results = query.searchSong(keyword);

      setState(() {
        currentPage = 0;
        songRange[currentPage] = results;
        isVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Column(
      children: <Widget>[
        buildSearchBar(
          focusNode: myFocusNode,
          filter: runFilter,
          label: 'Cerca per numero, titolo o testo',
          hint: 'Cerca un cantico',
        ),
        Visibility(
          visible: isVisible,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                left: kDefaultPadding,
                right: kDefaultPadding,
                bottom: kDefaultPadding,
              ),
              child: NumberPaginator(
                numberPages: songRange.length,
                onPageChange: (int index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                config: NumberPaginatorUIConfig(
                  height: 44,
                  mode: ContentDisplayMode.numbers,
                  buttonSelectedForegroundColor: kWhite,
                  buttonUnselectedForegroundColor:
                      themeProvider.isDarkMode ? kWhite : kBlack,
                  buttonSelectedBackgroundColor: themeProvider.isDarkMode
                      ? kPrimaryLightColor
                      : kPrimaryColor,
                  buttonUnselectedBackgroundColor: themeProvider.isDarkMode
                      ? kWhite.withOpacity(0.2)
                      : kBlack.withOpacity(0.1),
                ),
              ),
            ),
          ),
        ),
        const Divider(height: 0.0),
        buildMainList(
          future: songRange[currentPage],
          padding: const EdgeInsets.only(top: 8),
          row: buildRow,
          message: 'Nessun cantico trovato',
        ),
      ],
    );
  }

  Widget buildRow(Raccolta get, int i) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(
          get.songId.toString(),
        ),
      ),
      title: Text(get.songTitle),
      trailing: const Icon(
        Icons.navigate_next,
        color: kLightGrey,
      ),
      onTap: () {
        FocusScope.of(context).unfocus();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return SongsDetail(index: get.songId, from: 'Songs');
            },
          ),
        );
      },
    );
  }
}
