import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utilities/constants.dart';
import '../utilities/theme_provider.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({
    Key? key,
    required this.itemType,
    required this.itemToDelete,
  }) : super(key: key);

  final String itemType;
  final String itemToDelete;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return AlertDialog(
      scrollable: true,
      title: const Text('Errore!'),
      content: RichText(
        text: TextSpan(
          style: TextStyle(
            color: themeProvider.isDarkMode ? kWhite : kBlack,
          ),
          children: [
            TextSpan(
              text: 'Prima di eliminare $itemType ',
            ),
            TextSpan(
              text: '$itemToDelete ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text:
                  'è necessario dissociare o eliminare ${itemType == 'la macrocategoria' ? 'le categorie ancora associate' : 'i cantici ancora associati'}.\n\n',
            ),
            TextSpan(
              text:
                  '${itemType == 'la macrocategoria' ? 'Nella parte alta della pagina di ciascuna categoria associata' : 'Nel fondo della pagina di ciascun cantico associato'}, selezionare una delle seguenti opzioni:\n\n',
            ),
            const WidgetSpan(
              child: Icon(
                Icons.edit_note,
              ),
            ),
            const TextSpan(
              text: 'Modifica\n',
            ),
            const WidgetSpan(
              child: Icon(
                Icons.delete,
              ),
            ),
            const TextSpan(
              text: 'Elimina',
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FilledButton(
          onPressed: () {
            Navigator.pop(context, 'Ho capito');
          },
          child: const Text('Ho capito'),
        ),
      ],
    );
  }
}
