import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../data/queries.dart';
import '../utilities/constants.dart';
import '../utilities/error_codes.dart';
import '../utilities/theme_provider.dart';
import 'drop_list.dart';
import 'macrocat_dialog.dart';

class CatDialog extends StatefulWidget {
  const CatDialog({
    Key? key,
    this.catDialogFormKey,
    this.catController,
    this.catId,
    this.initialMacroId,
    this.initialMacroName,
    this.state,
  }) : super(key: key);

  final GlobalKey<FormState>? catDialogFormKey;
  final TextEditingController? catController;
  final int? catId;
  final int? initialMacroId;
  final String? initialMacroName;
  final dynamic state;

  @override
  State<CatDialog> createState() => _CatDialogState();
}

class _CatDialogState extends State<CatDialog> {
  late GlobalKey<FormState> formKey =
      widget.catDialogFormKey ?? GlobalKey<FormState>();
  late TextEditingController controller =
      widget.catController ?? TextEditingController();
  late int macroId = widget.initialMacroId ?? 0;
  late String? selectedValue = widget.initialMacroName;
  final QueryCtr query = QueryCtr();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return AlertDialog(
      scrollable: true,
      title: widget.catController != null
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
                maxLength: 25,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(25),
                ],
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
                            selectedValue = get.macroName;
                          },
                          child: Text(get.macroName),
                        );
                      },
                    ).toList(),
                    onChanged: (value) {
                      selectedValue = value;
                      widget.state(() {}) ?? setState(() {});
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
            TextButton.icon(
              icon: Row(
                children: [
                  Icon(
                    Icons.add,
                    size: 15,
                    color: themeProvider.isDarkMode ? kWhite : kBlack,
                  ),
                  Icon(
                    Icons.sell,
                    color: themeProvider.isDarkMode ? kWhite : kBlack,
                  ),
                ],
              ),
              label: Text(
                'Crea nuova macrocategoria',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: themeProvider.isDarkMode ? kWhite : kBlack,
                ),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return MacroCatDialog(
                      state: setState,
                    );
                  },
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
          },
          child: const Text('Annulla'),
        ),
        FilledButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              widget.catId != null
                  ? query.updateCat(
                      controller.text,
                      macroId,
                      selectedValue,
                      widget.catId,
                    )
                  : query.insertCat(
                      controller.text,
                      macroId,
                      selectedValue,
                    );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: widget.catId != null
                      ? const Text('Categoria modificata!')
                      : const Text('Categoria aggiunta!'),
                ),
              );
              Navigator.pop(context, 'Conferma');
              widget.state(() {}) ?? setState(() {});
            }
          },
          child: const Text('Conferma'),
        ),
      ],
    );
  }
}
