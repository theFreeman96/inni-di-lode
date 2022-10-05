import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:number_paginator/number_paginator.dart';

import '/theme/theme_provider.dart';
import '/theme/constants.dart';
import '/assets/data/models.dart';
import '/assets/data/queries.dart';

import 'songs_detail.dart';

class SongsBody extends StatefulWidget {
  const SongsBody({Key? key}) : super(key: key);

  @override
  State<SongsBody> createState() => _SongsBodyState();
}

class _SongsBodyState extends State<SongsBody> {
  late double textScaleFactor = MediaQuery.of(context).textScaleFactor;
  FocusNode myFocusNode = FocusNode();
  final QueryCtr query = QueryCtr();
  int currentPage = 0;

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
        Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: TextField(
            focusNode: myFocusNode,
            autofocus: false,
            onChanged: (value) {
              runFilter(value);
            },
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.search,
                color: kLightGrey,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: kDefaultPadding * 0.8,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(25.0),
                ),
                borderSide: BorderSide(
                    color: themeProvider.isDarkMode ? kWhite : kLightGrey,
                    width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(25.0),
                ),
                borderSide: BorderSide(
                    color: themeProvider.isDarkMode
                        ? kPrimaryLightColor
                        : kPrimaryColor,
                    width: 2.0),
              ),
              prefixIconColor: kPrimaryColor,
              labelText: 'Cerca per numero, titolo o testo',
              labelStyle: const TextStyle(color: kLightGrey),
              hintText: 'Cerca un Cantico',
            ),
          ),
        ),
        Visibility(
          visible: isVisible,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 2,
                left: kDefaultPadding,
                right: kDefaultPadding,
                bottom: kDefaultPadding + 2,
              ),
              child: NumberPaginator(
                numberPages: songRange.length,
                onPageChange: (int index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                config: NumberPaginatorUIConfig(
                  mode: ContentDisplayMode.numbers,
                  buttonSelectedForegroundColor: Colors.white,
                  buttonUnselectedForegroundColor:
                      themeProvider.isDarkMode ? Colors.white : kBlack,
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
        FutureBuilder<List?>(
          future: songRange[currentPage],
          initialData: const [],
          builder: (context, snapshot) {
            return snapshot.hasData
                ? Expanded(
                    child: Scrollbar(
                      thumbVisibility: true,
                      child: ListView.separated(
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, i) {
                          return buildRow(snapshot.data![i]);
                        },
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: kDefaultPadding),
                    child: Center(
                      child: Text(
                        'Nessun Cantico trovato',
                        style: TextStyle(fontSize: 20.0 * textScaleFactor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
          },
        ),
      ],
    );
  }

  Widget buildRow(Raccolta get) {
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
              return SongsDetail(songId: get.songId);
            },
          ),
        );
      },
    );
  }
}
