import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/assets/data/queries.dart';

import '/theme/constants.dart';
import '/theme/theme_provider.dart';

class NewSongPage2 extends StatefulWidget {
  const NewSongPage2({Key? key}) : super(key: key);

  @override
  NewSongPage2State createState() {
    return NewSongPage2State();
  }
}

int cat = 0;
String catHint = 'Seleziona una Categoria';
int aut = 0;
String autHint = 'Seleziona uno o più Autori';

class NewSongPage2State extends State<NewSongPage2> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final textController = TextEditingController();

  @override
  void initState() {
    cat = 0;
    catHint = 'Seleziona una Categoria';
    aut = 0;
    autHint = 'Seleziona uno o più Autori';
    super.initState();
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
          labelStyle:
              TextStyle(color: themeProvider.isDarkMode ? kWhite : kLightGrey),
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            elevation: 0.0,
            title: const Text('Nuovo Cantico'),
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
              if (formKey.currentState!.validate()) {
                QueryCtr().insertSong(
                    titleController.text,
                    '<ol>${textController.text.replaceAll('---Strofa---\n', '<li>').replaceAll('---Fine Strofa---', '</li>').replaceAll('---Coro---', '<i><b>Coro:</b>').replaceAll('---Fine Coro---', '</i>').replaceAll('---Bridge---', '<i><b>Bridge:</b>').replaceAll('---Fine Bridge---', '</i>').replaceAll('---Finale---', '<i><b>Finale:</b>').replaceAll('---Fine---', '</i>').replaceAll('\n', '<br>')}</ol>',
                    cat,
                    0);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cantico aggiunto!'),
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
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: titleController,
                      textCapitalization: TextCapitalization.sentences,
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
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: kDefaultPadding),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Aggiungi     '),
                              DropdownButton<String>(
                                icon: const Icon(Icons.arrow_drop_down),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(25.0),
                                ),
                                hint: Text(verseHint),
                                items: verseType
                                    .map<DropdownMenuItem<String>>((value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    verseHint = value!;
                                    if (textController.text.isEmpty) {
                                      switch (value) {
                                        case 'Strofa':
                                          final text = textController.text;
                                          final selection =
                                              textController.selection;
                                          final newText = text.replaceRange(
                                              selection.start,
                                              selection.end,
                                              '---Strofa---\n\n---Fine Strofa---\n');
                                          textController.value =
                                              TextEditingValue(
                                            text: newText,
                                            selection: TextSelection.collapsed(
                                                offset: selection.baseOffset +
                                                    '---Strofa---\n\n---Fine Strofa---\n'
                                                        .length),
                                          );
                                          break;
                                        case 'Coro':
                                          final text = textController.text;
                                          final selection =
                                              textController.selection;
                                          final newText = text.replaceRange(
                                              selection.start,
                                              selection.end,
                                              '---Coro---\n\n---Fine Coro---\n');
                                          textController.value =
                                              TextEditingValue(
                                            text: newText,
                                            selection: TextSelection.collapsed(
                                                offset: selection.baseOffset +
                                                    '---Coro---\n\n---Fine Coro---\n'
                                                        .length),
                                          );
                                          break;
                                        case 'Bridge':
                                          final text = textController.text;
                                          final selection =
                                              textController.selection;
                                          final newText = text.replaceRange(
                                              selection.start,
                                              selection.end,
                                              '---Bridge---\n\n---Fine Bridge---\n');
                                          textController.value =
                                              TextEditingValue(
                                            text: newText,
                                            selection: TextSelection.collapsed(
                                                offset: selection.baseOffset +
                                                    '---Bridge---\n\n---Fine Bridge---\n'
                                                        .length),
                                          );
                                          break;
                                        case 'Finale':
                                          final text = textController.text;
                                          final selection =
                                              textController.selection;
                                          final newText = text.replaceRange(
                                              selection.start,
                                              selection.end,
                                              '---Finale---\n\n---Fine---\n');
                                          textController.value =
                                              TextEditingValue(
                                            text: newText,
                                            selection: TextSelection.collapsed(
                                                offset: selection.baseOffset +
                                                    '---Finale---\n\n---Fine---\n'
                                                        .length),
                                          );
                                          break;
                                      }
                                    } else {
                                      switch (value) {
                                        case 'Strofa':
                                          final text = textController.text;
                                          final selection =
                                              textController.selection;
                                          final newText = text.replaceRange(
                                              selection.start,
                                              selection.end,
                                              '\n---Strofa---\n\n---Fine Strofa---\n');
                                          textController.value =
                                              TextEditingValue(
                                            text: newText,
                                            selection: TextSelection.collapsed(
                                                offset: selection.baseOffset +
                                                    '\n---Strofa---\n\n---Fine Strofa---\n'
                                                        .length),
                                          );
                                          break;
                                        case 'Coro':
                                          final text = textController.text;
                                          final selection =
                                              textController.selection;
                                          final newText = text.replaceRange(
                                              selection.start,
                                              selection.end,
                                              '\n---Coro---\n\n---Fine Coro---\n');
                                          textController.value =
                                              TextEditingValue(
                                            text: newText,
                                            selection: TextSelection.collapsed(
                                                offset: selection.baseOffset +
                                                    '\n---Coro---\n\n---Fine Coro---\n'
                                                        .length),
                                          );
                                          break;
                                        case 'Bridge':
                                          final text = textController.text;
                                          final selection =
                                              textController.selection;
                                          final newText = text.replaceRange(
                                              selection.start,
                                              selection.end,
                                              '\n---Bridge---\n\n---Fine Bridge---\n');
                                          textController.value =
                                              TextEditingValue(
                                            text: newText,
                                            selection: TextSelection.collapsed(
                                                offset: selection.baseOffset +
                                                    '\n---Bridge---\n\n---Fine Bridge---\n'
                                                        .length),
                                          );
                                          break;
                                        case 'Finale':
                                          final text = textController.text;
                                          final selection =
                                              textController.selection;
                                          final newText = text.replaceRange(
                                              selection.start,
                                              selection.end,
                                              '\n---Finale---\n\n---Fine---\n');
                                          textController.value =
                                              TextEditingValue(
                                            text: newText,
                                            selection: TextSelection.collapsed(
                                                offset: selection.baseOffset +
                                                    '\n---Finale---\n\n---Fine---\n'
                                                        .length),
                                          );
                                          break;
                                      }
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                          TextFormField(
                            controller: textController,
                            textCapitalization: TextCapitalization.sentences,
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
                          child: FutureBuilder(
                            future: QueryCtr().getAllCat(),
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
                                      items: snapshot.data!
                                          .map<DropdownMenuItem<String>>((get) {
                                        return DropdownMenuItem<String>(
                                          value: get.catName,
                                          onTap: () {
                                            cat = get.catId;
                                          },
                                          child: Text(get.catName),
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
                                      padding:
                                          EdgeInsets.only(top: kDefaultPadding),
                                      child: Text(
                                        'Nessuna Categoria trovata',
                                        style: TextStyle(),
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                            },
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.add_circle),
                        ),
                      ],
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: kDefaultPadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: FutureBuilder(
                              future: QueryCtr().getAllAut(),
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
                                        items: snapshot.data!
                                            .map<DropdownMenuItem<String>>(
                                                (get) {
                                          return DropdownMenuItem<String>(
                                            value: get.autName,
                                            onTap: () {
                                              aut = get.autId;
                                            },
                                            child: Text(get.autName),
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
                                        padding: EdgeInsets.only(
                                            top: kDefaultPadding),
                                        child: Text(
                                          'Nessun Autore trovato',
                                          style: TextStyle(),
                                          textAlign: TextAlign.center,
                                        ),
                                      );
                              },
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.add_circle),
                          ),
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
        ),
      ),
    );
  }
}
