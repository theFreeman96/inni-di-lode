import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/data/queries.dart';
import '/utilities/constants.dart';
import '/utilities/theme_provider.dart';

class AutDialog extends StatelessWidget {
  const AutDialog({
    Key? key,
    required this.newKey,
    required this.nameController,
    required this.surController,
    required this.state,
  }) : super(key: key);

  final GlobalKey<FormState> newKey;
  final TextEditingController nameController;
  final TextEditingController surController;
  final dynamic state;

  @override
  Widget build(BuildContext context) {
    final QueryCtr query = QueryCtr();
    final themeProvider = Provider.of<ThemeProvider>(context);
    return TextButton.icon(
      icon: Icon(Icons.person_add,
          color: themeProvider.isDarkMode ? kWhite : kBlack),
      label: Text(
        'Crea nuovo autore',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: themeProvider.isDarkMode ? kWhite : kBlack),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              scrollable: true,
              title: const Text('Nuovo autore'),
              content: Form(
                key: newKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: kDefaultPadding),
                      child: TextFormField(
                        controller: nameController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          labelText: 'Nome',
                          alignLabelWithHint: true,
                          prefixIcon: Icon(
                            Icons.edit,
                            color: kLightGrey,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Inserisci il nome!';
                          }
                          return null;
                        },
                      ),
                    ),
                    TextFormField(
                      controller: surController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'Cognome (facoltativo)',
                        alignLabelWithHint: true,
                        prefixIcon: Icon(
                          Icons.edit,
                          color: kLightGrey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context, 'Annulla');
                    nameController.clear();
                    surController.clear();
                  },
                  child: const Text('Annulla'),
                ),
                FilledButton(
                  onPressed: () {
                    if (newKey.currentState!.validate()) {
                      query.insertAut(nameController.text, surController.text);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Autore aggiunto!'),
                        ),
                      );
                      Navigator.pop(context, 'Conferma');
                      nameController.clear();
                      surController.clear();
                      state(() {});
                    }
                  },
                  child: const Text('Conferma'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
