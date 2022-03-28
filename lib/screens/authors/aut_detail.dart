import 'package:flutter/material.dart';

import '/theme/constants.dart';
import '/assets/data/query.dart';
import '/assets/data/tables.dart';

import '/screens/songs/songs_detail.dart';

class AutDetail extends StatefulWidget {
  final int autId;
  final String autName;
  const AutDetail(this.autId, this.autName);
  @override
  _AutDetailState createState() => _AutDetailState(autId, autName);
}

class _AutDetailState extends State<AutDetail> {
  final QueryCtr _query = QueryCtr();
  final int autId;
  final String autName;

  _AutDetailState(this.autId, this.autName);

  get id => autId;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Testi di ' + autName),
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
          future: _query.getSongsByAut(id),
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

  Widget _buildRow(Songs_Authors songsAuthors) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(
          songsAuthors.song_id.toString(),
        ),
      ),
      title: Text(songsAuthors.song_title),
      trailing: const Icon(
        Icons.navigate_next,
        color: kLightGrey,
      ),
      onTap: () {
        FocusScope.of(context).unfocus();
        int songId = songsAuthors.song_id;
        String songTitle = songsAuthors.song_title;
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
