import 'package:flutter/material.dart';
import 'constants.dart';

Widget buildSearchBar(myFocusNode, runFilter, {required String from}) {
  return Padding(
    padding: const EdgeInsets.all(kDefaultPadding),
    child: TextField(
      focusNode: myFocusNode,
      autofocus: false,
      onChanged: (value) {
        runFilter(value);
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.search,
          color: kLightGrey,
        ),
        labelText: from == 'Cantici' || from == 'Preferiti'
            ? 'Cerca per numero, titolo o testo'
            : from == 'Categorie'
                ? 'Cerca una categoria'
                : from == 'Autori'
                    ? 'Cerca un autore'
                    : 'Cerca',
        hintText: from == 'Cantici' || from == 'Preferiti'
            ? 'Cerca un cantico'
            : 'Cerca',
      ),
    ),
  );
}
