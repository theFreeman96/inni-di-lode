import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/data/queries.dart';
import '/utilities/constants.dart';
import '/utilities/error_codes.dart';
import '/utilities/theme_provider.dart';

class CatDialog extends StatefulWidget {
  const CatDialog({
    Key? key,
    required this.newKey,
    required this.controller,
  }) : super(key: key);

  final GlobalKey<FormState> newKey;
  final TextEditingController controller;

  @override
  State<CatDialog> createState() => _CatDialogState();
}

class _CatDialogState extends State<CatDialog> {
  final QueryCtr query = QueryCtr();
  late String macroHint;
  late int macroId;
  late String macroName;

  @override
  void initState() {
    macroHint = 'Seleziona';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return TextButton.icon(
      icon: SizedBox(
        height: kDefaultPadding,
        width: kDefaultPadding * 1.55,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Icon(
                Icons.add,
                size: 16,
                color: themeProvider.isDarkMode ? kWhite : kBlack,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.sell,
                size: 18,
                color: themeProvider.isDarkMode ? kWhite : kBlack,
              ),
            ),
          ],
        ),
      ),
      label: Text(
        'Crea nuova categoria',
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
              title: const Text('Nuova categoria'),
              content: Form(
                key: widget.newKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: kDefaultPadding),
                      child: TextFormField(
                        controller: widget.controller,
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
                                  padding: EdgeInsets.only(
                                      right: kDefaultPadding / 3),
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
                                items: snapshot.data!
                                    .map<DropdownMenuItem<String>>((get) {
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
                                  setState(() {
                                    macroHint = value!;
                                  });
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
                    widget.controller.clear();
                  },
                  child: const Text('Annulla'),
                ),
                FilledButton(
                  onPressed: () {
                    if (widget.newKey.currentState!.validate()) {
                      query.insertCat(
                          widget.controller.text, macroId, macroName);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Categoria aggiunta!'),
                        ),
                      );
                      Navigator.pop(context, 'Conferma');
                      widget.controller.clear();
                      setState(() {});
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
