import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/theme/provider.dart';
import '/theme/constants.dart';
import '/assets/data/query.dart';
import '/assets/data/tables.dart';

import 'songs_detail.dart';

class SongsBody extends StatefulWidget {
  @override
  _SongsBodyState createState() => _SongsBodyState();
}

class _SongsBodyState extends State<SongsBody> {
  TextEditingController editingController = TextEditingController();
  FocusNode myFocusNode = FocusNode();
  final QueryCtr _query = QueryCtr();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: TextField(
            focusNode: myFocusNode,
            autofocus: false,
            controller: editingController,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.search,
                color: kLightGrey,
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
              labelText: 'Cerca un Cantico',
              labelStyle: const TextStyle(color: kLightGrey),
              hintText: 'Cerca per numero, titolo o parole',
            ),
          ),
        ),
        const Divider(height: 0.0),
        FutureBuilder<List?>(
          future: _query.getAllSongs(),
          initialData: const [],
          builder: (context, snapshot) {
            return snapshot.hasData
                ? Expanded(
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
                  )
                : const Padding(
                    padding: EdgeInsets.all(kDefaultPadding * 2),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
          },
        ),
      ],
    );
  }

  Widget _buildRow(Songs song) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(
          song.id.toString(),
        ),
      ),
      title: Text(song.title),
      trailing: const Icon(
        Icons.navigate_next,
        color: kLightGrey,
      ),
      onTap: () {
        FocusScope.of(context).unfocus();
        int songId = song.id;
        String songTitle = song.title;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return SongsDetail(songId, songTitle);
            },
          ),
        );
      },
    );
  }
}
