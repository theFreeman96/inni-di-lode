import 'package:flutter/material.dart';

import '/utilities/constants.dart';

class DropList extends StatelessWidget {
  const DropList({
    Key? key,
    required this.icon,
    required this.label,
    required this.items,
    required this.onChanged,
    required this.selectedValue,
    required this.validator,
  }) : super(key: key);

  final IconData icon;
  final String label;
  final List<DropdownMenuItem<String>>? items;
  final ValueChanged onChanged;
  final String? selectedValue;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      icon: const Padding(
        padding: EdgeInsets.only(
          right: kDefaultPadding / 3,
        ),
        child: Icon(Icons.arrow_drop_down),
      ),
      borderRadius: const BorderRadius.all(
        Radius.circular(25.0),
      ),
      value: selectedValue,
      hint: const Text('Seleziona'),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: kDefaultPadding,
        ),
        prefixIcon: Icon(
          icon,
          color: kLightGrey,
        ),
        labelText: label,
        alignLabelWithHint: true,
      ),
      items: [
        const DropdownMenuItem<String>(
          value: null,
          child: Text('Seleziona'),
        ),
        ...?items
      ],
      onChanged: onChanged,
      validator: validator,
    );
  }
}
