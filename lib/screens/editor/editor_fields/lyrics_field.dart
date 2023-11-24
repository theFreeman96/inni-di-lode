import 'package:flutter/material.dart';

import '/utilities/constants.dart';

class LyricsField extends StatelessWidget {
  const LyricsField({
    Key? key,
    required this.controller,
    required this.focus,
  }) : super(key: key);

  final TextEditingController controller;
  final FocusNode focus;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focus,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.multiline,
      minLines: 15,
      maxLines: 15,
      decoration: const InputDecoration(
        labelText: 'Testo',
        alignLabelWithHint: true,
        contentPadding: EdgeInsets.all(
          kDefaultPadding,
        ),
        prefix: Icon(
          Icons.notes,
          color: kLightGrey,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Inserisci il testo!';
        }
        return null;
      },
    );
  }
}
