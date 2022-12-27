import 'dart:async';

import 'package:flutter/material.dart';

import '/theme/constants.dart';
import '/assets/data/models.dart';
import '/assets/data/queries.dart';

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
        Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: TextField(
            focusNode: myFocusNode,
            autofocus: false,
            onChanged: (value) {
              runFilter(value);
            },
            decoration: const InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: kLightGrey,
              ),
              labelText: 'Cerca per numero, titolo o testo',
              hintText: 'Cerca un cantico',
            ),
          ),
        ),
        const Divider(height: 0.0),
        FutureBuilder<List?>(
          future: future,
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
                          return buildRow(snapshot.data![i], i);
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
                        'Nessun preferito trovato',
                        style: TextStyle(fontSize: 20.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
          },
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
