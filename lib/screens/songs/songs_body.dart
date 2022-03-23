import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/assets/theme/provider.dart';
import '/assets/theme/constants.dart';
import '/assets/data/query.dart';
import '/assets/data/lists.dart';

import 'songs_detail.dart';

class SongsBody extends StatefulWidget {
  @override
  _SongsBodyState createState() => _SongsBodyState();
}

class _SongsBodyState extends State<SongsBody> {
  TextEditingController editingController = TextEditingController();
  FocusNode myFocusNode = new FocusNode();
  QueryCtr _query = new QueryCtr();

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
              prefixIcon: Icon(
                Icons.search,
                color: kLightGrey,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(25.0),
                ),
                borderSide: BorderSide(
                    color: themeProvider.isDarkMode ? kWhite : kLightGrey,
                    width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
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
              labelStyle: TextStyle(color: kLightGrey),
              hintText: 'Cerca per numero, titolo o parole',
            ),
          ),
        ),
        Divider(height: 0.0),
        FutureBuilder<List?>(
          future: _query.getAllSongs(),
          initialData: [],
          builder: (context, snapshot) {
            return snapshot.hasData
                ? Expanded(
                    child: ListView.separated(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, i) {
                        return _buildRow(snapshot.data![i]);
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(kDefaultPadding * 2),
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
    return new ListTile(
      leading: new CircleAvatar(
        child: new Text(
          song.id.toString(),
        ),
      ),
      title: new Text(song.title),
      trailing: Icon(
        Icons.navigate_next,
        color: kLightGrey,
      ),
      onTap: () {
        FocusScope.of(context).unfocus();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return SongsDetail();
            },
          ),
        );
      },
    );
  }
}
