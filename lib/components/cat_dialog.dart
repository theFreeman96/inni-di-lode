import 'package:flutter/material.dart';

import '../data/queries.dart';
import '../utilities/constants.dart';
import '../utilities/error_codes.dart';
import 'drop_list.dart';

class CatDialog extends StatelessWidget {
  CatDialog({
    Key? key,
    this.catDialogFormKey,
    this.catController,
    this.catId,
    this.state,
  }) : super(key: key);

  final GlobalKey<FormState>? catDialogFormKey;
  final TextEditingController? catController;
  final int? catId;
  final dynamic state;

  late GlobalKey<FormState> formKey =
      catDialogFormKey ?? GlobalKey<FormState>();
  late TextEditingController controller =
      catController ?? TextEditingController();

  late int macroId;
  late String macroName;
  String? selectedValue;

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
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Errore: ${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      ErrorCodes.macroCategoriesNotFound,
                    ),
                  );
                } else {
                  return DropList(
                    selectedValue: selectedValue,
                    icon: Icons.sell,
                    label: 'Macrocategoria',
                    items: snapshot.data!.map<DropdownMenuItem<String>>(
                      (get) {
                        return DropdownMenuItem<String>(
                          value: get.macroName,
                          onTap: () {
                            macroId = get.macroId;
                            macroName = get.macroName;
                          },
                          child: Text(get.macroName),
                        );
                      },
                    ).toList(),
                    onChanged: (value) {
                      state(() {
                        selectedValue = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Seleziona una macrocategoria!';
                      }
                      return null;
                    },
                  );
                }
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
              catId != null
                  ? query.updateCat(
                      controller.text,
                      macroId,
                      macroName,
                      catId,
                    )
                  : query.insertCat(
                      controller.text,
                      macroId,
                      macroName,
                    );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: catId != null
                      ? const Text('Categoria modificata!')
                      : const Text('Categoria aggiunta!'),
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
