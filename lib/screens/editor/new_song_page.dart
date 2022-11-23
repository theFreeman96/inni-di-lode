import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import '/assets/data/queries.dart';
import '/assets/data/models.dart';

import '/theme/constants.dart';
import '/theme/theme_provider.dart';

class NewSongForm extends FormBloc<String, String> {
  final title = TextFieldBloc(name: 'Titolo');
  final text = TextFieldBloc(name: 'Testo');

  NewSongForm() : super(isLoading: true) {
    addFieldBlocs(
      fieldBlocs: [title, text],
    );
  }

  @override
  void onSubmitting() async {
    // Insert into database
    QueryCtr().insertSong(
        title.value,
        '<ol>${text.value.replaceAll('---Strofa---\n', '<li>').replaceAll('---Fine Strofa---', '</li>').replaceAll('---Coro---', '<i><b>Coro:</b>').replaceAll('---Fine Coro---', '</i>').replaceAll('---Bridge---', '<i><b>Bridge:</b>').replaceAll('---Fine Bridge---', '</i>').replaceAll('---Finale---', '<i><b>Finale:</b>').replaceAll('---Fine---', '</i>').replaceAll('\n', '<br>')}</ol>',
        cat,
        0);

    // Without serialization
    final newSongsV1 = NewSongs(title: title.value, text: text.value);

    debugPrint('newSongsV1');
    debugPrint(newSongsV1.toMap().toString());

    // With Serialization
    final newSongsV2 = NewSongs.fromMap(state.toJson());

    debugPrint('newSongsV2');
    debugPrint(newSongsV2.toMap().toString());

    emitSuccess(
      canSubmitAgain: true,
      successResponse: const JsonEncoder.withIndent('    ').convert(
        state.toJson(),
      ),
    );
  }
}

class NewSongPage extends StatefulWidget {
  const NewSongPage({Key? key}) : super(key: key);

  @override
  State<NewSongPage> createState() => _NewSongPageState();
}

int cat = 0;
String catHint = 'Seleziona una Categoria';
int aut = 0;
String autHint = 'Seleziona uno o più Autori';

class _NewSongPageState extends State<NewSongPage> {
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
    return BlocProvider(
      create: (context) => NewSongForm(),
      child: Builder(
        builder: (context) {
          final formBloc = context.read<NewSongForm>();

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
                labelStyle: TextStyle(
                    color: themeProvider.isDarkMode ? kWhite : kLightGrey),
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
                  onPressed: formBloc.submit,
                  child: const Icon(Icons.send),
                ),
                body: FormBlocListener<NewSongForm, String, String>(
                  onSubmitting: (context, state) {
                    LoadingDialog.show(context);
                  },
                  onSuccess: (context, state) {
                    LoadingDialog.hide(context);

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: SingleChildScrollView(
                          child: Text(state.successResponse!)),
                      duration: const Duration(milliseconds: 1500),
                    ));
                  },
                  onFailure: (context, state) {
                    LoadingDialog.hide(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.failureResponse!)));
                  },
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      children: <Widget>[
                        TextFieldBlocBuilder(
                          padding: const EdgeInsets.all(kDefaultPadding),
                          textFieldBloc: formBloc.title,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: const InputDecoration(
                            labelText: 'Titolo del Cantico',
                            prefixIcon: Icon(
                              Icons.edit,
                              color: kLightGrey,
                            ),
                          ),
                        ),
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
                                  if (formBloc.text.value.isEmpty) {
                                    switch (value) {
                                      case 'Strofa':
                                        formBloc.text.updateValue(
                                            '---Strofa---\n\n---Fine Strofa---\n');
                                        break;
                                      case 'Coro':
                                        formBloc.text.updateValue(
                                            '---Coro---\n\n---Fine Coro---\n');
                                        break;
                                      case 'Bridge':
                                        formBloc.text.updateValue(
                                            '---Bridge---\n\n---Fine Bridge---\n');
                                        break;
                                      case 'Finale':
                                        formBloc.text.updateValue(
                                            '---Finale---\n\n---Fine---');
                                        break;
                                    }
                                  } else {
                                    switch (value) {
                                      case 'Strofa':
                                        formBloc.text.updateValue(
                                            '${formBloc.text.value}\n---Strofa---\n\n---Fine Strofa---\n');
                                        break;
                                      case 'Coro':
                                        formBloc.text.updateValue(
                                            '${formBloc.text.value}\n---Coro---\n\n---Fine Coro---\n');
                                        break;
                                      case 'Bridge':
                                        formBloc.text.updateValue(
                                            '${formBloc.text.value}\n---Bridge---\n\n---Fine Bridge---\n');
                                        break;
                                      case 'Finale':
                                        formBloc.text.updateValue(
                                            '${formBloc.text.value}\n---Finale---\n\n---Fine---');
                                        break;
                                    }
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                        TextFieldBlocBuilder(
                          padding: const EdgeInsets.all(kDefaultPadding),
                          textFieldBloc: formBloc.text,
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.multiline,
                          minLines: 15,
                          maxLines: 15,
                          decoration: const InputDecoration(
                            alignLabelWithHint: true,
                            labelText: 'Testo',
                            prefix: Icon(
                              Icons.notes,
                              color: kLightGrey,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kDefaultPadding),
                          child: Row(
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
                                              child:
                                                  Icon(Icons.arrow_drop_down),
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(25.0),
                                            ),
                                            hint: Text(catHint),
                                            decoration: const InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                vertical: kDefaultPadding,
                                              ),
                                              prefixIcon: Icon(
                                                Icons.sell,
                                                color: kLightGrey,
                                              ),
                                              labelText: 'Categoria',
                                            ),
                                            items: snapshot.data!
                                                .map<DropdownMenuItem<String>>(
                                                    (get) {
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
                                                log(value);
                                              });
                                            },
                                          )
                                        : const Padding(
                                            padding: EdgeInsets.only(
                                                top: kDefaultPadding),
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
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kDefaultPadding),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: FutureBuilder(
                                  future: QueryCtr().getAllAut(),
                                  builder: (context, AsyncSnapshot snapshot) {
                                    return snapshot.hasData
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: kDefaultPadding),
                                            child:
                                                DropdownButtonFormField<String>(
                                              isExpanded: true,
                                              icon: const Padding(
                                                padding: EdgeInsets.only(
                                                    right: kDefaultPadding / 3),
                                                child:
                                                    Icon(Icons.arrow_drop_down),
                                              ),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(25.0),
                                              ),
                                              hint: Text(autHint),
                                              decoration: const InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                  vertical: kDefaultPadding,
                                                ),
                                                prefixIcon: Icon(
                                                  Icons.people,
                                                  color: kLightGrey,
                                                ),
                                                labelText: 'Autore',
                                              ),
                                              items: snapshot.data!.map<
                                                      DropdownMenuItem<String>>(
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
                                                  log(value);
                                                });
                                              },
                                            ),
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
          );
        },
      ),
    );
  }
}

class LoadingDialog extends StatelessWidget {
  static void show(BuildContext context, {Key? key}) => showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (_) => LoadingDialog(key: key),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  const LoadingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Card(
          child: Container(
            width: 80,
            height: 80,
            padding: const EdgeInsets.all(kDefaultPadding),
            child: const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
