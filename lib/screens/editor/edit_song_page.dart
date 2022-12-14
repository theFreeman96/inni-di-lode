import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/assets/data/queries.dart';

import '/theme/constants.dart';
import '/theme/theme_provider.dart';

class EditSongPage extends StatefulWidget {
  int songId;
  String songTitle;
  String songText;
  int macroId;
  String macroName;
  int catId;
  String catName;
  int autId;
  String autName;
  String autSurname;
  EditSongPage({
    Key? key,
    required this.songId,
    required this.songTitle,
    required this.songText,
    required this.macroId,
    required this.macroName,
    required this.catId,
    required this.catName,
    required this.autId,
    required this.autName,
    required this.autSurname,
  }) : super(key: key);

  @override
  EditSongPageState createState() {
    return EditSongPageState();
  }
}

late int cat;
late int macro;
late String catHint;
late int mac;
late String macHint;
late int aut;
late String autHint;

class EditSongPageState extends State<EditSongPage> {
  final editSongKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController textController;
  late FocusNode textFocusNode;

  final newCatKey = GlobalKey<FormState>();
  final catController = TextEditingController();

  final newAutKey = GlobalKey<FormState>();
  final autNameController = TextEditingController();
  final autSurnameController = TextEditingController();

  final QueryCtr query = QueryCtr();

  @override
  void initState() {
    titleController = TextEditingController(text: widget.songTitle);
    textController = TextEditingController(
      text: widget.songText
          .replaceAll('<ol>', '')
          .replaceAll('</ol>', '')
          .replaceAll('<li>', '---Strofa---\n')
          .replaceAll('<b>Coro:</b>', '---Coro---')
          .replaceAll('<b>Bridge:</b>', '---Bridge---')
          .replaceAll('<b>Finale:</b>', '---Finale---')
          .replaceAll('<br>', '\n'),
    );
    cat = widget.catId;
    macro = widget.macroId;
    catHint = widget.catName;
    mac = 0;
    macHint = 'Seleziona una Categoria';
    aut = widget.autId;
    autHint = widget.autName;
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(25.0),
            ),
            borderSide: BorderSide(
                color: themeProvider.isDarkMode ? kWhite : kLightGrey,
                width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(25.0),
            ),
            borderSide: BorderSide(
                color: themeProvider.isDarkMode
                    ? kPrimaryLightColor
                    : kPrimaryColor,
                width: 2.0),
          ),
          errorStyle: TextStyle(
              color: themeProvider.isDarkMode ? Colors.redAccent : Colors.red,
              fontWeight: FontWeight.bold),
          errorBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(25.0),
            ),
            borderSide: BorderSide(
                color: themeProvider.isDarkMode ? Colors.redAccent : Colors.red,
                width: 1.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(25.0),
            ),
            borderSide: BorderSide(
                color: themeProvider.isDarkMode ? Colors.redAccent : Colors.red,
                width: 2.0),
          ),
          labelStyle:
              TextStyle(color: themeProvider.isDarkMode ? kWhite : kLightGrey),
        ),
      ),
      child: SafeArea(
        child: FutureBuilder(
          future: query.getAllSongs(),
          builder: (context, AsyncSnapshot snapshot) {
            return Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                elevation: 0.0,
                title: const Text('Modifica Cantico'),
                leading: IconButton(
                  tooltip: 'Indietro',
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    Navigator.of(context).pop();
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
                onPressed: () {
                  if (editSongKey.currentState!.validate()) {
                    query.updateSong(
                        titleController.text,
                        '<ol>${textController.text.replaceAll('---Strofa---\n', '<li>').replaceAll('---Coro---', '<b>Coro:</b>').replaceAll('---Bridge---', '<b>Bridge:</b>').replaceAll('---Finale---', '<b>Finale:</b>').replaceAll('\n\n\n\n', '\n\n').replaceAll('\n\n\n', '\n\n').replaceAll('\n', '<br>')}</ol>',
                        widget.songId,
                        widget.songId,
                        macro,
                        cat,
                        aut,
                        titleController.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Cantico modificato!'),
                      ),
                    );
                    FocusScope.of(context).unfocus();
                    Navigator.of(context).pop();
                  }
                },
                child: const Icon(Icons.send),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: Form(
                    key: editSongKey,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: kDefaultPadding),
                              child: CircleAvatar(
                                child: Text(widget.songId.toString()),
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: titleController,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                decoration: const InputDecoration(
                                  labelText: 'Titolo del Cantico',
                                  prefixIcon: Icon(
                                    Icons.edit,
                                    color: kLightGrey,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Inserisci un Titolo!';
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
                                textCapitalization:
                                    TextCapitalization.sentences,
                                keyboardType: TextInputType.multiline,
                                minLines: 15,
                                maxLines: 15,
                                decoration: const InputDecoration(
                                  labelText: 'Testo',
                                  alignLabelWithHint: true,
                                  prefix: Icon(
                                    Icons.notes,
                                    color: kLightGrey,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Inserisci il Testo!';
                                  }
                                  return null;
                                },
                              ),
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
                value: widget.catName,
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
                    return 'Seleziona una Categoria!';
                  }
                  return null;
                },
              )
            : const Padding(
                padding: EdgeInsets.only(top: kDefaultPadding),
                child: Text(
                  'Nessuna Categoria trovata',
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
                value: '${widget.autName} ${widget.autSurname}',
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
                    value: '${get.name} ${get.surname}',
                    onTap: () {
                      aut = get.id;
                    },
                    child: Text('${get.name} ${get.surname}'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    autHint = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Seleziona un Autore!';
                  }
                  return null;
                },
              )
            : const Padding(
                padding: EdgeInsets.only(top: kDefaultPadding),
                child: Text(
                  'Nessun Autore trovato',
                  style: TextStyle(),
                  textAlign: TextAlign.center,
                ),
              );
      },
    );
  }

  Widget newCatDialog() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Theme(
              data: Theme.of(context).copyWith(
                inputDecorationTheme: InputDecorationTheme(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(25.0),
                    ),
                    borderSide: BorderSide(
                        color: themeProvider.isDarkMode ? kWhite : kLightGrey,
                        width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(25.0),
                    ),
                    borderSide: BorderSide(
                        color: themeProvider.isDarkMode
                            ? kPrimaryLightColor
                            : kPrimaryColor,
                        width: 2.0),
                  ),
                  errorStyle: TextStyle(
                      color: themeProvider.isDarkMode
                          ? Colors.redAccent
                          : Colors.red,
                      fontWeight: FontWeight.bold),
                  errorBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(25.0),
                    ),
                    borderSide: BorderSide(
                        color: themeProvider.isDarkMode
                            ? Colors.redAccent
                            : Colors.red,
                        width: 1.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(25.0),
                    ),
                    borderSide: BorderSide(
                        color: themeProvider.isDarkMode
                            ? Colors.redAccent
                            : Colors.red,
                        width: 2.0),
                  ),
                  labelStyle: TextStyle(
                      color: themeProvider.isDarkMode ? kWhite : kLightGrey),
                ),
              ),
              child: AlertDialog(
                scrollable: true,
                title: const Text('Nuova Categoria'),
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
                            labelText: 'Nome Categoria',
                            prefixIcon: Icon(
                              Icons.edit,
                              color: kLightGrey,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Inserisci il Nome!';
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
                                      return 'Seleziona una Macrocategoria!';
                                    }
                                    return null;
                                  },
                                )
                              : const Padding(
                                  padding:
                                      EdgeInsets.only(top: kDefaultPadding),
                                  child: Text(
                                    'Nessuna Macrocategoria trovata',
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
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, 'Annulla');
                      catController.clear();
                    },
                    child: const Text(
                      'Annulla',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: kLightGrey),
                    ),
                  ),
                  TextButton(
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
                    child: Text(
                      'Conferma',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: themeProvider.isDarkMode
                              ? Colors.greenAccent
                              : Colors.green),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      icon: const Icon(Icons.add_circle),
    );
  }

  Widget newAutDialog() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Theme(
              data: Theme.of(context).copyWith(
                inputDecorationTheme: InputDecorationTheme(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(25.0),
                    ),
                    borderSide: BorderSide(
                        color: themeProvider.isDarkMode ? kWhite : kLightGrey,
                        width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(25.0),
                    ),
                    borderSide: BorderSide(
                        color: themeProvider.isDarkMode
                            ? kPrimaryLightColor
                            : kPrimaryColor,
                        width: 2.0),
                  ),
                  errorStyle: TextStyle(
                      color: themeProvider.isDarkMode
                          ? Colors.redAccent
                          : Colors.red,
                      fontWeight: FontWeight.bold),
                  errorBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(25.0),
                    ),
                    borderSide: BorderSide(
                        color: themeProvider.isDarkMode
                            ? Colors.redAccent
                            : Colors.red,
                        width: 1.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(25.0),
                    ),
                    borderSide: BorderSide(
                        color: themeProvider.isDarkMode
                            ? Colors.redAccent
                            : Colors.red,
                        width: 2.0),
                  ),
                  labelStyle: TextStyle(
                      color: themeProvider.isDarkMode ? kWhite : kLightGrey),
                ),
              ),
              child: AlertDialog(
                scrollable: true,
                title: const Text('Nuovo Autore'),
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
                              return 'Inserisci il Nome!';
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
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, 'Annulla');
                      autNameController.clear();
                      autSurnameController.clear();
                    },
                    child: const Text(
                      'Annulla',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: kLightGrey),
                    ),
                  ),
                  TextButton(
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
                    child: Text(
                      'Conferma',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: themeProvider.isDarkMode
                              ? Colors.greenAccent
                              : Colors.green),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      icon: const Icon(Icons.add_circle),
    );
  }
}
