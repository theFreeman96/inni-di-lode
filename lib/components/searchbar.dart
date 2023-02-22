import 'package:flutter/material.dart';

import '/utilities/constants.dart';

Widget buildSearchBar({
  required FocusNode focusNode,
  required Function filter,
  required String label,
  required String hint,
}) {
  return Padding(
    padding: const EdgeInsets.all(kDefaultPadding),
    child: TextField(
      focusNode: focusNode,
      autofocus: false,
      onChanged: (value) {
        filter(value);
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.search,
          color: kLightGrey,
        ),
        labelText: label,
        hintText: hint,
      ),
    ),
  );
}
