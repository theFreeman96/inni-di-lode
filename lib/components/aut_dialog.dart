import 'package:flutter/material.dart';

import '../data/queries.dart';
import '../utilities/constants.dart';

class AutDialog extends StatelessWidget {
  AutDialog({
    Key? key,
    this.autDialogFormKey,
    this.autNameController,
    this.autSurnameController,
    this.state,
  }) : super(key: key);

  final GlobalKey<FormState>? autDialogFormKey;
  final TextEditingController? autNameController;
  final TextEditingController? autSurnameController;
  final dynamic state;

  late GlobalKey<FormState> formKey;
  late TextEditingController nameController;
  late TextEditingController surnameController;

  final QueryCtr query = QueryCtr();

  @override
  Widget build(BuildContext context) {
    formKey = autDialogFormKey ?? GlobalKey<FormState>();
    nameController = autNameController ?? TextEditingController();
    surnameController = autSurnameController ?? TextEditingController();

    return AlertDialog(
      scrollable: true,
      title: const Text('Nuovo autore'),
      content: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                bottom: kDefaultPadding,
              ),
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
              controller: surnameController,
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
            surnameController.clear();
          },
          child: const Text('Annulla'),
        ),
        FilledButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              query.insertAut(
                nameController.text,
                surnameController.text,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Autore aggiunto!'),
                ),
              );
              Navigator.pop(context, 'Conferma');
              nameController.clear();
              surnameController.clear();
              state(() {});
            }
          },
          child: const Text('Conferma'),
        ),
      ],
    );
  }
}
