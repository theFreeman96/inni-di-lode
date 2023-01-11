import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/assets/data/queries.dart';

import '/theme/constants.dart';
import '/theme/theme_provider.dart';

import '../home.dart';

class NewSongPage extends StatefulWidget {
  const NewSongPage({Key? key}) : super(key: key);

  @override
  NewSongPageState createState() => NewSongPageState();
}

class NewSongPageState extends State<NewSongPage> {
  final newSongKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final textController = TextEditingController();
  late FocusNode textFocusNode;

  static List<int> macroList = [];
  static List<int> catList = [];
  late int cat;
  late int macro;
  late String catHint;
  final newCatKey = GlobalKey<FormState>();
  final catController = TextEditingController();
  late int mac;
  late String macHint;

  late int aut;
  late String autHint;
  final newAutKey = GlobalKey<FormState>();
  final autNameController = TextEditingController();
  final autSurnameController = TextEditingController();

  final QueryCtr query = QueryCtr();

  @override
  void initState() {
    cat = 1;
    macro = 1;
    catHint = 'Seleziona';
    mac = 1;
    macHint = 'Seleziona';
    aut = 1;
    autHint = 'Seleziona';
    textFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    textFocusNode.dispose();
    super.dispose();
  }

  List verseType = ['Strofa', 'Coro', 'Bridge', 'Finale'];
  String verseHint = 'Strofa';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
        future: query.getAllSongs(),
        builder: (context, AsyncSnapshot snapshot) {
          final newSongId = snapshot.data!.length + 1;
          return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              elevation: 0.0,
              title: const Text('Nuovo cantico'),
              leading: IconButton(
                tooltip: 'Indietro',
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const Home();
                      },
                    ),
                  );
                },
              ),
              actions: <Widget>[
                Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) {
                    return Row(
                      children: [
                        Icon(
                          themeProvider.isDarkMode
                              ? Icons.dark_mode
                              : Icons.light_mode,
                        ),
                        Switch(
                          onChanged: (value) {
                            themeProvider.toggleTheme();
                          },
                          value: themeProvider.isDarkMode,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              tooltip: 'Conferma',
              onPressed: () {
                if (newSongKey.currentState!.validate()) {
                  query.insertSong(
                      titleController.text,
                      '<ol>${textController.text.replaceAll('---Strofa---\n', '<li>').replaceAll('---Coro---', '<b>Coro:</b>').replaceAll('---Bridge---', '<b>Bridge:</b>').replaceAll('---Finale---', '<b>Finale:</b>').replaceAll('\n\n\n\n', '\n\n').replaceAll('\n\n\n', '\n\n').replaceAll('\n', '<br>')}</ol>',
                      0,
                      newSongId,
                      macro,
                      cat,
                      aut,
                      titleController.text);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Cantico aggiunto!'),
                    ),
                  );
                  titleController.clear();
                  textController.clear();
                  FocusScope.of(context).unfocus();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const Home();
                      },
                    ),
                  );
                }
              },
              child: const Icon(Icons.send),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Form(
                  key: newSongKey,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(right: kDefaultPadding),
                            child: CircleAvatar(
                              child: Text(newSongId.toString()),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: titleController,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: const InputDecoration(
                                labelText: 'Titolo del cantico',
                                prefixIcon: Icon(
                                  Icons.edit,
                                  color: kLightGrey,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Inserisci un titolo!';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: kDefaultPadding),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Aggiungi     '),
                                textType(),
                              ],
                            ),
                            TextFormField(
                              controller: textController,
                              focusNode: textFocusNode,
                              textCapitalization: TextCapitalization.sentences,
                              keyboardType: TextInputType.multiline,
                              minLines: 15,
                              maxLines: 15,
                              decoration: const InputDecoration(
                                labelText: 'Testo',
                                alignLabelWithHint: true,
                                contentPadding: EdgeInsets.all(
                                  kDefaultPadding,
                                ),
                                prefix: Icon(
                                  Icons.notes,
                                  color: kLightGrey,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Inserisci il testo!';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(bottom: kDefaultPadding * 2),
                        child: Column(
                          children: [
                            ...getCatFields(),
                            newCatDialog2(),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: catDropDown(),
                          ),
                          newCatDialog(),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: kDefaultPadding),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: autDropDown(),
                            ),
                            newAutDialog(),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: kDefaultPadding * 5,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget textType() {
    return DropdownButton<String>(
      icon: const Icon(Icons.arrow_drop_down),
      borderRadius: const BorderRadius.all(
        Radius.circular(25.0),
      ),
      hint: Text(verseHint),
      items: verseType.map<DropdownMenuItem<String>>((value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
          onTap: () {
            textFocusNode.requestFocus();
          },
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          verseHint = value!;
          final text = textController.text;
          final selection = textController.selection;
          var cursorPos = textController.selection.base.offset;
          const verseTag = '---Strofa---';
          const chorusTag = '---Coro---';
          const bridgeTag = '---Bridge---';
          const finaleTag = '---Finale---';

          if (cursorPos == 0) {
            switch (value) {
              case 'Strofa':
                final newText = text.replaceRange(
                    selection.start, selection.end, '$verseTag\n');
                textController.value = TextEditingValue(
                  text: newText,
                  selection: TextSelection.collapsed(
                      offset: cursorPos + '$verseTag\n'.length),
                );
                break;
              case 'Coro':
                final newText = text.replaceRange(
                    selection.start, selection.end, '$chorusTag\n');
                textController.value = TextEditingValue(
                  text: newText,
                  selection: TextSelection.collapsed(
                      offset: cursorPos + '$chorusTag\n'.length),
                );
                break;
              case 'Bridge':
                final newText = text.replaceRange(
                    selection.start, selection.end, '$bridgeTag\n');
                textController.value = TextEditingValue(
                  text: newText,
                  selection: TextSelection.collapsed(
                      offset: cursorPos + '$bridgeTag\n'.length),
                );
                break;
              case 'Finale':
                final newText = text.replaceRange(
                    selection.start, selection.end, '$finaleTag\n');
                textController.value = TextEditingValue(
                  text: newText,
                  selection: TextSelection.collapsed(
                      offset: cursorPos + '$finaleTag\n'.length),
                );
                break;
            }
          } else {
            switch (value) {
              case 'Strofa':
                final newText = text.replaceRange(
                    selection.start, selection.end, '\n\n$verseTag\n');
                textController.value = TextEditingValue(
                  text: newText,
                  selection: TextSelection.collapsed(
                      offset: cursorPos + '\n\n$verseTag\n'.length),
                );
                break;
              case 'Coro':
                final newText = text.replaceRange(
                    selection.start, selection.end, '\n\n$chorusTag\n');
                textController.value = TextEditingValue(
                  text: newText,
                  selection: TextSelection.collapsed(
                      offset: cursorPos + '\n\n$chorusTag\n'.length),
                );
                break;
              case 'Bridge':
                final newText = text.replaceRange(
                    selection.start, selection.end, '\n\n$bridgeTag\n');
                textController.value = TextEditingValue(
                  text: newText,
                  selection: TextSelection.collapsed(
                      offset: cursorPos + '\n\n$bridgeTag\n'.length),
                );
                break;
              case 'Finale':
                final newText = text.replaceRange(
                    selection.start, selection.end, '\n\n$finaleTag\n');
                textController.value = TextEditingValue(
                  text: newText,
                  selection: TextSelection.collapsed(
                      offset: cursorPos + '\n\n$finaleTag\n'.length),
                );
                break;
            }
          }
        });
      },
    );
  }

  Widget catDropDown() {
    return FutureBuilder(
      future: query.getAllCat(),
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
                hint: Text(catHint),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: kDefaultPadding,
                  ),
                  prefixIcon: Icon(
                    Icons.sell,
                    color: kLightGrey,
                  ),
                  labelText: 'Categoria',
                ),
                items: snapshot.data!.map<DropdownMenuItem<String>>((get) {
                  return DropdownMenuItem<String>(
                    value: get.name,
                    onTap: () {
                      cat = get.id;
                      macro = get.macro_id;
                    },
                    child: Text(get.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    catHint = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Seleziona una categoria!';
                  }
                  return null;
                },
              )
            : const Padding(
                padding: EdgeInsets.only(top: kDefaultPadding),
                child: Text(
                  'Nessuna categoria trovata',
                  style: TextStyle(),
                  textAlign: TextAlign.center,
                ),
              );
      },
    );
  }

  Widget autDropDown() {
    return FutureBuilder(
      future: query.getAllAut(),
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
                hint: Text(autHint),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: kDefaultPadding,
                  ),
                  prefixIcon: Icon(
                    Icons.people,
                    color: kLightGrey,
                  ),
                  labelText: 'Autore',
                ),
                items: snapshot.data!.map<DropdownMenuItem<String>>((get) {
                  return DropdownMenuItem<String>(
                    value:
                        '${get.name} ${get.surname.isEmpty ? '' : get.surname}',
                    onTap: () {
                      aut = get.id;
                    },
                    child: Text(
                        '${get.name} ${get.surname.isEmpty ? '' : get.surname}'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    autHint = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Seleziona un autore!';
                  }
                  return null;
                },
              )
            : const Padding(
                padding: EdgeInsets.only(top: kDefaultPadding),
                child: Text(
                  'Nessun autore trovato',
                  style: TextStyle(),
                  textAlign: TextAlign.center,
                ),
              );
      },
    );
  }

  Widget newCatDialog() {
    return IconButton(
      icon: const Icon(Icons.add_circle),
      tooltip: 'Nuova categoria',
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              scrollable: true,
              title: const Text('Nuova categoria'),
              content: Form(
                key: newCatKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: kDefaultPadding),
                      child: TextFormField(
                        controller: catController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          labelText: 'Nome categoria',
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
                                ),
                                items: snapshot.data!
                                    .map<DropdownMenuItem<String>>((get) {
                                  return DropdownMenuItem<String>(
                                    value: get.macroName,
                                    onTap: () {
                                      mac = get.macroId;
                                    },
                                    child: Text(get.macroName),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    macHint = value!;
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
                                  'Nessuna macrocategoria trovata',
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
                    catController.clear();
                  },
                  child: const Text('Annulla'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (newCatKey.currentState!.validate()) {
                      query.insertCat(catController.text, mac);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Categoria aggiunta!'),
                        ),
                      );
                      Navigator.pop(context, 'Conferma');
                      catController.clear();
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

  Widget newCatDialog2() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return TextButton.icon(
      icon: Icon(Icons.new_label,
          color: themeProvider.isDarkMode ? kWhite : kBlack),
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
                key: newCatKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: kDefaultPadding),
                      child: TextFormField(
                        controller: catController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          labelText: 'Nome categoria',
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
                                ),
                                items: snapshot.data!
                                    .map<DropdownMenuItem<String>>((get) {
                                  return DropdownMenuItem<String>(
                                    value: get.macroName,
                                    onTap: () {
                                      mac = get.macroId;
                                    },
                                    child: Text(get.macroName),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    macHint = value!;
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
                                  'Nessuna macrocategoria trovata',
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
                    catController.clear();
                  },
                  child: const Text('Annulla'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (newCatKey.currentState!.validate()) {
                      query.insertCat(catController.text, mac);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Categoria aggiunta!'),
                        ),
                      );
                      Navigator.pop(context, 'Conferma');
                      catController.clear();
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

  Widget newAutDialog() {
    return IconButton(
      icon: const Icon(Icons.add_circle),
      tooltip: 'Nuovo autore',
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              scrollable: true,
              title: const Text('Nuovo autore'),
              content: Form(
                key: newAutKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: kDefaultPadding),
                      child: TextFormField(
                        controller: autNameController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          labelText: 'Nome',
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
                      controller: autSurnameController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'Cognome (facoltativo)',
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
                    autNameController.clear();
                    autSurnameController.clear();
                  },
                  child: const Text('Annulla'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (newAutKey.currentState!.validate()) {
                      query.insertAut(
                          autNameController.text, autSurnameController.text);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Autore aggiunto!'),
                        ),
                      );
                      Navigator.pop(context, 'Conferma');
                      autNameController.clear();
                      autSurnameController.clear();
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

  List<Widget> getCatFields() {
    List<Widget> catFieldsList = [];
    for (int i = 0; i <= catList.length && i < 3; i++) {
      catFieldsList.add(
        Padding(
          padding: const EdgeInsets.only(bottom: kDefaultPadding),
          child: Row(
            children: [
              Expanded(child: CatFields(i)),
              i == 2
                  ? addRemoveButton(false, 0)
                  : addRemoveButton(i == catList.length, i),
            ],
          ),
        ),
      );
    }
    return catFieldsList;
  }

  Widget addRemoveButton(bool add, int index) {
    return IconButton(
      icon: Icon((add) ? Icons.add_circle : Icons.remove_circle),
      color: (add) ? Colors.green : Colors.red,
      tooltip: (add) ? 'Aggiungi categoria' : 'Rimuovi categoria',
      onPressed: () {
        if (add) {
          catList.insert(0, 0);
        } else {
          catList.removeAt(index);
        }
        setState(() {});
      },
    );
  }
}

class CatFields extends StatefulWidget {
  final int index;
  const CatFields(this.index, {Key? key}) : super(key: key);
  @override
  CatFieldsState createState() => CatFieldsState();
}

class CatFieldsState extends State<CatFields> {
  late int cat;
  late int macro;
  late String catHint;

  final QueryCtr query = QueryCtr();

  @override
  void initState() {
    cat = 1;
    macro = 1;
    catHint = 'Seleziona';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    return FutureBuilder(
      future: query.getAllCat(),
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? DropdownButtonFormField<String>(
                key: widget.key,
                isExpanded: true,
                icon: const Padding(
                  padding: EdgeInsets.only(right: kDefaultPadding / 3),
                  child: Icon(Icons.arrow_drop_down),
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(25.0),
                ),
                hint: Text(catHint),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: kDefaultPadding,
                  ),
                  prefixIcon: const Icon(
                    Icons.sell,
                    color: kLightGrey,
                  ),
                  labelText: widget.index == 0
                      ? 'Categoria'
                      : 'Categoria #${widget.index + 1}',
                ),
                items: snapshot.data!.map<DropdownMenuItem<String>>((get) {
                  return DropdownMenuItem<String>(
                    value: get.name,
                    onTap: () {
                      cat = get.id;
                      macro = get.macro_id;
                      /*NewSongPageState.catList[widget.index] = get.id;
                      NewSongPageState.macroList[widget.index] = get.macro_id;*/
                    },
                    child: Text(get.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    /*NewSongPageState.catList[widget.index] = value!;
                    catHint = NewSongPageState.catList.toString();*/
                    catHint = value!;
                    log(NewSongPageState.catList.toString());
                    log(NewSongPageState.macroList.toString());
                  });
                },
                validator: (value) {
                  if (widget.index != 0) {
                    return 'Seleziona anche la categoria #${widget.index + 1} o rimuovila!';
                  } else if (value == null || value.isEmpty) {
                    return 'Seleziona una categoria!';
                  }
                  return null;
                },
              )
            : const Padding(
                padding: EdgeInsets.only(top: kDefaultPadding),
                child: Text(
                  'Nessuna categoria trovata',
                  style: TextStyle(),
                  textAlign: TextAlign.center,
                ),
              );
      },
    );
  }
}
