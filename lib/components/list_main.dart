import 'package:flutter/material.dart';

import '/utilities/constants.dart';

Widget buildMainList({
  required future,
  required padding,
  required row,
  required message,
}) {
  return FutureBuilder<List?>(
    future: future,
    initialData: const [],
    builder: (context, snapshot) {
      return snapshot.hasData
          ? Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                child: ListView.separated(
                  padding: padding,
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, i) {
                    return row(snapshot.data![i], i);
                  },
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(top: kDefaultPadding),
              child: Center(
                child: Text(
                  message,
                  style: const TextStyle(fontSize: 20.0),
                  textAlign: TextAlign.center,
                ),
              ),
            );
    },
  );
}
