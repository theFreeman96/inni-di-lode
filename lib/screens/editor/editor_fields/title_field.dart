import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/utilities/constants.dart';

class TitleField extends StatelessWidget {
  const TitleField({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        controller: controller,
        textCapitalization: TextCapitalization.sentences,
        maxLength: 25,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        inputFormatters: [
          LengthLimitingTextInputFormatter(25),
        ],
        decoration: const InputDecoration(
          labelText: 'Titolo del cantico',
          alignLabelWithHint: true,
          prefixIcon: Icon(
            Icons.edit,
            color: kLightGrey,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Inserisci un titolo!';
          }
          return null;
        },
      ),
    );
  }
}
