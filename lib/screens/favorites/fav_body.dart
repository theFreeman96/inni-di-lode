import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/theme/constants.dart';
import '/assets/data/lists.dart';
import '/assets/data/query.dart';

import '../songs/songs_detail.dart';

class FavBody extends StatefulWidget {
  @override
  _FavBodyState createState() => _FavBodyState();
}

class _FavBodyState extends State<FavBody> with SingleTickerProviderStateMixin {
  final Map<int, Widget> children = const <int, Widget>{
    0: Text('1'),
    1: Text('2'),
    2: Text('3'),
    3: Text('4'),
    4: Text('5'),
    5: Text('6'),
    6: Text('7'),
  };

  final Map<int, Widget> icons = <int, Widget>{
    0: FutureBuilder<List?>(
      future: QueryCtr().getSongsFrom1To100(),
      initialData: const [],
      builder: (context, snapshot) {
        return Expanded(
          child: ListView.separated(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, i) {
              return (Raccolta get) {
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
              }(snapshot.data![i]);
            },
            separatorBuilder: (context, index) {
              return const Divider();
            },
          ),
        );
      },
    ),
    1: FutureBuilder<List?>(
      future: QueryCtr().getSongsFrom101To200(),
      initialData: const [],
      builder: (context, snapshot) {
        return Expanded(
          child: ListView.separated(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, i) {
              return (Raccolta get) {
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
              }(snapshot.data![i]);
            },
            separatorBuilder: (context, index) {
              return const Divider();
            },
          ),
        );
      },
    ),
    2: FutureBuilder<List?>(
      future: QueryCtr().getSongsFrom201To300(),
      initialData: const [],
      builder: (context, snapshot) {
        return Expanded(
          child: ListView.separated(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, i) {
              return (Raccolta get) {
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
              }(snapshot.data![i]);
            },
            separatorBuilder: (context, index) {
              return const Divider();
            },
          ),
        );
      },
    ),
    3: FutureBuilder<List?>(
      future: QueryCtr().getSongsFrom301To400(),
      initialData: const [],
      builder: (context, snapshot) {
        return Expanded(
          child: ListView.separated(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, i) {
              return (Raccolta get) {
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
              }(snapshot.data![i]);
            },
            separatorBuilder: (context, index) {
              return const Divider();
            },
          ),
        );
      },
    ),
    4: FutureBuilder<List?>(
      future: QueryCtr().getSongsFrom401To500(),
      initialData: const [],
      builder: (context, snapshot) {
        return Expanded(
          child: ListView.separated(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, i) {
              return (Raccolta get) {
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
              }(snapshot.data![i]);
            },
            separatorBuilder: (context, index) {
              return const Divider();
            },
          ),
        );
      },
    ),
    5: FutureBuilder<List?>(
      future: QueryCtr().getSongsFrom501To600(),
      initialData: const [],
      builder: (context, snapshot) {
        return Expanded(
          child: ListView.separated(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, i) {
              return (Raccolta get) {
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
              }(snapshot.data![i]);
            },
            separatorBuilder: (context, index) {
              return const Divider();
            },
          ),
        );
      },
    ),
    6: FutureBuilder<List?>(
      future: QueryCtr().getSongsFrom601To700(),
      initialData: const [],
      builder: (context, snapshot) {
        return Expanded(
          child: ListView.separated(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, i) {
              return (Raccolta get) {
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
              }(snapshot.data![i]);
            },
            separatorBuilder: (context, index) {
              return const Divider();
            },
          ),
        );
      },
    ),
  };

  int currentSegment = 0;

  void onValueChanged(newValue) {
    setState(() {
      currentSegment = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: CupertinoSlidingSegmentedControl<int>(
            children: children,
            onValueChanged: onValueChanged,
            groupValue: currentSegment,
          ),
        ),
        CupertinoUserInterfaceLevel(
          data: CupertinoUserInterfaceLevelData.base,
          child: Builder(
            builder: (BuildContext context) {
              return Container(
                child: icons[currentSegment],
              );
            },
          ),
        ),
      ],
    );
  }
}
