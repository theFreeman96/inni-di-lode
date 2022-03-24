import 'package:flutter/material.dart';

import '/theme/constants.dart';
import '/assets/data/query.dart';
import '/assets/data/lists.dart';

import '/screens/songs/songs_detail.dart';

class CatDetail extends StatefulWidget {
  @override
  _CatDetailState createState() => _CatDetailState();
}

class _CatDetailState extends State<CatDetail> {
  final QueryCtr _query = QueryCtr();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nome Categoria'),
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
          future: _query.getAllSongs(),
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
