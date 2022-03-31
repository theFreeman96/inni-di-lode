import 'package:flutter/material.dart';

import '/theme/constants.dart';
import '/assets/data/query.dart';
import '/assets/data/lists.dart';

import '/screens/songs/songs_detail.dart';

class CatDetail extends StatefulWidget {
  final int catId;
  final String catName;
  const CatDetail(this.catId, this.catName);
  @override
  _CatDetailState createState() => _CatDetailState(catId, catName);
}

class _CatDetailState extends State<CatDetail> {
  final QueryCtr _query = QueryCtr();
  final int catId;
  final String catName;

  _CatDetailState(this.catId, this.catName);

  get id => catId;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(catName),
          leading: IconButton(
            tooltip: 'Indietro',
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              FocusScope.of(context).unfocus();
              Navigator.of(context).pop();
            },
          ),
        ),
        body: FutureBuilder<List?>(
          future: _query.getSongsByCat(id),
          initialData: const [],
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ListView.separated(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(
                        top: kDefaultPadding * 0.5, bottom: kDefaultPadding),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, i) {
                      return _buildRow(snapshot.data![i]);
                    },
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  );
          },
        ),
      ),
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
