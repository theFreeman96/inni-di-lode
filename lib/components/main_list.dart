import 'package:flutter/material.dart';

import 'data_not_found.dart';

class MainList extends StatelessWidget {
  const MainList({
    Key? key,
    required this.future,
    required this.padding,
    required this.row,
    required this.notFoundMessage,
  }) : super(key: key);

  final Future<List?> future;
  final EdgeInsets padding;
  final Function row;
  final String notFoundMessage;

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
          return Expanded(
            child: DataNotFound(
              message: notFoundMessage,
            ),
          );
        } else {
          return Expanded(
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
          );
        }
      },
    );
  }
}
