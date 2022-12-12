import 'package:flutter/material.dart';

import '/theme/constants.dart';
import '/assets/data/queries.dart';
import '/assets/data/models.dart';

import '/screens/songs/songs_detail.dart';

class AutDetail extends StatefulWidget {
  final int autId;
  final String autName;
  const AutDetail(this.autId, this.autName, {Key? key}) : super(key: key);
  @override
  State<AutDetail> createState() => _AutDetailState();
}

class _AutDetailState extends State<AutDetail> {
  late ScrollController scrollController = ScrollController();
  final QueryCtr query = QueryCtr();

  get id => widget.autId;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text('Testi di $widget.autName'),
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
          future: query.getSongsByAut(id),
          initialData: const [],
          builder: (context, snapshot) {
            return snapshot.hasData
                ? Scrollbar(
                    thumbVisibility: true,
                    controller: scrollController,
                    child: ListView.separated(
                      controller: scrollController,
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(
                        top: kDefaultPadding * 0.4,
                        bottom: kDefaultPadding,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, i) {
                        return buildRow(snapshot.data![i]);
                      },
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  );
          },
        ),
      ),
    );
  }

  Widget buildRow(Raccolta get) {
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
              return SongsDetail(songId: get.songId, from: 'Author', id: id);
            },
          ),
        );
      },
    );
  }
}
