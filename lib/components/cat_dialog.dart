import 'package:flutter/material.dart';

import '../data/queries.dart';
import '../utilities/constants.dart';
import '../utilities/error_codes.dart';

class CatDialog extends StatelessWidget {
  CatDialog({
    Key? key,
    this.catDialogFormKey,
    this.catController,
    this.state,
  }) : super(key: key);

  final GlobalKey<FormState>? catDialogFormKey;
  final TextEditingController? catController;
  final dynamic state;

  late GlobalKey<FormState> formKey =
      catDialogFormKey ?? GlobalKey<FormState>();
  late TextEditingController controller =
      catController ?? TextEditingController();

  late int macroId;
  late String macroName;

  final QueryCtr query = QueryCtr();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: catController != null
          ? const Text('Modifica categoria')
          : const Text('Nuova categoria'),
      content: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: kDefaultPadding),
              child: TextFormField(
                controller: controller,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Nome categoria',
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
            FutureBuilder(
              future: query.getAllMacroCat(),
              builder: (context, AsyncSnapshot snapshot) {
                return snapshot.hasData
                    ? DropdownButtonFormField<String>(
                        isExpanded: true,
                        icon: const Padding(
                          padding: EdgeInsets.only(right: kDefaultPadding / 3),
                          child: Icon(Icons.arrow_drop_down),
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(25.0),
                        ),
                        hint: const Text('Seleziona'),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: kDefaultPadding,
                          ),
                          prefixIcon: Icon(
                            Icons.sell,
                            color: kLightGrey,
                          ),
                          labelText: 'Macrocategoria',
                          alignLabelWithHint: true,
                        ),
                        items:
                            snapshot.data!.map<DropdownMenuItem<String>>((get) {
                          return DropdownMenuItem<String>(
                            value: get.macroName,
                            onTap: () {
                              macroId = get.macroId;
                              macroName = get.macroName;
                            },
                            child: Text(get.macroName),
                          );
                        }).toList(),
                        onChanged: (value) {
                          state(() {});
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Seleziona una macrocategoria!';
                          }
                          return null;
                        },
                      )
                    : const Padding(
                        padding: EdgeInsets.only(top: kDefaultPadding),
                        child: Text(
                          ErrorCodes.macroCategoriesNotFound,
                          style: TextStyle(),
                          textAlign: TextAlign.center,
                        ),
                      );
              },
            ),
          ],
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: () {
            Navigator.pop(context, 'Annulla');
            controller.clear();
          },
          child: const Text('Annulla'),
        ),
        FilledButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              query.insertCat(
                controller.text,
                macroId,
                macroName,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Categoria aggiunta!'),
                ),
              );
              Navigator.pop(context, 'Conferma');
              controller.clear();
              state(() {});
            }
          },
          child: const Text('Conferma'),
        ),
      ],
    );
  }
}
