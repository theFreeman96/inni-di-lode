import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/queries.dart';
import '../utilities/constants.dart';

class MacroCatDialog extends StatefulWidget {
  const MacroCatDialog({
    Key? key,
    this.macroDialogFormKey,
    this.macroController,
    this.initialMacroId,
    this.state,
  }) : super(key: key);

  final GlobalKey<FormState>? macroDialogFormKey;
  final TextEditingController? macroController;
  final int? initialMacroId;
  final dynamic state;

  @override
  State<MacroCatDialog> createState() => _MacroCatDialogState();
}

class _MacroCatDialogState extends State<MacroCatDialog> {
  late GlobalKey<FormState> formKey =
      widget.macroDialogFormKey ?? GlobalKey<FormState>();
  late TextEditingController controller =
      widget.macroController ?? TextEditingController();
  late int macroId = widget.initialMacroId ?? 0;

  final QueryCtr query = QueryCtr();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: widget.macroController != null
          ? const Text('Modifica macrocategoria')
          : const Text('Nuova macrocategoria'),
      content: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: kDefaultPadding),
              child: TextFormField(
                controller: controller,
                textCapitalization: TextCapitalization.sentences,
                maxLength: 25,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(25),
                ],
                decoration: const InputDecoration(
                  labelText: 'Nome macrocategoria',
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
              widget.state(() {
                widget.initialMacroId != null
                    ? query.updateMacroCat(
                        controller.text,
                        macroId,
                      )
                    : query.insertMacroCat(
                        controller.text,
                      );
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: widget.initialMacroId != null
                      ? const Text('Macrocategoria modificata!')
                      : const Text('Macrocategoria aggiunta!'),
                ),
              );
              Navigator.pop(context, 'Conferma');
              widget.state(() {});
            }
          },
          child: const Text('Conferma'),
        ),
      ],
    );
  }
}
