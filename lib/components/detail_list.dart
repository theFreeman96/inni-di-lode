import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/utilities/constants.dart';
import '/utilities/theme_provider.dart';

import '/screens/editor/editor.dart';

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
    final themeProvider = Provider.of<ThemeProvider>(context);
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
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Nessun cantico trovato',
                              style: TextStyle(fontSize: 20.0)),
                          TextButton.icon(
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const Editor();
                                  },
                                ),
                              );
                            },
                            icon: Icon(Icons.add_circle,
                                color: themeProvider.isDarkMode
                                    ? kPrimaryLightColor
                                    : kPrimaryColor),
                            label: Text(
                              'Aggiungi cantico',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: themeProvider.isDarkMode
                                      ? kWhite
                                      : kBlack),
                            ),
                          ),
                        ],
                      )
                    : const CircularProgressIndicator(),
              );
      },
    );
  }
}
