import 'package:flutter/material.dart';

import '/utilities/constants.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key? key,
    required this.focusNode,
    required this.filter,
    required this.label,
    required this.hint,
  }) : super(key: key);

  final FocusNode focusNode;
  final Function filter;
  final String label;
  final String hint;

  @override
  Widget build(BuildContext context) {
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
}
