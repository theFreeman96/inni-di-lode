import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/theme/provider.dart';
import '/theme/constants.dart';
import '/assets/data/models.dart';
import '/assets/data/queries.dart';

import '../songs/songs_detail.dart';

class FavBody extends StatefulWidget {
  @override
  _FavBodyState createState() => _FavBodyState();
}

class _FavBodyState extends State<FavBody> {
  FocusNode myFocusNode = FocusNode();

  late Future<List?> future;

  bool isVisible = true;

  @override
  void initState() {
    future = QueryCtr().getAllFav();
    super.initState();
  }

  void _runFilter(String keyword) {
    Future<List?> results;
    if (keyword.isEmpty) {
      results = future;

      setState(() {
        future = future;
      });
    } else {
      results = QueryCtr().searchSong(keyword);

      setState(() {
        future = results;
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
        const Divider(height: 0.0),
        FutureBuilder<List?>(
          future: QueryCtr().getAllFav(),
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
                        'Lista Preferiti vuota',
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
              return SongsDetail(songId, songTitle, songText);
            },
          ),
        );
      },
    );
  }
}
