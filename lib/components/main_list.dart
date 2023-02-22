import 'package:flutter/material.dart';

import '/utilities/constants.dart';

class MainList extends StatelessWidget {
  const MainList({
    Key? key,
    required this.future,
    required this.padding,
    required this.row,
    required this.message,
  }) : super(key: key);

  final Future<List?> future;
  final EdgeInsets padding;
  final Function row;
  final String message;

  @override
  Widget build(BuildContext context) {
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
}
