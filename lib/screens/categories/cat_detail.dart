import 'package:flutter/material.dart';

import '/assets/theme/constants.dart';
import '/assets/data/query.dart';
import '/assets/data/lists.dart';

import '/screens/songs/songs_detail.dart';

class CatDetail extends StatefulWidget {
  @override
  State<CatDetail> createState() => _CatDetailState();
}

class _CatDetailState extends State<CatDetail> {
  QueryCtr _query = new QueryCtr();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Nome Categoria'),
          leading: IconButton(
            tooltip: 'Indietro',
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              FocusScope.of(context).unfocus();
              Navigator.of(context).pop();
            },
          ),
        ),
        body: FutureBuilder<List?>(
          future: _query.getAllSongs(),
          initialData: [],
          builder: (context, snapshot) {
            return snapshot.hasData
                ? new ListView.separated(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(
                        top: kDefaultPadding * 0.5, bottom: kDefaultPadding),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, i) {
                      return _buildRow(snapshot.data![i]);
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  );
          },
        ),
      ),
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
