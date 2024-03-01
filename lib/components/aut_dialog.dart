import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/queries.dart';
import '../utilities/constants.dart';

class AutDialog extends StatelessWidget {
  AutDialog({
    Key? key,
    this.autDialogFormKey,
    this.autNameController,
    this.autSurnameController,
    this.autId,
    this.state,
  }) : super(key: key);

  final GlobalKey<FormState>? autDialogFormKey;
  final TextEditingController? autNameController;
  final TextEditingController? autSurnameController;
  final int? autId;
  final dynamic state;

  late GlobalKey<FormState> formKey =
      autDialogFormKey ?? GlobalKey<FormState>();
  late TextEditingController nameController =
      autNameController ?? TextEditingController();
  late TextEditingController surnameController =
      autSurnameController ?? TextEditingController();

  final QueryCtr query = QueryCtr();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: autNameController != null
          ? const Text('Modifica autore')
          : const Text('Nuovo autore'),
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
                maxLength: 25,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(25),
                ],
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
              maxLength: 25,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              inputFormatters: [
                LengthLimitingTextInputFormatter(25),
              ],
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
          },
          child: const Text('Annulla'),
        ),
        FilledButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              autId != null
                  ? query.updateAut(
                      nameController.text,
                      surnameController.text,
                      autId,
                    )
                  : query.insertAut(
                      nameController.text,
                      surnameController.text,
                    );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: autId != null
                      ? const Text('Autore modificato!')
                      : const Text('Autore aggiunto!'),
                ),
              );
              Navigator.pop(context, 'Conferma');
              state(() {});
            }
          },
          child: const Text('Conferma'),
        ),
      ],
    );
  }
}
