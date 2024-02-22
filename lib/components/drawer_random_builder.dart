import 'dart:math';

import 'package:flutter/material.dart';

import '/data/queries.dart';
import '/screens/songs/songs_detail.dart';
import '/utilities/error_codes.dart';
import 'data_not_found.dart';

class DrawerRandomBuilder extends StatelessWidget {
  const DrawerRandomBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List?>(
      future: QueryCtr().getAllSongs(),
      initialData: const [],
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Text(
                'Errore: ${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(
              child: DataNotFound(
                message: ErrorCodes.songsNotFound,
              ),
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
