import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utilities/constants.dart';
import '../utilities/theme_provider.dart';

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({
    Key? key,
    required this.itemType,
    required this.itemToDelete,
    required this.onPressed,
  }) : super(key: key);

  final String itemType;
  final String itemToDelete;
  final dynamic onPressed;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    late String deleted =
        itemType == 'La categoria' || itemType == 'La macrocategoria'
            ? 'eliminata'
            : 'eliminato';

    return AlertDialog(
      scrollable: true,
      title: const Text('Conferma eliminazione'),
      content: RichText(
        text: TextSpan(
          style: TextStyle(
            color: themeProvider.isDarkMode ? kWhite : kBlack,
          ),
          children: <TextSpan>[
            TextSpan(text: '$itemType '),
            TextSpan(
              text: '$itemToDelete ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: 'sarà $deleted definitivamente.')
          ],
        ),
      ),
      actions: <Widget>[
        OutlinedButton(
          onPressed: () {
            Navigator.pop(context, 'Annulla');
          },
          child: const Text('Annulla'),
        ),
        FilledButton(
          onPressed: onPressed,
          child: const Text('Elimina'),
        ),
      ],
    );
  }
}
