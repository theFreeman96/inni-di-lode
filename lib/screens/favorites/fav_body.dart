import 'dart:async';

import 'package:flutter/material.dart';

import '/utilities/constants.dart';
import '/components/searchbar.dart';
import '/components/list_main.dart';
import '/data/models.dart';
import '/data/queries.dart';

import '../songs/songs_detail.dart';

class FavBody extends StatefulWidget {
  const FavBody({Key? key}) : super(key: key);

  @override
  State<FavBody> createState() => _FavBodyState();
}

class _FavBodyState extends State<FavBody> {
  final FocusNode myFocusNode = FocusNode();
  final QueryCtr query = QueryCtr();

  late Future<List?> future;
  @override
  void initState() {
    future = query.getAllFav();
    super.initState();
  }

  void refreshFavList() {
    future = query.getAllFav();
  }

  FutureOr onGoBack(dynamic value) {
    refreshFavList();
    setState(() {});
  }

  void runFilter(String keyword) {
    Future<List?> results;
    if (keyword.isEmpty) {
      results = future;

      setState(() {
        future = query.getAllFav();
      });
    } else {
      results = query.searchFav(1, keyword);

      setState(() {
        future = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        buildSearchBar(
          focusNode: myFocusNode,
          filter: runFilter,
          label: 'Cerca per numero, titolo o testo',
          hint: 'Cerca un cantico',
        ),
        const Divider(height: 0.0),
        buildMainList(
          future: future,
          padding: EdgeInsets.zero,
          row: buildRow,
          message: 'Nessun preferito trovato',
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
              return SongsDetail(index: i, from: 'Favorites');
            },
          ),
        ).then(onGoBack);
      },
    );
  }
}
