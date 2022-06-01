import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:number_paginator/number_paginator.dart';

import '/theme/provider.dart';
import '/theme/constants.dart';
import '/assets/data/queries.dart';
import '/assets/data/models.dart';

import 'songs_detail.dart';

class SongsBody extends StatefulWidget {
  @override
  _SongsBodyState createState() => _SongsBodyState();
}

class _SongsBodyState extends State<SongsBody> {
  FocusNode myFocusNode = FocusNode();

  int currentPage = 0;

  void onValueChanged(newValue) {
    setState(() {
      currentPage = newValue;
    });
  }

  late List<Future<List?>> queries = [
    QueryCtr().getSongsFrom1To100(),
    QueryCtr().getSongsFrom101To200(),
    QueryCtr().getSongsFrom201To300(),
    QueryCtr().getSongsFrom301To400(),
    QueryCtr().getSongsFrom401To500(),
    QueryCtr().getSongsFrom501To600(),
    QueryCtr().getSongsFrom601To700(),
  ];

  late Future<List?> future;

  bool isVisible = true;

  @override
  void initState() {
    future = queries[currentPage];
    super.initState();
  }

  void _runFilter(String keyword) {
    Future<List?> results;
    if (keyword.isEmpty) {
      results = future;

      setState(() {
        queries[currentPage] = future;
        isVisible = true;
      });
    } else {
      results = QueryCtr().searchSong(keyword);

      setState(() {
        currentPage = 0;
        queries[currentPage] = results;
        isVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Column(
      children: <Widget>[
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: TextField(
                focusNode: myFocusNode,
                autofocus: false,
                onChanged: (value) {
                  _runFilter(value);
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
                    top: kDefaultPadding * 4,
                    left: kDefaultPadding,
                    right: kDefaultPadding,
                    bottom: kDefaultPadding,
                  ),
                  child: NumberPaginator(
                    numberPages: 7,
                    onPageChange: (int index) {
                      setState(() {
                        currentPage = index;
                      });
                    },
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
          ],
        ),
        const Divider(height: 0.0),
        FutureBuilder<List?>(
          future: queries[currentPage],
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
                          return _buildRow(snapshot.data![i]);
                        },
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                      ),
                    ),
                  )
                : const Padding(
                    padding: EdgeInsets.only(top: kDefaultPadding),
                    child: Center(
                      child: Text(
                        'Nessun Cantico trovato',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  );
          },
        ),
      ],
    );
  }

  Widget _buildRow(Raccolta get) {
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
        int songId = get.songId;
        String songTitle = get.songTitle;
        String songText = get.songText;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return PageView.builder(
                itemCount: 5,
                itemBuilder: (BuildContext context, int itemIndex) {
                  return SongsDetail(songId, songTitle, songText);
                },
              );
            },
          ),
        );
      },
    );
  }
}
