import 'package:flutter/material.dart';

import '/utilities/constants.dart';
import 'song_not_found.dart';

class DetailList extends StatelessWidget {
  const DetailList({
    Key? key,
    required this.context,
    required this.future,
    required this.message,
    required this.controller,
    required this.row,
  }) : super(key: key);

  final BuildContext context;
  final Future<List?> future;
  final String message;
  final ScrollController controller;
  final Function row;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List?>(
      future: future,
      initialData: const [],
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Errore: ${snapshot.error}',
              textAlign: TextAlign.center,
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: SongNotFound(
              message: message,
            ),
          );
        } else {
          return Scrollbar(
            thumbVisibility: true,
            controller: controller,
            child: ListView.separated(
              controller: controller,
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.only(
                top: kDefaultPadding * 0.4,
                bottom: kDefaultPadding,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, i) {
                return row(snapshot.data![i], i);
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            ),
          );
        }
      },
    );
  }
}
