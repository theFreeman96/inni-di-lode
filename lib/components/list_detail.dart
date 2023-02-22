import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/utilities/constants.dart';
import '/utilities/theme_provider.dart';

import '/screens/editor/new_song_page.dart';

Widget buildDetailList({
  required BuildContext context,
  required Future<List?> future,
  required ScrollController controller,
  required Function row,
  required bool condition,
}) {
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
                                  return const NewSongPage();
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
                                color:
                                    themeProvider.isDarkMode ? kWhite : kBlack),
                          ),
                        ),
                      ],
                    )
                  : const CircularProgressIndicator(),
            );
    },
  );
}
