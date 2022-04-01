import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '/theme/provider.dart';
import '/theme/constants.dart';
import '/assets/data/query.dart';
import '/assets/data/lists.dart';

import 'songs_detail.dart';

class SongsBody extends StatefulWidget {
  @override
  _SongsBodyState createState() => _SongsBodyState();
}

class _SongsBodyState extends State<SongsBody> {
  TextEditingController editingController = TextEditingController();
  FocusNode myFocusNode = FocusNode();

  final Map<int, Widget> children = const <int, Widget>{
    0: Text('1'),
    1: Text('2'),
    2: Text('3'),
    3: Text('4'),
    4: Text('5'),
    5: Text('6'),
    6: Text('7'),
  };

  final List<Future<List?>> _query = [
    QueryCtr().getSongsFrom1To100(),
    QueryCtr().getSongsFrom101To200(),
    QueryCtr().getSongsFrom201To300(),
    QueryCtr().getSongsFrom301To400(),
    QueryCtr().getSongsFrom401To500(),
    QueryCtr().getSongsFrom501To600(),
    QueryCtr().getSongsFrom601To700(),
  ];

  int currentSegment = 0;

  void onValueChanged(newValue) {
    setState(() {
      currentSegment = newValue;
    });
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
        Padding(
          padding: const EdgeInsets.only(bottom: kDefaultPadding),
          child: CupertinoSlidingSegmentedControl<int>(
            children: children,
            onValueChanged: onValueChanged,
            groupValue: currentSegment,
            thumbColor:
                themeProvider.isDarkMode ? kPrimaryLightColor : Colors.white,
          ),
        ),
        const Divider(height: 0.0),
        CupertinoUserInterfaceLevel(
          data: CupertinoUserInterfaceLevelData.base,
          child: Builder(
            builder: (BuildContext context) {
              return FutureBuilder<List?>(
                future: _query[currentSegment],
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
              );
            },
          ),
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
