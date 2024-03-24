import 'package:flutter/material.dart';

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
    return AlertDialog(
      scrollable: true,
      title: const Text('Errore!'),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: <TextSpan>[
                TextSpan(text: 'Prima di eliminare $itemType '),
                TextSpan(
                  text: '$itemToDelete ',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(
                  text: 'è necessario dissociare o eliminare ',
                ),
                itemType == 'la macrocategoria'
                    ? const TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'le categorie ancora associate.\n\n',
                          ),
                          TextSpan(
                            text:
                                'Nella parte alta della pagina di ciascuna categoria associata ',
                          ),
                        ],
                      )
                    : const TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'i cantici ancora associati.\n\n',
                          ),
                          TextSpan(
                            text:
                                'Nel fondo della pagina di ciascun cantico associato ',
                          ),
                        ],
                      ),
                const TextSpan(
                  text: 'selezionare una delle seguenti opzioni:\n',
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.edit_note),
            title: const Text(
              'Modfica',
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text(
              'Elimina',
            ),
            onTap: () {},
          ),
        ],
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
