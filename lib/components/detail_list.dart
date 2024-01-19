import 'package:flutter/material.dart';

import '/utilities/constants.dart';
import 'song_not_found.dart';

class DetailList extends StatelessWidget {
  const DetailList({
    Key? key,
    required this.context,
    required this.future,
    required this.controller,
    required this.row,
    required this.condition,
  }) : super(key: key);

  final BuildContext context;
  final Future<List?> future;
  final ScrollController controller;
  final Function row;
  final bool condition;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List?>(
      future: future,
      initialData: const [],
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Scrollbar(
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
              )
            : Center(
                child: condition
                    ? const SongNotFound()
                    : const CircularProgressIndicator(),
              );
      },
    );
  }
}
