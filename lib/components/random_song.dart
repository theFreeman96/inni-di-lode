import 'dart:math';

import 'package:flutter/material.dart';
import 'package:inni_di_lode/components/empty_scaffold.dart';

import '/data/queries.dart';
import '/screens/songs/songs_detail.dart';
import '/utilities/error_codes.dart';
import 'data_not_found.dart';

class RandomSong extends StatelessWidget {
  const RandomSong({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List?>(
      future: QueryCtr().getAllSongs(),
      initialData: const [],
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return EmptyScaffold(
            body: Text(
              'Errore: ${snapshot.error}',
              textAlign: TextAlign.center,
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const EmptyScaffold(
            body: DataNotFound(
              notFoundMessage: ErrorCodes.songsNotFound,
            ),
          );
        } else {
          int randomSongId = Random().nextInt(snapshot.data!.length);
          return SongsDetail(
            index: randomSongId,
            from: 'Drawer',
          );
        }
      },
    );
  }
}
